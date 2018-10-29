Species = class("Species")

function Species:init(name)
	-- For our species preferred environment 
	-- We could use "Barren","Garden","Gas Giant","Poisonous"
	-- Those are directly from our star object. 
	-- They can be changed of course.  
	
    self.name = name or CreateName()
    print(name)
    self.type = "Insectoid"
    self.traits = "Greebly, scuttle-ish"
    self.preferred_environment = "Barren"
end

function Species:Destroy()
	
end

function Species:Serialize()
	local results = {}
    results.name = self.name
    results.type = self.type
    results.traits = self.traits
    results.preferred_environment = self.preferred_environment
	return results
end

--= Return Factory
return Species

