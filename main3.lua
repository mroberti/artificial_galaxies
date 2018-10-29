
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
function CreateGalaxy(passedData)
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

    local starView = {}
    local shipView = {}

    function Destroy()

        for i=#starView,1,-1 do
            table.remove(starView, i)
        end

        for i=#shipView,1,-1 do
            table.remove(shipView, i)
        end

        for i = sceneGroup.numChildren, 1, -1 do
          display.remove( sceneGroup[i] )
        end
    end


    function DisplayStars()
        -- Iterate through our list of galaxy.stars
        -- to get the DATA ONLY to use to crate our
        -- View portion
        for i=1,#galaxy.stars do
            local tempStar = display.newCircle(galaxy.stars[i].x, galaxy.stars[i].y, 2 )
            tempStar:setFillColor( 1,1,1 )
            table.insert(starView,tempStar)
            sceneGroup:insert(tempStar)
        end
        print("Size of StarView "..#starView)
    end

    function DisplayShips()
        -- Iterate through our list of galaxy.stars
        -- to get the DATA ONLY to use to crate our
        -- View portion
        -- Create a ship next to each star in our
        -- galaxy.stars data
        for i=1,#galaxy.ships do
            -- Create a temporary ship display object
            -- Polypoints can be found in our misclua
            -- folder under corona helper. It makes n sided
            -- polygon display objects
            local tempShip = polypoints(6, RAND(5,7), 0.0,0)
            tempShip.id = i -- Assign it an id for down the road
            --
            local sourceStar = galaxy.stars[math.random(1,#galaxy.stars)]
            local destinationStar = galaxy.stars[math.random(1,#galaxy.stars)]
            galaxy.ships[i].destination = destinationStar
            galaxy.ships[i]:ChangeHeading(destinationStar)
            tempShip.x,tempShip.y = galaxy.ships[i].x,galaxy.ships[i].y
            galaxy.ships[i].x,galaxy.ships[i].y = tempShip.x,tempShip.y
            table.insert(shipView,tempShip)
            sceneGroup:insert(tempShip)
        end
        print("Size of shipView "..#shipView)
    end

    local move = true

    function MoveShips()
        for i=1,#galaxy.ships do
            galaxy.ships[i]:ChangeHeading(galaxy.ships[i].destination)
            galaxy.ships[i]:MoveForward()
            -- Sync the view with the newly
            -- updated data model location
            shipView[i].x,shipView[i].y = galaxy.ships[i].x,galaxy.ships[i].y
        end
    end

    galaxy:CreateShips()

    DisplayStars()
    DisplayShips()


    -- -- Make it so we can 
    -- timer.performWithDelay( 50, MoveShips,-1 )
    -- timer.performWithDelay( 10000, Destroy,-1 )


    function DisplayBorders()
        print("Yo")
        -- Return x location, y location and vertices
        for i=1,#galaxy.empires do
            print('galaxy.empires '..galaxy.empires[i].name)
            if(galaxy:GetBorderForEmpire(galaxy.empires[i].name)~=nil)then
                -- Pick the colors
                local r = RAND(1,10)/10
                local g = RAND(1,10)/10
                local b = RAND(1,10)/10
                local o = display.newPolygon(galaxy:GetBorderForEmpire(galaxy.empires[i].name) )
                o.strokeWidth = 2
                o:setStrokeColor( r, g, b, 0.1 )
                o:setFillColor( r, g, b, 0.25)
                sceneGroup:insert(o)

                local options = 
                {
                    --parent = groupObj,
                    text = "Empire "..i,     
                    x = o.x,
                    y = o.y,
                    width = 100,            --required for multiline and alignment
                    height = 100,           --required for multiline and alignment
                    --          font = "Lato Black",   
                    fontSize = screenH*0.025,
                    align = "center"          --new alignment field
                }
                
                local textObject = display.newText( options )
                sceneGroup:insert(textObject)
            end
        end
    end



    -- -- Let's assign a empire
    -- to some stars that are within 
    -- 'x' distance of a source star

    for i=1,#galaxy.empires do
        local tempStar = galaxy.stars[RAND(1,#galaxy.stars)]
        local distance = RAND(100,screenW*.25)
        local nearestStars = galaxy:GetClosestStars(distance,tempStar)
        print("nearestStars "..#nearestStars)
        if(#nearestStars>2)then
            for k,v in pairs(nearestStars) do
                v.empireName = galaxy.empires[i].name
                print("Assigning civ "..galaxy.empires[i].name.." to "..v.name)
            end
        end
    end
    -- print("Distance "..getDistance(galaxy.stars[2],galaxy.stars[5]))
    DisplayBorders()
    -- galaxy:Serialize()
    
    -- galaxy:Deserialize()
    local function DoDeserialize()
        print("Deeeeeeserializing__________\n\n")
        -- Destroy graphics
        Destroy()
        galaxy:Deserialize()
        DisplayStars()
        DisplayShips()
        DisplayBorders()
    end



    timer.performWithDelay( 20, DoDeserialize,1) 
    -- DisplayStars()
    -- DisplayShips()
    
    -- for i=1,#galaxy.empires do
    --     local tempStar = galaxy.stars[RAND(1,#galaxy.stars)]
    --     local distance = RAND(100,screenW*.25)
    --     local nearestStars = galaxy:GetClosestStars(distance,tempStar)
    --     print("nearestStars "..#nearestStars)
    --     if(#nearestStars>2)then
    --         for k,v in pairs(nearestStars) do
    --             v.empireName = galaxy.empires[i].name
    --             print("Assigning civ "..galaxy.empires[i].name.." to "..v.name)
    --         end
    --     end
    -- end
    -- DisplayBorders()
end
CreateGalaxy()


