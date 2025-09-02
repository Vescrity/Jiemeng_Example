---@class HTMLGenerator
local HTMLGenerator = {
    config = {
        css_file = 'resource/chess/style.css'
    }
}
local exf = require('jm_generic_extend').file
HTMLGenerator.__index = HTMLGenerator
---comment
---@param board Chessboard
function HTMLGenerator.new(board)
    ---@class HTMLGenerator
    local self = setmetatable({}, HTMLGenerator)
    self.board = board
    self.css = exf.read(HTMLGenerator.config.css_file)
    return self
end

---@param status string
function HTMLGenerator:generateHTML(status )
    local css = self.css or ''
    local html = {}

    table.insert(html, [[
<html>
<head>
    <style>]] .. css .. [[
    </style>
</head>
<body>]])
    status = status or ''
    table.insert(html, string.format([[
    <h2>%s</h2>
    <div class="status"><pre>%s</pre></div>
    <div class="chessboard">
    ]], self.board.title,status))

    -- 生成棋盘行
    for i = 1, self.board.size do
        table.insert(html, '<div class="row">')
        local Chessboard = self.board

        for j = 1, self.board.size do
            local piece = self.board:getPiece(i, j)
            local pieceClass = ""

            if piece == Chessboard.PIECE.BLACK then
                pieceClass = "black"
            elseif piece == Chessboard.PIECE.WHITE then
                pieceClass = "white"
            end

            table.insert(html, string.format('<div class="cell" data-row="%d" data-col="%d">', i, j))
            if pieceClass ~= "" then
                table.insert(html, string.format('<div class="piece %s"></div>', pieceClass))
            end
            table.insert(html, string.format('<span class="coordinates row-coord">%s</span>', string.char(96 + i)))
            table.insert(html, string.format('<span class="coordinates col-coord">%s</span>', string.char(64 + j)))
            table.insert(html, '</div>')
        end
        table.insert(html, '</div>')
    end
    table.insert(html, [[
    </div>
</body>
</html>
    ]])

    return table.concat(html, "\n")
end

return HTMLGenerator
