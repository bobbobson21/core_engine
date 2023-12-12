
	local ENT = {}

function playerloaded() return false end --has the player been spawned
function playergetrespawnpoint() return 0, 0 end --re spawn point 
function playergetcontroles() return {["left"]="left",["right"]="right",["jump"]="space",["attack"]=1,["use"]="e"} end --player controles
function playersetcontroles( val ) function playergetcontroles() return val end end --sets the player controls
function playersetrespawnpoint( x, y ) function playergetrespawnpoint() return x, y end end --sets a respawn point 

PLAYER_COLLIDEGROUP_UPHEAVY = function( self, ent, side ) --makes the game more likely to react to a collision with an up motion which is good for parkore
if self.y +( self.hboxsy /2 ) > ent.y and side == "up" then return false end
if self.y +( self.hboxsy /2 ) <= ent.y and side ~= "up" then return false end
end

PLAYER_COLLIDEGROUP_UPONLY = function( self, ent, side ) --makes the player only collide with the top of a serface
if side ~= "up" then return false end
end

function playerdespawn() --despawns player
if playerloaded() == true then
getentity( "obj_player", "player" ).active = 0
removeentity( "obj_player", "player" )
playersetrespawnpoint( x, y )
   end
end

function playerspawn( x, y, dontdoextra ) --respawns them 
if playerloaded() == false then
	local ent = spawnentity( "obj_player", "player" )
	ent.x = x
	ent.y = y
ENT.dospawnstuff( ent, x, y )
return ent
end
if playerloaded() == true then
	local ent = getentity( "obj_player", "player" )
	ent.x = x
	ent.y = y
ent.dospawnstuff( ent, x, y )
   return ent
   end
end

function playerget()
if playerloaded() == true then
return getentity( "obj_player", "player" )
   end
end

function ENT.dospawnstuff( self, x, y )
	self.jumplastfor = 0 --player can't mid air jump
	self.jumpdir = 0
	self.injump = false
	self.jumpland = nil
	self.jumplandpullforce = nil
	getentity( "point_mainmenu", "mainmenu" ).darkness = 255 --we use main menu dake fade to make it seem more like a natural transition
end

function ENT.buttonpress( self, presstype, button ) --detect player trying to use entity use
if levels.getfreeze() ~= true then
if button == playergetcontroles()["use"] and self.blockinput ~= true then
	local allowuse = runhook( "player.allowuse", {self} )
	local masteruse = true
for z = 1, table.maxn( allowuse ) do if masteruse ~= false and allowuse[z] == false then masteruse = false end end
if masteruse ~= false then
	
for k,v in pairs( getentity( nil, nil ) ) do
if v.useable == true then --useable entities also must have self.useable = true in init function
if mua.distance( self.x +( self.sizex /2 ), self.y +( self.sizey /2 ), v.x +v.usepointoffsetx, v.y +v.usepointoffsety ) <= 60 then
runhook( "player.use", {v, self} )
runentityfunction( v, "use", true, {self} ) --use is a function you can put in any entity if if it has it, it will be used
break

                  end
               end
            end
         end
      end
   end
end

function ENT.loadresources()
soundsystem.emitgroup( "entmoveing_sound", {
emitresources( "XnewsoundX", "entmoveing_sound1", {[1]="sounds/ent/ent_moveing1.wav",[2]="static"} ),
emitresources( "XnewsoundX", "entmoveing_sound2", {[1]="sounds/ent/ent_moveing2.wav",[2]="static"} ),
emitresources( "XnewsoundX", "entmoveing_sound3", {[1]="sounds/ent/ent_moveing3.wav",[2]="static"} ),
emitresources( "XnewsoundX", "entmoveing_sound4", {[1]="sounds/ent/ent_moveing4.wav",[2]="static"} ),
})
soundsystem.emitgroup( "playerjump_sound", {
emitresources( "XnewsoundX", "playerjump_sound1", {[1]="sounds/player/player_jump1.wav",[2]="static"} ),
emitresources( "XnewsoundX", "playerjump_sound2", {[1]="sounds/player/player_jump2.wav",[2]="static"} ),
})
end

function ENT.init( self )
	self.x, self.y = 0, 0
	self.sizex, self.sizey = 40, 40
	self.hboxsx, self.hboxsy = 40, 40
function playerloaded() return true end
end

function ENT.onremove( self )
function playerloaded() return false end
end

function ENT.think( self )
if self.active ~= 0 then
	local controles = playergetcontroles()
	
if emitcam ~= nil and self.attachedcam ~= true then	
runentityfunction( emitcam(), "setcammotion", true, {getentity( self ), "x", "y", 20, -100} ) --attches a camera to the player as soon as a camera is loaded
	self.attachedcam = true
end

if mua.controlemaster( controles["attack"] ) == true then --can the player attcak
for k,v in pairs( getentity( nil, nil ) ) do
if v.health ~= nil and v.health >= 0 and v ~= self then
if mua.distance( self.x +( self.sizex /2 ), self.y +( self.sizey /2 ), v.x +( v.sizex /2 ), v.y +( v.sizey /2 ) ) <= 400 then
	v.health = math.max( v.health -10, 0 )
if v.damagereaction ~= nil then v.damagereaction( v, self ) end
         end
      end
   end
end

if ( self.blockinput ~= true ) and ( mua.controlemaster( controles["left"] ) == true or mua.controlemaster( controles["right"] ) == true ) then --dose sound for walking
if self.domovesoundin == nil then self.domovesoundin = emittimeadd( 8 ) end
if self.lastgravity ~= true and self.injump ~= true and self.jumpland ~= true then
if emittime() >= self.domovesoundin then
	self.domovesoundin = emittimeadd( 8 )
if self.lastgrav ~= true then soundsystem.playsound( soundsystem.getgroup( "entmoveing_sound" ), 0 ) end
if self.dotimerecoarding == true then self.recmovesound = true end
      end
   end
end

if mua.controlemaster( controles["right"] ) == true and self.blockinput ~= true then --walk right
if self.injump ~= true and self.jumpland ~= true then
	self.x = self.x +4
   end
end

if mua.controlemaster( controles["left"] ) == true and self.blockinput ~= true then --walk left
if self.injump ~= true and self.jumpland ~= true then
	self.x = self.x -4
   end
end

	local gravity = true
	self.hboxx, self.hboxy = self.x, self.y
for k,v in pairs( getentity( nil, nil ) ) do --all collision nonsence and no I wont go thougth it trust me you want to know how it works
if v.collideable == true and v.active ~= 0 then
if mua.isboxinbox( self.hboxx, self.hboxy, self.hboxsx, self.hboxsy, v.x, v.y -1, v.hboxsx, 3 ) == true then
if ( v.collideablegroup == nil and self.y +( self.hboxsy /2 ) <= v.y ) or ( v.collideablegroup ~= nil and v.collideablegroup( self, v, "up" ) ~= false ) then
if self.y +self.hboxsy > v.y then self.y = v.y -( self.hboxsy ) end
	gravity = false
   end
end

	local jumpmover = 0

if self.injump == true or self.jumpland ~= nil then
if self.blockinput ~= true and mua.controlemaster( controles["left"] ) == true or mua.controlemaster( controles["right"] ) == true then self.jumpmoveractive = true end
if gravity == true and self.jumpmoveractive == true then
	jumpmover = 5
   end
else
	self.jumpmoveractive = false
end


if mua.isboxinbox( self.hboxx, self.hboxy, self.hboxsx, self.hboxsy, v.x -jumpmover, v.y +( self.hboxsy /4 ), ( v.hboxsx /2 ), v.hboxsy -( self.hboxsy /4 ) ) == true then
if v.collideablegroup == nil or ( v.collideablegroup ~= nil and v.collideablegroup( self, v, "left" ) ~= false ) then
	self.x = v.x -( self.hboxsx +jumpmover )
   end
end

if mua.isboxinbox( self.hboxx, self.hboxy, self.hboxsx, self.hboxsy, v.x +( ( v.hboxsx /2 ) +jumpmover ), v.y +( self.hboxsy /4 ), ( v.hboxsx /2 ), v.hboxsy -( self.hboxsy /4 ) ) == true then
if v.collideablegroup == nil or ( v.collideablegroup ~= nil and v.collideablegroup( self, v, "right" ) ~= false ) then
	self.x = v.x +( v.hboxsx +jumpmover )
   end
end

if mua.isboxinbox( self.hboxx, self.hboxy, self.hboxsx, self.hboxsy, v.x +( self.hboxsx /2 ), v.y +self.hboxsy, v.hboxsx -( self.hboxsx *2 ), v.hboxsy -( self.hboxsx *4 ) ) == true then
if v.collideablegroup == nil or ( v.collideablegroup ~= nil and v.collideablegroup( self, v, "xfix" ) ~= false ) then
if self.x >= v.x +( self.hboxsx /2 ) then
	self.x = v.x +( v.hboxsx +jumpmover +self.hboxsx )
else
	self.x = v.x -( self.hboxsx +jumpmover +self.hboxsx )
            end
         end
      end
   end
end

if gravity == true then self.y = self.y +6 end --gravity also not gravity can sometimes be turnded off temporaliy

if self.injump ~= true and gravity ~= true then --jumping physics
if mua.controlemaster( controles["jump"] ) == true and self.blockinput ~= true then
if self.jumpmoveractive == true then self.jumpmoveractive = false end
	self.jumpdir = 0
	self.injump = true
	self.jumplastfor = emittimeadd( 40 )
if mua.controlemaster( controles["left"] ) == true then self.jumpdir = -4.20 end
if mua.controlemaster( controles["right"] ) == true then self.jumpdir = 4.20 end
soundsystem.playsound( soundsystem.getgroup( "playerjump_sound" ), 0 )
if self.dotimerecoarding == true then self.recjumpsound = true end
   end
end

if self.injump == true then --jumping physics
if mua.controlemaster( controles["left"] ) == true and self.blockinput ~= true and self.jumpdir >= -4.20 then self.jumpdir = self.jumpdir -0.40 end
if mua.controlemaster( controles["right"] ) == true and self.blockinput ~= true and self.jumpdir <= 4.20 then self.jumpdir = self.jumpdir +0.40 end
	
if emittime() <= self.jumplastfor then
	self.y = self.y -8
	self.x = self.x +math.floor( self.jumpdir + 0.5 )
end
if emittime() >= self.jumplastfor then self.injump, self.jumpland = nil, true end
end

if self.jumpland == true then --jumping physics
if self.jumplandpullforce == nil then self.jumplandpullforce = 4 end
if gravity == true and self.jumplandpullforce >= 0 then
	self.y = self.y -math.floor( self.jumplandpullforce +0.5 )
	self.jumplandpullforce = self.jumplandpullforce -0.01
	self.x = self.x +math.floor( self.jumpdir + 0.5 )
if mua.controlemaster( controles["left"] ) == true and self.jumpdir >= -4.20 then self.jumpdir = self.jumpdir -0.40 end
if mua.controlemaster( controles["right"] ) == true and self.jumpdir <= 4.20 then self.jumpdir = self.jumpdir +0.40 end
else
if self.jumpdir >= 0 then self.x = self.x +5 end
if self.jumpdir <= 0 then self.x = self.x -5 end
	self.jumpland = nil
	self.jumplandpullforce = nil
   end
end

	self.lastgrav = gravity
   end
end

function ENT.draw( self )
if getresourcesloaded() == true and self.active ~= 0 then

love.graphics.setLineWidth( 2 )
love.graphics.setColor( 0, 1, 1, 1 )
love.graphics.rectangle("fill", self.x, self.y, self.sizex, self.sizey )
love.graphics.setColor( 0, 0, 0, 1 )
love.graphics.rectangle("line", self.x, self.y, self.sizex, self.sizey )
love.graphics.setLineWidth( 1 )

end
return 0
end

function ENT.mousepress( self, x, y, side, touching ) runentityfunction( self, "buttonpress", true, {"mouse", side} ) end
function ENT.keypress( self, key, scancode, isrepet ) runentityfunction( self, "buttonpress", true, {"key", key} ) end

emitentitytype( "obj_player", ENT )
	
