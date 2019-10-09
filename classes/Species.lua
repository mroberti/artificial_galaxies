Species = class("Species")

function Species:init(data)
    local SpeciesTable = loadjson(".\\tables\\alien.json")
    function GetLenses()
        local result = ""
        local selection1 = {1,2,2,3,4}
        local selection2 = selection1[RAND(1,#selection1)]
        for i=1,selection2 do
            if(i==selection2)then
                result=result..choice(SpeciesTable["lens"])
            else
                result=result..choice(SpeciesTable["lens"])..","
            end
        end
        return result
    end
    self.lenses = GetLenses()
    self.social_structure = choice(SpeciesTable["social_structure"])
    self.body_type = choice(SpeciesTable["body_type"])
    if(debug)then
        print("Body type: "..self.body_type)
        print("Social Structure: "..self.social_structure)
        print("Lenses: "..self.lenses)
    end

end

function Species:Serialize()
    local results = {}
    table.insert(results,self.body_type)
    table.insert(results,self.social_structure)
    table.insert(results,self.lenses)
    return results
end
--= Return Factory
return Species