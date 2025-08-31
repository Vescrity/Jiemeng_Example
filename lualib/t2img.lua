local mapi = {}
local ex = require("jm_generic_extend")
local reverse_split = ex.string.reverse_split
---检查是否为有效的颜色值
---@param str string
---@return boolean
local function isValidHexadecimal(str)
    -- 检查字符串长度是否为 6 或 8
    if #str ~= 6 and #str ~= 8 then
        return false
    end

    -- 检查字符串是否只包含 0-9 和 A-F (或 a-f)
    return str:match("^[0-9A-Fa-f]+$") ~= nil
end
---使用t2img文生图
---@param f string font
---@param w string|integer wide
---@param c string color
---@param b string background color
---@param text string
---@return string CQcode
local function t2img(f, w, c, b, text)
    local tempFileName = os.tmpname()
    local file = assert(io.open(tempFileName, "w+"))
    file:write(text)
    file:close()
    os.execute('cat ' .. tempFileName)
    w = ex.string.qoute(tostring(w))
    f = ex.string.qoute(f)
    c = ex.string.qoute(c)
    b = ex.string.qoute(b)
    local cmd = string.format('cat %s | t2img -c %s -b %s -w %s -f %s > %st2img.png', tempFileName, c, b, w, f,
        tempFileName)
    os.execute("rm /tmp/*t2img.png")
    os.execute(cmd)
    os.remove(tempFileName)
    return '[CQ:image,file=file://' .. tempFileName .. 't2img.png]'
end
---comment
---@param para string
---@return string
local function t2img_para(para)
    local mm = 0
    ::_err::
    if mm == 1 then return 'ERROR' end
    mm = 1
    local prompt, last
    last, prompt = reverse_split(para)
    local c, b, w, f
    f = 'Monospace 15'
    w = '800'
    c = 'ffffffff'
    b = '000000ff'
    while last do
        if prompt == 't' then
            break
        elseif prompt == 'c' then
            _, c = reverse_split(last)
            if not isValidHexadecimal(c) then goto _err end
        elseif prompt == 'b' then
            _, b = reverse_split(last)
            if not isValidHexadecimal(b) then goto _err end
        elseif prompt == 'w' then
            _, w = reverse_split(last)
            local _w = tonumber(w)
            if _w == nil then goto _err end
        elseif prompt == 'f' then
            _, f = reverse_split(last)
        else
            break
        end
        last = reverse_split(last)
        last, prompt = reverse_split(last)
    end
    if last == '' then last = prompt end
    return t2img(f, w, c, b, last)
end
---comment
---@param message Message
---@return string
function mapi.t2img(message)
    local para = reverse_split(message:true_str())
    return t2img_para(para)
end

---comment
---@param message Message
---@return string
function mapi.t2img_reply(message)
    local para = reverse_split(message:true_str())
    if para == '' then para = 't' end
    local msgid = bot.get_reply_id(message)
    local js = get_msg(msgid, true)
    local msg = Message:new()
    msg:change(js.message)
    para = para .. bot.spliter .. msg:true_str()
    return t2img_para(para)
end

local T = {
    t2img = t2img,
    mapi = mapi,
}
return T
