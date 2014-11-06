
--This is level loader, loads of quick fixes
--This needs to be changed to be more general overall
Level = { 
  raw_level = nil,
  version = nil
  
}
function Level.load_level (level_number)
  loaded_level = require("game/levels/level" .. level_number)
  Level.version = loaded_level.version
  Level.raw_level = loaded_level
  Level.width = loaded_level.width
end

function Level.get_floor()
  tilesets = Level.raw_level.tilesets
  --Gets the floor layers, must be changed
  floor_layer_data = Level.raw_level.layers[1].data
  floor_tileset = nil
  floors = {}
 
  -- GET FLOOR TILE FROM LEVEL
  for k,v in pairs(tilesets) do     
    if v.name == "Floor" then
      floor_tileset = tilesets[k]
    end
  end
  
  for k,v in pairs(floor_layer_data) do  
    if v == floor_tileset.firstgid then  -- DISTINGUISHING FLOOR TILES IN THE DATA     
      
      floor_tile = {
        width = floor_tileset.tilewidth,
        height = floor_tileset.tileheight,
        -- SETS X AND Y COORDINATED FOR FLOOR TILE?
        --Since k starts on 1 we need to sub 1 to be able to start at 0
        x = ((k-1) % Level.raw_level.width) * floor_tileset.tilewidth,
        y = (math.floor((k-1) / Level.raw_level.width)) * floor_tileset.tileheight
      }
      table.insert(floors, floor_tile)
      
    end 
  end
  return floors
end
