local ex = require('jm_generic_extend')
local reverse_split = ex.string.reverse_split
local config = {
    md_css_path = 'resource/pngutils/md.css'
}
local T = {
    config = config,
    mapi = {}
}
local mapi = T.mapi

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
    os.execute('rm /tmp/*.html.png')
    local tmp = os.tmpname()
    ex.file.write(tmp, md)
    cmd = string.format('markdown -f image -f toc -f fencedcode -f html -f del %s > %s.html', tmp, tmp)
    os.execute(cmd)
    local html = ex.file.read(tmp .. 'html')
    html = md_css(html)
    return html
end
local html2png = require('pngutils').html2png
---comment
---@param md string
---@return string
local function md2png(md)
    local html = md2html(md)
    return html2png(html)
end

---comment
---@param message Message
---@return string
function mapi.md2png(message)
    local para = reverse_split(message:true_str())
    return string.format('[CQ:image,file=file://%s]', md2png(para))
end

---comment
---@param message Message
---@return string
function mapi.md2png_reply(message)
    local msgid = bot.get_reply_id(message)
    local js = get_msg(msgid, true)
    local msg = Message:new()
    msg:change(js.message)
    local para = msg:true_str()
    return string.format('[CQ:image,file=file://%s]', md2png(para))
end

return T
