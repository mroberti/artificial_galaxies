-- From: https://gist.github.com/HoraceBury/9431861
-- converts a table of {x,y,x,y,...} to points {x,y}
function tableToPoints( tbl )
   local pts = {}	
   for i=1, #tbl-1, 2 do
      pts[#pts+1] = { x=tbl[i], y=tbl[i+1] }
   end	
   return pts
end

function ordinal_numbers(n)
  local ordinal, digit = {"st", "nd", "rd"}, string.sub(n, -1)
  if tonumber(digit) > 0 and tonumber(digit) <= 3 and string.sub(n,-2) ~= '11' and string.sub(n,-2) ~= '12' and string.sub(n,-2) ~= '13' then
    return n .. ordinal[tonumber(digit)]
  else
    return n .. "th"
  end
end

-- ensures that a list of coordinates is converted to a table of {x,y} points
-- returns a table of {x,y} points and the number of points, whether a display group or not
function ensurePointsTable( tbl )
   if (type(tbl[1]) == "number") then
      -- list contains {x,y,x,y,...} coordinates - convert to table of {x,y} 
      tbl = tableToPoints( tbl )
      return tbl, #tbl
   else
      -- table is already in {x,y} point format...
      -- check for display group
      local count = tbl.numChildren
      if (count == nil) then
         count = #tbl
      end
      return tbl, count
   end
end

function getBoundingCentroid( pts )
   pts = ensurePointsTable( pts ) -- EFM change a little
   local xMin, xMax, yMin, yMax = 100000000, -100000000, 100000000, -100000000
   for i=1, #pts do
      local pt = pts[i]
      if (pt.x < xMin) then xMin = pt.x end
      if (pt.x > xMax) then xMax = pt.x end
      if (pt.y < yMin) then yMin = pt.y end
      if (pt.y > yMax) then yMax = pt.y end
   end
   local width, height = xMax-xMin, yMax-yMin
   local cx, cy = xMin+(width/2), yMin+(height/2)
   local output = {
      centroid = { x=cx, y=cy },
      width = width,
      height = height,
      bounding = { xMin=xMin, xMax=xMax, yMin=yMin, yMax=yMax },
   }
   return output
end

function calculateVertexPosition( self, num )
   local vertX = self._vertices[(num-1)*2+1]
   local vertY = self._vertices[(num) * 2]
   return { x = vertX + self.x - self._boundingCentroid.centroid.x,
            y = vertY + self.y - self._boundingCentroid.centroid.x }
end

function getDistance(objA, objB)
    -- Get the length for each of the components x and y
    local xDist = objB.x - objA.x
    local yDist = objB.y - objA.y

    return math.sqrt( (xDist ^ 2) + (yDist ^ 2) ) 
end

function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+4))
                        print(indent..string.rep(" ",string.len(pos)+3).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t," ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function splitstring(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function loadjson(filename)
    local f = assert(io.open(filename, "rb"))
    local content = f:read("*all")
    f:close()
    return JSON:decode(content)
end

function loadtext(filename)
    local f = assert(io.open(filename, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function deleteLastCharacter(str)
  return(str:gsub("[%z\1-\127\194-\244][\128-\191]*$", ""))
end

function CreateName(type)
  local result = ""
  -- Once determined what type, the
  -- below function will be used to generate
  -- final name.
  local function MakeName(myContent)
    local numberOfPieces = RAND(2,4)
    for i=1,numberOfPieces do
      result=result..myContent[RAND(1,#myContent)]
    end
  end

  local names = {"insectoid","aquatic","artificiallife","avian","feline","insectoid","lupine","reptilian"}
  if(type==nil)then
    type=names[RAND(1,#names)]
  end
  for i=1,#names do
    if(string.lower(type)==names[i])then
      local myContent = splitstring(loadtext("./names/"..string.lower(type)..".csv"),",")
      MakeName(myContent)
      -- Make the first letter uppercase
      result = firstToUpper(result)
      local lastChar = string.sub(result,string.len(result), -1)
      -- Let's check for any whacky characters
      -- and trim them off
      if(lastChar=="'" or lastChar=="-")then
        result = deleteLastCharacter(result)
      end
      break
    end
  end


  return result
end