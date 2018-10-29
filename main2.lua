json = require( "json" )
class = require("misclua.30log-global")

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

require("classes.Empire")
require("classes.Planet")
require("classes.Star")
require("classes.Species")
require("classes.Ship")
require("classes.Galaxy")
voronoi=require("classes.voronoi")
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
local mapBorder = border*2
local data= {
	-- The width and height of the 
	-- galaxy in units. Pixels, light years, 
	-- hey it's up to you,
	-- Number of empires
	-- minimum distance from another empire
	numberOfStars = 75,
	width = screenW,
	height = screenH,
	empires = 3,
	min_dist_from_empires = 200,
	max_dist_from_empires = 400,
	border = mapBorder
}

-- local galaxy = Galaxy:new()
local galaxy = Galaxy:new(data)

local starModel = {}
local shipModel = {}

local starView = {}
local shipView = {}

function Destroy()
	for i=#starModel,1,-1 do
        table.remove(starModel, i)
	end

	for i=#starView,1,-1 do
        table.remove(starView, i)
	end

	for i=#shipModel,1,-1 do
        table.remove(shipModel, i)
	end

	for i=#shipView,1,-1 do
        table.remove(shipView, i)
	end

	for i = sceneGroup.numChildren, 1, -1 do
	  display.remove( sceneGroup[i] )
	end

	galaxy:Destroy()
	galaxy = Galaxy:new(data)

	CreateModelStars()
	CreateModelShips()

	DisplayStars()
	DisplayShips()

	genvoronoi = voronoi:new(#galaxy.stars,1,border,border,screenW-(border*2),screenH-(border*2),galaxy.stars)
	draw(genvoronoi)
end


function CreateModelStars()
	-- Run some tests on the galaxy object
	-- starModel = galaxy:GetAllStarsBelongingToAEmpire(galaxy.empires[1])
	starModel = galaxy.stars
	-- Debug info if you wanna verify stuff!
	-- for i=1,#starModel do
	-- 	print("Star "..starModel[i].name.." belongs to the "..galaxy.empires[1].name)
	-- end
end

function CreateModelShips()
	-- Create 25 ships and pass some data
	for i=1,25 do
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
	for i=1,25 do
		-- Create a temporary ship display object
		-- Polypoints can be found in our misclua
		-- folder under corona helper. It makes n sided
		-- polygon display objects
		local tempShip = polypoints(6, RAND(5,7), 0.0,0)
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

local move = true

function MoveShips()
	-- For now, let's just move ship 1
	-- Since we named them sequentially
	-- we know Ship 1 is in shipView[1]
	-- and that it's counterpart in the
	-- data model shipModel[1] too

	-- So, the actual functionality is
	-- built in to the OOP object in 
	-- shipModel, so let's make it find
	-- the heading for travel and then 
	-- move along the course.

	-- This pre-supposes we told our
	-- ship to changeHeading and head
	-- towards a destination, and we did
	-- above when we created them. You can 
	-- always call the changeHeading command
	-- down the road at any time.
	for i=1,#shipModel do
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

genvoronoi = voronoi:new(#galaxy.stars,1,border,border,screenW-(border*2),screenH-(border*2),galaxy.stars)
-- function voronoilib:new(polygoncount,iterations,minx,miny,maxx,maxy,points) 

function draw(ivoronoi)

	-- get bounding box
	function bbox(vertices)
		local ulx,uly = vertices[1].x, vertices[1].y
		local lrx,lry = ulx,uly
		for i=2,#vertices do
			local p = vertices[i]
			if ulx > p.x then ulx = p.x end
			if uly > p.y then uly = p.y end

			if lrx < p.x then lrx = p.x end
			if lry < p.y then lry = p.y end
		end

		return ulx,uly, lrx,lry
	end

	-- draws the polygons
	for index,polygon in pairs(ivoronoi.polygons) do
		if #polygon.points >= 6 then
			local vertices2 = {}
			for i=1, #polygon.points, 2 do
			    local px = polygon.points[i]
			    local py = polygon.points[i+1]
			    table.insert(vertices2,{x=px,y=py})
			end
			-- love.graphics.setColor(50,50,50)
			-- love.graphics.polygon('fill',unpack(polygon.points))
			-- love.graphics.setColor(255,255,255)
			-- love.graphics.polygon('line',unpack(polygon.points))
			local r = 0--RAND(1,10)/10
			local g = 0--RAND(1,10)/10
			local b = .5--RAND(1,10)/10

			local x1,y1,x2,y2 = bbox(vertices2)
			local width = x2-x1
			local height = y2-y1

			local o = display.newPolygon(x1+(width/2),y1+(height/2),polygon.points)
			o.strokeWidth = 2
			o:setStrokeColor( r, g, b, 1 )
			o:setFillColor( r, g, b, 0.25)
			sceneGroup:insert(o)		
		end
	end

	-- draws the segments
	--[[love.graphics.setColor(150,0,100)
	for index,segment in pairs(ivoronoi.segments) do
		love.graphics.line(segment.startPoint.x,segment.startPoint.y,segment.endPoint.x,segment.endPoint.y)
	end]]--

	-- draws the segment's vertices
	--[[love.graphics.setColor(250,100,200)
	love.graphics.setPointSize(5)
	for index,vertex in pairs(ivoronoi.vertex) do
		love.graphics.point(vertex.x,vertex.y)
	end]]--

	-- draws the centroids
	for index,point in pairs(ivoronoi.centroids) do
		local tempCircle = display.newCircle(point.x,point.y,2)
		tempCircle:setFillColor( 1,0,0 )
		sceneGroup:insert(tempCircle)	
	end

	-- -- draws the relationship lines
	-- for pointindex,relationgroups in pairs(ivoronoi.polygonmap) do
	-- 	for badindex,subpindex in pairs(relationgroups) do
	-- 		local tempLine = display.newLine(ivoronoi.centroids[pointindex].x,ivoronoi.centroids[pointindex].y,ivoronoi.centroids[subpindex].x,ivoronoi.centroids[subpindex].y)			
	-- 		tempLine:setStrokeColor(0,1,0)
	-- 		-- love.graphics.line(ivoronoi.centroids[pointindex].x,ivoronoi.centroids[pointindex].y,ivoronoi.centroids[subpindex].x,ivoronoi.centroids[subpindex].y)
	-- 	end
	-- end
end


draw(genvoronoi)
--timer.performWithDelay( 250, MoveShips,-1 )
timer.performWithDelay( 250, Destroy,-1 )


-- function DisplayBorders()
-- 	-- Returm x location, y location and vertices
-- 	for i=1,#galaxy.empires do
-- 		-- Pick the colors
-- 		local r = RAND(1,10)/10
-- 		local g = RAND(1,10)/10
-- 		local b = RAND(1,10)/10
-- 		local o = display.newPolygon(galaxy:GetBorderForEmpire(galaxy.empires[i]) )
-- 		o.strokeWidth = 2
-- 		o:setStrokeColor( r, g, b, 0.1 )
-- 		o:setFillColor( r, g, b, 0.25)
-- 	end
-- end
-- DisplayBorders()




