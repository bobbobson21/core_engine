
	levels = {}

function levels.freezelevel( freeze ) --pauses the game
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

playerdespawn()

if levels.markednonunloadents ~= true then
for k,v in pairs( getentity( nil, nil ) ) do
	v.KEEP_AFTER_LEVEL_UNLOAD = true
end
	levels.markednonunloadents = true
end
for k,v in pairs( getentity( nil, nil ) ) do
if v.KEEP_AFTER_LEVEL_UNLOAD ~= true then removeentity( v ) end
end

soundsystem.replaymusic()
if gameindevmode() ~= true then love.mouse.setVisible( false ) end
particlesystem.removeparticle( nil, true )
runentityfunction( getentity( "env_sky", "sky" ), "resetclouds", true, {} )

	local menu = getentity( "point_mainmenu", "mainmenu" )

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

function levels.loadlevelraw( name )
if levels["levels"] == nil then levels["levels"] = {} end
if levels["levels"][name] == nil then return false end 

playerdespawn()

if levels.markednonunloadents ~= true then
for k,v in pairs( getentity( nil, nil ) ) do
	v.KEEP_AFTER_LEVEL_UNLOAD = true
end
	levels.markednonunloadents = true
end
for k,v in pairs( getentity( nil, nil ) ) do
if v.KEEP_AFTER_LEVEL_UNLOAD ~= true then removeentity( v ) end
end

particlesystem.removeparticle( nil, true )
runentityfunction( getentity( "env_sky", "sky" ), "resetclouds", true, {} )

	levels.activelevel = name
	levels.levelcontentloaded = true
levels["levels"][name]()

   return true
end

function levels.unloadlevel()
if levels["levels"] == nil then levels["levels"] = {} end

playerdespawn()

if levels.markednonunloadents == true then
for k,v in pairs( getentity( nil, nil ) ) do
if v.KEEP_AFTER_LEVEL_UNLOAD ~= true then removeentity( v ) end
   end
end

soundsystem.replaymusic()
if gameindevmode() ~= true then love.mouse.setVisible( true ) end
particlesystem.removeparticle( nil, true )
runentityfunction( getentity( "env_sky", "sky" ), "resetclouds", true, {} )

	local menu = getentity( "point_mainmenu", "mainmenu" )

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

emitentitytype( "point_levels", levels )

	local ent = spawnentity( "point_levels", "levelmanager" )
	
|