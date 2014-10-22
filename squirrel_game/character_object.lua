----------------------------
-- character_object class --
----------------------------

-- THE MENU CONSTRUCTOR SETS START VALUES FOR THE MENU
character_object = class(function (self, character_width, character_height, character_img)
	self.width = character_width or 50
	self.height = character_height or 50
	self.character_images={}
	self.current_character_image=1	-- DETERMINES WHICH CHARACTER IMAGE WILL BE DISPLAYED CURRENTLY
	self.character_surface=nil
	if character_img ~= nil then
		self:add_image(character_img) 
	end
end)

-- SETS MENU SIZE
function character_object:set_size(character_width, character_height)
	self.width=character_width or self.width
	self.height=character_height or self.height
end

-- RETURNS MENU SIZE
function character_object:get_size()
	local size={width=self.width, height=self.height}
	return size
end

-- ADDS NEW MENU ITEMS
function character_object:add_image(img_Path)
	table.insert(self.character_images, table.getn(self.character_images)+1, img_Path)
end

-- RETURNS ALL MENU ITEMS
function character_object:get_images()
	return self.character_images
end

-- RETURNS THE MENU ITEM CURRENTLY INDEXED
function character_object:get_current_image()
  	return self.character_images[self.current_character_image]
end 

-- CLEARS ALL ADDED MENU ITEMS
function character_object:clear_images()
  	self.character_images={}
end

function character_object:animate()
	if self.current_character_image<table.getn(self.character_images) then
		self.current_character_image=self.current_character_image+1
	else
		self.current_character_image=1
	end
end

function character_object:set_image()
	local sf = gfx.loadpng(self:get_current_image())
	self.character_surface:copyfrom(sf,nil,{x=0,y=0,width=self.width,height=self.height},true)
	sf:destroy()
end	

-- ASSEMBLES ALL MENU PARTS INTO A MENU
function character_object:update()
	self.character_surface=gfx.new_surface(self.width, self.height)
  	self:set_image()
  	self:animate()
end

-- RETURNS THE MENU SURFACE
function character_object:get_surface()
  	return self.character_surface
end 