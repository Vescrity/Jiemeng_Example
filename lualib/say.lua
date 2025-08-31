local mapi = {}
local T = {
    config = {
        voice_charactor = 'lucy-voice-suxinjiejie'
    }
}
---comment
---@param gid integer|string
---@param str string
local function ai_say(gid, str)
    bot.onebot.send_group_ai_record(gid, T.config.voice_charactor, str, true)
end
T.ai_say = ai_say
---comment
---@param msg Message
---@return string
function mapi.ai_say(msg)
    local para = msg:true_param()
    ai_say(msg.group_id, para)
    return ''
end

---comment
---@param message Message
---@return string
function mapi.ai_say_reply(message)
    local msg = bot.get_reply_message(message)
    ai_say(message.group_id, msg:true_str())
    return ''
end
T.mapi = mapi
return T
