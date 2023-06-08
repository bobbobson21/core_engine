
	local ENT = {}

function ENT.setskin( self, texture )
	self.anim = nil
	self.skinquads = nil
if type( texture ) ~= "table" then
	self.skin = love.graphics.newImage( texture )
	self.optsx, self.optsy = self.skin:getWidth(), self.skin:getHeight()
if self.filter ~= nil then self.skin:setFilter( self.filter, self.filter ) end
if self.looping == true then
	self.optsx, self.optsy = self.skinquadsize["sx"], self.skinquadsize["sy"]
	self.skinquad = love.graphics.newQuad( 0, 0, self.skinquadsize["sx"], self.skinquadsize["sy"], self.skin:getWidth() *( self.sizex or 1 ), self.skin:getHeight() *( self.sizey or 1 ) )
self.skin:setWrap( "repeat", "repeat" )
end

else
	self.anim = {}
	self.skinquads = {}
for z = 1, table.maxn( texture ) do
	self.anim[z] = love.graphics.newImage( texture[z] )
if self.filter ~= nil then self.anim[z]:setFilter( self.filter, self.filter ) end
if self.looping == true then
	self.skinquads[z] = love.graphics.newQuad( 0, 0, self.skinquadsize["sx"], self.skinquadsize["sy"], self.skin:getWidth() *( self.sizex or 1 ), self.skin:getHeight() *( self.sizey or 1 ) )
self.anim[z]:setWrap( "repeat", "repeat" )
   end
end
	local frame = self.animframeontexload or 1
	self.skin = self.anim[frame]
	self.animframeontexload = nil
	self.optsx, self.optsy = self.skin:getWidth(), self.skin:getHeight()
   end
end

function ENT.setloopandsize( self, looper, sxa, sya )
if self.skin ~= nil then
	self.optsx, self.optsy = sxa, sya
if self.anim == nil then
if looper == true then
	self.skinquad = love.graphics.newQuad( 0, 0, sxa, sya, self.skin:getWidth() *( self.sizex or 1 ), self.skin:getHeight() *( self.sizey or 1 ) )
self.skin:setWrap( "repeat", "repeat" ) 
end
if looper == false then
	self.skinquad = nil
self.skin:setWrap( "clamp", "clamp" )
end
else
	self.skinquads = {}
for z = 1, table.maxn( self.anim ) do
if looper == true then
self.skinquads[z] = love.graphics.newQuad( 0, 0, sxa, sya, self.anim[z]:getWidth() *( self.sizex or 1 ), self.anim[z]:getHeight() *( self.sizey or 1 ) )
self.anim[z]:setWrap( "repeat", "repeat" ) 
end
if looper == false then
	self.skinquads = nil
self.skin:setWrap( "clamp", "clamp" )
         end
      end
   end
end
	self.skinquadsize = {["sx"]=sxa,["sy"]=sya}
	self.looping = looper
end

function ENT.setfilter( self, filterr )
if self.skin ~= nil then
if self.anim == nil then
	self.skin:setFilter( filterr, filterr )
else
for z = 1, table.maxn( self.anim ) do
	self.anim[z]:setFilter( filterr, filterr )
      end
   end
end
	self.filter = filterr
end

function ENT.setskinframeloop( self, loop, loopin )
	self.animloop = loop
	self.animloopt = loopin
end

function ENT.setskinframe( self, frame )
if self.anim ~= nil then
	self.skin = self.anim[frame]
if self.looping ~= true then self.optsx, self.optsy = self.skin:getWidth(), self.skin:getHeight() end
if self.looping == true then self.skinquad = self.skinquads[z] end
else
	self.animframeontexload = frame
   end
end

function ENT.setposandsizemul( self, xa, ya, sxa, sya )
	self.x, self.y, self.sizex, self.sizey = xa, ya, sxa, sya
if self.looping == true then self.setloopandsize( self, true, self.skinquadsize["sx"], self.skinquadsize["sy"] ) end
if self.looping ~= true and self.skin ~= nil then self.optsx, self.optsy = self.skin:getWidth(), self.skin:getHeight() end
end

function ENT.setrot( rot )
	self.rot = rot
end

function ENT.init( self )
	self.x, self.y = 0, 0
	self.setrot = ENT.setrot
	self.setskin = ENT.setskin
	self.setfilter = ENT.setfilter
	self.setskinframe = ENT.setskinframe
	self.setloopandsize = ENT.setloopandsize
	self.setposandsizemul = ENT.setposandsizemul
	self.col = {["r"]=255,["g"]=255,["b"]=255,["a"]=255}
end

function ENT.think( self )
if self.anim ~= nil then
if self.animloop ~= nil then
if self.animloopin == nil then self.animloopin = emittimeadd( self.animloopt ) end
if emittime() >= self.animloopin then
	self.animloopin = emittimeadd( self.animloopt )
if self.animcurrentframe == nil then self.animcurrentframe = 0 end
if self.animcurrentframe >= table.maxn( self.anim ) then self.animcurrentframe = 0 end
	self.animcurrentframe = self.animcurrentframe +1
	self.skin = self.anim[self.animcurrentframe]
	self.optsx, self.optsy = self.skin:getWidth(), self.skin:getHeight()
if self.looping == true then self.skinquad = self.skinquads[self.animcurrentframe] end
         end
      end
   end
end

function ENT.draw( self )
if self.active ~= 0 and self.skin ~= nil then
if emitcam() ~= nil then
	local xcc, ycc, sxcc, sycc = emitcam().emitcamcoverage( emitcam() )
if mua.isboxinbox( xcc, ycc, sxcc, sycc, self.x or 0, self.y or 0, self.optsx or 0, self.optsy or 0 ) == true then

love.graphics.setColor( self.col["r"] /255, self.col["g"] /255, self.col["b"] /255, self.col["a"] /255 )
if self.looping ~= true then love.graphics.draw( self.skin, self.x, self.y, self.rot, self.sizex, self.sizey, 0, 0 ) end
if self.looping == true and self.skinquad ~= nil then love.graphics.draw( self.skin, self.skinquad, self.x, self.y ) end
love.graphics.setColor( 1, 1, 1, 1 )

         end
      end
   end
end

emitentitytype( "env_scenery", {["loadresourcetypes"]=ENT.loadresourcetypes,["loadresources"]=ENT.loadresources,["init"]=ENT.init,["onremove"]=ENT.onremove,["think"]=ENT.think,["draw"]=ENT.draw,["mousepress"]=ENT.mousepress,["keypress"]=ENT.keypress,} )
