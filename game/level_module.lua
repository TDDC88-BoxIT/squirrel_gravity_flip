-- loader for "tiled" map editor maps (.tmx,xml-based) http://www.mapeditor.org/
-- supports multiple layers
-- NOTE : function ReplaceMapTileClass (tx,ty,oldTileType,newTileType,fun_callback) end
-- NOTE : function TransmuteMap (from_to_table) end -- from_to_table[old]=new
-- NOTE : function GetMousePosOnMap () return gMouseX+gCamX-gScreenW/2,gMouseY+gCamY-gScreenH/2 end

tile_width = 32
tile_height = 32
kMapTileTypeEmpty = 0
local floor = math.floor
local ceil = math.ceil

function TiledMap_Load (filepath,tile_width,tile_height,spritepath_removeold,spritepath_prefix)
	spritepath_removeold = spritepath_removeold or "../"
	spritepath_prefix = spritepath_prefix or ""
	tile_width = tile_width or 32
	tile_height = tile_height or 32
	game_tile_set = {}
	
	local tiletype,layers = TiledMap_Parse(filepath)
	tile_layers = layers
	
	for first_gid,path in pairs(tiletype) do  -- LOOPS OVER ALL TILES TYPES IN THE LEVEL
		path = spritepath_prefix .. string.gsub(path,"^"..string.gsub(spritepath_removeold,"%.","%%."),"") -- RETREIVING THE PATH FOR THE TILES
		local tile_image = gfx.loadpng(path) -- CREATES A NEW IMAGE OF HERO AND FLOOR IMAGE FILE
		local w,h = tile_image:get_width(), tile_image:get_height() 
		local tile_type_id = first_gid
		local tile_image_surface = gfx.new_surface(tile_width,tile_height)
		tile_image_surface:copyfrom(tile_image,nil,nil,true) -- PUTS THE CREATED IMAGE (RAW) ON THE SPRITE SURFACE AND SETS ITS SEIZE TO e
		game_tile_set[tile_type_id] = tile_image_surface
		tile_type_id = tile_type_id + 1
		tile_image:destroy() -- DESTROYS THE RAW IMAGE TO SAVE RAM
	end
end

function get_tile_data_value (tx,ty,layerid) -- coords in tiles
	local row = tile_layers[layerid][ty]
	return row and row[tx] or kMapTileTypeEmpty
end

function draw_tiles (player_x,player_y)
	player_x,player_y = floor(player_x),floor(player_y)
	local screen_w = screen:get_width()
	local screen_h = screen:get_height()
	local minx,maxx = floor((player_x-screen_w/2)/tile_width),ceil((player_x+screen_w/2)/tile_width) -- DIVIDES THE SCREEN WIDTH INTO UNITS OF SIZE TILE_WIDTH
	local miny,maxy = floor((player_y-screen_h/2)/tile_height),ceil((player_y+screen_h/2)/tile_height) -- DIVIDES THE SCREEN INTO UNITS OF SIZE TILE_HEIGHT
	for layer_id = 1,#tile_layers do 	-- LOOPS OVER ALL LAYER OF TILES IN THE LEVEL
		for x = minx,maxx do 			-- LOOPS OVER THE WIDTH OF THE SCREEN
			for y = miny,maxy do 		-- LOOPS OVER THE HEIGHT OF THE SCREEN
				local tile = game_tile_set[get_tile_data_value(x,y,layer_id)] -- RETREIVES THE TILE FOR THE CURRENT LOCATION
				if (tile) then
					local sx = x*tile_width - player_x + screen_w/2 -- WHAT DOES THIS DO?
					local sy = y*tile_height - player_y + screen_h/2 -- WHAT DOES THIS DO?
					screen:copyfrom(tile,nil,{x=sx,y=sy,nil,nil})
				end
			end
		end
	end
end


-- ***** ***** ***** ***** ***** xml parser


-- LoadXML from http://lua-users.org/wiki/LuaXml
function LoadXML(s)
  local function LoadXML_parseargs(s)
    local arg = {}
    string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
  	arg[w] = a
    end)
    return arg
  end
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=LoadXML_parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=LoadXML_parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[stack.n].label)
  end
  return stack[1]
end


-- ***** ***** ***** ***** ***** parsing the tilemap xml file

local function getTilesets(node)
	local tiles = {}
	for k, sub in ipairs(node) do
		if (sub.label == "tileset") then
			tiles[tonumber(sub.xarg.firstgid)] = sub[1].xarg.source
		end
	end
	return tiles
end

local function getLayers(node)
	local layers = {}
	for k, sub in ipairs(node) do
		if (sub.label == "layer") then --  and sub.xarg.name == layer_name
			local layer = {}
			table.insert(layers,layer)
			width = tonumber(sub.xarg.width)
			i = 1
			j = 1
			for l, child in ipairs(sub[1]) do
				if (j == 1) then
					layer[i] = {}
				end
				layer[i][j] = tonumber(child.xarg.gid)
				j = j + 1
				if j > width then
					j = 1
					i = i + 1
				end
			end
		end
	end
	return layers
end

function TiledMap_Parse(filename)
	local xml = LoadXML(love.filesystem.read(filename))
	local tiles = getTilesets(xml[2])
	local layers = getLayers(xml[2])
	return tiles, layers
end

-- basic check collision - logic
function hitTest (herox, heroy, hero_width, hero_height)
	herox,heroy = floor(herox),floor(heroy)
	local screen_w = screen:get_width()
	local screen_h = screen:get_height()
	local minx,maxx = floor((herox-screen_w/2)/tile_width),ceil((herox+screen_w/2)/tile_width)
	local miny,maxy = floor((heroy-screen_h/2)/tile_height),ceil((heroy+screen_h/2)/tile_height)
	for layer_id = 1,#tile_layers do 	-- LOOPS OVER ALL LAYER OF TILES IN THE LEVEL
		for x = minx,maxx do 			-- LOOPS OVER THE WIDTH OF THE SCREEN
			for y = miny,maxy do 		-- LOOPS OVER THE HEIGHT OF THE SCREEN
				local tile = game_tile_set[get_tile_data_value(x,y,layer_id)]
				if (tile) then
					local sx = x*tile_width - herox + screen_w/2
					local sy = y*tile_height - heroy + screen_h/2
					local temp1,temp2,temp3,temp4 = CheckCollision2(herox, heroy, hero_width, hero_height, sx, sy, tile_width, tile_height)
					if temp1 ~= nil then
						return temp1,temp2,temp3,temp4
					end
				end
			end
	    end
	end
  return nil
end

-- basic check collesion
function checkCollesion(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  if ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 then
    return 1-- left & right
  end
  return 0
end
