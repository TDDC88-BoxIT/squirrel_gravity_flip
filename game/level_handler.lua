
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
-- This function needs to be called to load the level file into memory, you will then be able to just call Level.tiles to get a list of all the tiles
function Level.load_level (level_number,game_type)
  if game_type=="tutorial" then
    loaded_level = require("map/tutorialLevel"..level_number)
  else
    loaded_level = require("map/level"..level_number)
  end
  Level.version = loaded_level.version
  Level.raw_level = loaded_level
  Level.width = loaded_level.width
  Level.attributes = loaded_level.attributes
  -- Get all the tiles and saves them into the Level.tiles table
  Level.tiles = get_tiles()
  --return Level
end


function get_tiles()
  -- Selects the first layer in the lua level file, as of today only one layer is supported
  tile_layer_data = Level.raw_level.layers[1].data
  tilesets = {}
  tiles = {} 

  -- Saves the tilesets data into an array with the firstgid index, this is the same number as in the tile_layer_data
  for k,v in pairs(Level.raw_level.tilesets) do 
    tilesets[v.firstgid] = v
    load_images(v.name)
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

function load_images(tile_name)
  if tile_name == "floor1" then
    floorimg = gfx.loadpng("images/floor1.png")
  elseif tile_name == "powerup1" then
    powerup1Img = gfx.loadpng("images/powerup1.png") 
  elseif tile_name == "powerup2" then
    powerup2Img = gfx.loadpng("images/powerup2.png")
  elseif tile_name == "powerup3" then
    powerup3Img = gfx.loadpng("images/powerup3.png")
  elseif tile_name == "powerup4" then
    powerup4Img = gfx.loadpng("images/powerup4.png")
  elseif tile_name == "obstacle1" then
    obstacleGroundSpikeImg = gfx.loadpng("images/obstacleGroundSpike.png")
  elseif tile_name == "obstacle2" then
    obstacleCeilingSpikeImg = gfx.loadpng("images/obstacleCeilingSpike.png")
  elseif tile_name == "obstacle3" then
    obstacle3Img = gfx.loadpng("images/obstacle3.png")
  elseif tile_name == "obstacle4" then
    flame1Img = gfx.loadpng("images/flame1.png")
  elseif tile_name == "winTile" then
    winImg = gfx.loadpng("images/winTile.png")
  end 
end

function get_image(tile_name)
  if tile_name == "floor1" then
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
  elseif tile_name == "win" then
    return winImg
  else
    return winImg
  end 
end