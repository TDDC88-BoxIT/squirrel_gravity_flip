-----------------------
-- menu_object class --
-----------------------

--[[
IN ORDER TO USE THE MENU OBJECT YOU FIRST NEED TO CREATE AND SAVE A NEW INSTANCE OF THE OBJECT.
THIS IS DONE BY CALLING: 
  
  menu_object_variable = menu_object(width,height,character_image_path)

IN ORDER TO DRAW THE MENU ON THE SCREEN, THE OBJECT SURFACE FIRST HAS TO BE RETRIEVED.
THIS IS DONE BY CALLING:

  menu_image_surface = menu_object_variable:get_surface()

THE MENU OBJECT HAS A SET OF CONFIGURATION FUNCTIONS WHICH CAN BE USED, THESE ARE:
  
  menu_object:set_size(menu_width,menu_height)
  menu_object:get_size()
  menu_object:set_button_size(width,height)
  menu_object:get_button_size()
  menu_object:set_button_location(button_x, button_y)
  menu_object:get_button_location()
  menu_object:add_button(button_id, img_Path)
  menu_object:clear_buttons()
  menu_object:clear_images()
  menu_object:get_indexed_item()
  menu_object:set_indicator_color(color)
  menu_object:set_indicator_width(width)
  menu_object:increase_index()
  menu_object:decrease_index()
  menu_object:get_current_index()
  menu_object:set_background(path)

MAKE SURE TO USE THE DESTROY COMMAND WHEN THE OBJECT HAS BEEN DRAWN ON SCREEN IN ORDER TO SAVE RAM!
THIS WILL DESTROY THE OBJECTS SURFACE.
THIS IS DONE BY CALLING:

  menu_object:destroy()

--]]
require("class")
-- THE MENU CONSTRUCTOR SETS START VALUES FOR THE MENU
menu_object = class(function (self, menu_width, menu_height)
    self.width = menu_width or math.floor(screen:get_width()*0.2)
    self.height = menu_height or 300
    self.button_height = 60
    self.button_width = math.floor(self.width*0.9)
    self.button_x = (self.width-self.button_width)/2
    self.button_y = math.floor(self.height*0.05)
    self.indicator_color = {r=255,g=0,b=0}
    self.indexed_item=1
    self.menu_items={}
    self.menu_surface=nil
  end)

-- SETS MENU SIZE
function menu_object:set_size(menu_width,menu_height)
  self.widht=menu_width or self.width
  gameState = get_menu_state()
    self.height=menu_height or self.height
end

-- RETURNS MENU SIZE
function menu_object:get_size()
  local size={widht=self.width, height=self.height}
  return size
end

-- SETS MENU button SIZE
function menu_object:set_button_size(width,height)
  self.button_widht=widht or self.button_widht
  self.button_height=height or self.button_height
end

-- RETURNS MENU button SIZE
function menu_object:get_button_size()
  local size={widht=self.button_widht, height=self.button_height}
  return size
end

-- SETS button LOCATION
function menu_object:set_button_location(button_x, button_y)
  self.button_x=button_x or menu_object:get_location().x
  self.button_y=button_y or menu_object:get_location().y
end

-- RETURNS button LOCATION
function menu_object:get_button_location()
  local location={x=self.button_x, y=self.button_y}
  return location
end

-- ADDS NEW MENU ITEMS
function menu_object:add_button(button_id, img_Path)
  table.insert(self.menu_items, #self.menu_items+1, {id=button_id,img=img_Path})
end

-- CLEARS ALL ADDED MENU ITEMS
function menu_object:reset()
  self.menu_items={}
  self.indexed_item=1
end

-- RETURNS THE AMOUNT OF ITEMS WHICH HAVE BEEN ADDED TO THE MENU
function menu_object:get_item_amount()
  return #self.menu_items
end

-- RETURNS THE MENU ITEM CURRENTLY INDEXED
function menu_object:get_indexed_item()
  return self.menu_items[self.indexed_item]
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
  if self.indexed_item<#self.menu_items then
    self.indexed_item=self.indexed_item+1
  end
end

-- DECREASES THE INDEX FOR CURRENTLY SELECTED MENU ITEM
function menu_object:decrease_index()
  if self.indexed_item>1 then
    self.indexed_item=self.indexed_item-1
  end
end

-- RETURNS THE INDEX OF THE CURRENTLY SELECTED MENU ITEM
function menu_object:get_current_index()
  return self.indexed_item
end


-- SETS THE PATH TO THE MENU BACKGROUND IMAGE
function menu_object:set_background(path)
  self.menu_background=path
end

-- CREATES THE MENU BACKGROUND AND ADDS IT TO THE MENU
local function make_background(self)
  local img_surface=nil
  img_surface = gfx.loadpng(self.menu_background)
  self.menu_surface:copyfrom(img_surface,nil,{x=0,y=0,width=self.width,height=self.height-(20+2*screen:get_height()/100)},true)
  img_surface:destroy()
end

-- CREATES THE MENU INDICATOR AND ADDS IT TO THE MENU. THE Y-VALUE MARKS WHERE THE INDICATOR IS TO BE PUT
local function make_item_indicator(self, y_value)
  -- Set indicator size
  self.indicator_height = self.button_height -- INDICATOR HEIGHT IS SET TO button HEIGHT
  self.indicator_width = math.floor(self.button_width*0.05) -- INDICATOR WIDTH IS SET TO 5% OF button WIDTH
  -- Create indicator surface
  local sf = gfx.new_surface(self.indicator_width, self.indicator_height)
  --Set color for indicator surface
  sf:fill(self.indicator_color)
  self.menu_surface:copyfrom(sf,nil,{x=self.button_x, y=y_value, width=self.indicator_width, height=self.indicator_height})
  sf:destroy()
end

-- CREATES ALL MENU BUTTONS AND ADDS THEM TO THE MENU
local function make_buttons(self)
  
  -- LOOPS THROUGH ALL ITEMS WHICH HAVE BEEN ADDE TO THE MENU AND CREATES A SET OF BUTTONS FOR THESE
  for i = 1, #self.menu_items, 1 do
    -- SETS THE BUTTON IMAGE
    local img_surface=nil
    img_surface = gfx.loadpng(self.menu_items[i].img)

    -- PUTS THE CREATED BUTTON IMAGE ON THE MENU SURFACE  
      self.menu_surface:copyfrom(img_surface,nil,{x=self.button_x,y=(self.button_y+(self.button_height*(i-1)+i*10)),width=self.button_width,height=self.button_height},true)

    if i == self.indexed_item then
      -- CREATES AN INDICATOR WHICH IS SET ON THE INDEXED BUTTON
      make_item_indicator(self, (self.button_y+(self.button_height*(i-1)+i*10)))
    end
    -- DESTROYS THE BUTTON IMAGE SURFACE TO SAVE RAM CONSUMPTION
    img_surface:destroy()
  end
end

-- ASSEMBLES ALL MENU PARTS INTO A MENU
local function update(self)
  if self.menu_surface == nil then
    self.menu_surface=gfx.new_surface(self.width, self.height)
  end
  --if self.height~=#self.menu_items*(self.button_height+20) then
    --self:set_button_size(nil,(self.height-(#self.menu_items)*20-(2*screen:get_height()/100))/#self.menu_items) --ADJUSTS THE BUTTON HEIGHT IN CASE IT IS TOO BIG TO FIT ALL BUTTONS ON THE SCREEN (LEVEL MENU). TAKES INTO ACCOUNT THE FACT THAT THE LEVEL MENU STARTS 1/100 DOWN
  --end
  make_background(self)
  make_buttons(self)
end

-- RETURNS THE MENU SURFACE
function menu_object:get_surface()
  update(self)
  return self.menu_surface
end 

-- DESTROYS THE MENU OBEJCT'S SURFACE
function menu_object:destroy()
  self.menu_surface:destroy()
  self.menu_surface=nil
end