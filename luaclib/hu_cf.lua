---@meta

local hu_cf = {}
---comment
---@param filename string
function hu_cf.load(filename) end
---@class cf_result
---@field cf string
---@field orig string
---@field code string
local cf_result = {}
---获取传入字符的拆分，若无对应则返回 nil
---@param id integer utf-8 编码
---@return cf_result|nil
function hu_cf.get(id) end

return hu_cf
