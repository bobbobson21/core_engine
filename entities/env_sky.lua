
	local ENT = {}

function ENT.resetclouds( self ) --chages the sky background
	self.clouds = {}
	self.cloudsort = 0
	self.cloudsuncliped = false
for z = 1, 48 do self.clouds[z] = {["x"]=math.random( -( love.graphics.getWidth() /2 ), love.graphics.getWidth() *2 ),["y"]=math.random( -20, 400 ),["sx"]=math.random( 20, love.graphics.getWidth() /8 )} end
for z = 1, 48 do self.clouds[z]["sy"] = math.random( 20, math.min( 80, self.clouds[z]["sx"] ) ) end
end

function ENT.init( self )
	self.clouds = {}

for z = 1, 48 do self.clouds[z] = {["x"]=math.random( -( love.graphics.getWidth() /2 ), love.graphics.getWidth() *2 ),["y"]=math.random( -20, 400 ),["sx"]=math.random( 80, love.graphics.getWidth() /6 )} end
for z = 1, 48 do self.clouds[z]["sy"] = math.random( 20, math.min( 80, self.clouds[z]["sx"] ) ) end

	self.skyprinted = true
end

function ENT.think( self )
if self.skyprinted == true then

for z = 1, table.maxn( self.clouds ) do
	self.clouds[z]["x"] = self.clouds[z]["x"] -1 --moves clouds
if self.clouds[z]["x"] <= -( love.graphics.getWidth() /2 ) then --loops sky
	self.clouds[z]["x"] = love.graphics.getWidth() *2
      end
   end
end

if self.cloudsuncliped ~= true then --makes the clouds evenly spreed
if self.cloudsort == nil then self.cloudsort = 0 end
	self.cloudsort = self.cloudsort +1

	local cloudszcliping = false
for z = 1, table.maxn( self.clouds ) do
for y = 1, table.maxn( self.clouds ) do
if z ~= y then
if mua.isboxinbox( self.clouds[z]["x"] -2, self.clouds[z]["y"] -2, self.clouds[z]["sx"] +4, self.clouds[z]["sy"] +4, self.clouds[y]["x"] -2, self.clouds[y]["y"] -2, self.clouds[y]["sx"] +4, self.clouds[y]["sy"] +4 ) == true then
	
	self.clouds[z] = {["x"]=math.random( -love.graphics.getWidth() /2, love.graphics.getWidth() *2 ),["y"]=math.random( -20, 400 ),["sx"]=math.random( 80, love.graphics.getWidth() /6 ),["sy"]=math.random( 20, math.min( 80, self.clouds[z]["sx"] ) )}
	cloudszcliping = true
         
		 end
      end
   end
end

if cloudszcliping ~= true then if self.cloudsort >= love.graphics.getWidth() *2.20 or self.cloudsort <= -( love.graphics.getWidth() *2.20 ) then self.cloudsuncliped = true end end
   end
end

function ENT.draw( self )
if self.resources == nil and mua.tableisempty( getresources( "XimageAloopX" ) ) == false then self.resources = getresources( "XimageAloopX" ) end
if self.resources ~= nil and self.active ~= 0 then

love.graphics.setLineWidth( 6 )
love.graphics.setBackgroundColor( 0, 180 /255, 1, 1 )

if self.skyprinted == true then
for z = 1, table.maxn( self.clouds ) do
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.rectangle( "fill", self.clouds[z]["x"] +3, self.clouds[z]["y"], self.clouds[z]["sx"], self.clouds[z]["sy"] )
love.graphics.setColor( 0.70, 0.90, 0.90, 1 )
love.graphics.line ( self.clouds[z]["x"] +6, self.clouds[z]["y"] +0.50, self.clouds[z]["x"] +6, self.clouds[z]["y"] +self.clouds[z]["sy"] -0.50 )
love.graphics.line ( self.clouds[z]["x"] +3.50, self.clouds[z]["y"] +self.clouds[z]["sy"] -2, self.clouds[z]["x"] +self.clouds[z]["sx"] +3, self.clouds[z]["y"] +self.clouds[z]["sy"] -2 )
   end
end

love.graphics.setLineWidth( 1 )
love.graphics.setColor( 1, 1, 1, 1 )

end
return -7
end

emitentitytype( "env_sky", {ENT} )

	local ent = spawnentity( "env_sky", "sky" )
	
