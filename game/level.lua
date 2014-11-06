
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
      table.insert(tiles, tile)
    end
  end
  return tiles
end

-- basic check collision - logic
function hitTest (gameCounter,tileSet, herox, heroy, hero_width, hero_height)
  for k,v in pairs(tileSet) do
    local temp1,temp2,temp3,temp4 = CheckCollision2(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height)
    if temp1 ~= nil then
      return temp1,temp2,temp3,temp4
    end
  end
  return nil
  --[[herox,heroy = floor(herox),floor(heroy)
  local screen_w = screen:get_width()
  local screen_h = screen:get_height()
  local minx,maxx = floor((herox-screen_w/2)/tile_width),ceil((herox+screen_w/2)/tile_width)
  local miny,maxy = floor((heroy-screen_h/2)/tile_height),ceil((heroy+screen_h/2)/tile_height)
  for layer_id = 1,#tile_layers do  -- LOOPS OVER ALL LAYER OF TILES IN THE LEVEL
    for x = minx,maxx do      -- LOOPS OVER THE WIDTH OF THE SCREEN
      for y = miny,maxy do    -- LOOPS OVER THE HEIGHT OF THE SCREEN
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
  ]]
end