	
	loadingsystem = {["title"]=gamewindowtitle()}

function loadingsystem.register( name, text, percent, func ) --to create blocks of content to load and the name is the name of the loading stage and text is text used to display what is loading percent is how much is loaded function is where you put the files to load also put XresourcesX into name to load the resouces used in the files
if loadingsystem["toload"] == nil then loadingsystem["toload"] = {} end
if loadingsystem["fromload"] == nil then loadingsystem["fromload"] = 0 end
if loadingsystem["loadcount"] == nil then loadingsystem["loadcount"] = 0 end
if loadingsystem["toload"][name] == nil then loadingsystem["toload"][name] = {} end
if loadingsystem["startupt"] == nil then loadingsystem["startupt"] = 20 end
	loadingsystem["fromload"] = loadingsystem["fromload"] +math.random( 2, 8 ) +loadingsystem["startupt"]
	loadingsystem["loadcount"] = loadingsystem["loadcount"] +1
	loadingsystem["toload"][name][1] = func
	loadingsystem["toload"][name][2] = text
	loadingsystem["toload"][name][3] = percent
	loadingsystem["toload"][name][4] = emittimeadd( loadingsystem["fromload"] )
	loadingsystem["toload"][name][5] = loadingsystem["loadcount"]
end

function loadingsystem.fakeload( text, apercent, bgca, fgca, drl ) --for fake loading screens
	local bgc = bgca or {["r"]=0,["g"]=0,["b"]=0,["a"]=0}
	local fgc = fgca or {["r"]=255,["g"]=255,["b"]=255,["a"]=255}
	local percent = apercent or 100
	local drawpercent = ( math.min( v[3], 100 ) /100 ) *( ( love.graphics.getWidth() /1.20 ) -16 )
emithook( "draw", "LS_fakeload", function( rl )
if rl ~= drl then return false end

love.graphics.setColor( bgc["r"] /255, bgc["g"] /255, bgc["b"] /255, bgc["a"] /255 )
love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )

love.graphics.setLineWidth( 5 )
love.graphics.setColor( fgc["r"] /255, fgc["g"] /255, fgc["b"] /255, fgc["a"] /255 )
love.graphics.setFont( self.resources["XfontX"]["loading_font"] )
if loadingsystem["title"] ~= nil then love.graphics.print( loadingsystem["title"], ( love.graphics.getWidth() /2 ) -( self.resources["XfontX"]["loading_font"]:getWidth( loadingsystem["title"] ) /2 ), love.graphics.getHeight() /2.50 -( self.resources["XfontX"]["loading_font"]:getHeight() /2 ) ) end

love.graphics.setFont( self.resources["XfontX"]["dev_font"] )
love.graphics.print( text, ( love.graphics.getWidth() /2 ) -( self.resources["XfontX"]["dev_font"]:getWidth( text ) /2 ), ( love.graphics.getHeight() /2.50 +( self.resources["XfontX"]["loading_font"]:getHeight( loadingsystem["title"] ) ) ) -68 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -( ( love.graphics.getWidth() /1.20 ) /2 ), ( love.graphics.getHeight() /2.50 +( self.resources["XfontX"]["loading_font"]:getHeight() ) ) -10, love.graphics.getWidth() /1.20, 40 )
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -( ( love.graphics.getWidth() /1.20 ) /2 ) +8, ( love.graphics.getHeight() /2.50 +( self.resources["XfontX"]["loading_font"]:getHeight() ) ) -2, drawpercent, 23 )

end)
if percent >= 100 then removehook( "draw", "LS_fakeload" ) end
end

function loadingsystem.loadresources()
emitresources( "XfontX", "loading_font", {[1]="fonts/verdana.ttf",[2]=120} )
emitresources( "XfontX", "dev_font", {[1]="fonts/verdana.ttf",[2]=42} )
end

function loadingsystem.init( self )
	loadingsystem["startupt"] = 0
end

function loadingsystem.think( self ) 
if loadingsystem["lastloaded"] == nil then loadingsystem["lastloaded"] = 0 end
if loadingsystem["complete"] == true then --dose loading screen animations
if loadingsystem["alpha"] == nil then loadingsystem["alpha"] = 1 end
if loadingsystem["whiteness"] == nil then loadingsystem["whiteness"] = 0 end

	loadingsystem["alpha"] = loadingsystem["alpha"] -0.015
	loadingsystem["whiteness"] = math.min( loadingsystem["whiteness"] +0.15, 1 )

if loadingsystem["alpha"] <= 0 then removeentity( self ) end
end

if loadingsystem["toload"] ~= nil and loadingsystem["complete"] ~= true then --loades content and updates loading display
	local loaddone = 0
for k,v in pairs( loadingsystem["toload"] ) do
if v[6] == true then loaddone = loaddone +1 end
if emittime() >= v[4] and v[6] ~= true and loadingsystem["lastloaded"] == v[5] -1 then
	loadingsystem["lastloaded"] = v[5]
	loadingsystem["toload"][k][6] = true
	loadingsystem["loadingbartext"] = v[2]
    loadingsystem["loadingbarscale"] = ( math.min( v[3], 100 ) /100 ) *( ( love.graphics.getWidth() /1.20 ) -16 )
	v[1]()
if string.find( k, "XresourcesX" ) ~= nil then --loades resouces
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
   end
end
if loaddone == loadingsystem["loadcount"] then
	loadingsystem["complete"] = true
      end
   end
end

function loadingsystem.draw( self ) 
if self.resources == nil and next( getresources() ) ~= nil then self.resources = getresources() end
if self.resources ~= nil and self.active ~= 0 then
if loadingsystem["alpha"] == nil then loadingsystem["alpha"] = 1 end
if loadingsystem["whiteness"] == nil then loadingsystem["whiteness"] = 0 end
if loadingsystem["loadingbarscale"] == nil then loadingsystem["loadingbarscale"] = 0 end
if loadingsystem["loadingbartext"] == nil then loadingsystem["loadingbartext"] = "loading the loading system" end

love.graphics.setColor( loadingsystem["whiteness"], loadingsystem["whiteness"], loadingsystem["whiteness"], loadingsystem["alpha"] )
love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )

if loadingsystem["whiteness"] <= 0.9999 then

	local alpha = loadingsystem["alpha"]

love.graphics.setLineWidth( 5 )
love.graphics.setColor( 1, 1, 1, alpha )
love.graphics.setFont( self.resources["XfontX"]["loading_font"] )
if loadingsystem["title"] ~= nil then love.graphics.print( loadingsystem["title"], ( love.graphics.getWidth() /2 ) -( self.resources["XfontX"]["loading_font"]:getWidth( loadingsystem["title"] ) /2 ), love.graphics.getHeight() /2.50 -( self.resources["XfontX"]["loading_font"]:getHeight() /2 ) ) end

love.graphics.setFont( self.resources["XfontX"]["dev_font"] )
love.graphics.print( loadingsystem["loadingbartext"], ( love.graphics.getWidth() /2 ) -( self.resources["XfontX"]["dev_font"]:getWidth( loadingsystem["loadingbartext"] ) /2 ), ( love.graphics.getHeight() /2.50 +( self.resources["XfontX"]["loading_font"]:getHeight( loadingsystem["title"] ) ) ) -68 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -( ( love.graphics.getWidth() /1.20 ) /2 ), ( love.graphics.getHeight() /2.50 +( self.resources["XfontX"]["loading_font"]:getHeight() ) ) -10, love.graphics.getWidth() /1.20, 40 )
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -( ( love.graphics.getWidth() /1.20 ) /2 ) +8, ( love.graphics.getHeight() /2.50 +( self.resources["XfontX"]["loading_font"]:getHeight() ) ) -2, loadingsystem.loadingbarscale, 23 )
   end
end
return ">"
end

emitentitytype( "loader", loadingsystem )

	local ent = spawnentity( "loader", "loaderent" )

