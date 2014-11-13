
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
function Level.load_level (level_number,game_type)
  if game_type=="tutorial" then
    loaded_level = require("map/tutorialLevel"..level_number)
  else
    loaded_level = require("map/level"..level_number)
  end
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

function get_image(tile_name)
  print (tile_name)
  if tile_name == "floor" then
    return gfx.loadpng("images/floor1.png")
    end
  if tile_name == "powerup1" then
    return gfx.loadpng("images/powerup1.png")
  end
  if tile_name == "powerup2" then
    return gfx.loadpng("images/powerup2.png")
  end
  if tile_name == "powerup3" then
    return gfx.loadpng("images/powerup3.png")
  end
  if tile_name == "powerup4" then
    return gfx.loadpng("images/powerup4.png")
  end
  if tile_name == "win" then
    return gfx.loadpng("images/powerup4.png")
  end
  
  
return gfx.loadpng("images/powerup4.png")
end

-- basic check collision - logic
function hitTest(gameCounter,tileSet, herox, heroy, hero_width, hero_height)
  for k,v in pairs(tileSet) do
    local temp1,temp2,temp3,temp4 = CheckCollision(v, v.gid, herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height)
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

-- purpose: Check Collision between two objects.
-- input: (x,y) and (width, height) of Object A.
-- input: (x,y) and (width, height) of Object B.
-- return: nil if no collision occur.
--         The collision status if collision occur.
-- example1: return value (ABottom, BTop, BLeft, ARight) means that
-- the Bottom and Left side of Object A has collision with Top and Left side of Object B
-- example2: return value (ALeft, ARight, ABottom, BTop) means that
-- Object A is stand on Object B
-- example3: return value (ALeft, ARight, BBottom, ATop) means that
-- Object A is under Object B
function CheckCollision(v, gid, ax1,ay1,aw,ah, bx1,by1,bw,bh)
  if gid == 1 then
    local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
    if ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 then
      local X={{"ALeft",ax1},{"ARight",ax2},{"BLeft",bx1},{"BRight",bx2}}
      local Y={{"ABottom",ay1},{"ATop",ay2},{"BBottom",by1},{"BTop",by2}}
      local comp = function(a,b)
        return a[2] < b[2] 
      end
      table.sort(X, comp)
      table.sort(Y,comp)
      return X[2][1], X[3][1], Y[2][1], Y[3][1], true
    end
  
  elseif gid > 1 then -- power up collision test
    local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
    if ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 and v.visibility == true then
      
      if gid == 2 then --speed boost power_up
        change_game_speed(10, 7000)
            
      end
      
      if gid == 3 then --game score adder, kinda like the coins in more old school platform game 
        game_score = game_score + 500
      end
      
      if gid == 4 then --freeze 
        change_game_speed(0, 3000)
      end
      
      if gid == 5 then
        
      end
      
      --removed the power ups from the game, making it impossible to activate them again.
      v.visibility = false
    end
  elseif (gid == 3 or gid == 5) then -- Ground- and ceiling-facing spikes.
    local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
    if ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 and v.visibility == true then
      game_score = game_score - 1000
      v.visibility = false
    end
  else
    return nil
  end
end
