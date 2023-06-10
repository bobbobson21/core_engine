
--[[----------------------------[[--
  made by bobbobson21/ilikecreepers
   Feel free to use my code but do
         not copy my game.
--]]----------------------------]]--

	local windowtitle = "untitled" --if in devmode you need a title for the window and that title can be changed here
	local devfont = "dev_font" --the font to use to display devmode text
	local devmode = true --when releaseing a game turn off devmode to remove anything only devs are ment to see and pervent recompile
	local devkey = "r" --pushing this key at any time in game will reload the game and compile any changes that were made when the game was open
	
function loadresourcesandrequires() --loads all the sound, font, texture and texture type data and also all the entities and code files as well
local contents, size = love.filesystem.read( "doreload.dat" )
function gameindevmode() return devmode end
function gamedevreloadkey() return devkey end
function gamewindowtitle() return windowtitle end
if contents ~= nil and contents ~= "" and contents ~= "nil" then function gameisdevreload() return true end else function gameisdevreload() return false end end --gameisdevreload is used to check if the game was reloaded by a dev of if it just crashed and was restarted
love.filesystem.remove( "doreload.dat" )
love.filesystem.remove( "doreload.dat" )

require( "requires" )

runhook( "loadresourcetypes", {} ) --loades resource types for hooks. resource types allow you to create your own resources
if entities ~= nil then
for k,v in pairs( entities["mainfuncs"] ) do
if entities["mainfuncs"][k] ~= nil and entities["mainfuncs"][k]["loadresourcetypes"] ~= nil then
entities["mainfuncs"][k]["loadresourcetypes"]()  --loades resources types for entities
      end
   end
end
   
runhook( "loadresources", {} ) --loades resources for hooks
if entities ~= nil then
for k,v in pairs( entities["mainfuncs"] ) do
if entities["mainfuncs"][k] ~= nil and entities["mainfuncs"][k]["loadresources"] ~= nil then
entities["mainfuncs"][k]["loadresources"]()  --loades resources for hooks
         end
      end
   end
end

function emitentitytype( class, funcs ) --allows you create a new entity type. note have to access systems such as love.draw thougth the following set of functions: loadresourcetypes, loadresources, init, onremove, think, draw, mousepress, keypress. oh and you should put all the functions in a table under funcs
if entities == nil then entities = {["mainfuncs"]={}} end
	entities["mainfuncs"][class] = funcs --mainfuncs is like a sepical type of entity which stores the classes yo created and the funcs within them
	entities[class] = {} --creates the class type and once this is done it can not be undone
end

function spawnentity( class, identifyer ) --spawns an entity of a certain class
if entities == nil then entities = {["mainfuncs"]={}} end
if entities[class] ~= nil then

	local id = {[1]=1,[2]=false}

if identifyer == nil then -- note every entity needs an identifyer but if no identifyer is added one will be made here	
for z = 1, table.maxn( entities[class] ) +1 do
if entities[class][z] == nil and id[2] == false then
id = {[1]=z,[2]=true}
      end
   end
else
	id = {[1]=identifyer} --if an identifyer has been added it assigns the identifyer to the soon to be created entitiy
end

	entities[class][id[1]] = {}
	entities[class][id[1]]["class"] = class
	entities[class][id[1]]["identifyer"] = id[1]

runhook( "entity_oninit", _G["entities"][class][id[1]] ) --tells the game the entity was spawned  
if entities["mainfuncs"][class]["init"] ~= nil then entities["mainfuncs"][class]["init"]( _G["entities"][class][id[1]] ) end --runs the inital entity code

return _G["entities"][class][id[1]] --returns the enity so that valuse and stuff can be set on it and rendeing and think happens on the tick after actor creation so no issuse would come of this
   end
end

function getentity( entorclass, identifyer ) --gets an entity
if entities == nil then entities = {["mainfuncs"]={}} end
if type( entorclass ) ~= "table" then
if entorclass == nil then --if no infomation for the class or identifyer were put into the function this will get every entity in the game

	local ents = {}

for k,v in pairs( entities ) do
for l,w in pairs( entities[k] ) do
	ents[table.maxn( ents ) +1] = _G["entities"][k][l]
   end
end
return ents
end

if entities[entorclass] ~= nil then
if identifyer ~= nil then
return _G["entities"][entorclass][identifyer] --this will get the entity
else
      return _G["entities"][entorclass] --this will get every entity of a certain class if infomation for the class was added but no identifyer was
   end
end
else
	return _G["entities"][entorclass.class][entorclass.identifyer] --if you pass an ent to the function it will give you another copy of the ent
   end
end

function removeentity( entorclass, identifyer, confirm )
if entities == nil then entities = {["mainfuncs"]={}} end
if confirm == true and entorclass == nil and identifyer == nil then --ask for confirmation before deleting all entities which is what will happen if entorclass and identifyer == nil and confirmation is needed due to the fact that entities run everything so no entities no game
for k, v in pairs( entities ) do
for l, w in pairs( entities[k] ) do
if k ~= "mainfuncs" then

runhook( "entity_onremove", _G["entities"][k][l] )
if entities["mainfuncs"][k]["onremove"] ~= nil then entities["mainfuncs"][k]["onremove"]( _G["entities"][k][l] ) end
for m,x in pairs( _G["entities"][k][l] ) do x = nil end --delets all entitis

	_G["entities"][k][l] = nil --delets all entitis
	v = nil --delets all entitis

      end
   end
end

else

if type( entorclass ) == "table" then --delets an entity that was passed into the function

for k, v in pairs( entities ) do
for l, w in pairs( entities[k] ) do
if w == entorclass then

runhook( "entity_onremove", _G["entities"][k][l] )
if entities["mainfuncs"][k]["onremove"] ~= nil then entities["mainfuncs"][k]["onremove"]( _G["entities"][k][l] ) end
for m,x in pairs( _G["entities"][k][l] ) do m = nil end

	_G["entities"][k][l] = nil  --deletes entity
	
	  end
   end
end

	entorclass = nil

else

for k, v in pairs( entities ) do --delets an entity of a certain certain class with or without an identifyer
for l, w in pairs( entities[k] ) do

if k == entorclass and l ~= nil then
if l == identifyer or identifyer == nil then --checks  to see if an ents identifyer matches the identifyer entered of if no identifyer was entered

runhook( "entity_onremove", _G["entities"][k][l] )
if entities["mainfuncs"][k]["onremove"] ~= nil then entities["mainfuncs"][k]["onremove"]( _G["entities"][k][l] ) end
for m,x in pairs( _G["entities"][k][l] ) do m = nil end

	_G["entities"][k][l] = nil --deletes entity
	
	              end
	           end
            end
         end
      end
   end
end 

function runentitiesmainfuncs( func, addself, parameters, checkfunc ) --runs an entity main func on all entities. So it runs one of the following functions: loadresourcetypes, loadresources, init, onremove, think, draw, mousepress, keypress
	local returners, vars = {}, parameters or {}
if entities == nil then entities = {["mainfuncs"]={}} end
if entities ~= nil then
for k,v in pairs( entities["mainfuncs"] ) do
if entities["mainfuncs"][k] ~= nil and entities["mainfuncs"][k][func] ~= nil then
for l,w in pairs( entities[k] ) do
if checkfunc == nil or checkfunc( w ) ~= false then
if addself ~= false then returners[table.maxn( returners ) +1] = {[1]=w,[2]=entities["mainfuncs"][k][func]( w, unpack( vars ) )} end --add self adds the enity it is running the function for into the function
if addself == false then returners[table.maxn( returners ) +1] = {[1]=w,[2]=entities["mainfuncs"][k][func]( unpack( vars ) )} end --returners contains all the returned infomation and this is usfull for drawing
            end
         end
      end
   end
end
return returners
end

function emitentitytypeinfo( ent ) --tells you the class and identifyer of an entity
return {["class"]=ent.class,["identifyer"]=ent.identifyer}
end

function runentityfunction( ent, func, addself, parameters ) --runs a function for a specific entity
	local vars = parameters or {}
if ent[func] == nil then
if entities["mainfuncs"][ent.class][func] ~= nil then --checks if the function is a main func one
if addself ~= false then return entities["mainfuncs"][ent.class][func]( ent, unpack( vars ) ) end 
if addself == false then return entities["mainfuncs"][ent.class][func]( unpack( vars ) ) end
else
   return nil
   end
end
if addself ~= false then return ent[func]( ent, unpack( vars ) ) end 
if addself == false then return ent[func]( unpack( vars ) ) end
end

function setentityfunction( ent, info, func ) --creates a function in the most poitless way but it dose make code loo better
	ent[info] = func
end

function getentityfunction( ent, info ) --gets a function
if ent[info] ~= nil and type( ent[info] ) == "function" then return ent[info] end
end

function setentityinfo( ent, info, value ) --creates a bar in the most poitless way
	ent[info] = value
end

function getentityinfo( ent, info ) --gets the vars data
if info == nil then return ent end
if info ~= nil then return ent[info] end
end

function emithook( hook, identifyer, func ) --creates a hook which can hook onto other functions if allowed and then when that other function is runned so is this
if hooks == nil then hooks = {} end
if hooks[hook] == nil then hooks[hook] = {} end

	local id = {[1]=1,[2]=false}

if identifyer == nil then			
for z = 1, table.maxn( hooks[hook] ) +1 do
if hooks[hook][z] == nil and id[2] == false then
	id = {[1]=z,[2]=true}
      end
   end
else
	id = {[1]=identifyer}
end

if hooks[hook] ~= nil then hooks[hook][id[1]] = func end
end

function runhook( hook, tbl ) --put this in the first line of a function to to allow hooks to hook onto that function also put the name of the function in the hook part and the inputs in a table passed onto tbl
	local returnstbl, tblb = {}, tbl or {}
if hooks == nil then hooks = {} end
if hooks[hook] ~= nil then
for k,v in pairs( hooks[hook] ) do
	returnstbl[table.maxn( returnstbl ) +1] = v( unpack( tblb ) )
      end
   end
return returnstbl
end

function gethook( hook, identifyer ) --gets a hook
if hooks == nil then hooks = {} end
if hooks[hook] ~= nil then
if hook ~= nil and identifyer == nil then return hooks[hook] end --gets all hooks if no identifyer was found
if hook ~= nil and identifyer ~= nil then return hooks[hook][identifyer] end --gets a specific hook with an identifyer
end
return hooks
end

function removehook( hook, identifyer, confirm ) --removes a hook
if hooks == nil then hooks = {} end
if hooks[hook] ~= nil then
if hook ~= nil and identifyer == nil then hooks[hook] = nil end --removes all hooks of a certain class
if hook ~= nil and identifyer ~= nil then hooks[hook][identifyer] = nil end --removes a specific hook with an identifyer
end
if confirm == true and hook == nil and identifyer == nil then --removes all hooks if confirmation was given
	hooks = nil
	hooks = {}
   end
end

function addtimer( name, num, func ) --creates a timer oh and fyi num is where you would put emittimeadd( 50 ) and 50 is a second
if timers == nil then timers = {} end

	local id = {[1]=1,[2]=false}

if name == nil then			
for z = 1, table.maxn( timers ) +1 do
if name[z] == nil and id[2] == false then
	id = {[1]=z,[2]=true}
      end
   end
else
	id = {[1]=name}
end

	timers[id[1]] = {["num"]=num,["func"]=func,["numlog"]=0} --numlog is the amout of times the timer has runned and it is usally pased onto the timer function as an input
end

function gettimer( name ) --gets a timer
if timers == nil then timers = {} end
if timers[name] == nil and name ~= nil then return end --retunns nil if name is odd
if name ~= nil then return timers[name] else return timers end
end

function flowtimer( name, normal, bypassed ) --controls when the timer is in scope of time ie flowtimer( "bob", false, true ) means the timer is only checked if the game is paused and flowtimer( TIMER_NAME, true, false ) is the default 
if timers == nil then timers = {} end
if timers[name] == nil then return end
timers[name]["dothinkunder"] = {["normal"]=normal,["bypassed"]=bypassed}
end

function relooptimer( name, num ) --put this at the end of a timers function to make the time rerun its after num time has passed again 
if timers == nil then timers = {} end
if timers[name] == nil then return end
if emittime() < timers[name]["num"] then return end
numedittimer( name, num )
	timers[name]["reloop"] = true
end

function numedittimer( name, num ) --edits how long it takes for the timer to run it's function
if timers == nil then timers = {} end
if timers[name] == nil then return end
timers[name]["num"] = num
end

function stoptimer( name, isstoped ) --pauses the timer because pauseing the game wont do that
if timers == nil then timers = {} end
if timers[name] == nil then return end
if isstoped == false and timers[name]["stoptimer"] ~= false then timers[name]["num"], timers[name]["stoptimerdiff"] = ( emittime() +timers[name]["stoptimerdiff"] ), nil end
if isstoped == true and timers[name]["stoptimer"] ~= true then timers[name]["stoptimerdiff"] = ( timers[name]["num"] -emittime() ) end
timers[name]["stoptimer"] = isstoped
end

function removetimer( name ) --removes the timer
if timers == nil then timers = {} end
if timers[name] == nil then return end
timers[name] = nil
end

function emitresourcetype( ttype, func ) --allows you to create a resourcetypes with all the resource data being passed onto the function you use for the type and then the retuned data is now the resource
if resources == nil then resources = {} end
if resources["-resourcetypes-"] == nil then resources["-resourcetypes-"] = {} end
if resources["-resourcetypes-"][ttype] == nil then resources["-resourcetypes-"][ttype] = func end
end

function emitresources( tformat, name, file ) --loades external file data into a resource format
if resources == nil then resources = {} end
if resources[tformat] == nil then resources[tformat] = {} end

	local endfile = file

if tformat == "XnewsoundX" then endfile = function() return love.audio.newSource( file[1], file[2] ) end end --use if you want more than one audio emmiter at any given time for a sound
if tformat == "XsoundX" then endfile = love.audio.newSource( file[1], file[2] ) end --only allow one audio emmiter per sound but it dose load faster
if tformat == "XfontX" then endfile = love.graphics.newFont( file[1], file[2] ) end --loads fonts at specific sizes
if tformat == "XimageX" then endfile = love.graphics.newImage( file ) end --loads an image
if tformat == "XimagesX" then --loads an table/flip chat of images
	endfile = {}
for z = 1, table.maxn( file ) do endfile[z] = love.graphics.newImage( file[z] ) end
end
if tformat == "XimagesscanX" then --loads an table/flip chat of images but faser and easier
	endfile = {}
for z = file[3], file[4] do endfile[z] = love.graphics.newImage( file[1].."_"..tostring( z ).."."..file[2] ) end --file[1] = location and file name takeaway type and frame, file[2] = file type, file[3] and file[4] = start and end frames
end
if tformat == "XimagesaddloopX" then --loads an image in away that allows it to be tiled
	endfile = nil
for k,v in pairs( file ) do
v:setWrap("repeat", "repeat")
   end
end
if tformat == "XimagesaddnearX" then --pixle perfect quality images/4k
	endfile = nil
for k,v in pairs( file ) do
nearedimg:setFilter( "nearest", "nearest" )
   end
end

if resources["-resourcetypes-"] ~= nil then
for k,v in pairs( resources["-resourcetypes-"] ) do
if tformat == k then
	endfile = resources["-resourcetypes-"][k]( file )
      end
   end
end

if endfile ~= nil then resources[tformat][name] = endfile end
return resources[tformat][name]
end

function getresources( tformat, name ) --gets resource data such as image or font data
if resources == nil then resources = {} end
if tformat ~= nil and resources[tformat] == nil then resources[tformat] = {} end
if tformat ~= nil then
if name ~= nil then
return resources[tformat][name] --gets a specific resource
else
return resources[tformat] --gets all resources of a certain type
end
else
return resources --gets all resources
   end
end

function getresourcesminp() --faser resource collection
if resources == nil then resources = {} end
return _G["resources"]
end

function tostrevent( str ) --puts X's at the ends of things for thoese who are lazy
return "X"..str.."X"
end

function findstrevent( stra, strb ) --sees if something with X's at the end can be found
if string.find( strb, "X"..stra.."X" ) ~= nil then return true else return false end
end

function love.errorhandler( msg ) --better crash screen and it is not woth me explaing any of it.
	local utf8 = require("utf8")
	errormsg = tostring( msg )
print( ( debug.traceback("Error: " .. tostring( errormsg ), 3 ):gsub( "\n[^\n]+$", "" ) ) )

if not love.window or not love.graphics or not love.event or not love.mouse then return end
if not love.graphics.isCreated() or not love.window.isOpen() then
	local success, status = pcall( love.window.setFullscreen, true, "desktop" )
if not success or not status then
   return
   end
end

if love.audio then love.audio.stop() end
if love.mouse then
love.mouse.setVisible(true)
love.mouse.setGrabbed(false)
love.mouse.setRelativeMode(false)
if love.mouse.isCursorSupported() then
love.mouse.setCursor()
   end
end
if love.joystick then
for i,v in ipairs(love.joystick.getJoysticks()) do
v:setVibration()
   end
end

	local trace = debug.traceback()
	local sanitizedmsg = {}
	
for char in msg:gmatch(utf8.charpattern) do table.insert(sanitizedmsg, char) end
	sanitizedmsg = table.concat(sanitizedmsg)
	local err = {}
	
table.insert(err, "The error\n")
table.insert(err, sanitizedmsg)


if #sanitizedmsg ~= #msg then table.insert(err, "Invalid UTF-8 string in error message.") end

table.insert(err, "\n")

for l in trace:gmatch("(.-)\n") do
if not l:match("boot.lua") then
	l = l:gsub("stack traceback:", "Source code error location and effected elements\n")
table.insert(err, l)
   end
end

	local p = table.concat(err, "\n")

	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")
	
love.graphics.reset()
love.graphics.origin()

	local fonta = love.graphics.setNewFont(24)
	local fontb = love.graphics.setNewFont(16)
	local fontc = love.graphics.setNewFont(14)
	local clipbtex = "clipboard error"
	local domousepress = true
	local fmi = -1
	local fsi = 2

local function isboxinbox( xa, ya, wa, ha, xb, yb, wb, hb )
return xa < xb+wb and xb < xa+wa and ya < yb+hb and yb < ya+ha
end

local function think()
if fmi >= 0 then fmi = fmi -1 end
if fsi >= 0 then fsi = fsi -1 end
if fmi == 0 then domousepress = false end
if fsi == 0 then
	local fullscreen, fstype = love.window.getFullscreen()
if fullscreen ~= true or fstype ~= "desktop" then
love.window.maximize()
love.window.setFullscreen( true, "desktop" )
   end
end

if isboxinbox( 500, love.graphics.getHeight() -30, 240, 20, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == false and clipbtex ~= "copy error to clipboard" then clipbtex = "copy error to clipboard" end
if love.mouse.isDown( 1 ) == false and domousepress == false then domousepress = true end 
if love.mouse.isDown( 1 ) == true and domousepress == true then
	fmi = 2
if isboxinbox( 10, love.graphics.getHeight() -30, 480, 20, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then
love.event.quit( "restart" )
end
if isboxinbox( 500, love.graphics.getHeight() -30, 240, 20, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then
if not love.system then return end
love.system.setClipboardText( p )
	clipbtex = "error copied to clipboard!"
end
if isboxinbox( 750, love.graphics.getHeight() -30, 120, 20, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then
love.event.quit( "quit" )
      end
   end
end

local function draw()
love.graphics.clear( 1, 1, 1 )

love.graphics.setColor( 0, 0.68, 1, 1 )
love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 80 )

love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.setFont( fonta )
love.graphics.print( "Critical error: a crash has occoured", 8, 8 )
love.graphics.setFont( fontb )
love.graphics.printf( "Please contact the game/software developers as soon as possible if the error continues to persist after two reloads of the program.", 8, 50, love.graphics.getWidth() -16 )

love.graphics.setColor( 0, 0, 0, 1 )
love.graphics.setFont( fontc )
love.graphics.printf( p, 40, 110, love.graphics.getWidth() -120 )


love.graphics.setColor( 0, 0.68, 1, 1 )
love.graphics.rectangle("fill", 0, love.graphics.getHeight() -40, love.graphics.getWidth(), 60 )

love.graphics.setColor( 0.16, 0.16, 0.16, 1 )
if isboxinbox( 10, love.graphics.getHeight() -30, 480, 20, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 1 ) end
love.graphics.rectangle("fill", 10, love.graphics.getHeight() -30, 480, 20 )
love.graphics.setColor( 0.16, 0.16, 0.16, 1 )
if isboxinbox( 500, love.graphics.getHeight() -30, 240, 20, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 1 ) end
love.graphics.rectangle("fill", 500, love.graphics.getHeight() -30, 240, 20 )
love.graphics.setColor( 0.16, 0.16, 0.16, 1 )
if isboxinbox( 750, love.graphics.getHeight() -30, 120, 20, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 1 ) end
love.graphics.rectangle("fill", 750, love.graphics.getHeight() -30, 120, 20 )

love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.print( "reload program", 14, love.graphics.getHeight() -28 )
love.graphics.print( "close program", 754, love.graphics.getHeight() -28 )
love.graphics.print( clipbtex, 504, love.graphics.getHeight() -28 )

love.graphics.present()
end

return function()
love.event.pump()
for name, a,b,c,d,e,f in love.event.poll() do
if name == "quit" then
if not love.quit or not love.quit() then
return a or 0
      end
   end
end

think()
draw()

if love.timer then
love.timer.sleep(0.1)
      end
   end
end

function love.load() --stats the game DO NOT USE
love.window.setTitle( tostring( windowtitle ) )
love.window.minimize() --to help pervent visually bugs on windows

function emittimesync() return 0 end  --if sync is above 2 that meas you should NOT spawn anything in if you are spwning something in thougth think
function emittime() return 0.0001 end --emittime is our time constant 
function emittimeadd( addto ) return ( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) +0.0001 ) end
function emittimetake( addto ) return ( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) -0.0001 ) end

	local l_resources = "nil"
	local drawfunc = {}
	local lrl = false
	local subtime = 0
	local minrl = -1
	local maxrl = 1

function drawlockdepth( lock ) --has the amount of draw layers been locked meaning no auto ajustment for more layers cant be made
	lrl = lock
return lrl
end

function drawdepth( minv, maxv ) --sets the minamal and maxium amount of draw layers
if lrl ~= true then
if minv <= minrl -1 then minrl = minv end
if maxv >= maxrl +1 then maxrl = maxv end
end
return minrl, maxrl
end

function love.draw() --in this sort of game engine this dose not do the drawing the func below dose
love.window.maximize() --sets window size
love.window.setFullscreen( true, "desktop" ) --sets window size
if devmode ~= true then love.window.updateMode( love.graphics.getWidth(),  love.graphics.getHeight(), {["fullscreen"]=false} ) end --sets fallscreen
if devmode == true then love.window.updateMode( love.graphics.getWidth(),  love.graphics.getHeight() -60, {["fullscreen"]=false} ) end --allow for window bar if in devmode
	love.draw = drawfunc.drawcore
end

function drawfunc.drawcore() --this dose drawing
love.graphics.setColor( 1, 1, 1, 1 )
for k,v in pairs( runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= nil then return false end end) ) do --renders entities and gets there render level/depth
	v[1]["renderlevel"] = v[2] 
if tonumber( v[2] ) ~= nil and lrl ~= true then --auto ajustment of min and max render depth
if v[2] <= minrl -1 then minrl = v[2] end --auto ajustment
if v[2] >= maxrl +1 then maxrl = v[2] end --auto ajustment
   end
end

	local editrd = runhook( "draw", {nil} )
	
for z = 1, table.maxn( editrd ) do --auto ajustment of min and max render depth
if tonumber( editrd[z] ) ~= nil and lrl ~= true then --auto ajustment of min and max render depth
if editrd[z] <= minrl -1 then minrl = editrd[z] end --auto ajustment of min and max render depth
if editrd[z] >= maxrl +1 then maxrl = editrd[z] end --auto ajustment of min and max render depth
   end
end

runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= "<" then return false end end) --draws entities of < render level below everything
runhook( "draw", {"<"} ) --draws hooks of < render level below everything

for z = minrl, maxrl do --draws the render levels
runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= z then return false end end)
runhook( "draw", {z} )
end

runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= ">" then return false end end) --draws entities of > render level over everything
runhook( "draw", {">"} ) --draws hooks of > render level over everything

if l_resources == "nil" and next( getresources() ) ~= nil then l_resources = getresources() end --makes sure resources are loaded before drawing devmode text
if l_resources ~= "nil" then
if devmode == true then --if in dev mode draw devmode text
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.setFont( l_resources["XfontX"][devfont] )
love.graphics.print( "press "..tostring( devkey ).." to reload and apply", ( love.graphics.getWidth() /2 ) -( l_resources["XfontX"][devfont]:getWidth( "press "..tostring( devkey ).." to reload and apply" ) /2 ), 0 )
      end
   end
end

function love.mousepressed( x, y, side, touching ) --noteifys the game and entities of a mouse press
runhook( "mousepress", x, y, side, touching )
runentitiesmainfuncs( "mousepress", true, {x, y, side, touching}, nil )
end

function love.keypressed( key, scancode, isrepeat ) --noteifys the game and entities of a key press
if devmode == true and key == tostring( devkey ) then --dose the game reload
love.filesystem.write( "doreload.dat", "reloading" )
love.event.quit( "restart" )
end

runhook( "keypress", key, scancode, isrepeat ) --dose notify
runentitiesmainfuncs( "keypress", true, {key, scancode, isrepeat}, nil )
end

function love.update( dt ) --DO NOT USE

	local dtii = 0
	local emitthink = dt +1.50
	local pausethink = false

if emitthink >= 2 and emitthink <= 2.9999 then emitthink = emitthink -1 end
if emittime ~= nil then dtii = emittime() +( ( 0.0001 *( emitthink ) ) -0.00002 ) end --updates emittime's time and helps with the calulation bellow

function emittime() return dtii end 
function emittimesync() if math.floor( emitthink ) >= 1 then return emitthink else return subtime +emitthink end end
function emittimeadd( addto ) return dtii +( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) ) end
function emittimetake( addto ) return dtii -( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) ) end

	local thinkend = runhook( "think.end", {} )
for z = 1, table.maxn( thinkend ) do if pausethink ~= true and thinkend[z] == true then pausethink = true end end

if ( dt *100 ) <= 1 then --this is used to calulate how may times we should run the think functions per update to keep it aproxmently accurate to time
	subtime, emitthink = subtime +dt *100, 0
if subtime >= 1 then subtime, emitthink = 0, 1 end
end

if pausethink == true then --if the game is paused we stop running think and start running think.bypass hooks and times insted
for z = 1, math.floor( emitthink ) do --dose the running of the think functions per update
runhook( "think.bypass", {} )
if timers ~= nil then
for k,v in pairs( timers ) do
if emittime() >= v.num and v.stoptimer ~= true and ( v.dothinkunder["bypassed"] == true ) then
	v.numlog = v.numlog +1
v.func( v.numlog )
if v.reloop ~= true then timers[k], v = nil, nil end
	v.reloop = nil
            end
         end
      end
   end
end

if pausethink ~= true then --if the game is not paused we stop running think.bypass and start running think hooks and times insted
for z = 1, math.floor( emitthink ) do --dose the running of the think functions per update
runhook( "think", {} )
runentitiesmainfuncs( "think", true, nil, nil )
if timers ~= nil then
for k,v in pairs( timers ) do
if emittime() >= v.num and v.stoptimer ~= true and ( v.dothinkunder == nil or v.dothinkunder["normal"] == true ) then
	v.numlog = v.numlog +1
v.func( v.numlog )
if v.reloop ~= true then timers[k], v = nil, nil end
	v.reloop = nil
               end
            end
         end
      end
   end
end
  
loadresourcesandrequires() --loads the game

end
