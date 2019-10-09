
function polypoints(sides, radius, start, displacement)
  local vertices = {}
    local x_center = RAND(-displacement,displacement) or 0.0
    local y_center = RAND(-displacement,displacement) or 0.0
    local angle = start
    local angle_increment = 2 * math.pi / sides
    local x=0.0
    local y=0.0

    -- print(string.format("coordinates for a %d sided regular polygon of radius %d\nVertex",sides,radius),"X"," ","Y")
    for i=1,sides do
        x_center = RAND(-displacement,displacement) or 0.0
        y_center = RAND(-displacement,displacement) or 0.0
        x = x_center + radius * math.cos(angle)
        y = y_center + radius * math.sin(angle)
        -- print(string.format("%d\t%f\t%f",i,x,y))
        table.insert(vertices,x)
        table.insert(vertices,y)
        angle = angle + angle_increment
    end

    -- computes coordinates for n-sided, regular polygon of given radius and start angle
    -- all values are in radians
    local function create(vertices)
      local r, g, b = math.random(),math.random(),math.random()
      local o = display.newPolygon( 0, 0, vertices )
      o:translate(RAND(1,screenW),RAND(1,screenH))
      o:setFillColor( 0,0,0,0 )
      o:setStrokeColor( 1,1,1 )
      o.strokeWidth = 1
      o.vertices = vertices
      return o
    end --create
    return create(vertices)
end

function SplitString (line,sep) 
    local res = {}
    local pos = 1
    sep = sep or ','
    while true do 
        local c = string.sub(line,pos,pos)
        if (c == "") then break end
        if (c == '"') then
            -- quoted value (ignore separator within)
            local txt = ""
            repeat
                local startp,endp = string.find(line,'^%b""',pos)
                txt = txt..string.sub(line,startp+1,endp-1)
                pos = endp + 1
                c = string.sub(line,pos,pos) 
                if (c == '"') then txt = txt..'"' end 
                -- check first char AFTER quoted string, if it is another
                -- quoted string without separator, then append it
                -- this is the way to "escape" the quote char in a quote. example:
                --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
            until (c ~= '"')
            table.insert(res,txt)
            assert(c == sep or c == "")
            pos = pos + 1
        else  
            -- no quotes used, just look for the first separator
            local startp,endp = string.find(line,sep,pos)
            if (startp) then 
                table.insert(res,string.sub(line,pos,startp-1))
                pos = endp + 1
            else
                -- no separator found -> use rest of string and terminate
                table.insert(res,string.sub(line,pos))
                break
            end 
        end
    end
    return res
end

