local mapi = {}
local T = {}
local m = require('member')
local template = {
    [[%s和%s是初恋]],
    [[%s和%s是青梅竹马]],
    [[%s和%s一见钟情]],
    [[%s和%s一见生恨]],
    [[%s和%s有娃娃亲]],
    [[%s和%s是宿敌]],
    [[%s爱上了%s]],
    [[%s暗恋着%s]],
    [[%s的第一次给了%s]],
    [[%s和%s是情敌]],
    [[%s和%s走到了人生尽头]],
    [[%s和%s合葬在一起]],
    [[%s掘了%s的坟]],
    [[%s和%s决定分手]],
}
---@param message Message
---@return string
function mapi.test(message)
    local group_id = tonumber(message.group_id)
    ---@cast group_id integer
    local list = m.init_list(group_id)
    local function f()
        return '【' .. m.get_random_member(list) .. '】'
    end
    local N = #template
    return string.format(template[bot.rand(1, N)], f(), f());
end

---@param message Message
---@return string
function mapi.goushi(message)
    local group_id = tonumber(message.group_id)
    ---@cast group_id integer
    local list = m.init_list(group_id)
    local function f()
        return '【' .. m.get_random_member(list) .. '】'
    end
    local N = #template
    return string.format(template[bot.rand(1, N)], f(), f());
end

function mapi._9999(message)
    return m.get_random_member_once(message.group_id) .. '和玖玖99'
end

function mapi.jiujiu2(message)
    return m.get_random_member_once(message.group_id) .. '和'
        .. m.get_random_member_once(message.group_id) .. '99'
end

function mapi.jiujiu(message)
    return message.user_nm .. '和'
        .. m.get_random_member_once(message.group_id) .. '99'
end

T.mapi = mapi
return T
