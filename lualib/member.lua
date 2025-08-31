local T = {}

---@param gid integer|string
---@return json
function T.init_list(gid)
    local dt = {
        group_id = gid,
    }
    local data = bot.onebot_api('get_group_member_list', dt).data
    return data
end

---@param list json
---@return string
function T.get_random_member(list)
    local n = #list
    local mem = list[bot.rand(0, n - 1)]
    local name = mem.card:val() or mem.nickname:val()
    ---@cast name string
    return name
end

---@param group_id integer|string
---@return string
function T.get_random_member_once(group_id)
    local list = T.init_list(group_id)
    return T.get_random_member(list)
end
return T
