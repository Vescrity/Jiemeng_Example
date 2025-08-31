local T = {}
local ex = require("jm_generic_extend")
local fortune = require("fortune")
local sleep_update = false
local sleep
---@cast sleep table
T.config = {
    message_file = 'resource/getup_message.lua',
    check_file = 'tmp/checkin.lua',
}
local function get_random_message_by_hour(hour)
    local messages = {}
    local weights = {}
    local total_weight = 0
    local time_messages = ex.file2table(T.config.message_file)

    for _, msg_data in ipairs(time_messages) do
        local start_hour, end_hour, weight, message = table.unpack(msg_data)
        weight = weight or 1

        local is_match
        ---@cast is_match boolean
        if start_hour <= end_hour then
            is_match = hour >= start_hour and hour <= end_hour
        else
            is_match = hour >= start_hour or hour <= end_hour
        end

        if is_match then
            table.insert(messages, message)
            total_weight = total_weight + weight
            table.insert(weights, total_weight)
        end
    end

    if total_weight == 0 then return "" end
    local random_value = bot.rand(1, total_weight)
    for i, weight in ipairs(weights) do
        if random_value <= weight then
            return messages[i]
        end
    end
    return ""
end
---comment
---@param msg Message|Message_Place
---@param get_list? boolean
---@return string
function T.getup(msg, get_list)
    local uid = tonumber(msg.user_id)
    assert(uid ~= nil)
    local time = os.time()
    -- 取4小时前的日期做为当前日期，即4:00开始算新的一天
    local today = os.date("%Y-%m-%d", time - 4 * 3600)
    local check_file = T.config.check_file
    local check_in = ex.file2table(check_file)
    check_in[today] = check_in[today] or {
        cnt = 0,
        list = {},
    }
    check_in.sleep = check_in.sleep or {}
    local slp = check_in.sleep
    local ck = check_in[today]
    if not get_list then
        local tm = os.date('*t')
        local prefix = get_random_message_by_hour(tm.hour)
        local tail
        ---@cast tail string
        if ck[uid] then
            tail = '你已经起过床啦！'
        else
            ck[uid] = true
            ck.cnt = ck.cnt + 1
            local tmstr = os.date("%H:%M:%S", time)
            local log = string.format("%03d\t[%s]\t%s", ck.cnt, tmstr, msg.user_nk)
            table.insert(ck.list, log)
            tail = fortune.generate(msg.user_nk, ck.cnt, prefix)
            --tail = '你是第' .. ck.cnt .. '个起床的！'
        end
        if slp[uid] ~= nil then
            local sec = time - slp[uid]
            if sec < 3600 then
                tail = string.format('%s\n你这次睡了%d秒', tail, (time - slp[uid]))
            else
                local h = sec // 3600
                local m = (sec % 3600) // 60
                local s = (sec % 60)
                tail = string.format('%s\n你这次睡了%d时%d分%d秒', tail, h, m, s)
            end
            slp[uid] = nil
        end
        ex.table2file(check_in, check_file)
        return prefix .. tail
    else
        local rt = '今日排行\n' .. table.concat(ck.list, '\n')
        return rt
    end
end

function T.getup_list(msg) return T.getup(msg, true) end

---comment
---@param user_id integer
---@return boolean
function T.is_sleep(user_id)
    if not sleep_update then
        local check_in = ex.file2table(T.config.check_file)
        check_in.sleep = check_in.sleep or {}
        sleep = check_in.sleep or {}
    end
    return sleep[user_id] ~= nil
end

---comment
---@param user_id integer
function T.sleep(user_id)
    local check_in = ex.file2table(T.config.check_file)
    check_in.sleep = check_in.sleep or {}
    sleep = check_in.sleep
    sleep[user_id] = os.time()
    ex.table2file(check_in, T.config.check_file)
end

return T
