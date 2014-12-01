-- LOOPS THROUGH ALL TILES AND DEPENDING ON TILE-TYPE HANDLES THEM DIFFERENTLY
--Rebuild the hitTest, narrow the travel range to 4 tiles

-- REMOVED TO DUE TO TESTING 
-- local s_width = screen:get_width()
function hitTest(gameCounter,tileSet, herox, heroy, hero_width, hero_height, tileset_start, tileset_end)
  --Collision detection for cloud and flame since they don't have fixed position compare to other tiles
  for k,v in pairs(SpSet) do
    if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil then
      print("Death caused by hitting Cloud or Flame")
      get_killed()
    end
  end
  --Check the 4 tiles around the character if they have collision
  local inputSet= {}
  local x_n=math.floor((herox+gameCounter)/32)+1---the n'th tile in the column
  local y_n=math.floor(heroy/32)+1  -- the n'th tile in the row 
  inputSet={(x_n-1)*22+y_n, x_n*22+y_n, (x_n-1)*22+y_n+1, x_n*22+y_n+1}
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
        elseif ob.type==4  then -- ob.type==4  IS A WIN TILE
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
end


--[[function hitTest_old(gameCounter,tileSet, herox, heroy, hero_width, hero_height, tileset_start, tileset_end)
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
    --return X[2][1], X[3][1], Y[2][1], Y[3][1]
  end
  return nil
end

