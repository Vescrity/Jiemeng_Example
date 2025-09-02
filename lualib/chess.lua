local T = {
    config = {
        help = [[
**用法：**

- .chess#list : 房间列表
- .chess#help : 帮助
- .chess#*房间名*#*操作*

操作：

|命令|说明|
|-   | :-:|
| create     |建立房间|
| delete     |移除房间|
| black      |执黑|
| white      |执白|
| show       |展示棋盘|
| put#行列   |放置|
| undo       |撤回上一步|
| set#single |打开/关闭单人模式|
| set#cooper |允许/禁止协作|

### 例

|功能|指令|
|-|-|
| 创建房间【uwu】               |`.chess#uwu#create`|
| 在房间【uwu】选择执黑         |`.chess#uwu#black`|
| 在房间【uwu】放置棋子至p行Q列 |`.chess#uwu#put#pQ`|
| 在房间【uwu】悔棋             |`.chess#uwu#undo`|

### 说明

单人模式：自己轮流放置黑白
协作：允许多人执同色共同提交操作
]]
    }
}
local ChessRoom = require('chess.room')
---@type ChessRoom[]
local rooms = {}
local rvsplit = require('jm_generic_extend').string.reverse_split
local pngutils = require('pngutils')
local function main(uid, para)
    local cmd, room = rvsplit(para)
    if room == 'help' or cmd == 'help' then
        return string.format('[CQ:image,file=file://%s]', pngutils.md2png(T.config.help))
    end
    if room == 'list' then
        local md = [[
|房间名|房主|共同操作？|黑可加入？|白可加入？|单人模式？|
|------|----| -------- |----------|----------|----------|
]]
        for k, v in pairs(rooms) do
            md = md .. string.format(
                '|%s|%s|%s|%s|%s|%s|\n',
                tostring(k), tostring(v.owner),
                v.coOperate and '是' or '否',
                v:isNewPlayerAvailable(v.board.PIECE.BLACK) and '是' or '否',
                v:isNewPlayerAvailable(v.board.PIECE.WHITE) and '是' or '否',
                v.singleMode and '是' or '否'
            )
        end
        return string.format('[CQ:image,file=file://%s]', pngutils.md2png(md))
    end
    if cmd == 'create' then
        if rooms[room] ~= nil then return '房间已存在' end
        rooms[room] = ChessRoom.new(uid, room)
        return '房间已建成，请选择颜色'
    end
    if rooms[room] == nil then return string.format('房间【%s】不存在', room) end
    if cmd == 'delete' then
        if rooms[room].owner ~= uid then return '你不是房主' end
        rooms[room] = nil
        return '已删除'
    end
    return rooms[room]:operate(uid, cmd)
end
T.main = main
return T
