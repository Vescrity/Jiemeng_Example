local mapi = {}
local ex = require("jm_generic_extend")
local reverse_split = ex.string.reverse_split
---comment
---@param d table
---@return string
local function sdai_send(d)
    d.negative_prompt = d.negative_prompt or 'bad legs, ugly, nsfw, watermark'
    d.steps = d.steps or 10
    d.width = d.width or 384
    d.height = d.height or 384
    d.cfg_scale = d.cfg_scale or 7
    d.sampler_name = d.sampler_name or 'DPM++ 2M'
    if d.width * d.height * d.steps > 1920 * 1080 * 10 then
        return 'Too Large'
    end
    --[[local s = {
        url = "http://127.0.0.1:7860",
        api = "/sdapi/v1/txt2img",
        data = d
    }
    print(jsonlib.table2json(s):dump(2))
    local rt = bot.api(s)]]
    local tmp = os.tmpname()
    local file = assert(io.open(tmp, "w"))
    file:write(jsonlib.table2json(d):dump())
    file:close()
    local output = io.popen('./script/sdtxt2img < ' .. tmp):read("*a")
    os.remove(tmp)
    if #output == 0 then
        return '魔法棒丢了qwq'
    end
    local rt = json.new()
    rt:parse(output)
    local r = jsonlib.json2table(rt)
    return '[CQ:image,file=base64://' .. r.images[1] .. ']'
end
---comment
---@param order string
---@return string
local function sdai(order)
    local options = {
        negative_prompt = '-n',
        prompt = '-p',
        steps = '-s',
        sampler_name = '-m',
        width = '-x',
        height = '-y',
        cfg_scale = '-c'
    }
    local res = ex.string.parse_options(options, order)
    return sdai_send(res)
end
---comment
---@param message Message
---@return string
function mapi.sdai(message)
    local str = message:true_str()
    local para = reverse_split(str)
    return sdai(para)
end

return { mapi = mapi, sdai = sdai }
