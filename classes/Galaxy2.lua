require("classes.Empire")
require("classes.Planet")
require("classes.Star")
require("classes.Species")
Galaxy2 = class("Galaxy2")

function Galaxy2:init(data)
    -- local data= {
        -- numberOfStars = 50,
        -- width = screenW,
        -- height = screenH,
        -- numberOfEmpires = 3,
        -- numberOfShips = 5,
        -- numberOfSpecies = 3
    -- }
   	-- Make a table to hold our stars
	self.numberOfStars = data.numberOfStars or 100
	self.numberOfEmpires = data.numberOfEmpires or 4
	-- Make sure we have at least as many species as Empires...kinda would suck if we had less...
	self.numberOfSpecies = data.numberOfSpecies or RAND(self.numberOfEmpires,self.numberOfEmpires+3)
	self.stars = {}
	self.empires = {}
	self.ships = {}
	self.species = {}

	-- We're expecting data from the instantiation
	-- of the Galaxy2 object, below is what we're
	-- expecting. 
	self.width = data.width or 1000
	self.height = data.height or 1000

	-- First make all stars
	print("Creating "..self.numberOfStars.." stars...")
	for i=1,self.numberOfStars do
		-- Let's pick a 
		-- random spot on the map and create stars
		-- within a specific distance of that location
		local tempX = RAND(0,self.width)
		local tempY = RAND(0,self.height)
		local star_data = {
			name = namegen.generate("elf female 2"),
			x = tempX,
			y = tempY,
			empireName = "none"
		}
		local myStar = Star:new(star_data)
		-- print("Star name: "..myStar.name.."\t\t\t\tLocation x:"..myStar.x..",y:"..myStar.y)
		print(string.format("Star name: %s Location x:%d y:%d",myStar.name,myStar.x,myStar.y))
		table.insert(self.stars,myStar)
	end

	-- Make some species
	print("Creating "..self.numberOfSpecies.." species...")
	for i=1,self.numberOfSpecies do
		local tempSpecies = Species:new(CreateSpeciesName())
		table.insert(self.species,tempSpecies)
	end

	print("Creating "..self.numberOfEmpires.." Empires...")
	-- Second make empires
	for i=1,self.numberOfEmpires do
		local myEmpire = Empire:new(namegen.generate("empires"))
		print("Name: "..myEmpire.name)
		table.insert(self.empires,myEmpire)

		local diameter = 100
		local minimumDistance=100
		-- Let's pick a 
		-- random spot on the map and create stars
		-- within a specific distance of that location
		local tempX = RAND(0,self.width)
		local tempY = RAND(0,self.height)
		local numberOfStars = RAND(5,15)
	end

	-- Make some ships
	print("Creating "..data.numberOfShips.." Ships...")
	local tempShips = {}
	for i=1,data.numberOfShips do
		local tempShip = {
            name = "Ship "..i,
            dockedAt = self.stars[RAND(1,#self.stars)],
            destination = self.stars[RAND(1,#self.stars)],
            empire = self.empires[1],
            speed = RAND(1,10),
            heading = RAND(1,360) -- This can change of course if you use ship:changeHeading(starObject or whatever)
        }
		table.insert(tempShips,tempShip)
		print(string.format("Ship name: %s dockedAt %s, destination %s, belongs to empire %s",tempShip.name,tempShip.dockedAt.name,tempShip.destination.name,tempShip.empire.name))
	end
	self:CreateShips(tempShips)
end

function Galaxy2:CreateShips(data)
    -- Create 25 ships and pass some data
    if(data)then
	    for i=1,#data do
	        local shipData = {
	            name = data[i].name,
	            dockedAt = data[i].dockedAt or nil,
	            destination = data[i].destination or nil,
	            empire = data[i].empire or nil,
	            speed = data[i].speed,
	            heading = data[i].heading,
	            x = data[i].x,
	            y = data[i].y
	        }

	        local myShip = Ship:new(shipData)
	        -- myShip.x,myShip.y = myShip.dockedAt.x,myShip.dockedAt.y
	        table.insert(self.ships,myShip)
	    end
    else
    	print("We dont got data")
	    for i=1,RAND(2,5) do
	        local shipData = {
	            name = "Ship "..i,
	            dockedAt = self.stars[RAND(1,#self.stars)],
	            destination = self.stars[RAND(1,#self.stars)],
	            empire = self.empires[1],
	            speed = RAND(1,10),
	            heading = RAND(1,360)
	        }

	        local myShip = Ship:new(shipData)
	        myShip.x,myShip.y = myShip.dockedAt.x,myShip.dockedAt.y
	        table.insert(self.ships,myShip)
	    end
	end
end

function Galaxy2:GetAllStarsBelongingToAEmpire(empireName)
	-- print("Attempting to get border....")
	local result = {}
	for k,v in pairs(self.stars) do
		if(v.empireName == empireName)then
			table.insert(result,v)
		end
	end
	return result
end

function Galaxy2:GetBorderForEmpire(empireName)
	local myTable2 = {}
	local starModel = self:GetAllStarsBelongingToAEmpire(empireName)
	-- We need at least a triangle
	-- for a shape, otherwise...
	if(#starModel>2)then
		for i=1,#starModel do
			local tempX = starModel[i].x
			local tempY = starModel[i].y
			table.insert(myTable2,{x=tempX,y=tempY})
		end

		-- Tests for convex_hull.lua
		-- Include this module wherever 
		-- you're planning on calling it from
		-- Don't forget!
		local chull = hull.jarvis(myTable2)
		-- print(chull)
		local vertices = {}

		for i=1,#chull do
			-- print("x,y "..chull[i].x,chull[i].y)
			if(i>1)then
				local x2 = chull[i].x
				local y2 = chull[i].y
				table.insert(vertices,x2)
				table.insert(vertices,y2)
			else
				local x1 = chull[1].x
				local y1 = chull[1].y
				table.insert(vertices,x1)
				table.insert(vertices,y1)
			end
		end

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

		local x1,y1,x2,y2 = bbox(chull)
		local width = x2-x1
		local height = y2-y1
		return x1+(width/2),y1+(height/2), vertices
	else
		return nil
	end
end

function Galaxy2:Destroy()
	-- Destroy empires
	for i=#self.empires,1,-1 do
        table.remove(self.empires, i)
	end
	-- Destroy stars
	for i=#self.stars,1,-1 do
        table.remove(self.stars, i)
	end
	-- Destroy species
	if(self.species~=nil)then
		for i=#self.species,1,-1 do
	        table.remove(self.species, i)
		end
	end
	-- Destroy ships
	for i=#self.ships,1,-1 do
        table.remove(self.ships, i)
	end
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-- Cycle through and return the closest
-- 'x' stars to the source that was passed
-- If there aren't any within 'x' distance
-- return nil
function Galaxy2:GetClosestStars(radius,sourceStar)
	local nearestStars = {}
	for i=1,#self.stars do
		local distance = math.getDistance(sourceStar,self.stars[i])
		if(distance~=0 and distance<radius)then
			table.insert(nearestStars,self.stars[i])
			-- print("Distance "..math.getDistance(sourceStar,self.stars[i]))
		end
	end
	return nearestStars
end

function Galaxy2:Serialize()
	-- Begin serializing objects out
	-- Create a holder table for all 
	-- our data...
	local data = {}
	data.stars = {}
	data.empires = {}
	data.species = {}
	data.ships = {}
	data.width = self.width
	data.height = self.height
	-- Serialize the civilzations...
	-- NOTE: The empires contain species objects
	-- which is automagically serialized from within 
	-- the empire object.
	for k,v in pairs(self.species) do
		table.insert(data.species,v:Serialize())
	end
	
	for k,v in pairs(self.empires) do
		table.insert(data.empires,v:Serialize())
	end
 
	-- Serialize the stars
	for k,v in pairs(self.stars) do
		table.insert(data.stars,v:Serialize())
	end
	 
	-- Serialize the stars
	for k,v in pairs(self.ships) do
		table.insert(data.ships,v:Serialize())
	end
	 
	-- Path for the file to write
	-- Hmmmm this only works for Corona...I'll 
	-- look into a plain lua version to serialize 
	-- output to.
	local path = system.pathForFile( "saveddata.json", system.DocumentsDirectory )
	 
	-- Open the file handle
	local file, errorString = io.open( path, "w" )
	 
	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Write data to file
	    file:write( json.encode( data ) )
	    -- Close the file handle
	    io.close( file )
	end
	 
	file = nil
end

function Galaxy2:Deserialize(filename)
	self:Destroy()
	-- Begin serializing objects out
	local path = system.pathForFile( "saveddata.json", system.DocumentsDirectory)

	local file = io.open( path, "r" )
	local data = json.decode(file:read( "*a" ))

	io.close( file )
	file = nil

	-- Create empires from serialized
	-- data
	print("Number of civs "..#data.empires)

		-- Make a table to hold empires
	local numberOfEmpires = #data.empires or 1
	for i=1,numberOfEmpires do
		local myEmpire = Empire:new(data.empires[i])
		table.insert(self.empires,myEmpire)
	end
	print("Number of empires "..#self.empires)
	-- -- Make a table to hold our stars
	self.numberOfStars = #data["stars"]

	-- We're expecting data from the instantiation
	-- of the Galaxy2 object, below is what we're
	-- expecting. 
	self.width = data.width or 1000
	self.height = data.height or 1000
	self.species = {}

	-- Create all stars first...

	for i=1,self.numberOfStars do
		local star_data = {
			name = data.stars[i].name,
			x = data["stars"][i].x,
			y = data["stars"][i].y,
			empireName = data["stars"][i].empireName
		}
		local myStar = Star:new(star_data)

		table.insert(self.stars,myStar)
	end

	self:CreateShips(data.ships)

end



--= Return Factory
return Galaxy2