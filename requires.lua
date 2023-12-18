drawdepth( -7, 4 )
drawlockdepth( true )
require( "systems/loadingsystem" )

loadingsystem.register( "stage_1;XresourcesX", "loading mua, sound system, particle system", 17, function()
require( "mua" )
require( "systems/soundsystem" )
require( "systems/particlesystemandemiters" )
require( "systems/navcore" )
end)

loadingsystem.register( "stage_2", "loading effects file and particle emiters", 31, function()
particlesystem.adddepth( -6, 2 )
require( "effects" )
end)

loadingsystem.register( "stage_3;XresourcesX", "loading entities and interfaces", 51, function()
require( "entities/env_invisbarrier" )
require( "entities/env_scenery" )
require( "entities/env_ground" )
require( "entities/env_sky" )
require( "entities/obj_player" )
require( "entities/obj_trigger" )
require( "entities/point_mainmenu" )
require( "entities/point_levels" )
require( "entities/point_hud" )
end)

loadingsystem.register( "stage_4;XresourcesX", "loading entities and interfaces", 68, function()

end)

loadingsystem.register( "stage_5", "loading levels", 85, function()

end)

loadingsystem.register( "stage_6", "loading sound track", 100, function()
soundsystem.playasmusic( emitresources( "XsoundX", "soundtrack_sound", {[1]="sounds/soundtrack.wav",[2]="static"} ) )
end)