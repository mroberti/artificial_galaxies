function ordinal_numbers(n)
  local ordinal, digit = {"st", "nd", "rd"}, string.sub(n, -1)
  if tonumber(digit) > 0 and tonumber(digit) <= 3 and string.sub(n,-2) ~= '11' and string.sub(n,-2) ~= '12' and string.sub(n,-2) ~= '13' then
    return n .. ordinal[tonumber(digit)]
  else
    return n .. "th"
  end
end

function UnitCreator()
    local Patron = {"Regent's ", "Chancellor's ", "Star King's ","Governor's ", "Kaiser's ","General's ", "King's ", "Queen's ","The Guild's ","Emperor's ","Ben Moshe's ","The Temple's "}
    local tempstring = ""
    tempstring = Patron[math.random(1,#Patron)]
    -- Do we get a bonus description often?
    -- Adjust the random number to increase/decrease
    -- the frequency of the bonus descriptor!
    -- After all, EVERY unit can't be special...can they?! :)
    local tempNumber = math.random(1,5)
    if(tempNumber == 2)then
        local BonusDescriptor = {"North ","East ","South ","West ","Last Resort ","Old ","Sacred ", "Crimson ","Grey ","Green ","Orange ","Own ","Double X ","Drop-short ","First and Last ", "Holy ","Elegant ","Excellers ", "Supreme ","Savage ", "Dirty ", "Lofty ", "Fancy ","Invincible ","Jolly ","Dandy ","Concealed ","Celestials "}
        tempstring = tempstring..BonusDescriptor[math.random(1,#BonusDescriptor)] 
    end
    local tempNumber2 = math.random(1,999)
    tempstring = tempstring..ordinal_numbers(tempNumber2).." "
    local UnitType = {"Grenadiers ","Regiment ","Battalion ","Horsemen ", "Carabiniers ","Light Horse ","Rejects ","Guards ","Fusiliers ","Regiment ","Hussars ", "Dragoons ", "Shock Troops ","Iron Strike ", "Cavalliers ", "Deathbringers ","Blazing Fury ","Pikemen ","Defenders ","Blackwatch ","Executioners "}
    tempstring = tempstring..UnitType[math.random(1,#UnitType)]     

    return tempstring
end

