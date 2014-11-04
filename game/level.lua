
--This is level loader, loads of quick fixes
--This needs to be changed to be more general overall
Level = { 
  raw_level = nil,
  version = nil,
  tiles = nil;
  
}
function Level.load_level (level_number)
  loaded_level = require("game/levels/level" .. level_number)
  Level.version = loaded_level.version
  Level.raw_level = loaded_level
  Level.width = loaded_level.width
  Level.tiles = get_tiles()
end

function get_tiles()
  
  --Gets the floor layers, must be changed
  floor_layer_data = Level.raw_level.layers[1].data
  tilesets = {}
  tiles = {} 
  
  -- GET FLOOR TILE FROM LEVEL
  for k,v in pairs(Level.raw_level.tilesets) do 
    tilesets[v.firstgid] = v
  end   

  
  for k,firstgid in pairs(floor_layer_data) do
    if firstgid ~= 0 then  -- DISTINGUISHING FLOOR TILES IN THE DATA
      tile = {
        width = tilesets[firstgid].tilewidth,
        height = tilesets[firstgid].tileheight,
        image = tilesets[firstgid].image,
        -- SETS X AND Y COORDINATED FOR FLOOR TILE?
        --Since k starts on 1 we need to sub 1 to be able to start at 0
        x = ((k-1) % Level.raw_level.width) * tilesets[firstgid].tilewidth,
        y = (math.floor((k-1) / Level.raw_level.width)) * tilesets[firstgid].tileheight
      }
      table.insert(tiles, tile)
      
      
    end 
  end
  return tiles
end
