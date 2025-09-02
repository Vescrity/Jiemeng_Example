---@class ChessRoom
local ChessRoom = {}
ChessRoom.__index = ChessRoom
local req_prefix = (...):match("(.+)%.[^%.]+$")
---@module "chess.chessboard"
local Chessboard = require(req_prefix .. ".chessboard")
---@module "chess.gomoku_rules"
local rule = require(req_prefix .. ".gomoku_rules")
---@module "chess.game"
local game = require(req_prefix .. ".game")
---@module "chess.html_generator"
local generator = require(req_prefix .. ".html_generator")
local ex = require('jm_generic_extend')
local rvsplit = ex.string.reverse_split
local pngutils = require('pngutils')
---@param owner integer
---@param title string
function ChessRoom.new(owner, title)
    ---@class ChessRoom
    local self = setmetatable({}, ChessRoom)
    self.updateTime = os.time()
    self.coOperate = false
    self.singleMode = false
    self.board = Chessboard.new(19, '五子棋：' .. title)
    self.game = game.new(self.board, rule.new(self.board))
    self.generator = generator.new(self.board)
    self.owner = owner
    ---@type {[integer]:pieceType}
    self.players = {}
    self.cnt = {}
    for k, v in pairs(self.board.PIECE) do
        if k ~= 'EMPTY' then
            self.cnt[v] = 0
        end
    end
    return self
end

---comment
---@param pieceType pieceType
---@return boolean
function ChessRoom:isNewPlayerAvailable(pieceType)
    if self.singleMode then return false end
    if self.coOperate then return true end
    return self.cnt[pieceType] == 0
end

---comment
function ChessRoom:getStatus()
    local blist = {}
    local wlist = {}
    local b = self.board.PIECE.BLACK
    for k, v in pairs(self.players) do
        if (v == b) then
            table.insert(blist, tostring(k))
        else
            table.insert(wlist, tostring(k))
        end
    end
    local rt = string.format([[
=== 房间属性 ===
房主：%s
允许协作：%s
单人模式：%s
执黑列表：%s
执白列表：%s
]],
        tostring(self.owner),
        self.coOperate and '允许' or '不允许',
        tostring(self.singleMode),
        table.concat(blist, ' '),
        table.concat(wlist, ' ')
    )
    return rt .. self.game:getStatus()
end

function ChessRoom:getBoardPicture(msg)
    msg = msg or ''
    local html = self.generator:generateHTML(msg .. '\n' .. self:getStatus())
    return string.format('[CQ:image,file=file://%s]', pngutils.html2png(html))
end

---comment
---@param uid integer
---@param para string
---@return string
function ChessRoom:operate_put(uid, para)
    if self.players[uid] == nil then return '未加入该棋局' end
    if #para ~= 2 then return '提示: put#行列' end
    local rown, coln = string.byte(para, 1, #para)
    rown = rown - 96
    coln = coln - 64
    local suc, msg
    if self.singleMode then
        suc, msg = self.game:makeMove(rown, coln, self.game:getCurrentPlayer())
    else
        suc, msg = self.game:makeMove(rown, coln, self.players[uid])
    end
    return suc and (self:getBoardPicture(msg)) or msg
end

function ChessRoom:operate_undo(uid)
    local role = self.players[uid]
    if role == nil then return '未加入该棋局' end
    if not self.singleMode then
        if role == self.game:getCurrentPlayer() then return '请先让对方提出撤回' end
    end
    local suc, msg = self.game:undoMove()
    return suc and self:getBoardPicture(msg) or msg
end

function ChessRoom:operate_add(uid, pieceType)
    if self:isNewPlayerAvailable(pieceType) then
        self.cnt[pieceType] = self.cnt[pieceType] + 1
        self.players[uid] = pieceType
        return 'OK'
    end
    return '不可加入'
end

---comment
---@param uid integer
---@param cmd string
function ChessRoom:operate(uid, cmd)
    local para, oper = rvsplit(cmd)
    if oper == 'black' then return self:operate_add(uid, self.board.PIECE.BLACK) end
    if oper == 'white' then return self:operate_add(uid, self.board.PIECE.WHITE) end
    if oper == 'put' then
        return self:operate_put(uid, para)
    elseif oper == 'undo' then
        return self:operate_undo(uid)
    elseif oper == 'show' then
        return self:getBoardPicture()
    elseif oper == 'set' then
        if uid ~= self.owner then return '你不是房主' end
        if para == '' then return '请传参' end
        if para == 'cooper' then
            self.coOperate = not (self.coOperate)
            return '已将协作设置为：coOperate = ' .. tostring(self.coOperate)
        end
        if para == 'single' then
            self.singleMode = not (self.singleMode)
            return '已将单人模式设置为：singleMode = ' .. tostring(self.singleMode)
        end
        return 'TODO'
    else
        return 'what?'
    end
end

return ChessRoom
