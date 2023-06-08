
	soundsystem = {}

	_G_soundsystem_dooutputcheck = true

function soundsystem.overallvolume( num, maxover )
if soundsystem["toplay"] == nil then soundsystem["toplay"] = {} end
if soundsystem["soundtime"] == nil then soundsystem["soundtime"] = {} end
if maxover == true then
love.audio.setVolume( num /100 )
for z = 1, table.maxn( soundsystem["toplay"] ) do soundsystem["toplay"][z][1]:setVolume( 1 ) end
for z = 1, table.maxn( soundsystem["soundtime"] ) do
if soundsystem["soundtime"][z][1] ~= nil then
	soundsystem["soundtime"][z][1]:setVolume( 1 )
   end
end
else
for z = 1, table.maxn( soundsystem["toplay"] ) do soundsystem["toplay"][z][1]:setVolume( num /100 ) end
for z = 1, table.maxn( soundsystem["soundtime"] ) do
if soundsystem["soundtime"][z][1] ~= nil then
	soundsystem["soundtime"][z][1]:setVolume( num /100 )
         end
      end
   end
end

function soundsystem.masterstop( maxstop )
if soundsystem["toplay"] == nil then soundsystem["toplay"] = {} end
if soundsystem["soundtime"] == nil then soundsystem["soundtime"] = {} end
if maxstop == true then
love.audio.stop()
for z = 1, table.maxn( soundsystem["toplay"] ) do soundsystem["toplay"][z] = nil end
for z = 1, table.maxn( soundsystem["soundtime"] ) do
if soundsystem["soundtime"][z] ~= nil then
	soundsystem["soundtime"][z][1]:stop()
	soundsystem["toplay"] = nil
   end
end
else
for z = 1, table.maxn( soundsystem["soundtime"] ) do
if soundsystem["soundtime"][z][1] ~= nil and soundsystem["soundtime"][z][1].autooverrideminstop ~= true then
	soundsystem["soundtime"][z][1]:stop()
	soundsystem["soundtime"][z] = nil
         end
      end
   end
end

function soundsystem.getgroup( name )
if soundsystem["groups"] == nil then soundsystem["groups"] = {} end
return soundsystem["groups"][name]
end

function soundsystem.emitgroup( name, tbl )
if soundsystem["groups"] == nil then soundsystem["groups"] = {} end
if soundsystem["formatgroups"] == nil then soundsystem["formatgroups"] = {} end
	local tblb = {}
	soundsystem["formatgroups"][name] = 0
for k,v in pairs( tbl ) do
	soundsystem["formatgroups"][name] = soundsystem["formatgroups"][name] +1
	tblb[tostring( soundsystem["formatgroups"][name] )] = v
end
	soundsystem["groups"][name]=tblb
end

function soundsystem.volumemusic( vol )
if _G_soundsystem_dooutputcheck ~= true or soundsystem["soundfullloaded"] == true then
soundsystem["soundtrack"]:setVolume( vol /100 )
else
	soundsystem["soundtrackvol"] = vol /100
   end
end

function soundsystem.stopmusic()
if soundsystem["soundtrack"] ~= nil then soundsystem["soundtrack"]:stop() end
end

function soundsystem.replaymusic()
if soundsystem["soundtrack"] ~= nil then soundsystem["soundtrack"]:play() end
end

function soundsystem.playasmusic( sound )
if _G_soundsystem_dooutputcheck ~= true or soundsystem["soundfullloaded"] == true then
sound:setLooping( true )
sound:play()
if soundsystem["soundtrackvol"] ~= nil then sound:setVolume( soundsystem["soundtrackvol"] ) end
	soundsystem["soundtrack"] = sound
else
	soundsystem["soundtrack"] = sound
   end
end

function soundsystem.playsound( sound, delay )
	local thesound = sound
if soundsystem["soundfullloaded"] == false then return soundsystem["fakesndtbl"] end
if soundsystem["toplay"] == nil then soundsystem["toplay"] = {} end
if soundsystem["soundtime"] == nil then soundsystem["soundtime"] = {} end
if type( sound ) ~= "table" then
if type( sound ) == "function" then thesound = sound() end
if delay == 0 then thesound:play() else soundsystem["toplay"][table.maxn( soundsystem["toplay"] ) +1] = {[1]=thesound,[2]=delay,} end
	soundsystem["soundtime"][table.maxn( soundsystem["soundtime"] ) +1] = {[1]=thesound,[2]=emittimeadd( thesound:getDuration( "samples" ) ) +delay,}
if type( sound ) == "function" then return thesound end
else
	local val, cval, thesound = math.random( 1, mua.tablecount( sound ) ), 0, "nil"
for k,v in pairs( sound ) do
	cval = cval +1
if cval == 1 then thesound = v end
if cval == val then 
   thesound = v
   end	
end
if thesound ~= "nil" then
	local soundwasfunc = false
if type( thesound ) == "function" then thesound, soundwasfunc = thesound(), true end
if delay == 0 then thesound:play() else soundsystem["toplay"][table.maxn( soundsystem["toplay"] ) +1] = {[1]=thesound,[2]=delay,} end
	soundsystem["soundtime"][table.maxn( soundsystem["soundtime"] ) +1] = {[1]=thesound,[2]=emittimeadd( thesound:getDuration( "samples" ) ) +delay,}
if soundwasfunc == true then return thesound end
      end
   end
end

function soundsystem.init( self )
	soundsystem["fakesndtbl"] = {["setVolume"]=function()end,["setPitch"]=function()end,}
	soundsystem["soundfullloaded"] = false
if _G_soundsystem_dooutputcheck ~= true then soundsystem["soundfullloaded"] = true end
if _G_soundsystem_dooutputcheck == true then
love.filesystem.write( "sndoutput.vbs", tostring( 'Dim snd, dat, file: Set snd =CreateObject("SAPI.spvoice"): Set dat =CreateObject("Scripting.FileSystemObject"): ' )..tostring( 'Set file =dat.OpenTextFile( "' )..tostring( love.filesystem.getSaveDirectory() )..tostring( '/soundon.dat",2,true ): If snd.GetAudioOutputs.Count <= 0 Then file.Write "false" Else file.Write "true" End If' ) )
	local contents, size = love.filesystem.read( "sndoutput.vbs" )
if contents ~= nil and contents ~= "" and contents ~= "nil" then
os.execute( "if exist "..love.filesystem.getSaveDirectory().."/sndoutput.vbs start "..love.filesystem.getSaveDirectory().."/sndoutput.vbs" )
	self.actonsndoutputin = emittimeadd( 20 )
	  end
   end
end

function soundsystem.think( self )
if self.actonsndoutputin ~= nil then
if emittime() >= self.actonsndoutputin then
	self.actonsndoutputin = nil
	local contents, size = love.filesystem.read( "soundon.dat" )
if contents ~= nil and contents ~= "" and contents ~= "nil" then
if contents ~= "true" then
function soundsystem.playsound( sound, delay ) return soundsystem["fakesndtbl"] end
function soundsystem.emitgroup( name, tbl ) end
function soundsystem.getgroup( name ) end
function soundsystem.overallvolume( num ) end
function soundsystem.masterstop( maxstop ) end
else
	soundsystem["soundfullloaded"] = true
end
else
	soundsystem["soundfullloaded"] = true
end	

if soundsystem["soundfullloaded"] == true and soundsystem["soundtrack"] ~= nil then
if soundsystem["soundtrackvol"] ~= nil then soundsystem["soundtrack"]:setVolume( soundsystem["soundtrackvol"] ) end
soundsystem["soundtrack"]:setLooping( true )
soundsystem["soundtrack"]:play()
end

love.filesystem.remove( "sndoutput.vbs" )
love.filesystem.remove( "sndoutput.vbs" )
love.filesystem.remove( "soundon.dat" )
love.filesystem.remove( "soundon.dat" )
   end
end

if soundsystem["soundtime"] ~= nil then
for z = 1, table.maxn( soundsystem["soundtime"] ) do
if soundsystem["soundtime"][z] ~= nil then
if soundsystem["soundtime"][z][1] ~= nil and soundsystem["soundtime"][z][2] ~= nil then

if emittimesync() >= 2 then
	local seekto = soundsystem["soundtime"][z][1]:tell( "samples" )
if seekto >= 0 then 
soundsystem["soundtime"][z][1]:seek( seekto +emittimesync(), "samples" )
    end 
end

if emittime() >= soundsystem["soundtime"][z][2] then soundsystem["soundtime"][z][2] = nil end

         end
      end
   end
end

if soundsystem["toplay"] ~= nil then
for k,v in pairs( soundsystem["toplay"] ) do
if emittime() >= v[2] then
v[1]:play()
	soundsystem["toplay"][k] = nil
         end
      end
   end
end

emitentitytype( "soundsystem", {["loadresources"]=soundsystem.loadresources,["init"]=soundsystem.init,["onremove"]=soundsystem.onremove,["think"]=soundsystem.think,["draw"]=soundsystem.draw,["mousepress"]=soundsystem.mousepress,["keypress"]=soundsystem.keypress,} )

	local ent = spawnentity( "soundsystem", "soundsystement" )

	