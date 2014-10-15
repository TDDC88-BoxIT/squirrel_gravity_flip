
mgravity = 10
mspeed = 10
mcurx = 10
mcury = 10
startx = 10
starty = 10

function reset(curx, cury, speed)
  mcurx = x
  mcury = y
  mspeed = speed
end

function gupdate(dt)
  
end

function ggetX()
  
end

function ggetY()
  
end

function gsetSpeed()
  
end

function gsetGravity(gravity)
  mgravity = gravity
end



function CheckCollision2(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  if ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1 then
    local X={{"aleft",ax1},{"aright",ax2},{"bleft",bx1},{"bright",bx2}}
    local Y={{"abottom",ay1},{"atop",ay2},{"bbottom",by1},{"btop",by2}}
    local comp = function(a,b)
      return a[2] < b[2] 
    end
    table.sort(X, comp)
    table.sort(Y,comp)
    return X[2][1], X[3][1],Y[2][1],Y[3][1]
  end
  return nil
end