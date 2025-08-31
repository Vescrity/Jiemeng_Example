--- vim:fileencoding=utf-8:foldmethod=marker

-- cards.lua - 卡片模块
local cards = { config = {} }

local infoitem, progress_bar
---BASIC {{{
---comment
---@param lable string
---@param value any
---@return string
function infoitem(lable, value)
    return string.format([[
        <div class="info-item">
            <span class="label">%s</span>
            <span class="value">%s</span>
        </div>
    ]], lable, tostring(value))
end

---comment
---@param class string
---@param percent number|string
---@return string
function progress_bar(class, percent)
    if type(percent) == 'number' then
        percent = string.format('%.1f%%', percent)
    end
    return string.format([[
    <div class="progress-bar">
        <div class="progress-fill %s" style="width: %s"></div>
    </div>
    ]], class, percent)
end

---}}}
-- 系统概览卡片
function cards.system_overview(info)
    local content =
        infoitem('操作系统', info.os) ..
        infoitem('运行时间', info.uptime) ..
        infoitem('进程', info.processes)

    return string.format(cards.config.card_template, "📊 系统", content)
end

function cards.performance(info)
    local mem = info.memory
    local mem_percent = mem.used / mem.total * 100
    local used = mem.used / 1e6
    local total = mem.total / 1e6
    local cpu = infoitem('CPU 负载', info.load_avg)
    local mems =
        infoitem('内存', string.format('%.2fGB/%.2fGB', used, total)) ..
        progress_bar('progress-memory', mem_percent)

    return string.format(cards.config.card_template, "🚀 负载", cpu .. mems)
end

-- bot卡片
---@param info table
---@retun string
function cards.bot_info(info)
    local bots = info.bot
    local content =
        infoitem('名称', bots.name) ..
        infoitem('版本', bot._version) ..
        infoitem('编译时间', bot._compile_time) ..
        infoitem('启动时间', bot.start_up_time()) ..
        infoitem('牌堆词条', bot.get_deck_size()) ..
        infoitem('应答词条', bot.get_answer_size()) ..
        infoitem('Lua 版本', _VERSION)

    return string.format(cards.config.card_template, "Bot", content)
end

---@class  df_entry
---@field Filesystem string
---@field Size string
---@field Used string
---@field Avail string
---@field Use_percent string
---@field Mounted_on string

--- 磁盘使用卡片
---@param info table
---@retun string
function cards.disk_usage(info)
    ---@type df_entry[]
    local disk = info.disk
    local rt = ''
    for _, v in ipairs(disk) do
        rt = rt ..
            infoitem(v.Mounted_on, v.Used .. '/' .. v.Size) ..
            progress_bar('progress-disk', v.Use_percent)
    end
    return string.format(cards.config.card_template, "💿 存储", rt)
end

-- 网络状态卡片
function cards.network_status(info)
    local content = [[<div class="info-grid">]]

    for _, net in ipairs(info.network) do
        content = content .. [[
        <div class="info-item">
            <span class="label">]] .. net.interface .. [[ ↓</span>
            <span class="value">]] .. net.rx .. [[</span>
        </div>
        <div class="info-item">
            <span class="label">]] .. net.interface .. [[ ↑</span>
            <span class="value">]] .. net.tx .. [[</span>
        </div>
        ]]
    end

    content = content .. "</div>"

    return string.format(cards.config.card_template, "🌐 网络状态", content)
end

return cards
