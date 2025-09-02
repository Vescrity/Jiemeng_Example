---@class RulesInterface
local RulesInterface = {}
RulesInterface.__index = RulesInterface
---comment
---@param board Chessboard
---@return RulesInterface
function RulesInterface.new(board)
    ---@class RulesInterface
    local self = setmetatable({}, RulesInterface)
    self.board = board
    self.name = 'BASE'
    return self
end

-- 检查落子是否有效（子类必须实现）
---@param row integer
---@param col integer
---@param pieceType pieceType
function RulesInterface:isValidMove(row, col, pieceType)
    error("子类必须实现 isValidMove 方法")
end

-- 检查游戏是否结束（子类必须实现）
---@param row integer
---@param col integer
---@param pieceType pieceType
---@return boolean, pieceType|nil
function RulesInterface:checkGameOver(row, col, pieceType)
    error("子类必须实现 checkGameOver 方法")
end

return RulesInterface
