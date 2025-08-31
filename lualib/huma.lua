local hu_cf = require('hu_cf')
local huma = {}
local mapi = {}
huma.cf_load = false
---comment
---@param str string
---@return string
local function get_first_char(str)
    -- 检查字符串是否为空
    if str == nil or str == "" then
        return ''
    end

    -- 使用 utf8.offset 获取首字符的 UTF-8 编码位置
    local first_char_end = utf8.offset(str, 2)

    -- 如果首字符存在，返回它
    if first_char_end then
        return str:sub(1, first_char_end - 1)
    else
        return ''
    end
end
---comment
---@param input string
---@return string
function huma.charcut(input)
    local _ = huma.cf_load or hu_cf.load('resource/hu_cf.txt')
    huma.cf_load = true
    local rt = ''
    for char_id in utf8.codes(input) do
        local char = string.sub(input, char_id)
        local cp = utf8.codepoint(char)
        local entry = hu_cf.get(cp)
        local ad = (entry and entry.cf) or get_first_char(char)
        rt = rt .. ad
    end
    return rt
end
---comment
---@param input string
---@return string
function huma.code(input)
    local _ = huma.cf_load or hu_cf.load('resource/hu_cf.txt')
    huma.cf_load = true
    local rt = ''
    for char_id in utf8.codes(input) do
        local char = string.sub(input, char_id)
        local cp = utf8.codepoint(char)
        local entry = hu_cf.get(cp)
        local ad = (entry and entry.code) or get_first_char(char)
        rt = rt .. ad .. ' '
    end
    return rt
end

---comment
---@param input string
---@return string
function huma.show_utf8(input)
    local rt = ''
    for char_id in utf8.codes(input) do
        local char = string.sub(input, char_id)
        local cp = utf8.codepoint(char)
        local ad = utf8.char(cp) .. '\t' .. cp .. '\n'
        rt = rt .. ad
    end
    return rt
end

function mapi.charcut(message)
    return huma.charcut(message:get_string())
end

function mapi.show_utf8(message)
    return huma.show_utf8(message:true_str())
end

function mapi.charcut_get(message)
    return huma.charcut(message:param())
end

function mapi.show_utf8_get(message)
    return huma.show_utf8(message:param())
end

function mapi.charcut_reply(message)
    local msg = bot.get_reply_message(message)
    return mapi.charcut(msg)
end

function mapi.show_utf8_reply(message)
    local msg = bot.get_reply_message(message)
    return mapi.show_utf8(msg)
end

huma.mapi = mapi
return huma
