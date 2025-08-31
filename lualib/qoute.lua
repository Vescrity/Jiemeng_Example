local ex = require("jm_generic_extend")
local mapi = {}
---comment
---@param id string|integer
---@param name string
---@param text string
---@return string
local function qoute(id, name, text)
    os.execute('rm /tmp/*.html.png')
    local tmp = os.tmpname()
    local cmd = 'qoutehtml ' .. tostring(id) .. ' ' .. ex.string.qoute(name) .. ' > ' .. tmp
    local prcs = io.popen(cmd, "w")
    if prcs then
        prcs:write(text)
        prcs:close()
    else
        return "无法启动进程"
    end
    local content = ex.file.read(tmp)
    os.remove(tmp)
    return content
end

---comment
---@param message Message
---@return string
function mapi.qoute(message)
    local msgid = bot.get_reply_id(message)
    local js = bot.get_msg(msgid, true)
    local msg = Message:new()
    msg:change(js.message)
    local nick = js.sender.nickname:val()
    local id = js.sender.user_id:val()
    ---@cast nick string
    ---@cast id integer
    return qoute(id, nick, msg:true_str())
end

---comment
---@param message Message
---@return string
function mapi.qoute_cut(message)
    local msgid = bot.get_reply_id(message)
    local js = bot.get_msg(msgid, true)
    local msg = Message:new()
    msg:change(js.message)
    local nick = js.sender.nickname:val()
    local id = js.sender.user_id:val()
    ---@cast nick string
    ---@cast id integer
    local huma = require('huma')
    return qoute(id, nick, huma.charcut(msg:true_str()))
end

return { mapi = mapi }
