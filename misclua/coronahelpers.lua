
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