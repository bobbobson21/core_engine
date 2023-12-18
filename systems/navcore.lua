
	navsystem = {}

function navsystem.addblock(x, y, sx, sy)
if navsystem.blocks == nil then navsystem.blocks = {} end
	navsystem.blocks[#navsystem.blocks +1] = {x, y, sx, sy}
end
	
function navsystem.setspeedandjump(speed, jumpheight, jumphorzontal)
	navsystem.objspeed, navsystem.objjumpheight, navsystem.objjumphorzontal = speed, jumpheight, jumphorzontal
end

function navsystem.setmaxfalldist(maxfalldist)
	navsystem.objmaxfalldist = maxfalldist
end

function navsystem.setposandsize(x, y, sx, sy)
	navsystem.objx, navsystem.objy, navsystem.objsizex, navsystem.objsizey = x, y, sx, sy
end

function navsystem.setdestanation(x, y)
	navsystem.desx, navsystem.desy = x, y
end

function navsystem.setmappingsize(mappingsize, detail)
	navsystem.objmappingsize, navsystem.objmappingdetail = mappingsize, detail
end

function navsystem.getspeedandjump()
return navsystem.objspeed, navsystem.objjumpheight, navsystem.objjumphorzontal
end

function navsystem.getmaxfalldist()
return navsystem.objmaxfalldist
end

function navsystem.getposandsize()
return navsystem.objx, navsystem.objy, navsystem.objsizex, navsystem.objsizey
end

function navsystem.getdestanation()
return navsystem.desx, navsystem.desy
end

function navsystem.getmappingsize(mappingsize)
return navsystem.objmappingsize, navsystem.objmappingdetail
end

function navsystem.returnaction()
if navsystem.blocks == nil then navsystem.blocks = {} end
	
	local xdir = 0
	local deadenddetected = false
	local isdeadendgap = true
	local closetodeadend = false
	local jump = false
	local entlist = {}

for k,v in pairs( getentity( nil, nil ) ) do
if v.collideable == true then entlist[#entlist +1] = v end
end
for z = 1, #navsystem.blocks do
	entlist[#entlist +1] = {["x"]=navsystem.blocks[z][1],["y"]=navsystem.blocks[z][2],["hboxsx"]=navsystem.blocks[z][3],["hboxsy"]=navsystem.blocks[z][4]}
end

if navsystem.desx < navsystem.objx then xdir = -1 end
if navsystem.desx > navsystem.objx then xdir = 1 end

if xdir ~= 0 then
	local tempclosetodeadend = true
for k,v in pairs( entlist ) do
for z = 1, navsystem.objmappingsize /navsystem.objmappingdetail do

if mua.isboxinbox( navsystem.objx +((xdir *navsystem.objmappingdetail) *( z -1 ) ), navsystem.objy, navsystem.objmappingdetail, navsystem.objsizey /2, v.x, v.y, v.hboxsx, v.hboxsy ) == true then
	deadenddetected = true
end
if mua.isboxinbox( navsystem.objx +((xdir *navsystem.objmappingdetail) *( z -1 ) ), navsystem.objy, navsystem.objmappingdetail, navsystem.objsizey +navsystem.objmaxfalldist, v.x, v.y, v.hboxsx, v.hboxsy ) ~= true then
	isdeadendgap = false
end
if mua.isboxinbox( navsystem.objx -10, navsystem.objy, navsystem.objsizex +20, navsystem.objsizey /2, v.x, v.y, v.hboxsx, v.hboxsy ) == true then
if (v.x >= navsystem.objx +navsystem.objsizex and xdir == 1) or (v.x +v.hboxsx <= navsystem.objx and xdir == -1) then
	closetodeadend = true
   end
end

if closetodeadend ~= true then
if mua.isboxinbox( navsystem.objx -10, navsystem.objy, 10, navsystem.objsizey +navsystem.objmaxfalldist, v.x, v.y, v.hboxsx, v.hboxsy ) == true then
	tempclosetodeadend = false
end
if mua.isboxinbox( navsystem.objx -10, navsystem.objy, 10, navsystem.objsizey +navsystem.objmaxfalldist, v.x, v.y, v.hboxsx, v.hboxsy ) == true then
	tempclosetodeadend = false
   end
end
if deadenddetected == true and closetodeadend == true then break end
end
if deadenddetected == true and closetodeadend == true then break end
end
if tempclosetodeadend == true then closetodeadend = tempclosetodeadend end
end

if closetodeadend == true then return "stop" end

if navsystem.objjumpheight ~= nil and navsystem.objjumpheight >= 1 then
if (deadenddetected == true and isdeadendgap == true) or navsystem.desy +20 < navsystem.objy then
for k,v in pairs( entlist ) do
if v.collideablegroup == PLAYER_COLLIDEGROUP_UPONLY then
for z = 1, navsystem.objjumphorzontal /navsystem.objmappingdetail do
if mua.isboxinbox( navsystem.objx +((xdir *10) *( z-1 ) ), navsystem.objy -navsystem.objjumpheight, 10, navsystem.objsizey +navsystem.objjumpheight, v.x, v.y, v.hboxsx, v.hboxsy ) == true then
	jump = true
	break
      end
   end
end
if jump == true then break end
   end
end

if closetodeadend == true and isdeadendgap == true and jump ~= true then
for k,v in pairs( entlist ) do
if xdir == 1 then
if mua.isboxinbox( navsystem.objx +navsystem.objsizex +20, navsystem.objy, navsystem.objjumphorzontal, navsystem.objsizey +navsystem.objmaxfalldist, v.x, v.y, v.hboxsx, v.hboxsy ) == true then
	jump = true
   break
   end
end
if xdir == -1 then
if mua.isboxinbox( navsystem.objx -( navsystem.objjumphorzontal +20 ), navsystem.objy, navsystem.objjumphorzontal, navsystem.objsizey +navsystem.objmaxfalldist, v.x, v.y, v.hboxsx, v.hboxsy ) == true then
	jump = true
      break
      end
   end
end
if jump == false then return "stop" end
end

else

if closetodeadend == true then return "stop" end
end

	local output = ""
if xdir == -1 then output = "left" end
if xdir == 1 then output = "right" end

return output, jump
end	

