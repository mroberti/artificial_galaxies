Ship = class("Ship")

function Ship:init(data)
    self.name = data.name or "Ship "..RAND(1,999)
    self.x = data.x or RAND(1,200) 
    self.y = data.y or RAND(1,200)
    self.dockedAt = data.dockedAt or nil
    self.empire = data.empire or nil
    self.speed = data.speed or RAND(1,15)
    self.heading = data.heading or 0
    self.destination = data.destination or nil
    -- print("Created Ship: "..self.name.." at "..self.x..","..self.y..", belongs to "..self.empire.name.." docked at "..self.dockedAt.name)
end

function Ship:ChangeHeading(targetObject)
	self.heading = ((math.angleBetween(self,targetObject)+360) % 360)
end

function Ship:MoveForward()
    -- Only rotate the the image
    local tempdistance = 2
    local distance_angle = self.heading -90
    local distance_x = tempdistance * COS (RAD(distance_angle));
    local distance_y = tempdistance * SIN (RAD(distance_angle));
    self.x = self.x + distance_x
    self.y = self.y + distance_y
end

function Ship:Serialize()
    local results = {}
    results.x = self.x
    results.y = self.y
    results.speed = self.speed
    results.heading = self.heading
    results.name = self.name
    results.empire = self.empire.name
    results.name = self.name
    return results
end

--= Return Factory
return Ship