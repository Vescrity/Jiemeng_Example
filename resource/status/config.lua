-- config.lua - 配置文件
local config = {
    modules = {
        "bot_info",
        "system_overview",
        "performance",
        "disk_usage",
    },
}

-- 基本配置
config.title = "桔梦状态"
config.background = "/home/vescrity/Pictures/Wallpaper/repo/acchan.jpg"
config.style_file = "./resource/status/style.css"
config.update_time = os.date("%Y-%m-%d %H:%M:%S")

-- 样式配置
config.styles = {
    primary_color = "#667eea",
    secondary_color = "#764ba2",
    card_bg = "rgba(25, 125, 175, 0.95)",
    text_color = "#eee",
    border_radius = "15px"
}

-- 布局模板
config.layout = [[
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>%s</title>
    <style>%s</style>
</head>
<body style="background-image: url('%s');">
    <div class="container">
        <div class="header">
            <h1>%s</h1>
            <p>%s</p>
        </div>

        <div class="dashboard">
            %s  <!-- 卡片内容将插入这里 -->
        </div>

        <div class="footer">
            <p>%s</p>
        </div>
    </div>
</body>
</html>
]]

-- 卡片模板
config.card_template = [[
<div class="card">
    <h2>%s</h2>
    <div class="item-list">
    %s
    </div>
</div>
<br/>
]]

-- 页脚模板
config.footer_text = "桔梦姬"

return config
