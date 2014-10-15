
mgravity = 10
mspeed = 200
mcurx = 10
mcury = 10
startx = 10
mstarty = 10
mtotal = 0

function greset(cury, speed)
  mcury = y
  mspeed = speed
  mtotal = 0
end

function CurveY(dt)
  mtotal = mtotal + dt
  mcury = mspeed*mtotal + mgravity * mtotal * mtotal / 2
  local dy = mcury - mstarty
  mstarty = mcury
  return dy
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
    local X={{"ALeft",ax1},{"ARight",ax2},{"BLeft",bx1},{"BRight",bx2}}
    local Y={{"ABottom",ay1},{"ATop",ay2},{"BBottom",by1},{"BTop",by2}}
    local comp = function(a,b)
      return a[2] < b[2] 
    end
    table.sort(X, comp)
    table.sort(Y,comp)
    return X[2][1], X[3][1],Y[2][1],Y[3][1]
  end
  return nil
end