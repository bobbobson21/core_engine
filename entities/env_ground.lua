
	local ENT = {} --allows you to create a sort of ground for the player

function ENT.setposandsize( self, xa, ya, sxa, sya ) --set pos and then size in pixles
	self.x, self.y, self.sizex, self.sizey = xa, ya, sxa, sya
	self.hboxsx, self.hboxsy = sxa, sya
if self.loperforgtex ~= nil then self.loperforgtex = love.graphics.newQuad( 0, 0, self.sizex, self.sizey, self.groundtexture:getWidth(), self.groundtexture:getHeight() ) end
if self.loperforstex ~= nil then self.loperforstex = love.graphics.newQuad( 0, 0, self.sizex +1, self.surfacetexture:getHeight(), self.surfacetexture:getWidth(), self.surfacetexture:getHeight() ) end
if self.loperfordtex ~= nil then self.loperfordtex = love.graphics.newQuad( 0, 0, self.sizex -1, self.surfacetexture:getHeight(), self.surfacetexture:getWidth(), self.surfacetexture:getHeight() ) end
end

function ENT.loadresources() 
emitresources( "XimagesaddloopX", "add", {emitresources( "XimageX", "groundstone_texture", "textures/ground/ground_stone.png" ),} )
emitresources( "XimagesaddloopX", "add", {emitresources( "XimageX", "groundover_texture", "textures/ground/ground_over.png" ),} )
end

function ENT.init( self )
	self.x, self.y = 0, 0
	self.sizex, self.sizey = 0, 0
	self.collideable = true
end

function ENT.draw( self )

if getresourcesloaded() == true and self.active ~= 0 then
if self.groundtexture == nil then self.groundtexture = getresources( "XimageAloopX", "groundstone_texture" ) end
if self.surfacetexture == nil then self.surfacetexture = getresources( "XimageAloopX", "groundover_texture") end
if self.loperforgtex == nil then self.loperforgtex = love.graphics.newQuad( 0, 0, self.sizex, self.sizey, self.groundtexture:getWidth(), self.groundtexture:getHeight() ) end
if self.loperforstex == nil then self.loperforstex = love.graphics.newQuad( 0, 0, self.sizex, self.surfacetexture:getWidth(), self.surfacetexture:getWidth(), self.surfacetexture:getHeight() ) end

if emitcam() ~= nil then
	local xcc, ycc, sxcc, sycc = runentityfunction( emitcam(), "emitcamcoverage", true, {} )
if mua.isboxinbox( xcc, ycc, sxcc, sycc, self.x or 0, self.y or 0, self.sizex or 0, self.sizey or 0 ) == true or (xcc == 0 and ycc == 0 and sxcc == 0 and sycc == 0) then

love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.draw( self.groundtexture, self.loperforgtex, self.x, self.y )
love.graphics.draw( self.surfacetexture, self.loperforstex, self.x, self.y )

love.graphics.setLineWidth( 4 )
love.graphics.setColor( 0.50, 0.50, 0.50, 1 )
love.graphics.rectangle( "line", self.x +2, self.y +2, self.sizex -4, self.sizey -4 )

love.graphics.setColor( 0.20, 0.20, 0.20, 1 )
love.graphics.line( self.x +0.50, self.y +2, self.x +self.sizex -0.50, self.y +2 )
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.setLineWidth( 1 )
      
	  end
   end
end
return -4
end


emitentitytype( "env_ground", ENT )
