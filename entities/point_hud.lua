
	local ENT = {}

function ENT.loadresources()

end

function ENT.think( self )

end

function ENT.draw( self )
if getresourcesloaded() == true and self.active ~= 0 then

love.graphics.setLineWidth( 2 )
love.graphics.setColor( 0, 0, 0, 0.60 )
love.graphics.rectangle( "fill", 20, 20, 240, 63 )
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.rectangle( "line", 20, 20, 240, 63 )
love.graphics.setLineWidth( 1 )

end
return 3
end

emitentitytype( "point_hud", ENT )

	local ent = spawnentity( "point_hud", "hud" )
	ent.active = 0
	
