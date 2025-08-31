require("bot_api")
local ex = require("jm_generic_extend")
local bottle = {
    config = {
        bottle_file = 'tmp/bottles.lua'
    }
}
local config = bottle.config

local function get_bottles()
    return ex.file2table(config.bottle_file)
end
local function save(bottles)
    ex.table2file(bottles,config.bottle_file)
end
function bottle.count() return #get_bottles() end
---comment
---@param str string
function bottle.append(str)
    local bottles = get_bottles()
    table.insert(bottles, str)
    save(bottles)
end
---comment
---@return string
function bottle.get()
    local bottles = get_bottles()
    if #bottles == 0 then return '捡光啦！' end
    local r = bot.rand(1,#bottles)
    return bottles[r]
end
---comment
---@return string
function bottle.get_and_remove()
    local bottles = get_bottles()
    if #bottles == 0 then return '捡光啦！' end
    local r = bot.rand(1,#bottles)
    local p = bottles[r]
    table.remove(bottles, r)
    p = p..'\n还剩'..#bottles..'瓶'
    save(bottles)
    return p
end

return bottle
