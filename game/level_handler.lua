
-- This is the level loader, Level is the main
-- raw_level
--   The raw level file as expressed in the .lua level file, contains all the level info unchanged 
-- tiles
--   This is a table of all the tiles that the map contains, it has the width, heigh, x, y and image path of each tile
Level = { 
  raw_level = nil,
  version = nil,
  width = nil,
  tiles = nil,
  attributes = {
    speed = nil,
    upper_bound_y = nil,
    lower_bound_y = nil
  }
}
local floorimg
local powerup1Img
local powerup2Img
local powerup3Img
local powerup4Img
local obstacleGroundSpikeImg
local obstacleCeilingSpikeImg
local obstacle3Img
local flame1Img
local winImg
local loaded_level
-- This function needs to be called to load the level file into memory, you will then be able to just call Level.tiles to get a list of all the tiles
function Level.load_level (level_number,game_type)
  if game_type=="tutorial" then
    local file = io.open("map/tutorialLevel"..level_number..".lua","r")
    if file~=nil then -- MAKE SURE LEVEL FILE EXISTS
      loaded_level = require("map/tutorialLevel"..level_number)
    else -- IF LEVEL DOESN'T EXIST, THE USER IS SENT BACK TO THE START MENU
      return
    end
  else
    local file = io.open("map/level"..level_number..".lua","r")
    if file ~= nil then -- MAKE SURE LEVEL FILE EXISTS
      loaded_level = require("map/level"..level_number)
    else -- IF LEVEL DOESN'T EXIST, THE USER IS SENT BACK TO THE START MENU
      return
    end
  end
  Level.version = loaded_level.version
  Level.raw_level = loaded_level
  Level.width = loaded_level.width
  Level.attributes = loaded_level.attributes
  -- Get all the tiles and saves them into the Level.tiles table
  Level.tiles = get_tiles()
  Level.character_start_pos_x = loaded_level.properties["character_start_pos_x"] * 32  -- Sets the characters start position on the x-axis
  Level.character_start_pos_y = loaded_level.properties["character_start_pos_y"] * 32  -- Sets the characters start position on the y-axis
  return "level_loaded"
end


function get_tiles()
  -- Selects the first layer in the lua level file, as of today only one layer is supported
  tile_layer_data = Level.raw_level.layers[1].data
  tilesets = {}
  tiles = {} 

  -- Saves the tilesets data into an array with the firstgid index, this is the same number as in the tile_layer_data
  for k,v in pairs(Level.raw_level.tilesets) do 
    tilesets[v.firstgid] = v
    if string.sub(v.image,1,3)=="../" then
      print(string.sub(v.image,4,string.len(v.image))) 
      load_images(v.name, string.sub(v.image,4,string.len(v.image))) -- LOADS IMAGE PATH WITHOUT UNWANTED FIRST CHARACTERS
    else
      load_images(v.name, v.image)
    end
  end   
  -- Loops all the numbers in the level file, 
  for k,gid in pairs(tile_layer_data) do
    -- Only if there actually is a tile on the current position
    if gid ~= 0 then
      -- Get the information about the current tile from it's tileset 
      tile = {
        name = tilesets[gid].name,
        gid = tilesets[gid].firstgid,
        visibility = true,
        width = tilesets[gid].tilewidth,
        height = tilesets[gid].tileheight,
        image = get_image(tilesets[gid].name),    --tilesets[gid].image,
        -- Calculates the X and Y coordinates depending in the position in the layer data number array and the width of the current tile
        x = ((k-1) % Level.raw_level.width) * tilesets[gid].tilewidth,
        y = (math.floor((k-1) / Level.raw_level.width)) * tilesets[gid].tileheight
      }
      table.insert(tiles, tile)
      
    end
  end
  return tiles
end


function load_images(tile_name, img_path)
  if string.sub(tile_name,1,5) == "floor" then
    floorimg = gfx.loadpng(img_path)
    floorimg:premultiply()
  elseif tile_name == "powerup1" then
    powerup1Img = gfx.loadpng(img_path) 
    powerup1Img:premultiply()
  elseif tile_name == "powerup2" then
    powerup2Img = gfx.loadpng(img_path)
    powerup2Img:premultiply()
  elseif tile_name == "powerup3" then
    powerup3Img = gfx.loadpng(img_path)
    powerup3Img:premultiply()
  elseif tile_name == "powerup4" then
    powerup4Img = gfx.loadpng(img_path)
    powerup4Img:premultiply()
  elseif tile_name == "obstacle1" then
    obstacleGroundSpikeImg = gfx.loadpng(img_path)
    obstacleGroundSpikeImg:premultiply()
  elseif tile_name == "obstacle2" then
    obstacleCeilingSpikeImg = gfx.loadpng(img_path)
    obstacleCeilingSpikeImg:premultiply()
  elseif tile_name == "obstacle3" then
    obstacle3Img = gfx.loadpng(img_path)
    obstacle3Img:premultiply()
  elseif tile_name == "obstacle4" then
    flame1Img = gfx.loadpng(img_path)
    flame1Img:premultiply()
  elseif tile_name == "obstacle5" then
    obstacleLeftSpikeImg = gfx.loadpng(img_path)
    obstacleLeftSpikeImg:premultiply()
  elseif tile_name == "obstacle6" then
    obstacleRightSpikeImg = gfx.loadpng(img_path)
    obstacleRightSpikeImg:premultiply()
  elseif string.sub(tile_name,1,3) == "win" then
    winImg = gfx.loadpng(img_path)
    winImg:premultiply()
  end 
end

function get_image(tile_name)
  if string.sub(tile_name,1,5) == "floor" then
    return floorimg
  elseif tile_name == "powerup1" then
    return powerup1Img
  elseif tile_name == "powerup2" then
    return powerup2Img
  elseif tile_name == "powerup3" then
    return powerup3Img
  elseif tile_name == "powerup4" then
    return powerup4Img
  elseif tile_name == "obstacle1" then
    return obstacleGroundSpikeImg
  elseif tile_name == "obstacle2" then
    return obstacleCeilingSpikeImg
  elseif tile_name == "obstacle3" then
    return obstacle3Img
  elseif tile_name == "obstacle4" then
    return flame1Img
  elseif tile_name == "obstacle5" then
    return obstacleLeftSpikeImg
  elseif tile_name == "obstacle6" then
    return obstacleRightSpikeImg
  elseif string.sub(tile_name,1,3) == "win" then
    return winImg
  end 
end