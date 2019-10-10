Star = class("Star")

local map = { 
    I = 1,
    V = 5,
    X = 10,
    L = 50,
    C = 100, 
    D = 500, 
    M = 1000,
}
local numbers = { 1, 5, 10, 50, 100, 500, 1000 }
local chars = { "I", "V", "X", "L", "C", "D", "M" }

function ToRomanNumerals(s)
    --s = tostring(s)
    s = tonumber(s)
    if not s or s ~= s then error"Unable to convert to number" end
    if s == math.huge then error"Unable to convert infinity" end
    s = math.floor(s)
    if s <= 0 then return s end
    local ret = ""
        for i = #numbers, 1, -1 do
        local num = numbers[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. chars[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = numbers[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. chars[j] .. chars[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
end

function Star:init(data)
    self.name = data.name or "Star "..RAND(1,999)
    self.x = data.x or RAND(1,200) 
    self.y = data.y or RAND(1,200)
    self.empireName = data.empireName or "No affiliation"
    self.planets = {}
    -- Let's create between 3 and 6 planets
    print("Created Star: "..self.name.." at "..self.x..","..self.y)
    for i=1,RAND(3,6) do
    	self.planets[i] = Planet:new({
    		name=self.name.." "..ToRomanNumerals(i)
    	})
    	logger("Created planet: "..self.planets[i].name.." ".."Environment: "..self.planets[i].environment)
    end
end

function Star:Serialize()
    local results = {}
    results.x = self.x
    results.y = self.y
    results.name = self.name
    results.empireName = self.empireName
    results.planets = {}
    for k,planet in pairs(self.planets) do
        table.insert(results.planets,planet:Serialize())-- We can match the name to saved data on de=serialize
    end
    return results
end

--= Return Factory
return Star