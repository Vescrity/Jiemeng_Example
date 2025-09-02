local ex = require('jm_generic_extend')
local reverse_split = ex.string.reverse_split
local config = {
    md_css_path = 'resource/pngutils/md.css',
    html2png_cmd = 'html2png %s.html %s.html.png'
}
local T = {
    config = config,
    mapi = {}
}
---comment
---@param html string
---@return string
function T.html2png(html)
    os.execute('rm /tmp/*.html.png')
    local tmp = os.tmpname()
    local filename = (tmp .. '.html')
    if not ex.file.write(filename, html) then return '出错了' end
    --local cmd = string.format('html2png %s.html %s.html.png', tmp, tmp)
    local cmd = string.format(config.html2png_cmd, tmp, tmp)
    os.execute(cmd)
    os.remove(tmp)
    --os.remove(tmp .. '.html')
    return string.format('%s.html.png', tmp)
end

---comment
---@param html string
---@return string
local function md_css(html)
    local css0 = ex.file.read(config.md_css_path)
    local html_content = [[
    <html> <head> <style>
    ]] .. css0 ..
        [[ </style> </head> <body> ]] .. html .. [[ </body> </html> ]]
    return html_content
end
local function md2html(md)
    local tmp = os.tmpname()
    ex.file.write(tmp, md)
    cmd = string.format('markdown -f image -f toc -f fencedcode -f html -f del %s > %s.html', tmp, tmp)
    os.execute(cmd)
    os.remove(tmp)
    local html = ex.file.read(tmp .. '.html')
    html = md_css(html)
    return html
end
---comment
---@param md string
---@return string
local function md2png(md)
    local html = md2html(md)
    return T.html2png(html)
end
T.md2png = md2png

---comment
---@param message Message
---@return string
function T.mapi.md2png(message)
    local para = reverse_split(message:true_str())
    return string.format('[CQ:image,file=file://%s]', md2png(para))
end

---comment
---@param message Message
---@return string
function T.mapi.md2png_reply(message)
    local msgid = bot.get_reply_id(message)
    local js = get_msg(msgid, true)
    local msg = Message:new()
    msg:change(js.message)
    local para = msg:true_str()
    return string.format('[CQ:image,file=file://%s]', md2png(para))
end

return T

