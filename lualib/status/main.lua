-- main.lua - 主程序
local generator = require("lualib.status.html_generator")
local df = require("lualib.status.df")
local function os_sh(cmd)
    local handle = io.popen(cmd)
    assert(handle ~= nil)
    local output = handle:read("*a")
    handle:close()
    return output
end
local function get_sysinfo()
    local memory_total = tonumber(os_sh([[grep MemTotal /proc/meminfo|tr -s ' '|cut -d' ' -f2 ]]))
    local memory_available = tonumber(os_sh([[grep MemAvailable /proc/meminfo|tr -s ' '|cut -d' ' -f2 ]]))
    assert(memory_available ~= nil)
    assert(memory_total ~= nil)
    return {
        hostname = os_sh('uname -n'),
        os = os_sh('lsb_release -drs'),
        uptime = os_sh('uptime -p'),
        cpu_usage = "45.2%",
        memory = {
            total = memory_total,
            available = memory_available,
            used = memory_total - memory_available,
        },
        bot = { name = '桔梦' },
        disk = df.df_parse(os_sh([[df -h|grep '^/dev']])),
        load_avg = os_sh([[cut -d' ' -f1-3 /proc/loadavg]]),
        processes = os_sh("pgrep -c ."),
    }
end

-- 系统信息（可以替换为真实数据获取）

local T = {
    config_file = 'resource/status/config.lua',
    config = {
        modules = {
            "bot_info",
            "system_overview",
            "performance",
            "disk_usage",
        },
    }
}
function T.generate()
    -- 生成 HTML
    local config = dofile(T.config_file)
    return generator.generate_html(get_sysinfo(), config)
end

return T
