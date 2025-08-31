local T = {
    template_file = 'resource/fortune/fortune.html'
}
local ex = require("jm_generic_extend")
local png = require("pngutils")
local webapi = require("webapi")
---comment
---@param name string
---@param rank string|number
---@param title? string
function T.generate(name, rank,title)
    local temp          = ex.file.read(T.template_file)

    local info          = {
        title = title or '起床！',
        date = os.date("%Y年%m月%d日 %H:%M:%S"),
        user_name = name,
        rp = bot.rand(0, 100),
        rank = rank,
        sym = nil,
        fortune = nil,
        describe = nil,
        title2 = '一言',
        lists = string.format('<li>%s</li>', webapi.hitokoto()),
        foot = '桔梦姬',
    }
    local rp <const>    = info.rp
    ---@format disable
    local fortune_index =
        {"max","sym","fortune","fortune_color", "describes" }
    ---@type table[]
    local fortunes = {
        {   4, '凶', '大凶', '#000000',{ '真的要出门吗？', '问题很大，慌吧'} },
        {  10, '凶', '中凶', '#111122',{ '阿巴阿巴' } },
        {  20, '凶', '小凶', '#777788',{ '问题不大，慌也没用' } },
        {  40, '中', '中'  , '#33ff33',{ '平淡是福' } },
        {  50, '吉', '末吉', '#e0e050',{ '吉！！' } },
        {  60, '吉', '小吉', '#a07050',{ '小吉亦吉' } },
        {  75, '吉', '中吉', '#b06030',{ '不错不错' } },
        { 100, '吉', '大吉', '#E74C3C',{ '大吉大利！' } },
    }
    ---@format enable
    local selected
    for k,v in ipairs(fortunes) do
        if rp < v[1] then
            selected = k
            break
        end
    end
    for i = 2, #fortune_index do
        info[fortune_index[i]] = fortunes[selected][i]
    end
    local list = info.describes
    ---@cast list table
    local r = bot.rand(1,#list)
    info.describe = list[r]
    info.describes = nil
    local html = ex.string.format_from_table(temp, info)
    return string.format("[CQ:image,file=file://%s]", png.html2png(html))
end

return T
