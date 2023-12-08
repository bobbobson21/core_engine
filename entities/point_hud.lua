
	local ENT = {}

function ENT.loadresources()
emitresources( "XfontX", "hudtext_font", {[1]="fonts/retro.ttf",[2]=16} )
end

function ENT.think( self )

end

function ENT.draw( self )
if self.resources == nil and mua.tableisempty( getresourcesminp() ) == false then self.resources = getresourcesminp() end
if self.resources ~= nil and self.active ~= 0 then

love.graphics.setLineWidth( 2 )
love.graphics.setColor( 0, 0, 0, 0.60 )
love.graphics.rectangle( "fill", 20, 20, 240, 37 )
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.rectangle( "line", 20, 20, 240, 37 )
love.graphics.setLineWidth( 1 )

	local playerhealthpercentage = 0.5
	
if playerloaded() == true and playerget().health ~= nil then
	playerhealthpercentage = playerget().health /playerget().maxhealth
end

love.graphics.setFont( getresources("XfontX", "hudtext_font") )
love.graphics.print( "hp: ", 30, 30 )

love.graphics.setColor( 0.5, 0, 0, 1 )
love.graphics.rectangle( "fill", 60, 30, 190, getresources("XfontX", "hudtext_font"):getHeight() )
love.graphics.setColor( 0.2, 0.8, 0.2, 1 )
love.graphics.rectangle( "fill", 60, 30, playerhealthpercentage *190, getresources("XfontX", "hudtext_font"):getHeight() )

if playerhealthpercentage ~= 1 then
	local wavestep = 0.2
	local wavespeed = 900
	local wavemaxheight = 4
for z = 1, getresources("XfontX", "hudtext_font"):getHeight() -1 do
love.graphics.setColor( 0.2, 0.8, 0.2, 1 )
love.graphics.line( 60 +(playerhealthpercentage *190), 31 +(z -1), math.min( 60+ (playerhealthpercentage *190) +math.abs( math.sin( ( emittime() *wavespeed ) +( wavestep *z ) ) *wavemaxheight ), 60+ 190 ), 31 +(z -1) )
      end
   end
end
return 3
end

emitentitytype( "point_hud", ENT )

	local ent = spawnentity( "point_hud", "hud" )
	ent.active = 0
	
