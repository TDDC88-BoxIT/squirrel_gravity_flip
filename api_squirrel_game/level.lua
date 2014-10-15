
--This is level loader, loads of quick fixes
--This needs to be changed to be more general overall
Level = { 
  raw_level = nil,
  version = nil
  
}
function Level.load_level (level_number)
  loaded_level = require("levels/level" .. level_number)
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
 
  for k,v in pairs(tilesets) do     
    if v.name == "Floor" then
      floor_tileset = tilesets[k]
    end
  end
  
  for k,v in pairs(floor_layer_data) do     
    --print(k .. " " .. v)
    --print(floor_tileset)
    if v == floor_tileset.firstgid then      
      floor_tile = {
        width = floor_tileset.tilewidth,
        height = floor_tileset.tileheight,
        x = (k % Level.raw_level.width) * floor_tileset.tilewidth,
        y = (math.floor(k / Level.raw_level.width)) * floor_tileset.tileheight,
        k = k
      }
      table.insert(floors, floor_tile)
    end
    --print(floor_tileset.firstgid)
    --table.foreach(floors, print) 
    
  end
  print(table.getn(floors))
  return floors
end
