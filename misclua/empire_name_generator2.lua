function EmpireNameGenerator()
    local prefix = {"The ","God's ","Wrathful "}
    local tempstring = ""
    tempstring = prefix[math.random(1,#prefix)]
    -- Do we get a bonus description often?
    -- Adjust the random number to increase/decrease
    -- the frequency of the bonus descriptor!
    -- After all, EVERY unit can't be special...can they?! :)
    local tempNumber = math.random(1,5)
    if(tempNumber == 2)then
        local BonusDescriptor = {"Democratic ","Holy ","Democratic ","Industrial "}
        tempstring = tempstring..BonusDescriptor[math.random(1,#BonusDescriptor)] 
    end
    local Suffix1 = {"Concordance ","Republic ","League ","Compact "}
    tempstring = tempstring..Suffix1[math.random(1,#Suffix1)] 
    local tempNum = RAND(1,3)
    if(tempNum==1)then
        tempstring=tempstring.."of "..CreateName()
    end    

    return tempstring
end
