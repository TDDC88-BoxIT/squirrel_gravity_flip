-- LOOPS THROUGH ALL TILES AND DEPENDING ON TILE-TYPE HANDLES THEM DIFFERENTLY
--Rebuild the hitTest, narrow the travel range to 4 tiles

function hitTest(gameCounter,tileSet, herox, heroy, hero_width, hero_height, tileset_start, tileset_end)
  local s_width = screen:get_width()
--Collision detection for flames, only canculate the columns of flames which close to the hero 
  local x_cloud=math.floor((herox+gameCounter)/32)+1
  for i = ((x_cloud-1)*Level.raw_level.height+1), (x_cloud+1)*Level.raw_level.height, 1 do
    if Level.map_table[i] ~= nil then
      v = tiles[Level.map_table[i]]
      if v.gid == 9 then
        if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
          print("Death caused by hitting Cloud")
          get_killed()
          return
        end
      end
    end
  end
  --Collision detection for flames, only canculate the rows of flames which close to the hero 
  local y_flame=math.floor((heroy/32)+1)
  for i = y_flame, ((Level.raw_level.width-1)*(Level.raw_level.height)+y_flame), (Level.raw_level.height) do
    if Level.map_table[i] ~= nil then
      v = tiles[Level.map_table[i]]
      if v.gid==10 and v.x-gameCounter+v.width>0 and v.x-gameCounter<s_width then
        if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
          print("Death caused by hitting Flame")
          get_killed()
          return
        end
      end
    end
  end
  for i = y_flame+1, ((Level.raw_level.width-1)*(Level.raw_level.height)+y_flame+1), (Level.raw_level.height) do
    if Level.map_table[i] ~= nil then
      v = tiles[Level.map_table[i]]
      if v.gid==10 and v.x-gameCounter+v.width>0 and v.x-gameCounter<s_width then
        if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
          print("Death caused by hitting Flame")
          get_killed()
          return
        end
      end
    end
  end
   --Check the 4 tiles around the character if they have collision
  local inputSet= {}
  local x_n=math.floor((herox+gameCounter)/32)+1---the n'th tile in the column
  local y_n=math.floor(heroy/32)+1  -- the n'th tile in the row
  inputSet={(x_n-1)*(Level.raw_level.height)+y_n, x_n*(Level.raw_level.height)+y_n, (x_n-1)*(Level.raw_level.height)+y_n+1, x_n*(Level.raw_level.height)+y_n+1}
  for i=1, 4, 1 do
    if Level.map_table[inputSet[i]] ~=nil then
      local ob= tiles[Level.map_table[inputSet[i]]]
      local temp1,temp2,temp3,temp4 = CheckCollision(herox, heroy, hero_width, hero_height, ob.x-gameCounter, ob.y, ob.width, ob.height)
      if temp1 ~= nil then
        if ob.type==1 then -- ob.type==1  IS A FLOOR TILE
          return temp1,temp2,temp3,temp4
        elseif ob.type==2  and ob.visibility == true then -- ob.type==2  IS A POWERUP TILE
          activate_power_up(ob.name)
          ob.visibility = false
        elseif ob.type==3  and player.invulnerable==false then -- ob.type==3  IS AN OBSTACLE TILE        
          print("Death caused by hitting obstacle")
          get_killed()
          return temp1,temp2,temp3,temp4
        elseif ob.type==4  then -- ob.type==4  IS A WIN TILE
          if get_game_type() == "tutorial" and tutorial_goal_is_fulfilled()==false then
            get_killed()
            return temp1,temp2,temp3,temp4
          else
            levelwin()
            break
          end
        end
      end
    end
  end
  return nil
end

--[[function hitTest(gameCounter,tileSet, herox, heroy, hero_width, hero_height, tileset_start, tileset_end)
  local w = screen:get_width()
  for k = tileset_start, tileset_end, 1 do
    v = tileSet[k]
    if v.x-gameCounter+v.width>0 and v.visibility==true and v.x-gameCounter<w then
      --print("old_x= "..v.x-gameCounter.." : old_y= "..v.y)
      local temp1,temp2,temp3,temp4 = CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height)
      if temp1 ~= nil then
        --print("old collision function")
        --print("x="..v.x.." :y="..v.y)
        if v.type==1 then -- v.type==1  IS A FLOOR TILE
          return temp1,temp2,temp3,temp4
        elseif v.type==2  and v.visibility == true then -- v.type==2  IS A POWERUP TILE
          activate_power_up(v.name)
          v.visibility = false
        elseif v.type==3  and player.invulnerable==false then -- v.type==3  IS AN OBSTACLE TILE        
          print("Death caused by hitting obstacle")
          get_killed()
        elseif v.type==4  then -- v.type==4  IS A WIN TILE
          if get_game_type() == "tutorial" and tutorial_goal_is_fulfilled()==false then
            get_killed()
          else
            levelwin()
          end
        end
      end
    end
  end
  return nil
end]]
  --[[for k,v in pairs(CloudSet) do   
    if v.x-gameCounter+v.width>0 and v.visibility==true and v.x-gameCounter<s_width then
      print("hero_x= "..herox)
      print("hero_y= "..heroy)
      print("old_function_x= "..v.x+gameCounter)
      print("old_function_y= "..v.y)
      print("------------------------")
      if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
        print("Death caused by hitting Cloud")
        get_killed()
        return
      end
    end
  end]]
  --[[  for k,v in pairs(FlameSet) do
    if v.x-gameCounter+v.width>0 and v.visibility==true and v.x-gameCounter<s_width then
      print("hero_x= "..herox)
      print("hero_y= "..heroy)
      print("old_function_x= "..v.x+gameCounter)
      print("old_function_y= "..v.y)
      print("------------------------")
      if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
        print("Death caused by hitting Flame")
        get_killed()
        return
      end
    end
  end]]
-- purpose: Check Collision between two objects.
-- input: (x,y) and (width, height) of Object A.
-- input: (x,y) and (width, height) of Object B.
-- return: nil if no collision occur.
--         The collision status if collision occur.
-- example1: return value (ABottom, BTop, BLeft, ARight) means that
-- the Bottom and right side of Object A has collision with Top and Left side of Object B
-- example2: return value (ALeft, ARight, ABottom, BTop) means that
-- Object A is stand on Object B
-- example3: return value (ALeft, ARight, BBottom, ATop) means that
-- Object A is under Object B
function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  if ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 then
    local X={{"ALeft",ax1},{"ARight",ax2},{"BLeft",bx1},{"BRight",bx2}}
    local Y={{"ATop",ay1},{"ABottom",ay2},{"BTop",by1},{"BBottom",by2}}
    local B_T=Y[3][2]
    local B_B=Y[4][2]
    local comp = function(a,b)
      return a[2] < b[2] 
    end
    table.sort(X, comp)
    table.sort(Y,comp)
    local W=X[3][2]-X[2][2]
    local H=Y[3][2]-Y[2][2]
    return W,H,B_T,B_B
  end
  return nil
end

