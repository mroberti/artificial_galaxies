Planet = class("Planet")

function Planet:init(data)
	local environment = {"Chthonian planet","Carbon planet","City planet","Coreless planet","Desert planet","Gas dwarf","Gas giant","Helium planet","Ice giant","Ice planet","Iron planet","Lava planet","Ocean planet","Protoplanet","Puffy planet","Silicate planet","Terrestrial planet"}
    self.parent_star = data.star_name
    self.name = data.name or "Planet "..RAND(1,999)
    self.environment = data.environmentNumber or RAND(1,#environment) --environment[RAND(1,#environment)]
    self.species = {}
    -- Debug
    if(debug)then
        print(self.name.." "..self.environment)
    end
end

function Planet:Serialize()
    local results = {}
    results.empireName = self.empireName or nil
    results.parent_star = self.parent_star
    results.environment = self.environment
    results.name = self.name
    return results
end
--= Return Factory
return Planet
