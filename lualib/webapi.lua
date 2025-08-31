local mapi = {}
local T = {}
require("bot_os_shell")
require("bot_string")
require("bot_api")
local reverse_split = require("jm_generic_extend").string.reverse_split
---一言
---@return string CQMessage
function T.hitokoto()
    local data = {
        url = "https://v3.alapi.cn/api",
        api = "/hitokoto",
        data = { token = bot.custom_config.AL_TOKEN }
    }
    local rt = bot.request_api(data)
    return rt.data.hitokoto .. '\n\t——' .. rt.data.from
end

---每日新闻
---@return string
function T.daily_news()
    local data = {
        url = "https://v3.alapi.cn/api",
        api = "/zaobao",
        data = { token = bot.custom_config.AL_TOKEN, format = 'json' },
        get = true
    }
    local rt = bot.request_api(data)
    return '[CQ:image,file=' .. rt.data.image .. ']'
end

function T.wiki(str)
    local data = {
        url = "https://api2.wer.plus/api",
        api = "/dub",
        data = { t = str },
        get = true
    }
    local rt = bot.request_api(data)
    return rt.data.text
end

function mapi.wiki(msg)
    local str = msg:true_str()
    local para = reverse_split(str)
    return T.wiki(para)
end

function T.rand_pic()
    local data = {}
    data[1] = {
        url = "https://www.dmoe.cc",
        api = "/random.php",
        get = true,
        data = {}
    }
    data[1].data['return'] = 'json'

    data[2] = {
        url = "https://iw233.cn",
        api = "/api.php",
        get = true,
        data = { type = 'json', sort = 'random' }
    }
    local r = math.random(1, 2)
    local rt = bot.request_api(data[r])
    local t
    if (r == 1) then
        t = rt.imgurl:val()
    elseif (r == 2) then
        t = rt.pic[1]:val()
    else
        t = rt.url:val()
    end
    return '[CQ:image,file=' .. t .. ']'
end

function T.youdao_dict(word)
    local data = {
        url = "http://dict.youdao.com",
        api = "/suggest",
        data = { q = word, num = 1, doctype = 'json' },
        get = true
    }
    local rt = bot.request_api(data)
    return rt.data.entries[1].entry .. '\n' .. rt.data.entries[1].explain ..
        '\n来源：http://dict.youdao.com'
end

function mapi.youdao_dict(msg)
    local str = msg:true_str()
    local para = reverse_split(str)
    return T.youdao_dict(para)
end

function mapi.sdcv(msg)
    local str = msg:true_str()
    local para = reverse_split(str)
    return bot.os_sh("sdcv '" .. para .. "' <<EOF\n")
end

---comment
---@param word string
---@param times integer
---@return string
function T.music_sch(word, times)
    if (times > 10) then return '不要超过10' end
    local data = {
        url = "https://music.163.com/api",
        api = "/search/get/web",
        data = { s = word, type = 1, offset = 0, total = "true", limit = times },
        get = true
    }
    local rt = bot.request_api(data)
    local rtstr = ''
    local mx_times = math.min(times, #rt.result.songs)
    if (mx_times == 1) then
        rtstr = '[CQ:music,type=163,id=' .. rt.result.songs[1].id .. ']'
        return rtstr
    end
    for i = 1, mx_times do
        local song = rt.result.songs[i]
        local a_name = ''
        for j, k in ipairs(song.artists) do
            if (j > 1) then a_name = a_name .. ', ' end
            a_name = a_name .. k.name
        end
        rtstr = rtstr .. song.name .. ' - ' .. a_name ..
            '\nhttps://music.163.com/song/' .. song.id
        if (i ~= mx_times) then rtstr = rtstr .. '\n\n' end
    end
    if (mx_times < times) then
        rtstr = rtstr .. '\n\n没有更多结果了。'
    end
    return rtstr
end

---
---@param msg Message
---@return string
function mapi.music_sch(msg)
    local str = msg:true_str()
    local para = reverse_split(str)
    local para2, para1 = reverse_split(para, '\n')
    local para2n = tonumber(para2) or 1
    return T.music_sch(para1, para2n)
end

---comment
---@return string
function T.random_picture()
    local data = {
        url = "https://www.dmoe.cc",
        api = "/random.php",
        get = true,
        data = {}
    }
    data.data["return"] = 'json'
    local rt = bot.request_api(data)
    return '[CQ:image,file=' .. rt['imgurl'] .. ']'
end

T.mapi = mapi
return T
