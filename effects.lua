particlesystem.emiteffect( "bg_effect", function( particlespawner, tbl )
for z = 1, math.random( 288, 488 ) do 
	
	local part = particlespawner( nil )
	
	part.renderlevel = -6
	part.lifetime = emittimeadd( math.random( 200, 800 ) )
	part.x = -100
	part.y = math.random( -100, love.graphics:getHeight() +100 )
	part.velocityx = mua.randompoint( -6, 6 )
	part.velocityy = mua.randompoint( -6, 6 )
	part.ang = math.random( 1, 360 )
	part.velocityang = math.random( 1, 360 )
	part.size = mua.randompoint( 0.20, 1 )
	part.image = resources["XimageX"]["normalparicletexture"]
	part.r = 1
	part.g = 1
	part.b = 1
	part.a = mua.randompoint( 0.80, 1 )

if math.random( 0, 1 ) == 1 then
	part.x = love.graphics.getWidth() +100
	part.y = math.random( -100, love.graphics:getHeight() +100 )
end

if math.random( 0, 1 ) == 1 then
	part.x = math.random( -100, love.graphics.getWidth() +100 )
if math.random( 0, 1 ) == 1 then
	part.y = love.graphics:getHeight()
else
	part.y = -100
   end
end

	part.active = 1

   end
end)