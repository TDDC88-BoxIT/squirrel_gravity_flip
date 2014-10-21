-----------------------
-- menu_object class --
-----------------------
-- THE MENU CONSTRUCTOR SETS START VALUES FOR THE MENU
menu_object = class(function (self, menu_width, menu_height)
	self.width = menu_width or screen:get_width()*0.2
	self.height = menu_height or 300
  self.tile_height = 60
	self.tile_width = self.width*0.9
	self.tile_x = (self.width-self.tile_width)/2
	self.tile_y = self.height*0.05
	self.indicator_color = {r=255,g=0,b=0}
	self.indicator_width=self.tile_width*0.05
  self.indexed_item=1
  self.menu_items={}
  self.menu_surface=nil
end)

-- SETS MENU SIZE
function menu_object:set_size(menu_width,menu_height)
	self.widht=menu_width or self.width
	self.height=menu_height or self.height
end

-- RETURNS MENU SIZE
function menu_object:get_size()
	local size={widht=self.width, height=self.height}
	return size
end

-- SETS MENU TILE SIZE
function menu_object:set_tile_size(width,height)
	self.tile_widht=widht or self.tile_widht
	self.tile_height=height or self.tile_height
end

-- RETURNS MENU TILE SIZE
function menu_object:get_tile_size()
	local size={widht=self.tile_widht, height=self.tile_widht}
	return size
end

-- SETS TILE LOCATION
function menu_object:set_tile_location(tile_x, tile_y)
	self.tile_x=tile_x or menu_object:get_location().x
	self.tile_y=tile_y or menu_object:get_location().y
end

-- RETURNS TILE LOCATION
function menu_object:get_tile_location()
	local location={x=self.tile_x, y=self.tile_y}
	return location
end

-- ADDS NEW MENU ITEMS
function menu_object:add_item(item_id, img_Path)
	table.insert(self.menu_items, table.getn(self.menu_items)+1, {id=item_id,img=img_Path})
end

-- CLEARS ALL ADDED MENU ITEMS
function menu_object:clear_items()
  self.menu_items={}
end

-- RETURNS THE MENU ITEM CURRENTLY INDEXED
function menu_object:get_indexed_item()
  return self.menu_items[self.indexed_item]
end 

-- RETURNS ALL MENU ITEMS
function menu_object:get_items()
	return self.menu_items
end

-- SETS THE MENU INDICATOR COLOR
function menu_object:set_indicator_color(color)
  self.indicator_color=color;
end

-- SETS THE INDICATOR WIDTH
function menu_object:set_indicator_width(width)
  self.indicator_width=width
end

-- INCREASES THE INDEX FOR CURRENTLY SELECTED MENU ITEM
function menu_object:increase_index()
  if self.indexed_item<table.getn(self.menu_items) then
    self.indexed_item=self.indexed_item+1
  end
end

-- DE CREASES THE INDEX FOR CURRENTLY SELECTED MENU ITEM
function menu_object:decrease_index()
  if self.indexed_item>1 then
    self.indexed_item=self.indexed_item-1
  end
end

-- RETURNS THE INDEX OF THE CURRENTLY SELECTED MENU ITEM
function menu_object:get_current_index()
  return self.indexed_item
end

-- ASSEMBLES ALL MENU PARTS INTO A MENU
function menu_object:update()
  if self.height<table.getn(self.menu_items)*(self.tile_height+20) then
    self:set_tile_size(nil,(self.height-(table.getn(self.menu_items))*20)/table.getn(self.menu_items))
  end
  self.menu_surface=gfx.new_surface(self.width, self.height)
  self:make_bakground()
  self:make_tiles()
end


-- SETS THE PATH TO THE MENU BACKGROUND IMAGE
function menu_object:set_background(path)
  self.menu_background=path
end

-- CREATES THE MENU BACKGROUND AND ADDS IT TO THE MENU
function menu_object:make_bakground()
   local img_surface=nil
    img_surface = gfx.loadpng(self.menu_background)
    self.menu_surface:copyfrom(img_surface,nil,{x=0,y=0,width=self.width,height=self.height},true)
    img_surface:destroy()
end

-- CREATES ALL MENU BUTTONS AND ADDS THEM TO THE MENU
function menu_object:make_tiles()
  -- Create menu tile rectangles    CREATE AN ARRAY WITH ALL TILES AND LOOP THROUGH IT WHEN DRAWING TO AVOID BLACK AREAS
  for i = 1, table.getn(self.menu_items), 1 do
    -- Set button image
    local img_surface=nil
    img_surface = gfx.loadpng(self.menu_items[i].img)
    self.menu_surface:copyfrom(img_surface,nil,{x=self.tile_x,y=(self.tile_y+(self.tile_height*(i-1)+i*10)
),width=self.tile_width,height=self.tile_height},true)
    if i == self.indexed_item then
		self:make_item_indicator((self.tile_y+(self.tile_height*(i-1)+i*10)))
  	end
    img_surface:destroy()
  end
end

-- CREATES THE MENU INDICATOR AND ADDS IT TO THE MENU. THE Y-VALUE MARKS WHERE THE INDICATOR IS TO BE PUT
function menu_object:make_item_indicator(y_value)
	-- Set indicator size
  self.indicator_height = self.tile_height -- Indicator is as high as the tile which it incicates
	-- Create indicator surface
  local sf = gfx.new_surface(self.indicator_width, self.indicator_height)
 
	--Set color for indicator surface
  sf:fill(self.indicator_color)
  self.menu_surface:copyfrom(sf,nil,{x=self.tile_x, y=y_value, width=self.indicator_width, height=self.indicator_height})
  sf:destroy()
end

-- RETURNS THE MENU SURFACE
function menu_object:get_surface()
  return self.menu_surface
end 