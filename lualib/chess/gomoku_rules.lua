---@module "chess.rules_interface"
local RulesInterface = require((...):match("(.+)%.[^%.]+$") .. ".rules_interface")

---@class GomokuRules:RulesInterface
local GomokuRules = setmetatable({}, RulesInterface)
GomokuRules.__index = GomokuRules

function GomokuRules.new(board)
    local self = RulesInterface.new(board)
    setmetatable(self, GomokuRules)
    self.name = '五子棋'
    return self
end

-- 检查落子是否有效
function GomokuRules:isValidMove(row, col, pieceType)
    -- 检查位置是否在棋盘内
    if not self.board:isValidPosition(row, col) then
        return false, "位置超出棋盘范围"
    end

    -- 检查位置是否为空
    if not self.board:isEmpty(row, col) then
        return false, "该位置已有棋子"
    end

    return true, nil
end

-- 检查游戏是否结束
function GomokuRules:checkGameOver(row, col, pieceType)
    -- 检查是否形成五连
    if self:checkFiveInRow(row, col, pieceType) then
        return true, pieceType
    end

    -- 检查是否棋盘已满（平局）
    if self:isBoardFull() then
        return true, nil -- nil 表示平局
    end

    return false, nil
end

-- 检查是否形成五连
function GomokuRules:checkFiveInRow(row, col, pieceType)
    local directions = {
        { 1, 0 }, -- 水平
        { 0, 1 }, -- 垂直
        { 1, 1 }, -- 右下对角线
        { 1, -1 } -- 左下对角线
    }

    for _, dir in ipairs(directions) do
        local deltaRow, deltaCol = dir[1], dir[2]

        -- 计算一个方向上的连续棋子数
        local count = 1 -- 包括当前落子

        -- 正向检查
        count = count + self:countConsecutive(row, col, deltaRow, deltaCol, pieceType)

        -- 反向检查
        count = count + self:countConsecutive(row, col, -deltaRow, -deltaCol, pieceType)

        if count >= 5 then
            return true
        end
    end

    return false
end

-- 计算一个方向上的连续棋子数
function GomokuRules:countConsecutive(startRow, startCol, deltaRow, deltaCol, pieceType)
    local count = 0
    local row, col = startRow + deltaRow, startCol + deltaCol

    while self.board:isValidPosition(row, col) do
        if self.board:getPiece(row, col) == pieceType then
            count = count + 1
            row = row + deltaRow
            col = col + deltaCol
        else
            break
        end
    end

    return count
end

-- 检查棋盘是否已满
function GomokuRules:isBoardFull()
    for i = 1, self.board.size do
        for j = 1, self.board.size do
            if self.board:isEmpty(i, j) then
                return false
            end
        end
    end
    return true
end

-- 获取所有合法的落子位置（可选，用于AI或提示）
function GomokuRules:getValidMoves()
    local validMoves = {}
    for i = 1, self.board.size do
        for j = 1, self.board.size do
            if self.board:isEmpty(i, j) then
                table.insert(validMoves, { row = i, col = j })
            end
        end
    end
    return validMoves
end

-- 评估棋盘状态（可选，用于AI）
function GomokuRules:evaluateBoard()
    -- 这里可以实现更复杂的评估函数
    -- 暂时返回简单的评估值
    return 0
end

return GomokuRules
