
SQRT = math.sqrt
PI = math.pi
SIN = math.sin
COS = math.cos
FLOOR = math.floor
ABS = math.abs
CEIL = math.ceil
RAND = math.random
RAD = math.rad

math.randomseed( os.time() )


-- Requires ---------------------------
require("misclua.mathlib")
require("misclua.helpers")
require("misclua.coronahelpers")
json = require( "json" )
class = require("misclua.30log-global")
require("classes.Empire")
require("classes.Planet")
require("classes.Star")
require("classes.Species")
require("classes.Ship")
require("classes.Galaxy")


hull = require("classes.Convex_hull")

sceneGroup = display.newGroup()


---------------------------------------

--OLDER Spatial Definitions------------------------------------------
screenW = display.contentWidth
screenH = display.contentHeight
centerX  = display.contentWidth/2
centerY = display.contentHeight/2

---------------------------------------------------------------------
local border = 20
local data= {
    -- The width and height of the 
    -- galaxy in units. Pixels, light years, 
    -- hey it's up to you,
    -- Number of empires
    -- minimum distance from another empire
    numberOfStars = 50,
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

local starView = {}
local shipView = {}


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
    print("How big is ships? "..#galaxy.ships)
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

function DisplayStars()
    -- Iterate through our list of starModel
    -- to get the DATA ONLY to use to crate our
    -- View portion
    for i=1,#starModel do
        local tempStar = display.newCircle(starModel[i].x, starModel[i].y, 2 )
        tempStar:setFillColor( 1,1,1 )
        table.insert(starView,tempStar)
        sceneGroup:insert(tempStar)
    end
    print("Size of StarView "..#starView)
end

function DisplayShips()
    -- Iterate through our list of starModel
    -- to get the DATA ONLY to use to crate our
    -- View portion
    -- Create a ship next to each star in our
    -- starModel data
    for i=1,#galaxy.ships do
        -- Create a temporary ship display object
        -- Polypoints can be found in our misclua
        -- folder under corona helper. It makes n sided
        -- polygon display objects
        local tempShip = polypoints(6, RAND(5,7), 0.0,0)
        tempShip:setFillColor( 0,1,0 )
        tempShip.id = i -- Assign it an id for down the road
        --
        local sourceStar = starModel[math.random(1,#starModel)]
        local destinationStar = starModel[math.random(1,#starModel)]
        galaxy.ships[i]:ChangeHeading(destinationStar)
        tempShip.x,tempShip.y = sourceStar.x+10,sourceStar.y
        galaxy.ships[i].x,galaxy.ships[i].y = tempShip.x,tempShip.y
        table.insert(shipView,tempShip)
        sceneGroup:insert(tempShip)
    end
    print("Size of shipView "..#shipView)
end

function MoveShips()
    for i=1,#galaxy.ships do
        galaxy.ships[i]:ChangeHeading(galaxy.ships[i].destination)
        galaxy.ships[i]:MoveForward()
        -- Sync the view with the newly
        -- updated data model location
        shipView[i].x,shipView[i].y = galaxy.ships[i].x,galaxy.ships[i].y
    end
end

CreateModelStars()
CreateModelShips()
DisplayStars()
DisplayShips()
timer.performWithDelay( 10, MoveShips,-1 )