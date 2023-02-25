function strSplit(a,b)result={} for c in(a..b):gmatch("(.-)"..b) do table.insert(result,c) end; return result end

function pad(text, pad)
    if pad == nil then return text end
    if pad < 0 then
        pad = math.abs(pad)
        while string.len(text) < pad do text = " " .. text end
    elseif pad > 0 then
        while string.len(text) < pad do text = text .. " " end
    end
    return text
end

function ToColor(w,x,y,z) return {r = w, g = x, b = y, o = z} end

names = {}
function fixText(text)
    if names[text] == nil then
        text = text:gsub("%B ", "Basic ")
        text = text:gsub(" I ", " Industry ")
        text = text:gsub(" S ", " Smelter ")
        text = text:gsub(" E ", " Electronics ")
        text = text:gsub(" 3 ", " 3d ")
        text = text:gsub(" R ", " Refiner ")
        text = text:gsub(" P ", " Printer ")
        text = text:gsub(" M ", " Metalwork ")
        text = text:gsub("TU " , "Transfer Unit ")
        text = text:gsub(" AL ", " Assembly Line ")

        text = text:gsub("`I", "Cycling")
        text = text:gsub("`R", "Running")
        text = text:gsub("`W", "Cycling")
        text = text:gsub("`J", "JAMMED!")
        text = text:gsub("`P", "Cycling")
        text = text:gsub("!!", "!SCHEMATICS!")

        names[text] = text
    end
    return names[text]
end

if not init then
    rx, ry = getResolution()
    init = true
end
local fontSize = 18
local font = loadFont('RobotoMono', fontSize)
local rslib = require('rslib')
local config = { fontSize = fontSize}
local l = createLayer()

xcoords = {}
xcoords[1] = 5
xcoords[2] = 70
xcoords[3] = 255
xcoords[4] = 375
xcoords[5] = 445
xcoords[6] = 525

padding = {}
padding[1] = -5
padding[4] = -5
padding[5] = -5
-- padding[6] = -5

local white = ToColor(1, 1, 1, 1)
local red = ToColor(1, 0, 0, 1)
local green = ToColor(0, 1, 0, 1)

for i,text in pairs(strSplit(getInput(), "\n")) do
    y = i * (fontSize + 4)
    split = strSplit(text, ",")
    local color = white
    if split[3] == "`R" then color = green end
    if split[3] == "!!" then color = red end
    if split[2] == "Refiner" and split[3] == '`W' then 
        color = red 
        split[3] = "!NEED ORE!"
    end

    for j, t in pairs(split) do
        setNextFillColor(l, color.r, color.g, color.b, color.o)
        addText(l, font, pad( fixText(t:gsub("^||", "line")), padding[j]), xcoords[j], y, AlignH_Center, AlignV_Middle, ToColor(0.5, 0.5, 0.5, 0.5))    
    end
end

addText(l, font, "Input", 100, 485, 0)
addText(l, font, "Line 1", 350, 485, 0)
addText(l, font, "Line 2", 600, 485, 0)
addText(l, font, "Output", 865, 485, 0)
