---@class Chessboard
---@field grid integer[][]
local Chessboard = {}
Chessboard.__index = Chessboard

---@enum pieceType
Chessboard.PIECE = {
    EMPTY = 0,
    BLACK = 1,
    WHITE = 2
}
---@param size integer
---@param title? string
function Chessboard.new(size,title)
    ---@class Chessboard
    local self = setmetatable({}, Chessboard)
    self.size = size or 15
    self.title = (title and title) or 'Title'
    self.grid = {}

    -- 初始化棋盘
    for i = 1, self.size do
        self.grid[i] = {}
        for j = 1, self.size do
            self.grid[i][j] = Chessboard.PIECE.EMPTY
        end
    end

    -- 设置初始布局（可选）
    self:setupInitialPieces()

    return self
end

-- 设置初始棋子布局（例如围棋或五子棋的初始状态）
function Chessboard:setupInitialPieces()
    -- 这里可以根据你的棋类规则设置初始布局
    -- 例如围棋的星位，或者空棋盘
end

function Chessboard:isValidPosition(row, col)
    return row >= 1 and row <= self.size and col >= 1 and col <= self.size
end

-- 检查位置是否为空
function Chessboard:isEmpty(row, col)
    return self:isValidPosition(row, col) and
        self:getPiece(row, col) == Chessboard.PIECE.EMPTY
end

-- 放置棋子
---@param row integer
---@param col integer
---@param pieceType pieceType
function Chessboard:placePiece(row, col, pieceType)
    if self:isValidPosition(row, col) then
        self.grid[row][col] = pieceType
        return true
    end
    return false
end

-- 移除棋子
---@param row integer
---@param col integer
function Chessboard:removePiece(row, col)
    if self:isValidPosition(row, col) then
        self.grid[row][col] = Chessboard.PIECE.EMPTY
        return true
    end
    return false
end

-- 获取棋子
---@param row integer
---@param col integer
function Chessboard:getPiece(row, col)
    if self:isValidPosition(row, col) then
        return self.grid[row][col]
    end
    return nil
end

function Chessboard:clearBoard()
    for i = 1, self.size do
        for j = 1, self.size do
            self.grid[i][j] = Chessboard.PIECE.EMPTY
        end
    end
end

Chessboard.clear = Chessboard.clearBoard

-- 获取棋盘状态（用于序列化）
function Chessboard:getState()
    return {
        size = self.size,
        grid = self.grid
    }
end

-- 从状态恢复棋盘
function Chessboard:fromState(state)
    self.size = state.size
    self.grid = state.grid
end

-- 打印棋盘到控制台（调试用）
function Chessboard:print()
    print("棋盘状态:")
    for i = 1, self.size do
        local row = {}
        for j = 1, self.size do
            local piece = self:getPiece(i, j)
            if piece == Chessboard.PIECE.BLACK then
                table.insert(row, "●")
            elseif piece == Chessboard.PIECE.WHITE then
                table.insert(row, "○")
            else
                table.insert(row, "+")
            end
        end
        print(table.concat(row, " "))
    end
end

return Chessboard
