
	levels = {}

function levels.freezelevel( freeze )
if freeze == true then
	levels.isfrozen = true
emithook( "think.end", "levelsystempause", function() return true end)
soundsystem.masterstop( false )
end
if freeze == false then
	levels.isfrozen = false
removehook( "think.end", "levelsystempause" )
   end
end

function levels.getfreeze()
	local frozen = levels.isfrozen or false
return frozen
end

function levels.addlevel( name, func )
if levels["levels"] == nil then levels["levels"] = {} end
	levels["levels"][name] = func
end

function levels.removelevel( name )
if levels["levels"] == nil then levels["levels"] = {} end
	levels["levels"][name] = nil
end

function levels.reloadlevel()
levels.loadlevel( levels.activelevel )
end

function levels.loadlevel( name )
if levels["levels"] == nil then levels["levels"] = {} end
if levels["levels"][name] == nil then return false end 
if levels["levels"][name] ~= nil then 

playerdespawn()
for k,v in pairs( getentity( nil, nil ) ) do
	v.KEEP_AFTER_LEVEL_UNLOAD = true
end
for k,v in pairs( getentity( nil, nil ) ) do
if v.KEEP_AFTER_LEVEL_UNLOAD ~= true then removeentity( v ) end
end
particlesystem.removeparticle( nil, true )
getentity( "env_sky", "sky" ).resetsky( getentity( "env_sky", "sky" ) )

	local menu = getentity( "point_mainmenu", "mainmenu" )

	menu.drawbackground = nil
	menu.pauseon = true
	menu.qgtext = "exit level"
	menu.pgtext ="resume game"
	menu.active = 0
	menu.darkness = 255 
	menu.darknessdir = 0

	local hud = getentity( "point_hud", "hud" )
	hud.active = nil

	levels.activelevel = name
levels["levels"][name]()
   return true
   end
end

function levels.unloadlevel()
if levels["levels"] == nil then levels["levels"] = {} end

playerdespawn()
for k,v in pairs( getentity( nil, nil ) ) do
	v.KEEP_AFTER_LEVEL_UNLOAD = true
end
for k,v in pairs( getentity( nil, nil ) ) do
if v.KEEP_AFTER_LEVEL_UNLOAD ~= true then removeentity( v ) end
end
soundsystem.replaymusic()
love.mouse.setVisible( true )
particlesystem.removeparticle( nil, true )
getentity( "env_sky", "sky" ).resetsky( getentity( "env_sky", "sky" ) )

	local menu = getentity( "point_mainmenu", "mainmenu" )

	menu.drawbackground = true
	menu.pauseon = nil
	menu.qgtext = "quit game"
	menu.pgtext = "play game"
	menu.active = nil
	menu.darkness = 255
	menu.darknessdir = 0
	menu.menu = 1

	local hud = getentity( "point_hud", "hud" )
	hud.active = 0

	levels.activelevel = nil
end

emitentitytype( "point_levels", {["loadresources"]=levels.loadresources,["init"]=levels.init,["onremove"]=levels.onremove,["think"]=levels.think,["draw"]=levels.draw,["mousepress"]=levels.mousepress,["keypress"]=levels.keypress,} )

	local ent = spawnentity( "point_levels", "levelmanager" )
	
