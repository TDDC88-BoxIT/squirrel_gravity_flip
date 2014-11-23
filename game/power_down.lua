--Set the hero has a certain hp, reduce the hp when he get hurt.(accoding to the concept of hit to the obstacles with spikes

require "physic"
require "level"
hero_hp=10;

function spikeAndBomb(hero_hp,gameCounter,tileSet, herox, heroy, hero_width, hero_height)
  for k, v in pairs(tileSet) do
    local temp1,temp2,temp3,temp4=CheckCollision2(herox,heroy,hero_width,hero_height,v.x-gameCounter, v.y, v.width, v.height)
    --git==3 is bomb, 4 is spikes, when it is spikes,check the hero whether above/under obstacles
    if git==3 or (gid==4 and temp1==herox and temp2==(herox+hero_width)) then
      --hero_hp--
      hero_hp=0
      return hero_hp
    end
  end
end
 
 

 function fire_ball()
  
end
