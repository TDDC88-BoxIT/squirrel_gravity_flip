-- LOOPS THROUGH ALL TILES AND DEPENDING ON TILE-TYPE HANDLES THEM DIFFERENTLY
function hitTest(gameCounter,tileSet, herox, heroy, hero_width, hero_height)
  for k,v in pairs(tileSet) do
    local temp1,temp2,temp3,temp4 = CheckCollision(herox, heroy, hero_width, hero_height, v.x-gameCounter, v.y, v.width, v.height)
    if temp1 ~= nil then
      if string.sub(v.name,1,5)=="floor" then -- gid==1 IS A FLOOR TILE
        return temp1,temp2,temp3,temp4   
      elseif string.sub(v.name,1,3)=="pow" and v.visibility == true then
        activate_power_up(v.name)
        v.visibility = false
      elseif string.sub(v.name,1,3)=="obs" then
        print("Death caused by hitting obstacle")
        if player.invulnerable==false then
          get_killed()
        end
      elseif v.name=="win" then
        levelwin()
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


    --return "hit"
  end
  return nil
end

