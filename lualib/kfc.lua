local kfc = {}
local mapi = {}
kfc.mapi = mapi
local exs = require("jm_generic_extend").string
local filename = "vme50.txt" -- 数据文件名

-- 数据结构
local data = {}

-- 读取数据从文件
local function load_data()
    data = {}
    local file = io.open(filename, "r")
    if file then
        local lines = {}
        for line in file:lines() do
            table.insert(lines, line)
        end
        file:close()

        for i = 1, #lines, 4 do
            local name = lines[i]
            local a = lines[i + 1] or ""
            local b = lines[i + 2] or ""
            table.insert(data, { name = name, a = a, b = b })
        end
    else
        -- 初始化数据
        local names = { "疯", "狂", "星", "期", "四", "微", "我", "五", "十" }
        for i = 1, 20 do
            data[i] = { name = 'awa', a = "0", b = "0" }
        end
    end
end

-- 保存数据到文件
local function save_data()
    local file = io.open(filename, "w")
    if file then
        for _, row in ipairs(data) do
            file:write(row.name .. "\n" .. row.a .. "\n" .. row.b .. "\n[CUT]\n")
        end
        file:close()
    else
        return "Error: Unable to save data."
    end
end

-- 展示数据
local function display_data()
    load_data() -- 加载数据
    local output = {}
    for i, row in ipairs(data) do
        table.insert(output, string.format("%d: %s %s %s", i, row.name, row.a, row.b))
    end
    return table.concat(output, "\n")
end

-- 修改指定行
local function modify_row(index, new_a, new_b)
    if index >= 1 and index <= 20 then
        data[index].a = new_a
        data[index].b = new_b
        save_data() -- 每次修改后保存数据
        return string.format("Modified Row %d: 曲名 = %s, 作者 = %s", index, new_a, new_b)
    else
        return "Error: Index out of bounds."
    end
end

-- 主程序

kfc.display = display_data

function mapi.modify(message)
    load_data() -- 加载数据
    local str = message:true_str()
    local para = exs.reverse_split(str)
    local paras, para1 = exs.reverse_split(para)
    local para3, para2 = exs.reverse_split(paras)
    para01 = tonumber(para1)
    local result = modify_row(para01, para2, para3)
    return bot.string_only(result)
end

return kfc
