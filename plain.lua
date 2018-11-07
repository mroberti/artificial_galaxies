
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

-- Requires ---------------------------
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

