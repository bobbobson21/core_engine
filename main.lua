
--[[--------------------[[--
  made by ed/ilikecreepers
  Feel free to use my code
  but do not copy my game.
--]]--------------------]]--

	local windowtitle = "untitled"
	local devfont = "dev_font"
	local devmode = true
	local devkey = "r"
	
function loadresourcesandrequires()
local contents, size = love.filesystem.read( "doreload.dat" )
function gameindevmode() return devmode end
function gamedevreloadkey() return devkey end
function gamewindowtitle() return windowtitle end
if contents ~= nil and contents ~= "" and contents ~= "nil" then function gameisdevreload() return true end else function gameisdevreload() return false end end
love.filesystem.remove( "doreload.dat" )
love.filesystem.remove( "doreload.dat" )

require( "requires" )

runhook( "loadresourcetypes", {} )
if entities ~= nil then
for k,v in pairs( entities["mainfuncs"] ) do
if entities["mainfuncs"][k] ~= nil and entities["mainfuncs"][k]["loadresourcetypes"] ~= nil then
entities["mainfuncs"][k]["loadresourcetypes"]()
      end
   end
end
   
runhook( "loadresources", {} )
if entities ~= nil then
for k,v in pairs( entities["mainfuncs"] ) do
if entities["mainfuncs"][k] ~= nil and entities["mainfuncs"][k]["loadresources"] ~= nil then
entities["mainfuncs"][k]["loadresources"]()
         end
      end
   end
end

function emitentitytype( class, funcs )
if entities == nil then entities = {["mainfuncs"]={}} end
	entities["mainfuncs"][class] = funcs
	entities[class] = {}
end

function spawnentity( class, identifyer )
if entities == nil then entities = {["mainfuncs"]={}} end
if entities[class] ~= nil then

	local id = {[1]=1,[2]=false}

if identifyer == nil then			
for z = 1, table.maxn( entities[class] ) +1 do
if entities[class][z] == nil and id[2] == false then
id = {[1]=z,[2]=true}
      end
   end
else
	id = {[1]=identifyer}
end

	entities[class][id[1]] = {}
	entities[class][id[1]]["class"] = class
	entities[class][id[1]]["identifyer"] = id[1]

runhook( "entity_oninit", _G["entities"][class][id[1]] )
if entities["mainfuncs"][class]["init"] ~= nil then entities["mainfuncs"][class]["init"]( _G["entities"][class][id[1]] ) end

return _G["entities"][class][id[1]]
   end
end

function getentity( entorclass, identifyer )
if entities == nil then entities = {["mainfuncs"]={}} end
if type( entorclass ) ~= "table" then
if entorclass == nil then

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
return _G["entities"][entorclass][identifyer]
else
      return _G["entities"][entorclass]
   end
end
else
	return _G["entities"][entorclass.class][entorclass.identifyer]
   end
end

function removeentity( entorclass, identifyer, confirm )
if entities == nil then entities = {["mainfuncs"]={}} end
if confirm == true and entorclass == nil and identifyer == nil then

for k, v in pairs( entities ) do
for l, w in pairs( entities[k] ) do
if k ~= "mainfuncs" then

runhook( "entity_onremove", _G["entities"][k][l] )
if entities["mainfuncs"][k]["onremove"] ~= nil then entities["mainfuncs"][k]["onremove"]( _G["entities"][k][l] ) end
for m,x in pairs( _G["entities"][k][l] ) do x = nil end

	_G["entities"][k][l] = nil
	v = nil

      end
   end
end

else

if type( entorclass ) == "table" then

for k, v in pairs( entities ) do
for l, w in pairs( entities[k] ) do
if w == entorclass then

runhook( "entity_onremove", _G["entities"][k][l] )
if entities["mainfuncs"][k]["onremove"] ~= nil then entities["mainfuncs"][k]["onremove"]( _G["entities"][k][l] ) end
for m,x in pairs( _G["entities"][k][l] ) do m = nil end

	_G["entities"][k][l] = nil
	
	  end
   end
end

	entorclass = nil

else

for k, v in pairs( entities ) do
for l, w in pairs( entities[k] ) do

if k == entorclass and l ~= nil then
if l == identifyer or identifyer == nil then

runhook( "entity_onremove", _G["entities"][k][l] )
if entities["mainfuncs"][k]["onremove"] ~= nil then entities["mainfuncs"][k]["onremove"]( _G["entities"][k][l] ) end
for m,x in pairs( _G["entities"][k][l] ) do m = nil end

	_G["entities"][k][l] = nil
	
	              end
	           end
            end
         end
      end
   end
end 

function runentitiesmainfuncs( func, addself, parameters, checkfunc )
	local returners, vars = {}, parameters or {}
if entities == nil then entities = {["mainfuncs"]={}} end
if entities ~= nil then
for k,v in pairs( entities["mainfuncs"] ) do
if entities["mainfuncs"][k] ~= nil and entities["mainfuncs"][k][func] ~= nil then
for l,w in pairs( entities[k] ) do
if checkfunc == nil or checkfunc( w ) ~= false then
if addself ~= false then returners[table.maxn( returners ) +1] = {[1]=w,[2]=entities["mainfuncs"][k][func]( w, unpack( vars ) )} end
if addself == false then returners[table.maxn( returners ) +1] = {[1]=w,[2]=entities["mainfuncs"][k][func]( unpack( vars ) )} end
            end
         end
      end
   end
end
return returners
end

function emitentitytypeinfo( ent )
return {["class"]=ent.class,["identifyer"]=ent.identifyer}
end

function runentityfunction( ent, func, addself, parameters )
	local vars = parameters or {}
if addself ~= false then return ent[tostring( func )]( ent, unpack( vars ) ) end 
if addself == false then return ent[tostring( func )]( unpack( vars ) ) end
end

function setentityfunction( ent, info, func )
	ent[info] = func
end

function getentityfunction( ent, info )
if ent[info] ~= nil and type( ent[info] ) == "function" then return ent[info] end
end

function setentityinfo( ent, info, value )
	ent[info] = value
end

function getentityinfo( ent, info )
if info == nil then return ent end
if info ~= nil then return ent[info] end
end

function emithook( hook, identifyer, func )
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

function runhook( hook, tbl )
	local returnstbl, tblb = {}, tbl or {}
if hooks == nil then hooks = {} end
if hooks[hook] ~= nil then
for k,v in pairs( hooks[hook] ) do
	returnstbl[table.maxn( returnstbl ) +1] = v( unpack( tblb ) )
      end
   end
return returnstbl
end

function gethook( hook, identifyer )
if hooks == nil then hooks = {} end
if hooks[hook] ~= nil then
if hook ~= nil and identifyer == nil then return hooks[hook] end
if hook ~= nil and identifyer ~= nil then return hooks[hook][identifyer] end
end
return hooks
end

function removehook( hook, identifyer, confirm )
if hooks == nil then hooks = {} end
if hooks[hook] ~= nil then
if hook ~= nil and identifyer == nil then hooks[hook] = {} end
if hook ~= nil and identifyer ~= nil then hooks[hook][identifyer] = nil end
end
if confirm == true and hook == nil and identifyer == nil then
	hooks = nil
	hooks = {}
   end
end

function addtimer( name, num, func )
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

	timers[id[1]] = {["num"]=num,["func"]=func,["numlog"]=0}
end

function gettimer( name )
if timers == nil then timers = {} end
if timers[name] == nil then return end
if name ~= nil then return timers[name] else return timers end
end

function flowtimer( name, normal, bypassed )
if timers == nil then timers = {} end
if timers[name] == nil then return end
timers[name]["dothinkunder"] = {["normal"]=normal,["bypassed"]=bypassed}
end

function relooptimer( name, num )
if timers == nil then timers = {} end
if timers[name] == nil then return end
if emittime() < timers[name]["num"] then return end
numedittimer( name, num )
	timers[name]["reloop"] = true
end

function numedittimer( name, num )
if timers == nil then timers = {} end
if timers[name] == nil then return end
timers[name]["num"] = num
end

function stoptimer( name, isstoped )
if timers == nil then timers = {} end
if timers[name] == nil then return end
if isstoped == false and timers[name]["stoptimer"] ~= false then timers[name]["num"], timers[name]["stoptimerdiff"] = ( emittime() +timers[name]["stoptimerdiff"] ), nil end
if isstoped == true and timers[name]["stoptimer"] ~= true then timers[name]["stoptimerdiff"] = ( timers[name]["num"] -emittime() ) end
timers[name]["stoptimer"] = isstoped
end

function removetimer( name )
if timers == nil then timers = {} end
if timers[name] == nil then return end
timers[name] = nil
end

function emitresourcetype( ttype, func )
if resources == nil then resources = {} end
if resources["-resourcetypes-"] == nil then resources["-resourcetypes-"] = {} end
if resources["-resourcetypes-"][ttype] == nil then resources["-resourcetypes-"][ttype] = func end
end

function emitresources( tformat, name, file )
if resources == nil then resources = {} end
if resources[tformat] == nil then resources[tformat] = {} end

	local endfile = file

if tformat == "XnewsoundX" then endfile = function() return love.audio.newSource( file[1], file[2] ) end end
if tformat == "XsoundX" then endfile = love.audio.newSource( file[1], file[2] ) end
if tformat == "XfontX" then endfile = love.graphics.newFont( file[1], file[2] ) end
if tformat == "XimageX" then endfile = love.graphics.newImage( file ) end
if tformat == "XimagesX" then
	endfile = {}
for z = 1, table.maxn( file ) do endfile[z] = love.graphics.newImage( file[z] ) end
end
if tformat == "XimagesscanX" then
	endfile = {}
for z = file[3], file[4] do endfile[z] = love.graphics.newImage( file[1].."_"..tostring( z ).."."..file[2] ) end
end
if tformat == "XimagesaddloopX" then
	endfile = nil
for k,v in pairs( file ) do
v:setWrap("repeat", "repeat")
   end
end
if tformat == "XimagesaddnearX" then
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

function getresources( tformat, name )
if resources == nil then resources = {} end
if tformat ~= nil and resources[tformat] == nil then resources[tformat] = {} end
if tformat ~= nil then
if name ~= nil then
return resources[tformat][name]
else
return resources[tformat]
end
else
return resources
   end
end

function getresourcesminp()
if resources == nil then resources = {} end
return _G["resources"]
end

function tostrevent( str )
return "X"..str.."X"
end

function findstrevent( stra, strb )
if string.find( strb, "X"..stra.."X" ) ~= nil then return true else return false end
end

function love.errorhandler( msg )
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

function love.load()
love.window.setTitle( tostring( windowtitle ) )
love.window.minimize()

function emittimesync() return 0 end
function emittime() return 0.0001 end
function emittimeadd( addto ) return ( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) +0.0001 ) end
function emittimetake( addto ) return ( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) -0.0001 ) end

	local l_resources = "nil"
	local drawfunc = {}
	local lrl = false
	local subtime = 0
	local minrl = -1
	local maxrl = 1

function drawlockdepth( lock )
	lrl = lock
return lrl
end

function drawdepth( minv, maxv )
if lrl ~= true then
if minv <= minrl -1 then minrl = minv end
if maxv >= maxrl +1 then maxrl = maxv end
end
return minrl, maxrl
end

function love.draw()
love.window.maximize()
love.window.setFullscreen( true, "desktop" )
if devmode ~= true then love.window.updateMode( love.graphics.getWidth(),  love.graphics.getHeight(), {["fullscreen"]=false} ) end
if devmode == true then love.window.updateMode( love.graphics.getWidth(),  love.graphics.getHeight() -60, {["fullscreen"]=false} ) end
	love.draw = drawfunc.drawcore
end

function drawfunc.drawcore()
love.graphics.setColor( 1, 1, 1, 1 )
for k,v in pairs( runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= nil then return false end end) ) do
	v[1]["renderlevel"] = v[2] 
if tonumber( v[2] ) ~= nil and lrl ~= true then
if v[2] <= minrl -1 then minrl = v[2] end
if v[2] >= maxrl +1 then maxrl = v[2] end
   end
end

	local editrd = runhook( "draw", {nil} )
	
for z = 1, table.maxn( editrd ) do
if tonumber( editrd[z] ) ~= nil and lrl ~= true then
if editrd[z] <= minrl -1 then minrl = editrd[z] end
if editrd[z] >= maxrl +1 then maxrl = editrd[z] end
   end
end

runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= "<" then return false end end)
runhook( "draw", {"<"} )

runhook( "draw", {minrl -1} )
for z = minrl, maxrl do
runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= z then return false end end)
runhook( "draw", {z} )
end
runhook( "draw", {maxrl +1} )

runentitiesmainfuncs( "draw", true, nil, function( self ) if self.renderlevel ~= ">" then return false end end)
runhook( "draw", {">"} )

if l_resources == "nil" and next( getresources() ) ~= nil then l_resources = getresources() end
if l_resources ~= "nil" then
if devmode == true then
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.setFont( l_resources["XfontX"][devfont] )
love.graphics.print( "press "..tostring( devkey ).." to reload and apply", ( love.graphics.getWidth() /2 ) -( l_resources["XfontX"][devfont]:getWidth( "press "..tostring( devkey ).." to reload and apply" ) /2 ), 0 )
      end
   end
end

function love.mousepressed( x, y, side, touching )
runhook( "mousepress", x, y, side, touching )
runentitiesmainfuncs( "mousepress", true, {x, y, side, touching}, nil )
end

function love.keypressed( key, scancode, isrepeat )
if devmode == true and key == tostring( devkey ) then
love.filesystem.write( "doreload.dat", "reloading" )
love.event.quit( "restart" )
end

runhook( "keypress", key, scancode, isrepeat )
runentitiesmainfuncs( "keypress", true, {key, scancode, isrepeat}, nil )
end

function love.update( dt )

	local dtii = 0
	local emitthink = dt +1.50
	local pausethink = false

if emitthink >= 2 and emitthink <= 2.9999 then emitthink = emitthink -1 end
if emittime ~= nil then dtii = emittime() +( ( 0.0001 *( emitthink ) ) -0.00002 ) end

function emittime() return dtii end
function emittimesync() if math.floor( emitthink ) >= 1 then return emitthink else return subtime +emitthink end end
function emittimeadd( addto ) return dtii +( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) ) end
function emittimetake( addto ) return dtii -( tonumber( "0."..string.sub( "0000", 1, 4 -string.len( tostring( addto ) ) )..tostring( addto ) ) ) end

	local thinkend = runhook( "think.end", {} )
for z = 1, table.maxn( thinkend ) do if pausethink ~= true and thinkend[z] == true then pausethink = true end end

if ( dt *100 ) <= 1 then
	subtime, emitthink = subtime +dt *100, 0
if subtime >= 1 then subtime, emitthink = 0, 1 end
end

if pausethink == true then
for z = 1, math.floor( emitthink ) do
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

if pausethink ~= true then
for z = 1, math.floor( emitthink ) do
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
  
loadresourcesandrequires()

end
