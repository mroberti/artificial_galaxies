function EmpireNameGenerator()
    local prefix = {"The ","The People's ","God's ","Wrathful "}
    local tempstring = ""
    tempstring = prefix[math.random(1,#prefix)]
    -- Do we get a bonus description often?
    -- Adjust the random number to increase/decrease
    -- the frequency of the bonus descriptor!
    -- After all, EVERY unit can't be special...can they?! :)
    local tempNumber = math.random(1,5)
    if(tempNumber == 2)then
        local part1 = {"Democratic ","Holy ","Democratic ","Industrial "}
        tempstring = tempstring..part1[math.random(1,#part1)] 
    end

    local part2 = {"Alliance ","Association ","Band ","Circle ","Clan ","Combine ","Company ","Cooperative ","Corporation ","Enterprises ","Faction ","Group ","Megacorp ","Multistellar ","Organization ","Outfit ","Pact ","Partnership ","Ring ","Society ","Sodality ","Syndicate ","Union ","Unity ","Zaibatsu "}
    tempstring = tempstring..part2[math.random(1,#part2)] 

    local tempNum = RAND(1,3)
    if(tempNum==1)then
        tempstring=tempstring.."of "..CreateName()
    end    

    return tempstring
end
