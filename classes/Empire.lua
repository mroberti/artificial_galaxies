Empire = class("Empire")

-- local json = require( "json" )

local function Select_Random_Government()
	local tempValue = RAND(1,#government_type)
	return government_type[tempValue],government_description[tempValue]
end

function Empire:init(data)
	self.name = data.name or namegen.generate("empires")
	self.government_type,self.governmentdescription = data.government_type,data.government_description or Select_Random_Government()
end

function Empire:Serialize()
	local results = {}
    results.name = self.name
    results.government = self.government
    return results
end
--= Return Factory
return Empire
