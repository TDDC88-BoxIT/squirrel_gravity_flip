require('surface_class')
-- ## gfx module ##
-- 
-- gfx.set_auto_update(bool)
--   If set to true, any change to gfx.screen immediately triggers
--   gfx.update() to make the change visible. This slows the system if
--   the screen is updated in multiple steps but is useful for
--   interactive development.
-- 
-- gfx.new_surface(width, height)
--   Creates and returns a new 32-bit RGBA graphics surface of chosen
--   dimensions. The surface pixels are not initialized; clear() or
--   copyfrom() should be used for this.
--   <width> and <height> must be positive integers and each less than 10000.
--   An error is raised if enough graphics memory cannot be allocated.
-- 
-- gfx.get_memory_use()
--   Returns the number of bytes of graphics memory the application
--   currently uses. Each allocated pixel uses 4 bytes since all surfaces
--   are 32-bit. A limit of gfx.get_memory_limit() is enforced.
-- 
-- gfx.screen or screen
--   The surface that shows up on the screen when gfx.update() is called.
--   Calling gfx.set_auto_update(true) makes the screen update
--   automatically when gfx.screen is changed (for development; too slow
--   for animations)
-- 
-- gfx.get_memory_limit()
--   Returns the maximum bytes of graphics memory the application is
--   allowed to use.
-- 
-- gfx.update()
--   Makes any pending changes to gfx.screen visible.
-- 
-- gfx.loadpng(path)
--   Loads the PNG image at <path> into a new surface that is
--   returned. The image is always translated to 32-bit
--   RGBA. Transparency is preserved. A call to surface:premultiply()
--   might be necessary for transparency to work.
--   An error is raised if not enough graphics memory can be allocated.
-- 
-- gfx.loadjpeg(path)
--   Loads the JPEG image at <path> into a new surface that is returned.
--   The image is always translated to 32-bit RGBA. All pixels will be
--   opaque since JPEG does not support transparency.  
--   An error is raised if not enough graphics memory can be allocated.

local gfx = {}

function gfx.set_auto_update(bool)
  gfx.auto_update = bool
end


function gfx.new_surface(width, height)
  gfx.memory_use = gfx.memory_use + (width*height*4)
  return surface_class(width, height)
end


function gfx.get_memory_use()
  return gfx.memory_use
end


screen = surface_class(love.graphics.getDimensions())
--screen = gfx.screen
--buffer_screen = gfx.screen

function gfx.get_memory_limit()
  -- Taken from the box
  return 10485760
end


function gfx.update()
  --print('Called draw')
  --love.graphics.draw(gfx.screen.canvas)
  buffer_screen = screen
end


function gfx.loadpng(path)
  return gfx.loadjpeg(path)
end


function gfx.loadjpeg(path)
  image = love.graphics.newImage(path)
  surface = surface_class(image:getDimensions())
  gfx.memory_use = gfx.memory_use + (image:getWidth()*image:getHeight()*4)
  love.graphics.setCanvas(surface.canvas)
  love.graphics.setColor(check_color({255,255,255,255}))
  --love.graphics.setBlendMode('premultiplied')
  love.graphics.draw(image)
  love.graphics.setCanvas()
  return surface
end


----------------------
-- Helper variables --
----------------------

gfx.auto_update = false
gfx.memory_use = 0

return gfx
