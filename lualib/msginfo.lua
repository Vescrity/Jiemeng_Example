local mapi = {}

---
---@param msg_array table
---@return string
local function get_imgurl(msg_array)
    local rt = ''
    for _, v in ipairs(msg_array) do
        if (v.type == 'image') then rt = rt .. v.data.url .. '\n' end
    end
    return rt
end
---
---@param message Message
---@return string
function mapi.get_imgurl(message)
    local msgid = bot.get_reply_id(message)
    ---@type table
    local dt = get_msg(msgid)
    return get_imgurl(dt.message)
end
---复读回复中指定消息
---@param message Message
---@return string
function mapi.echo_reply(message)
    local id = bot.get_reply_id(message)
    local js = get_msg(id, true)
    local msg = Message:new()
    msg:change(js.message)
    return msg:get_string()
end
---显示回复中指定的消息的详细信息
---@param message Message
---@return string
function mapi.get_info(message)
    local msgid = bot.get_reply_id(message)
    local dt = get_msg(msgid, true)
    return dt:dump(2)
end

---comment
---@param message Message
---@return string
function mapi.get_json(message)
    local msgid = bot.get_reply_id(message)
    local msg = bot.get_msg_by_id(msgid)
    local js = jsonlib.parse(msg.message[1].data.data)
    return js:dump(2)
end


local T = {
    mapi = mapi
}
return T

