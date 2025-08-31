local mapi = {}
---@param uid integer|string
---@param times integer
local function like(uid, times)
    local dt = {
        user_id = uid,
        times = times
    }
    local rt = bot.onebot_api('send_like', dt)
    if rt['status']:val() ~= 'ok' then
        return '赞不了啦'
    else
        return '已赞>w<'
    end
end
---@param msg Message
---@return string
function mapi.like(msg)
    local uid = msg.user_id
    return like(uid, 10)
end

function mapi.like5(msg)
    local uid = msg.user_id
    local a = like(uid, 10)
    a = a .. like(uid, 10)
    a = a .. like(uid, 10)
    a = a .. like(uid, 10)
    a = a .. like(uid, 10)
    return a
end

local T = { like = like, mapi = mapi }
return T
