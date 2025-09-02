package.cpath = package.cpath .. ";./luaclib/?.so"
-- package.path = package.path .. ";./luaclib/?.lua"
package.path = package.path .. ";./luarc/?.lua"
package.path = package.path .. ";./lualib/?.lua"
DECK_MAX = 20
require("bot_meta")
Plug                           = {
    broad    = require("broad"),
    t2img    = require("t2img"),
    msginfo  = require("msginfo"),
    kfc      = require("kfc"),
    huma     = require("huma"),
    pngutils = require("pngutils"),
    qoute    = require("qoute"),
    webapi   = require("webapi"),
    ai_say   = require("say"),
    format   = require("format"),
    sdai     = require("sdai"),
    easymapi = require("easymapi"),
    status   = require("status"),
    code_run = require("code_run"),
    like     = require("like"),
    test     = require("test"),
    bottle   = require("bottle"),
    chess    = require("chess"),
}
Plug.bottle.config.bottle_file = 'tmp/bottles.lua'
mapi.t2img                     = Plug.t2img.mapi.t2img
mapi.md2png                    = Plug.pngutils.mapi.md2png
mapi.md2png_reply              = Plug.pngutils.mapi.md2png_reply
mapi.ai_say                    = Plug.ai_say.mapi.ai_say
mapi.ai_say_reply              = Plug.ai_say.mapi.ai_say_reply
mapi.sdai                      = Plug.sdai.mapi.sdai
local ex                       = require("jm_generic_extend")
table2str                      = ex.table2str
local checkin                  = require("checkin")
local cjson                    = require "cjson"
local secret                   = dofile('./secret.lua')
local stop                     = Operation.new()
local ignore                   = Operation.new()
stop:set_type("stop")
ignore:set_type("ignore")

broad_list = bot.get_group_list()
gemini_key = secret.gemini_key

local broad_black = secret.broad_black
local b_set = {}
for _, v in ipairs(broad_black) do
    b_set[v] = true
end

-- 反向遍历并删除元素（避免索引错乱）
for i = #broad_list, 1, -1 do
    if b_set[broad_list[i]] then
        table.remove(broad_list, i)
    end
end
---comment
---@param list table
---@param val any
---@return boolean
local function contains(list, val)
    for _, value in ipairs(list) do
        if value == val then
            return true
        end
    end
    return false
end

local enable_group_name_change = secret.enable_group_name_change
local enable_group_card_change = secret.enable_group_card_change
---comment
---@param msg Message
---@return string
function mapi._163music(msg)
    local id = tonumber(msg:true_param())
    return id and ('[CQ:music,type=163,id=' .. id .. ']') or ''
end

--- 在送入词库前执行
---@param js json
---@return boolean
function pre_process(js)
    local w = jsonlib.json2table(js)
    for _, v in ipairs(w.message) do
        if (v.type == "json") then
            local mmp = ''
            local str
            ---@cast str string
            local flag = false
            local key = ''
            local data = v.data.data
            if (string.find(data, 'b23.tv') ~= nil) then
                if w.group_id == 790461091 then
                    return false
                end
            end
            if (string.find(data, 'jumpUrl') ~= nil) then
                flag = true
                key = 'jumpUrl'
            elseif (string.find(data, 'jumpURL') ~= nil) then
                flag = true
                key = 'jumpURL'
            elseif (string.find(data, 'qqdocurl') ~= nil) then
                flag = true
                key = 'qqdocurl'
            end
            if (string.find(data, 'mqqapi:')) then
                flag = true
                mmp = '\n警告: 该链接为 mqqapi 链接，可能执行任意 qq 操作，不建议盲目打开。'
            end
            if flag then
                local t = cjson.decode(data)
                local _, nxt = next(t.meta)
                assert(nxt ~= nil)
                str = nxt[key]
                bot.group_output(
                    tostring(w.group_id),
                    '该卡片信息会跳转至\n'
                    .. str .. mmp
                )
                return true
            end
        end
    end
    return false
end

---@param str string
---@return string
local function str_shuffle(str)
    local chars = {}
    local cnt = 1
    for _, code in utf8.codes(str) do
        --local char = string.sub(str, char_id)
        local char = utf8.char(code)
        chars[cnt] = char
        cnt = cnt + 1
    end
    math.randomseed(os.time())                     -- 初始化随机种子
    for i = #chars, 2, -1 do
        local j = math.random(i)                   -- 随机选择一个索引
        chars[i], chars[j] = chars[j], chars[i]    -- 交换
    end
    local combinedString = table.concat(chars, "") -- 用空格连接
    return combinedString
end
local locks = {}
local claps = {}
---A checker function
---@param msg Message
function before_all(msg)
    local gid = msg.group_id
    local uid = tonumber(msg.user_id)
    if (uid == nil) then return '' end
    local m = msg:true_str()
    if m == '解锁' then
        locks[gid] = false
        return '已解锁'
    end
    if locks[gid] then
        return ''
    end
    if m == '锁定' then
        locks[gid] = true
        return '已锁定'
    end
    if m == '你拍一' then
        claps[uid] = claps[uid] or 0;
        claps[uid] = claps[uid] + 1;
        return '我拍一'
    end
    if m == '你拍二' and claps[uid] and claps[uid] > 0 then
        claps[uid] = claps[uid] - 1;
        return '我拍二'
    end
    if m == '起床' then
        return checkin.getup(msg)
    end
    if m == '睡觉' then
        checkin.sleep(uid)
        return '晚安哦~'
    end
    if m == '起床排行' then
        return checkin.getup_list(msg)
    end
    if checkin.is_sleep(uid) then
        return '你不是睡觉了吗？'
    end
end

---A checker function
---@param msg Message
---@return Operation
function lock_checker(msg)
    local gid = msg.group_id
    local locked = locks[gid]
    if not locked then
        local uid = tonumber(msg.user_id)
        if uid ~= nil then
            locked = checkin.is_sleep(uid)
        end
    end

    return locked and stop or ignore
end

---A checker function
---@param msg Message
function random_event(msg)
    local gid = msg.group_id
    local uid = msg.user_id
    local r = bot.rand(1, 50)
    print('bot.rand(1,50)=', r)
    local m = msg:true_str()
    if (string.find(m, 'JM') == nil) and (#m > 1) then
        if contains(enable_group_name_change, gid) and r == 1 then
            bot.onebot.set_group_name(gid, '♪' .. m)
        end
        if contains(enable_group_card_change, gid) and r == 10 then
            bot.onebot.set_group_card(gid, uid, '♪' .. m)
        end
        if r == 3 and bot.rand(1, 10) < 3 then
            bot.onebot.set_group_ban(gid, uid, 360000, false)
            bot.sleep(1000)
            bot.onebot.set_group_ban(gid, uid, 0, false)
        end
        if r == 5 then
            bot.onebot.set_essence_msg(msg.message_id)
        end
    end
    return ""
end

Repeater_Check = {}
---A checker function
---@param msg Message
---@return string
function msg_precheck(msg)
    local gid = msg.group_id
    local text = msg:true_str()
    if #text == 0 then return '' end

    if Repeater_Check[gid] == nil then
        Repeater_Check[gid] = {
            text = text,
            cnt = 1
        }
        return ''
    end
    local rc = Repeater_Check[gid]
    if rc.text ~= text then
        rc.text = text
        rc.cnt = 1
        return ''
    end
    rc.cnt = rc.cnt + 1
    if rc.cnt >= 3 then
        rc.cnt = 0
        if utf8.len(rc.text) < 5 then
            local xx = Plug.huma.charcut(rc.text)
            if xx == rc.text then xx = ' ' .. xx end
            return xx
        end
        return bot.string_only(str_shuffle(rc.text))
    end
    return ''
end

---comment
---@param msg Message
---@return string
function mapi.message_shuffle_reply(msg)
    return bot.string_only(str_shuffle(bot.get_reply_message(msg):true_str()))
end

function Daily_Broad()
    return bot.group_broad(Plug.webapi.daily_news())
end

--- System Prompt for chat
CHAT_SYSTEM = secret.CHAT_SYSTEM
