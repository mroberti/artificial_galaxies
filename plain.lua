
SQRT = math.sqrt
PI = math.pi
SIN = math.sin
COS = math.cos
FLOOR = math.floor
ABS = math.abs
CEIL = math.ceil
RAND = math.random
RAD = math.rad
-- require'lfs'
JSON = require( "JSON" )
math.randomseed(os.time())
namegen = require("namegen")
debug = false
function logger(info,override)
	-- Override will print regardless of global debug value
	if(debug or override~=nil)then
		print(info)
	end
end

-- Requires ---------------------------
require("misclua.coronahelpers")
require("misclua.mathlib")
require("misclua.helpers")
require("misclua.military_unit_name")
require("misclua.coronahelpers")
class = require("misclua.30log-global")
require("classes.Empire")
require("classes.Planet")
require("classes.Star")
require("classes.Species")
require("classes.Ship")
require("classes.Galaxy")
require("classes.Galaxy2")
hull = require("classes.Convex_hull")

-- While we like OOP, there are 
-- some things that should be loaded
-- and handled globally, like the table
-- for our different governments
government_file = loadjson("./misclua/government_types.json")
government_type = {}
government_description = {}

for k,v in pairs(government_file) do
    table.insert(government_type,k)
    table.insert(government_description,v[1])
end

--Spatial Definitions------------------------------------------
screenW = 500
screenH = 300
centerX  = screenW/2
centerY = screenH/2

---------------------------------------------------------------------
local border = 20
local data= {
    -- The width and height of the 
    -- galaxy in units. Pixels, light years, 
    -- hey it's up to you,
    -- Number of empires
    -- minimum distance from another empire
    numberOfStars = 20,
    width = screenW,
    height = screenH,
    numberOfEmpires = 3,
    numberOfShips = 5,
    numberOfSpecies = 3
}


-- local galaxy = Galaxy:new()
local galaxy = Galaxy:new(data)
local starModel = {}
local shipModel = {}

function CreateModelStars()
    -- Run some tests on the galaxy object
    -- starModel = galaxy:GetAllStarsBelongingToAEmpire(galaxy.empires[1])
    starModel = galaxy.stars
    -- Debug info if you wanna verify stuff!
    -- for i=1,#starModel do
    --  print("Star "..starModel[i].name.." belongs to the "..galaxy.empires[1].name)
    -- end
end

function CreateModelShips()
    -- Create ships and pass some data
    -- print("How big is ships? "..#galaxy.ships)
    for i=1,#galaxy.ships do
        local shipData = {
            name = "Ship "..i,
            dockedAt = galaxy.stars[RAND(1,#galaxy.stars)],
            empire = galaxy.empires[1],
            speed = RAND(1,10),
            heading = RAND(1,360)
        }

        local myShip = Ship:new(shipData)
        myShip.x,myShip.y = myShip.dockedAt.x,myShip.dockedAt.y
        table.insert(shipModel,myShip)
    end
end

function MoveShips()
    for i=1,#galaxy.ships do
        galaxy.ships[i]:ChangeHeading(galaxy.ships[i].destination)
        galaxy.ships[i]:MoveForward()
        -- Sync the view with the newly
        -- updated data model location
        -- shipView[i].x,shipView[i].y = galaxy.ships[i].x,galaxy.ships[i].y
    end
end

CreateModelStars()
CreateModelShips()
-- CreateSpeciesName()

function ScanForSerializables2(file)

    local temp1 = SplitString(file,".lua")
    local temp = SplitString(temp1[1],"\\")
    local name = temp[#temp]
    print("name "..name)
    function file_check(file_name)
        local file_found=io.open(file_name, "r")    
        local result = false  

        if file_found==nil then
            result = false
        else
            result = true
        end
        return result
    end

    -- get all lines from a file, returns an empty 
    -- list/table if the file does not exist
    function lines_from(file)
        if not file_exists(file) then return {} end
        lines = {}
        for line in io.lines(file) do 
            lines[#lines + 1] = line
        end
        return lines
    end

    if(file_check(file))then
        print("Exists "..tostring(file_check(file)))
        print("File "..file)
        print("MOyster")        
    -- Read variables/data/properties from file
        local variables = {}
        local methods = {}
        -- tests the functions above
        local file = '.\\classes\\Galaxy.lua'
        local contents = lines_from(file)
        -- print all line numbers and their contents
        -- for k,v in pairs(contents) do
        --   print('line[' .. k .. ']', v)
        -- end
        -- for line in (contents..'\n'):gmatch'(.-)\r?\n' do 
        for k,line in pairs(contents) do
            -- print("POn")
            if string.match(line, "Serialize this") then
                local word1 = SplitString(line,"=")[1]
                word1 = word1:gsub("%s+", "")
                local word2 = SplitString(word1,"self.")[2]
                -- print ("temp"..name.."."..word2.." = "..word1)
                table.insert(variables,"{Ctrl {Enter}}{Delay 250}"..word2..":int{Delay 100}{Enter}")
                -- print ("{Ctrl {Enter}}{Delay 250}"..word2..":int{Delay 100}{Enter}")
            elseif string.match(line, "function "..name..":") then
                -- print("Ok we found "..line)
                local word1 = SplitString(line,":")[2]
                -- print ("temp "..word1)
                table.insert(methods,"{Ctrl {Shift {Enter}}}{Delay 250}"..word1..":int{Delay 100}{Enter}")
            end
        end
        print("Variables\n------------------")
        for i=1,#variables do
            print(variables[i])
        end
        print("Methods\n------------------")
        for i=1,#methods do
            print(methods[i])
        end
    else

    end
end

ScanForSerializables2(".\\classes\\Galaxy.lua")
function loadjson(filename)
    local f = assert(io.open(filename, "rb"))
    local content = f:read("*all")
    f:close()
    return JSON:decode(content)
end

local model = loadjson(".\\AG_modelmdj.mdj")

function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+4))
                        print(indent..string.rep(" ",string.len(pos)+3).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t," ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

-- print_r(model)

print("Test "..model._type)
print("Id "..model._id)