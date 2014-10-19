require('class')

-------------------
-- Help function --
-------------------

function check_color(color)
  if color ~= nil then
    if color.red ~= nil or color.green ~= nil or color.blue ~= nil or color.alpha ~= nil then
      tmp_color = {}
      if color.red == nil then
        tmp_color[1] = 0
      else
        tmp_color[1] = color.red
      end

      if color.green == nil then
        tmp_color[2] = 0
      else
        tmp_color[2] = color.green
      end

      if color.blue == nil then
        tmp_color[3] = 0
      else
        tmp_color[3] = color.blue
      end

      if color.alpha == nil then
        tmp_color[4] = 255
      else
        tmp_color[4] = color.alpha
      end

      return tmp_color
    end

    if color.r ~= nil or color.g ~= nil or color.b ~= nil or color.a ~= nil then
      tmp_color = {}
      if color.r == nil then
        tmp_color[1] = 0
      else
        tmp_color[1] = color.r
      end

      if color.g == nil then
        tmp_color[2] = 0
      else
        tmp_color[2] = color.g
      end

      if color.b == nil then
        tmp_color[3] = 0
      else
        tmp_color[3] = color.b
      end

      if color.a == nil then
        tmp_color[4] = 255
      else
        tmp_color[4] = color.a
      end

      return tmp_color
    end

    tmp_color = {}
    for i,v in ipairs(color) do
      tmp_color[i] = v
    end

    for i=1,3 do
      if i >= #tmp_color then
        tmp_color[i] = 0
      end
    end
  else
    tmp_color = {0, 0, 0, 255}
  end
  
  return tmp_color
end

function check_rectangle(rectangle)
  if rectangle.x == nil or rectangle.x < 0 then
    rectangle.x = 0
  end
  
  if rectangle.y == nil or rectangle.y < 0 then
    rectangle.y = 0
  end
  
  if rectangle.w ~= nil and rectangle.width == nil then
    rectangle.width = rectangle.w
  end
  
  if rectangle.h ~= nil and rectangle.height == nil then
    rectangle.height = rectangle.h
  end
  
  if rectangle.width == nil or rectangle.width < 0 then
    rectangle.width = 0
  end
  
  if rectangle.height == nil or rectangle.height < 0 then
    rectangle.height = 0
  end
  
  return rectangle
end

-------------------
-- surface_class class --
-------------------

surface_class = class(function (self, width, height)
  width = width or 1280
  height = height or 720
  self.canvas = love.graphics.newCanvas(width, height)
end)

function surface_class:clear(color, rectangle)
  color = check_color(color)
  rectangle = rectangle or {x=0, y=0, width=self.canvas:getWidth(), height=self.canvas:getHeight()}
  rectangle = check_rectangle(rectangle)
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.setColor(color)
  love.graphics.setBlendMode("alpha")
  love.graphics.rectangle("fill", rectangle.x, rectangle.y, rectangle.width, rectangle.height)
  love.graphics.setCanvas()
end

function surface_class:fill(color, rectangle)
  rectangle = rectangle or {x=0, y=0, width=self.canvas:getWidth(), height=self.canvas:getHeight()}
  rectangle = check_rectangle(rectangle)
  
  love.graphics.setCanvas(self.canvas)
  love.graphics.setColor(check_color(color))
  love.graphics.setBlendMode("alpha")
  love.graphics.rectangle("fill", rectangle.x, rectangle.y, rectangle.width, rectangle.height)
  love.graphics.setCanvas()
end

function surface_class:copyfrom(src_surface, src_rectangle, dest_rectangle, blend_option)
  if src_rectangle == nil then
    src_rectangle = {x=0, y=0, width=src_surface:get_width(), height=src_surface:get_height()}
  else
    src_rectangle = check_rectangle(src_rectangle)
  end
  
  if dest_rectangle == nil then
    dest_rectangle = {x=0, y=0, width=src_rectangle.width, height=src_rectangle.height}
  else
    if dest_rectangle.width == nil and dest_rectangle.w == nil then
      dest_rectangle.width=src_rectangle.width
    end
    
    if dest_rectangle.height == nil and dest_rectangle.h == nil then
      dest_rectangle.height=src_rectangle.height
    end
  end
  
  dest_rectangle = check_rectangle(dest_rectangle)
  love.graphics.setColor({255,255,255,255})
  if blend_option ~= nil and blend_option then
    love.graphics.setBlendMode("alpha")
  else
    love.graphics.setBlendMode("replace")
    --love.graphics.setBlendMode('premultiplied')
  end
  
  love.graphics.setCanvas(self.canvas)
  quad = love.graphics.newQuad(src_rectangle.x, src_rectangle.y, src_rectangle.width, src_rectangle.height, src_surface:get_width(), src_surface:get_height())
  love.graphics.draw(src_surface.canvas, quad, dest_rectangle.x, dest_rectangle.y, 0, dest_rectangle.width/src_rectangle.width, dest_rectangle.height/src_rectangle.height)
  love.graphics.setCanvas()
  
  love.graphics.setBlendMode("alpha")
end

function surface_class:get_width()
  return self.canvas:getWidth()
end

function surface_class:get_height()
  return self.canvas:getHeight()
end

function surface_class:get_pixel(x, y)
  local r, g, b, a = self.canvas:getPixel(x, y)
  return {r, g, b, a}
end

function surface_class:set_pixel(x, y, color)
  love.graphics.setCanvas(self.canvas)
  love.graphics.setColor(check_color(color))
  love.graphics.rectangle("fill", x, y, 1, 1)
  love.graphics.setCanvas()
end

function surface_class:premultiply()
  -- Unsure exactly what this method does.
  --love.graphics.setCanvas(self.canvas)
  love.graphics.setBlendMode('premultiplied')
  --love.graphics.draw(self.canvas)
  --love.graphics.setBlendMode('alpha')
  --love.graphics.setCanvas()
end

function surface_class:destroy()
  gfx.memory_use = gfx.memory_use - (self.canvas:getWidth()*self.canvas:getHeight()*4)
  self.canvas = nil
end