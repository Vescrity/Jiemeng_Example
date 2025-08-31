local T = {}
function T.df_parse(df_output_string)
    local parsed_data = {}
    -- 迭代字符串中的每一行
    for line in df_output_string:gmatch("[^\n]+") do
        -- 确保行不是空的或者只有空白符
        if line:match("%S") then
            -- 使用模式匹配来提取每个字段
            -- %S+ 匹配一个或多个非空白字符
            -- (.-) 匹配任意字符直到下一个模式出现，
            -- 这是为了捕获Mounted_on，因为它可能包含空格
            local filesystem, size, used, avail, use_percent, mounted_on =
                line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(.*)")

            if filesystem then -- 确保匹配成功
                local entry = {
                    Filesystem = filesystem,
                    Size = size,
                    Used = used,
                    Avail = avail,
                    Use_percent = use_percent,
                    Mounted_on = mounted_on
                }
                table.insert(parsed_data, entry)
            end
        end
    end
    return parsed_data
end
return T
