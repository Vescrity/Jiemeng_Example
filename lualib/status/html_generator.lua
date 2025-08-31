-- html_generator.lua - HTML 生成器
local cards = require("lualib.status.cards")
local ex = require("luarc.jm_generic_extend")

local generator = {}

local process_styles = ex.string.format_from_table

-- 生成完整的 HTML
function generator.generate_html(sysinfo, config)
    cards.config = config
    -- 处理样式变量
    local style_file = io.open(config.style_file, "r")
    assert(style_file ~= nil)
    local styles = style_file:read("*a")
    style_file:close()
    local processed_styles = process_styles(styles, config.styles)

    -- 生成卡片内容
    local cards_content = ""
    for _, card_name in ipairs(config.modules) do
        if cards[card_name] then
            cards_content = cards_content .. cards[card_name](sysinfo)
        end
    end

    -- 使用配置的布局模板生成完整 HTML
    local html = string.format(
        config.layout,
        config.title,       -- 标题
        processed_styles,   -- CSS 样式
        config.background,  -- 背景图片
        config.title,       -- 页面标题
        config.update_time, -- 更新时间
        cards_content,      -- 卡片内容
        config.footer_text  -- 页脚文本
    )

    return html
end

-- 保存 HTML 到文件
function generator.save_html(html, filename)
    local file = io.open(filename, "w")
    if file then
        file:write(html)
        file:close()
        return true
    end
    return false
end

return generator
