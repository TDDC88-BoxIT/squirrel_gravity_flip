-- varibales list
mgravity = 10
mspeed = 100
mcurx = 10
mcury = 10
startx = 10
mstarty = 10
mtotal = 0

-- purpose: reset the current state of gravity.
function greset(cury, speed)
  mcury = y
  mspeed = speed
  mtotal = 0
end

-- purpose: change the gravity to Top.
function ToTop()
  mstarty = 0
  mtotal = 0
  mgravity = -10
end

-- purpose: change the gravity to Bottom.
function ToBottom()
  mstarty = 0
  mtotal = 0
  mgravity = 10
end

function getNewYStep(step_length)
  local newStep = mgravity
  return newStep
end

function getNewXStep(step_length)
  local newStep = step_length*mspeed
  return newStep
end

-- purpose: get current Y position.
-- input: the delta of current update.
-- return: the new Y position.
function CurveY(dt)
  mtotal = mtotal + dt
  mcury = mspeed*mtotal + mgravity * mtotal * mtotal / 2
  local dy = mcury - mstarty
  mstarty = mcury
  return dy
end

-- not used yet.
function ggetY()
  
end

-- not used yet.
function gsetSpeed()
  
end

-- set the current gravity.
function gsetGravity(gravity)
  mgravity = gravity
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
    return X[2][1], X[3][1], Y[2][1], Y[3][1]
  end
  return nil
end