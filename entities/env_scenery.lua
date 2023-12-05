
	local ENT = {} --renders just images

function ENT.setskin( self, texture ) --sets the texture also put in a table of textures if you wish for an animation
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

function ENT.setloopandsize( self, looper, sxa, sya ) --sets the size of the ent and it also makes it repeat it it is made to repeat
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

function ENT.setfilter( self, filterr ) --sets filter
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

function ENT.setskinframeloop( self, loop, loopin ) --should animate and set time between frames  
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

function ENT.setposandsizemul( self, xa, ya, sxa, sya ) --sets pos and size muiltyplyer example: {sxa *IMAGE_SIZE_X, sya *IMAGE_SIZE_Y}
	self.x, self.y, self.sizex, self.sizey = xa, ya, sxa, sya
if self.looping == true then self.setloopandsize( self, true, self.skinquadsize["sx"], self.skinquadsize["sy"] ) end
if self.looping ~= true and self.skin ~= nil then self.optsx, self.optsy = self.skin:getWidth(), self.skin:getHeight() end
end

function ENT.setrot( rot ) --rotation
	self.rot = rot
end

function setcolor( col ) --tint image to white like so: {["r"]=255,["g"]=255,["b"]=255,["a"]=255}
	self.col = col
end

function ENT.init( self )
	self.x, self.y = 0, 0
	self.col = {["r"]=255,["g"]=255,["b"]=255,["a"]=255} --color
end

function ENT.think( self ) --dose animation stuff
if self.anim ~= nil then
if self.animloop == true then
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
	local xcc, ycc, sxcc, sycc = runentityfunction( emitcam(), "emitcamcoverage", true, {} )
if mua.isboxinbox( xcc, ycc, sxcc, sycc, self.x or 0, self.y or 0, self.sizex or 0, self.sizey or 0 ) == true or (xcc == 0 and ycc == 0 and sxcc == 0 and sycc == 0) then

love.graphics.setColor( self.col["r"] /255, self.col["g"] /255, self.col["b"] /255, self.col["a"] /255 )
if self.looping ~= true then love.graphics.draw( self.skin, self.x, self.y, self.rot, self.sizex, self.sizey, 0, 0 ) end
if self.looping == true and self.skinquad ~= nil then love.graphics.draw( self.skin, self.skinquad, self.x, self.y ) end
love.graphics.setColor( 1, 1, 1, 1 )

         end
      end
   end
end

emitentitytype( "env_scenery", ENT )
