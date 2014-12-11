-- LOOPS THROUGH ALL TILES AND DEPENDING ON TILE-TYPE HANDLES THEM DIFFERENTLY
local s_width = screen:get_width()
function hitTest(gameCounter,tileSet, herox, heroy, hero_width, hero_height)
--Collision detection for clouds, only calculate the columns of clouds closest to the hero 
  local x_cloud=math.floor((herox+gameCounter)/32)+1
  for i = ((x_cloud-1)*Level.raw_level.height+1), (x_cloud+1)*Level.raw_level.height, 1 do
    if Level.map_table[i] ~= nil then
      v = tiles[Level.map_table[i]]
      if v.gid == 9 then
        if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
          get_killed()
          return
        end
      end
    end
  end
  --Collision detection for flames, only calculate the rows of flames closest to the hero 
  local y_flame=math.floor((heroy/32)+1)
  local x_flame=x_cloud
  for i= ((x_flame-1)*(Level.raw_level.height)+y_flame), ((x_flame-1+s_width/32)*(Level.raw_level.height)+y_flame), (Level.raw_level.height) do
    if Level.map_table[i] ~= nil then
      v = tiles[Level.map_table[i]]
      if v.gid==10 then
        if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
          get_killed()
          return
        end
      end
    end
  end
  for i= ((x_flame-1)*(Level.raw_level.height)+y_flame+1), ((x_flame-1+s_width/32)*(Level.raw_level.height)+y_flame+1), (Level.raw_level.height) do
    if Level.map_table[i] ~= nil then
      v = tiles[Level.map_table[i]]
      if v.gid==10 then
        if CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height) ~=nil and player.invulnerable==false then
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
          table.insert(pending_redraw, ob.x)
        elseif ob.type==3  and player.invulnerable==false then -- ob.type==3  IS AN OBSTACLE TILE        
          get_killed()
          return temp1,temp2,temp3,temp4
        elseif ob.type==4  then -- ob.type==4  IS A WIN TILE
          if get_game_type() == "tutorial" and tutorial_goal_is_fulfilled()==false then
            get_killed()
            return temp1,temp2,temp3,temp4
          else
            levelwin()
            return temp1,temp2,temp3,temp4
          end
        end
      end
    end
  end
  return nil
end

function buttonTest(gameCounter,tileSet, herox, heroy, hero_width, hero_height)
  --Check the 4 tiles around the character if they have collision
  local inputSet= {}
  local x_n=math.floor((herox+gameCounter-10)/32)+1---the n'th tile in the column
  local y_n=math.floor(heroy/32)+1  -- the n'th tile in the row
  inputSet={(x_n-1)*(Level.raw_level.height)+y_n, x_n*(Level.raw_level.height)+y_n, (x_n-1)*(Level.raw_level.height)+y_n+1, x_n*(Level.raw_level.height)+y_n+1}
  for i=1, 4, 1 do
    if Level.map_table[inputSet[i]] ~=nil then
      local ob= tiles[Level.map_table[inputSet[i]]]
      local temp1,temp2,temp3,temp4 = CheckCollision(herox, heroy, hero_width, hero_height, ob.x-gameCounter+10, ob.y, ob.width, ob.height)
      if temp1 ~= nil then
        if ob.type ==1 then
          return temp1,temp2,temp3,temp4
        end
      end
    end
  end
  return nil
end

function buttonTest1(gameCounter,tileSet, herox, heroy, hero_width, hero_height, direction_flag)
  --Check the 4 tiles around the character if they have collision
  local inputSet_up= {}
  local inputSet_down= {}
  local x_n=math.floor((herox+gameCounter)/32)+1---the n'th tile in the column
  local y_n=math.floor(heroy/32)+1  -- the n'th tile in the row
  inputSet_up={(x_n-1)*(Level.raw_level.height)+y_n, x_n*(Level.raw_level.height)+y_n}
  inputSet_down={(x_n-1)*(Level.raw_level.height)+y_n+1, x_n*(Level.raw_level.height)+y_n+1}
  if direction_flag == "down" then
    for i=1, 2, 1 do
      if Level.map_table[inputSet_down[i]] ~=nil then
        local ob= tiles[Level.map_table[inputSet_down[i]]]
        local temp1,temp2,temp3,temp4 = CheckCollision(herox, heroy, hero_width, hero_height, ob.x-gameCounter, ob.y, ob.width, ob.height)
        if temp1 ~= nil then
          if ob.type ==1 then
            return temp1,temp2,temp3,temp4
          end
        end
      end
    end
  else
    for i=1, 2, 1 do
      if Level.map_table[inputSet_up[i]] ~=nil then
        local ob= tiles[Level.map_table[inputSet_up[i]]]
        local temp1,temp2,temp3,temp4 = CheckCollision(herox, heroy, hero_width, hero_height, ob.x-gameCounter, ob.y, ob.width, ob.height)
        if temp1 ~= nil then
          if ob.type ==1 then
            return temp1,temp2,temp3,temp4
          end
        end
      end
    end
  end
  return nil
end

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
    local B_L=bx1
    local B_R=bx2
    local B_T=by1
    local B_B=by2
    return B_L, B_R, B_T, B_B
  end
  return nil
end

