
	local ENT = {}
	
function emitcam() return getentity( "obj_motioncamera", "cam" ) end

function ENT.screenshakerandom( self, shaketime, shakeamout, minx, miny, maxx, maxy )
	self.runscreenshakerandom = true
	self.screenshakerandomtime = math.floor( (shaketime /shakeamout) +0.50 )
	self.screenshakerandomamount = shakeamout
	self.screenshakerandomminx = minx
	self.screenshakerandomminy = miny
	self.screenshakerandommaxx = maxx
	self.screenshakerandommaxy = maxy
end

function ENT.screenshakepunch( self, shakespeed, x, y  )
	self.runscreenshakepunch = true
	self.screenshakepunchspeed = shakespeed
	self.screenshakex = x
	self.screenshakey = y
end

function ENT.setcammotion( self, camman, x, y, ox, oy ) --set the entity the camera should be attached to ie the player
	self.xsys, self.ysys, self.offsetx, self.offsety, self.cament = x, y, ox, oy, camman
	self.x = self.cament[self.xsys] +self.offsetx
	self.y = self.cament[self.ysys] +self.offsety
end

function ENT.setgravitymotion( self, gravatate, gravitylevelx, gravitylevely, snapradius )
	self.gravitymotion = gravatate
	self.gravityamountx = gravitylevelx
	self.gravityamounty = gravitylevely
	self.gravitysnapradius = snapradius
end

function ENT.getgravitymotion( self )
return self.gravitymotion, self.gravityamount, self.maxgravityamount
end

function ENT.setcamboarders( self, minx, miny, maxx, maxy ) --creates a box extended from 0,0 which the camera can't leave 
	self.mincamx, self.mincamy, self.maxcamx, self.maxcamy = minx, miny, maxx, maxy
end

function ENT.emitcampos( self ) --returns the camera posistion
if self.cament ~= nil then
	local x = self.x +self.screenshakex
	local y = self.y +self.screenshakey
if x >= self.maxcamx then x = self.maxcamx end
if y >= self.maxcamy then y = self.maxcamy end
if x <= self.mincamx then x = self.mincamx end
if y <= self.mincamy then y = self.mincamy end
if self.lockcamx ~= nil then x = self.lockcamx end
if self.lockcamy ~= nil then y = self.lockcamy end
	x = math.floor( x + 0.5 )
	y = math.floor( y + 0.5 )
   return -( x ) +( love.graphics.getWidth() /2 ) or 0, -( y ) +( love.graphics.getHeight() /2 ) or 0
   end
return 0, 0
end

function ENT.emitcamcoverage( self ) --returns the dimentions of a box which coveres the entire view area
if self.cament ~= nil then
	local x = self.x +self.screenshakex
	local y = self.y +self.screenshakey
if x >= self.maxcamx then x = self.maxcamx end
if y >= self.maxcamy then y = self.maxcamy end
if x <= self.mincamx then x = self.mincamx end
if y <= self.mincamy then y = self.mincamy end
if self.lockcamx ~= nil then x = self.lockcamx end
if self.lockcamy ~= nil then y = self.lockcamy end
	x = math.floor( x + 0.5 )
	y = math.floor( y + 0.5 )
   return x -( love.graphics.getWidth() /2 ) or 0, y -( love.graphics.getHeight() /2 ) or 0, love.graphics.getWidth() or 0, love.graphics.getHeight() or 0
   end
return 0,0,0,0
end

function ENT.removefromcam( self ) --use this to fix the rendering of something onto the screen ie use to make hud elements
if self.cament ~= nil then
	local x = self.x +self.screenshakex
	local y = self.y +self.screenshakey
if x >= self.maxcamx then x = self.maxcamx end
if y >= self.maxcamy then y = self.maxcamy end
if x <= self.mincamx then x = self.mincamx end
if y <= self.mincamy then y = self.mincamy end
if self.lockcamx ~= nil then x = self.lockcamx end
if self.lockcamy ~= nil then y = self.lockcamy end
	x = math.floor( x + 0.5 )
	y = math.floor( y + 0.5 )
love.graphics.translate( -( -( x ) +( love.graphics.getWidth() /2 ) ), -( -( y ) +( love.graphics.getHeight() /2 ) ) )
   
   end
end

function ENT.addtocam( self ) --use this to undo removefromcam changes AND YOU SHUOULD ALWAYS USE IT IF YOU ARE GOING TO USE removefromcam
if self.cament ~= nil then
	local x = self.x +self.screenshakex
	local y = self.y +self.screenshakey
if x >= self.maxcamx then x = self.maxcamx end
if y >= self.maxcamy then y = self.maxcamy end
if x <= self.mincamx then x = self.mincamx end
if y <= self.mincamy then y = self.mincamy end
if self.lockcamx ~= nil then x = self.lockcamx end
if self.lockcamy ~= nil then y = self.lockcamy end
	x = math.floor( x + 0.5 )
	y = math.floor( y + 0.5 )
love.graphics.translate( -( x ) +( love.graphics.getWidth() /2 ), -( y ) +( love.graphics.getHeight() /2 ) )
   end
end

function ENT.init( self )
	self.maxcamx = 9000
	self.maxcamy = 9000
	self.mincamx = -9000
	self.mincamy = -9000
	self.offsetx = 0
	self.offsety = 0
	self.ysys = "y"
	self.xsys = "x"
	self.iscam = true
	self.lastdrawin = emittimeadd( 20 )
	self.mindepth = -7
	self.maxdepth = 2
	self.x = 0
	self.y = 0
	self.screenshakex = 0
	self.screenshakey = 0
end

function ENT.think( self )

if self.runscreenshakerandom == true then
if self.screenshakerandomcurrenttime == nil then self.screenshakerandomcurrenttime = emittimeadd( self.screenshakerandomtime ) end
if emittime() >= self.screenshakerandomcurrenttime then
	self.screenshakerandomcurrenttime = emittimeadd( self.screenshakerandomtime )
	self.screenshakex = math.random( self.screenshakerandomminx, self.screenshakerandommaxx )
	self.screenshakey = math.random( self.screenshakerandomminx, self.screenshakerandommaxx )
	self.screenshakerandomamount = self.screenshakerandomamount -1
if self.screenshakerandomamount <= 0 then
	self.runscreenshakerandom = nil
	self.screenshakepunchx = 0
	self.screenshakepunchy = 0
      end
   end
end

if self.runscreenshakepunch == true then
	
if self.screenshakex > 0 then self.screenshakex = math.max( self.screenshakex -self.screenshakepunchspeed, 0 ) end
if self.screenshakex < 0 then self.screenshakex = math.min( self.screenshakex +self.screenshakepunchspeed, 0 ) end
if self.screenshakey > 0 then self.screenshakey = math.max( self.screenshakey -self.screenshakepunchspeed, 0 ) end
if self.screenshakey < 0 then self.screenshakey = math.min( self.screenshakey +self.screenshakepunchspeed, 0 ) end

if self.screenshakepunchx == 0 and self.screenshakepunchy == 0 then
	self.runscreenshakepunch = nil
	self.screenshakex = 0
	self.screenshakey = 0
   end
end	
	
if self.cament ~= nil then
if self.gravitymotion == true then
	local cex = self.cament[self.xsys] +self.offsetx
	local cey = self.cament[self.ysys] +self.offsety
	
if math.abs( self.x -cex ) <= self.gravitysnapradius then
	self.x = cex
else
if self.x < cex then self.x = self.x +self.gravityamountx end
if self.x > cex then self.x = self.x -self.gravityamountx end
end

if math.abs( self.y -cey ) <= self.gravitysnapradius then
	self.y = cey
else
if self.y < cey then self.y = self.y +self.gravityamounty end
if self.y > cey then self.y = self.y -self.gravityamounty end
end

else
	self.x = self.cament[self.xsys] +self.offsetx
	self.y = self.cament[self.ysys] +self.offsety
   end
end

if self.cament ~= nil then self.cament = getentity( self.cament ) end
if self.renderlevel ~= self.mindepth then self.renderlevel = self.mindepth end

if self.lastdrawin ~= nil then
if emittime() >= self.lastdrawin then
	self.lastdrawin = nil
emithook( "draw", "point_motioncamera-end"..tostring( emitentitytypeinfo( self )["identifyer"] ), function( renderlevel )
if renderlevel ~= self.maxdepth then return end
runentitiesmainfuncs( "removefromcam", true, nil, function( self ) if self.iscam ~= true then return false end end)
         end)
      end
   end
end

function ENT.draw( self )
runentityfunction( self, "addtocam", true, {} )
end


emitentitytype( "obj_motioncamera", ENT )

	local ent = spawnentity( "obj_motioncamera", "cam" )
