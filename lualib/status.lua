local T = {}
local g = require('lualib.status.main')
local png = require('pngutils')
function T.pretty()
    return string.format('[CQ:image,file=file://%s]',png.html2png(g.generate()))
end
return T
