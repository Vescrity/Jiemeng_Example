---@class Game
local Game = {}
Game.__index = Game
Game.STATE = {
    PLAYING = 0,
    BLACK_WIN = 1,
    WHITE_WIN = 2,
    DRAW = 3,
}
---comment
---@param board Chessboard
---@param rules RulesInterface
---@return table
function Game.new(board, rules)
    ---@class Game
    local self = setmetatable({}, Game)
    self.board = board
    self.rules = rules
    self.currentPlayer = board.PIECE.BLACK
    self.state = Game.STATE.PLAYING
    self.moveHistory = {}
    return self
end

function Game:getStatus()
    return string.format([[
=== 游戏状态 ===
执子：%s
状态：%s
    ]],
        self.currentPlayer == self.board.PIECE.BLACK and '黑棋' or '白棋',
        self:getStateString()
    )
end

function Game:getStateString()
    if self.state == self.STATE.DRAW then return '平局' end
    if self.state == self.STATE.PLAYING then return '游戏中' end
    if self.state == self.STATE.BLACK_WIN then return '黑棋胜利' end
    if self.state == self.STATE.WHITE_WIN then return '白棋胜利' end
end

-- 切换玩家
function Game:switchPlayer()
    self.currentPlayer = (self.currentPlayer == self.board.PIECE.BLACK) and
        self.board.PIECE.WHITE or self.board.PIECE.BLACK
end

-- 尝试落子
function Game:makeMove(row, col)
    if self.state ~= self.STATE.PLAYING then
        return false, "游戏已结束"
    end

    if not self.rules:isValidMove(row, col, self.currentPlayer) then
        return false, "无效的落子位置"
    end

    -- 放置棋子
    self.board:placePiece(row, col, self.currentPlayer)
    table.insert(self.moveHistory, { row = row, col = col, player = self.currentPlayer })

    local crtp = self.currentPlayer
    -- 切换玩家
    self:switchPlayer()
    -- 检查游戏是否结束
    local isOver, winner = self.rules:checkGameOver(row, col, crtp)
    if isOver then
        if winner == nil then self.state = self.STATE.DRAW end
        if winner == self.board.PIECE.BLACK then self.state = self.STATE.BLACK_WIN end
        if winner == self.board.PIECE.WHITE then self.state = self.STATE.WHITE_WIN end
        return true, "游戏结束: " .. self:getStateString()
    end

    return true, "落子成功"
end

-- 悔棋
function Game:undoMove()
    if #self.moveHistory == 0 then
        return false, "没有可悔棋的步骤"
    end

    local lastMove = table.remove(self.moveHistory)
    self.board:removePiece(lastMove.row, lastMove.col)
    self:switchPlayer()        -- 切换回上一个玩家
    self.gameState = "playing" -- 重置游戏状态

    return true, "悔棋成功"
end

-- 获取当前玩家
function Game:getCurrentPlayer()
    return self.currentPlayer
end

-- 获取游戏状态
function Game:getGameState()
    return self.gameState
end

-- 获取移动历史
function Game:getMoveHistory()
    return self.moveHistory
end

return Game
