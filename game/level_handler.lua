
-- This is the level loader, Level is the main
-- raw_level
--   The raw level file as expressed in the .lua level file, contains all the level info unchanged 
-- tiles
--   This is a table of all the tiles that the map contains, it has the width, heigh, x, y and image path of each tile

-- Cause we only store tile when its gid > 0, Level.map_table store the index-index map from all tiles to no-zero tiles.
-- For example, map_table[38]=23 means the No.38 tile of raw_level data is the 23th value in our tiles table.
Level = { 
  raw_level = nil,
  version = nil,
  width = nil,
  tiles = nil,
  map_table = nil,
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
local current_level=0

-- This function needs to be called to load the level file into memory, you will then be able to just call Level.tiles to get a list of all the tiles
function Level.load_level (level_number,game_type)
  current_level=level_number
  if game_type=="tutorial" then
    local file = io.open(file_prefix .. "map/tutorialLevel"..level_number..".lua","r")
    if file~=nil then -- MAKE SURE LEVEL FILE EXISTS
      loaded_level = require("map/tutorialLevel"..level_number)
    else -- IF LEVEL DOESN'T EXIST, THE USER IS SENT BACK TO THE START MENU
      return
    end
  else
    local file = io.open(file_prefix .. "map/level"..level_number..".lua","r")
    if file ~= nil then -- MAKE SURE LEVEL FILE EXISTS
      loaded_level = require("map/level"..level_number)
    else -- IF LEVEL DOESN'T EXIST, THE USER IS SENT BACK TO THE START MENU
      return
    end
  end
  Level.version = loaded_level.version
  Level.raw_level = loaded_level
  Level.width = loaded_level.width
  set_game_boudries(screen:get_height(),0)
  -- Get all the tiles and saves them into the Level.tiles table
  Level.tiles = get_tiles()
  --Level.CloudSet = Cloud_set()
  --Level.FlameSet = Flame_set()
  Level.character_start_pos_x = loaded_level.properties["character_start_pos_x"] * 32  -- Sets the characters start position on the x-axis
  Level.character_start_pos_y = loaded_level.properties["character_start_pos_y"] * 32  -- Sets the characters start position on the y-axis
  return "level_loaded"
end


function get_tiles()
  -- Selects the first layer in the lua level file, as of today only one layer is supported
  tile_layer_data = Level.raw_level.layers[1].data
  tilesets = {}
  tiles = {}
  Level.map_table = {}
  local tile_index = 1

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

  --[[
    Order the tiles primary on Y position, to make index them more convenient.
    ]]
  for ix=1, Level.width, 1 do
    for iy=1, Level.raw_level.height, 1 do
      k = (iy - 1) * Level.raw_level.width + ix
      key_index = (ix - 1) * Level.raw_level.height + iy
      gid = tile_layer_data[k]
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
        if string.sub(tile.name,1,3)=="pow" then  --DISTINGUISING TYPES OF TILES WHICH CAN BE USED IN THE COLLISION HANDLER LATER
          tile.type=2
        elseif string.sub(tile.name,1,3)=="obs" then
          tile.type=3
        elseif string.sub(tile.name,1,3)=="win" then
          tile.type=4
        else
          tile.type=1
        end
        tiles[tile_index] = tile
        Level.map_table[key_index] = tile_index
        tile_index = tile_index + 1
      end
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

function get_current_level()
  return current_level
end
--[[function Cloud_set()
  CloudSet = {}
  local cloud_index=1
  for k,v in pairs(tiles) do
    if v.gid==9 then
      CloudSet[cloud_index]=v
      cloud_index=cloud_index+1
    end
  end
  return CloudSet
end
function Flame_set()
  FlameSet = {}
  local flame_index=1
  for k,v in pairs(tiles) do
    if v.gid==10 then
      FlameSet[flame_index]=v
      flame_index=flame_index+1
    end
  end
  return FlameSet
end]]