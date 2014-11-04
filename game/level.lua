
-- This is the level loader, Level is the main
-- raw_level
--   The raw level file as expressed in the .lua level file, contains all the level info unchanged 
-- tiles
--   This is a table of all the tiles that the map contains, it has the width, heigh, x, y and image path of each tile
Level = { 
  raw_level = nil,
  version = nil,
  width = nil,
  tiles = nil;
  
}
-- This function needs to be called to load the level file into memory, you will then be able to just call Level.tiles to get a list of all the tiles
function Level.load_level (level_number)
  loaded_level = require("map/level"..level_number)
  Level.version = loaded_level.version
  Level.raw_level = loaded_level
  Level.width = loaded_level.width
  -- Get all the tiles and saves them into the Level.tiles table
  Level.tiles = get_tiles()
end

function get_tiles()
  -- Selects the first layer in the lua level file, as of today only one layer is supported
  tile_layer_data = Level.raw_level.layers[1].data
  tilesets = {}
  tiles = {} 
  
  -- Saves the tilesets data into an array with the firstgid index, this is the same number as in the tile_layer_data
  for k,v in pairs(Level.raw_level.tilesets) do 
    tilesets[v.firstgid] = v
  end   

  -- Loops all the numbers in the level file, 
  for k,gid in pairs(tile_layer_data) do
    -- Only if there actually is a tile on the current position
    if gid ~= 0 then
      -- Get the information about the current tile from it's tileset 
      tile = {
        width = tilesets[gid].tilewidth,
        height = tilesets[gid].tileheight,
        image = tilesets[gid].image,
        -- Calculates the X and Y coordinates depending in the position in the layer data number array and the width of the current tile
        x = ((k-1) % Level.raw_level.width) * tilesets[gid].tilewidth,
        y = (math.floor((k-1) / Level.raw_level.width)) * tilesets[gid].tileheight
      }
      print(((k-1) % Level.raw_level.width) )
      table.insert(tiles, tile)
    end
  end
  return tiles
end
