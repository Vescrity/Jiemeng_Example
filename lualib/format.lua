local T = {
    config = {
        fadian_list = 'resource/fadian_list.lua'
    }
}
local ex = require('jm_generic_extend')
---comment
---@param template string
---@param replacements table
---@return string
local function format(template, replacements)
    local result = template
    for i = 1, #replacements do
        local pattern = "{#" .. i .. "}"
        local replacement = tostring(replacements[i] or "")
        result = result:gsub(pattern, replacement)
    end
    return result
end

local function fadian(name)
    local forms = ex.file2table(T.config.fadian_list)
    local r = bot.rand(1, #forms)
    return format(forms[r], { name })
end

T.format = format
T.fadian = fadian

return T
