
	local ENT = {}

function ENT.loadresources()
emitresources( "XfontX", "menutitle_font", {[1]="fonts/retro.ttf",[2]=80} )
emitresources( "XfontX", "menubutton_font", {[1]="fonts/retro.ttf",[2]=40} )
emitresources( "XfontX", "menutext_font", {[1]="fonts/count.ttf",[2]=16} )
emitresources( "XfontX", "menuaction_font", {[1]="fonts/retro.ttf",[2]=32} )
soundsystem.emitgroup( "menubuttonclick_sound", {
emitresources( "XsoundX", "menubuttonclick_sound1", {[1]="sounds/menu/sound_menuclick1.wav",[2]="static"} ),
emitresources( "XsoundX", "menubuttonclick_sound2", {[1]="sounds/menu/sound_menuclick2.wav",[2]="static"} ),
emitresources( "XsoundX", "menubuttonclick_sound3", {[1]="sounds/menu/sound_menuclick3.wav",[2]="static"} ),
emitresources( "XsoundX", "menubuttonclick_sound4", {[1]="sounds/menu/sound_menuclick4.wav",[2]="static"} ),
})
end

function ENT.init( self )

	self.pgtext = "play game"
	self.qgtext = "quit game"
	self.startlevel = "lv1"
	self.backgroundlevel = "lvl_bg"
	
	self.menu = 1
	self.darkness = 0
	self.settings = {[1]="e",[2]=1,[3]="right",[4]="left",[5]="space",[6]="escape",[7]=10}
	self.pausekey = "escape" 
	self.musicvolume = self.settings[7]

soundsystem.volumemusic( self.settings[7] )
	
	local contents, size = love.filesystem.read( "save.dat" )
if contents ~= nil and contents ~= "" and contents ~= "nil" then self.pgtext = "continue" end
emithook( "think.bypass", "point_mainmenu-"..tostring( emitentitytypeinfo( self )["identifyer"] ), function() ENT.think( self ) end)

	local contentsb, sizeb = love.filesystem.read( "settings.dat" )
	
if contentsb ~= nil and contentsb ~= "" and contentsb ~= "nil" then
	contentsb = mua.stringsplit( contentsb, "|" )
for z = 1, table.maxn( contentsb ) do if string.find( contentsb[z], "XnumX" ) ~= nil then contentsb[z] = tonumber( string.sub( contentsb[z], 7, string.len( contentsb[z] ) -1 ) ) end end
	self.settings = contentsb
	self.pausekey = self.settings[6]
	self.musicvolume = self.settings[7]
soundsystem.volumemusic( self.settings[7] )
playersetcontroles( {["left"]=self.settings[4],["right"]=self.settings[3],["jump"]=self.settings[5],["attack"]=self.settings[2],["use"]=self.settings[1]} )
   end
end

function ENT.think( self )
if levels.activelevel == nil and self.backgroundlevel ~= nil and self.pauseon ~= true and self.qgtext == "quit game" and self.pgtext == "play game" then levels.loadlevelraw( self.backgroundlevel ) end

if self.menu == -1 and self.active ~= 0 then
if mua.isboxinbox( ( ( love.graphics.getWidth() /2 ) +love.graphics.getWidth() /4 ) +19, ( love.graphics.getHeight() /1.40 ) -340, 60, 372, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then 
if love.mouse.isDown( 1 ) == true then
	self.musicvolume = math.max( math.min( ( ( love.mouse.getY() -( ( ( (love.graphics.getHeight() /1.40 ) -290 ) ) ) ) /309 ) *100, 100 ) , 0 )
	self.settings[7] = self.musicvolume
soundsystem.volumemusic( self.musicvolume )
if self.settingtoapply ~= true then self.settingtoapply = true end
	  end
   end
end

if self.darknessdir ~= nil and self.darkness ~= nil then
if self.darkness <= 154 and self.darknessdir == 1 then self.darkness = math.min( 150, self.darkness +4 ) end
if self.darkness >= 151 and self.darknessdir == 1 then self.darkness = math.max( 150, self.darkness -4 ) end
if self.darkness >= 1 and self.darknessdir == 0 then self.darkness = math.max( 0, self.darkness -4 ) end
end

if self.menuloadicontime ~= nil then
if emittime() <= self.menuloadicontime then
if self.rotloadicon == nil then self.rotloadicon = 0 end
if self.menuloadiconrdw ~= true then self.rotloadicon = self.rotloadicon +0.08 else self.rotloadicon = self.rotloadicon -0.08 end
if emittime() >= self.menuloadicontime then self.menuloadicontime, self.rotloadicon, self.menuloadiconcolor, self.menuloadiconrdw = nil, nil, nil, nil end
      end
   end
end

function ENT.draw( self )
if getresourcesloaded() == true then

love.graphics.setLineWidth( 4 )

love.graphics.setColor( 0, 0, 0, self.darkness /255 )
love.graphics.rectangle( "fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight() )

love.graphics.setColor( 1, 1, 1, 1 )

if self.menuloadicontime ~= nil then
if emittime() <= self.menuloadicontime then
if self.rotloadicon == nil then self.rotloadicon = 0 end
love.graphics.setColor( 1, 1, 1, 1 )
if self.menuloadiconcolor ~= nil then love.graphics.setColor( self.menuloadiconcolor["r"] /255, self.menuloadiconcolor["g"] /255, self.menuloadiconcolor["b"] /255, 1 ) end
love.graphics.push()
love.graphics.translate( love.graphics.getWidth() -30, 30 )
love.graphics.rotate( self.rotloadicon )
love.graphics.translate( -10, -10 )
love.graphics.rectangle("line", 0, 0, 20, 20 )
love.graphics.pop()
   end
end

if self.active ~= 0 then
if self.menu == 1 then

love.graphics.setColor( 0, 0, 0, 1 )
love.graphics.setFont( getresources("XfontX", "menutitle_font") )
love.graphics.print( gamewindowtitle(), ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menutitle_font"):getWidth( gamewindowtitle() ) /2 ) +6, ( love.graphics.getHeight() /1.40 ) -348 +6 )
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.print( gamewindowtitle(), ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menutitle_font"):getWidth( gamewindowtitle() ) /2 ), ( love.graphics.getHeight() /1.40 ) -348 )

love.graphics.setColor( 0, 0, 0, 0.60 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -240, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 0.80 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -240, love.graphics.getWidth() /2, 80 )
love.graphics.setColor( 0, 0, 0, 0.60 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -140, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 0.80 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -140, love.graphics.getWidth() /2, 80 )
love.graphics.setColor( 0, 0, 0, 0.60 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -40, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 0.80 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -40, love.graphics.getWidth() /2, 80 )
love.graphics.setColor( 0, 0, 0, 0.60 )

love.graphics.setColor( 1, 1, 1, 1 )

love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -240, love.graphics.getWidth() /2, 80 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -140, love.graphics.getWidth() /2, 80 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -40, love.graphics.getWidth() /2, 80 )

love.graphics.setFont( getresources("XfontX", "menubutton_font") )
love.graphics.print( self.pgtext, ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menubutton_font"):getWidth( self.pgtext ) /2 ), ( love.graphics.getHeight() /1.40 ) -220 )
love.graphics.print( "settings", ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menubutton_font"):getWidth( "settings" ) /2 ), ( love.graphics.getHeight() /1.40 ) -120 )
love.graphics.print( self.qgtext, ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menubutton_font"):getWidth( self.qgtext ) /2 ), ( love.graphics.getHeight() /1.40 ) -20 )
end

if self.menu == -1 then

love.graphics.setColor( 0, 0, 0, 1 )
love.graphics.setFont( getresources("XfontX", "menutitle_font") )
love.graphics.print( "settings", ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menutitle_font"):getWidth( "settings" ) /2 ) +6, ( love.graphics.getHeight() /1.40 ) -448 +6 )
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.print( "settings", ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menutitle_font"):getWidth( "settings" ) /2 ), ( love.graphics.getHeight() /1.40 ) -448 )

love.graphics.setColor( 0, 0, 0, 0.60 )
if mua.isboxinbox( ( ( love.graphics.getWidth() /2 ) +love.graphics.getWidth() /4 ) +19, ( love.graphics.getHeight() /1.40 ) -340, 60, 372, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 0.80 ) end
love.graphics.rectangle( "fill", ( ( love.graphics.getWidth() /2 ) +love.graphics.getWidth() /4 ) +19, ( love.graphics.getHeight() /1.40 ) -340, 61, 372 )
love.graphics.setColor( 0, 0, 0, 0.60 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) +52, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then love.graphics.setColor( 0, 0, 0, 0.80 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) +52, love.graphics.getWidth() /2, 80 )
love.graphics.setColor( 0, 0, 0, 0.60 )
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -340, love.graphics.getWidth() /2, 372 )

love.graphics.setColor( 0, 0, 0, 0 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -284, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox == nil or self.cursentbox == 1 then love.graphics.setColor( 0, 0, 0, 0.60 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -284, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.setColor( 0, 0, 0, 0 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -234, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox == nil or self.cursentbox == 2 then love.graphics.setColor( 0, 0, 0, 0.60 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -234, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.setColor( 0, 0, 0, 0 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -184, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox == nil or self.cursentbox == 3 then love.graphics.setColor( 0, 0, 0, 0.60 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -184, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.setColor( 0, 0, 0, 0 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -134, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox == nil or self.cursentbox == 4 then love.graphics.setColor( 0, 0, 0, 0.60 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -134, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.setColor( 0, 0, 0, 0 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -84, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox == nil or self.cursentbox == 5 then love.graphics.setColor( 0, 0, 0, 0.60 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -84, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.setColor( 0, 0, 0, 0 )
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -34, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox == nil or self.cursentbox == 6 then love.graphics.setColor( 0, 0, 0, 0.60 ) end
love.graphics.rectangle( "fill", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -34, ( love.graphics.getWidth() /2 ) -301, 40 )

love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) +52, love.graphics.getWidth() /2, 80 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -340, love.graphics.getWidth() /2, 372 )
love.graphics.rectangle( "line", ( ( love.graphics.getWidth() /2 ) +love.graphics.getWidth() /4 ) +19, ( love.graphics.getHeight() /1.40 ) -340, 61, 372 )

love.graphics.rectangle( "fill", math.floor( ( ( ( love.graphics.getWidth() /2 ) +love.graphics.getWidth() /4 ) +50.50 ) -( getresources("XfontX", "menubutton_font"):getWidth( "M" ) /2 ) ), ( love.graphics.getHeight() /1.40 ) -290, 32, ( self.musicvolume /100 ) *309 )

love.graphics.setFont( getresources("XfontX", "menubutton_font") )
love.graphics.print( "M", math.floor( ( ( ( love.graphics.getWidth() /2 ) +love.graphics.getWidth() /4 ) +50.50 ) -( getresources("XfontX", "menubutton_font"):getWidth( "M" ) /2 ) ), math.floor( ( love.graphics.getHeight() /1.40 ) -330 ) )
love.graphics.print( "back to menu and apply", math.floor( ( love.graphics.getWidth() /2 ) -( getresources("XfontX", "menubutton_font"):getWidth( "back to menu and apply" ) /2 ) ), math.floor( ( love.graphics.getHeight() /1.40 ) +72 ) )
love.graphics.print( "action", math.floor( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +31 ), math.floor( ( love.graphics.getHeight() /1.40 ) -330 ) )
love.graphics.print( "key", math.floor( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +270 ), math.floor( ( love.graphics.getHeight() /1.40 ) -330 ) )

love.graphics.setFont( getresources("XfontX", "menuaction_font") )
love.graphics.print( "use object", math.floor( ( love.graphics.getWidth() /2 ) -( love.graphics.getWidth() /4 ) +40.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -280 ) +0.50 ) )
love.graphics.print( "attack", math.floor( ( love.graphics.getWidth() /2 ) -( love.graphics.getWidth() /4 ) +40.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -230 ) +0.50 ) )
love.graphics.print( "Right", math.floor( ( love.graphics.getWidth() /2 ) -( love.graphics.getWidth() /4 ) +40.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -180 ) +0.50 ) )
love.graphics.print( "LeFt", math.floor( ( love.graphics.getWidth() /2 ) -( love.graphics.getWidth() /4 ) +40.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -130 ) +0.50 ) )
love.graphics.print( "jump", math.floor( ( love.graphics.getWidth() /2 ) -( love.graphics.getWidth() /4 ) +40.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -80 ) +0.50 ) )
love.graphics.print( "pause", math.floor( ( love.graphics.getWidth() /2 ) -( love.graphics.getWidth() /4 ) +40.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -30 ) +0.50 ) )


	local ds = {[1]=self.settings[1],[2]=self.settings[2],[3]=self.settings[3],[4]=self.settings[4],[5]=self.settings[5],[6]=self.settings[6]}

for z = 1, table.maxn( self.settings ) do
if type( ds[z] ) == "number" then ds[z] = "MOUSE "..tostring( ds[z] ) end
if self.cursentbox == z then ds[z] = "><" end
if ds[z] == nil then ds[z] = "err?:/invalid_key_link" end
if ds[z] == "right" then ds[z] = "RIGHT ARROW" end
if ds[z] == "left" then ds[z] = "LEFT ARROW" end
if ds[z] == "down" then ds[z] = "DOWN ARROW" end
if ds[z] == "up" then ds[z] = "UP ARROW" end
if ds[z] == "space" then ds[z] = "SPACE" end
if ds[z] == "escape" then ds[z] = "ESCAPE" end
if string.len( tostring( ds[z] ) ) == 1 then ds[z] = string.upper( ds[z] ) end
end

love.graphics.print( ds[1], math.floor( ( ( love.graphics.getWidth() /2 ) +122 ) -( getresources("XfontX", "menuaction_font"):getWidth( ds[1] ) /2 ) +0.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -280 ) +0.50 ) )
love.graphics.print( ds[2], math.floor( ( ( love.graphics.getWidth() /2 ) +122 ) -( getresources("XfontX", "menuaction_font"):getWidth( ds[2] ) /2 ) +0.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -230 ) +0.50 ) )
love.graphics.print( ds[3], math.floor( ( ( love.graphics.getWidth() /2 ) +122 ) -( getresources("XfontX", "menuaction_font"):getWidth( ds[3] ) /2 ) +0.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -180 ) +0.50 ) )
love.graphics.print( ds[4], math.floor( ( ( love.graphics.getWidth() /2 ) +122 ) -( getresources("XfontX", "menuaction_font"):getWidth( ds[4] ) /2 ) +0.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -130 ) +0.50 ) )
love.graphics.print( ds[5], math.floor( ( ( love.graphics.getWidth() /2 ) +122 ) -( getresources("XfontX", "menuaction_font"):getWidth( ds[5] ) /2 ) +0.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -80 ) +0.50 ) )
love.graphics.print( ds[6], math.floor( ( ( love.graphics.getWidth() /2 ) +122 ) -( getresources("XfontX", "menuaction_font"):getWidth( ds[6] ) /2 ) +0.50 ), math.floor( ( ( love.graphics.getHeight() /1.40 ) -30 ) +0.50 ) )

love.graphics.setColor( 0.80, 0.80, 0.80, 1 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +33, ( love.graphics.getHeight() /1.40 ) -284, 229, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +33, ( love.graphics.getHeight() /1.40 ) -234, 229, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +33, ( love.graphics.getHeight() /1.40 ) -184, 229, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +33, ( love.graphics.getHeight() /1.40 ) -134, 229, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +33, ( love.graphics.getHeight() /1.40 ) -84, 229, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +33, ( love.graphics.getHeight() /1.40 ) -34, 229, 40 )
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -284, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -234, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -184, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -134, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -84, ( love.graphics.getWidth() /2 ) -301, 40 )
love.graphics.rectangle( "line", ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -34, ( love.graphics.getWidth() /2 ) -301, 40 )

   end
end
love.graphics.setLineWidth( 1 )
end
return 4
end

function ENT.mousepress( self, x, y, side, touching )
	local escapejam = ""
if self.pauseon == true then
if side == self.pausekey then
if side ~= escapejam then
	local done = false
if self.active ~= 0 and done == false then
	self.active, self.darknessdir, done = 0, 0, true
levels.freezelevel( false )
if gameindevmode() ~= true then love.mouse.setVisible( false ) end
end
if self.active == 0 and done == false then
	self.active, self.darknessdir, done = 1, 1, true
levels.freezelevel( true )
if gameindevmode() ~= true then love.mouse.setVisible( true ) end
end
	self.cursentbox = nil
	self.menu = 1
	  end
   end
end

if self.active ~= 0 then
if self.cursentbox ~= nil then
	local abuttonact = false
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -284, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox ~= 1 then abuttonact = true end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -234, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox ~= 2 then abuttonact = true end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -184, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox ~= 3 then abuttonact = true end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -134, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox ~= 4 then abuttonact = true end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -84, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox ~= 5 then abuttonact = true end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -34, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true and self.cursentbox ~= 6 then abuttonact = true end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) +52, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then abuttonact = true end 
if abuttonact == false then
for z = 1, table.maxn( self.settings ) do if self.settings[z] == side and z ~= self.cursentbox then return false end end
soundsystem.playsound( soundsystem.getgroup( "menubuttonclick_sound" ), 0 )
	self.hold = true
	self.settings[self.cursentbox] = side
	self.cursentbox = nil
	self.settingtoapply = true
   end
end

if side == 1 then
if self.menu == 1 and self.hold ~= true then
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -240, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then
soundsystem.playsound( soundsystem.getgroup( "menubuttonclick_sound" ), 0 )
if self.pgtext == "resume game" then
	self.active = 0
	self.darknessdir = 0
levels.freezelevel( false )
if gameindevmode() ~= true then love.mouse.setVisible( false ) end
else
	self.hold = true
	self.savedata = self.startlevel
	local contents, size = love.filesystem.read( "save.dat" )
if contents ~= nil and contents ~= "" and contents ~= "nil" then self.savedata = contents end
levels.loadlevel( self.savedata )
if gameindevmode() ~= true then love.mouse.setVisible( false ) end
   end
end

if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -140, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then
soundsystem.playsound( soundsystem.getgroup( "menubuttonclick_sound" ), 0 )
	self.hold = true
	self.menu = -1
end

if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) -40, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then
if self.qgtext == "quit game" then love.event.quit( "quit" ) end
if self.qgtext == "exit level" then
	levels.dontwrite = false
soundsystem.playsound( soundsystem.getgroup( "menubuttonclick_sound" ), 0 )
levels.freezelevel( false )
levels.unloadlevel()
      end
   end
end

if self.menu == -1 and self.hold ~= true then
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -284, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then self.cursentbox = 1 end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -234, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then self.cursentbox = 2 end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -184, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then self.cursentbox = 3 end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -134, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then self.cursentbox = 4 end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -84, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then self.cursentbox = 5 end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4 +271, ( love.graphics.getHeight() /1.40 ) -34, ( love.graphics.getWidth() /2 ) -301, 40, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then self.cursentbox = 6 end
if self.cursentbox ~= nil then soundsystem.playsound( soundsystem.getgroup( "menubuttonclick_sound" ), 0 ) end
if mua.isboxinbox( ( love.graphics.getWidth() /2 ) -love.graphics.getWidth() /4, ( love.graphics.getHeight() /1.40 ) +52, love.graphics.getWidth() /2, 80, love.mouse.getX(), love.mouse.getY(), 1, 1 ) == true then
soundsystem.playsound( soundsystem.getgroup( "menubuttonclick_sound" ), 0 )
	self.cursentbox = nil
	self.menu = 1
	self.hold = true

if self.settingtoapply == true then

	self.menuloadicontime = emittimeadd( 240 )
	self.oldsettings = self.settings
	self.pausekey = self.settings[6]
	local sfs = {[1]=self.settings[1],[2]=self.settings[2],[3]=self.settings[3],[4]=self.settings[4],[5]=self.settings[5],[6]=self.settings[6],[7]=self.settings[7]}
	
playersetcontroles( {["left"]=self.settings[4],["right"]=self.settings[3],["jump"]=self.settings[5],["attack"]=self.settings[2],["use"]=self.settings[1]} )
for z = 1, table.maxn( self.settings ) do if type( sfs[z] ) == "number" then sfs[z] = "XnumX["..tostring( sfs[z] ).."]" end end
love.filesystem.write( "settings.dat", sfs[1].."|"..sfs[2].."|"..sfs[3].."|"..sfs[4].."|"..sfs[5].."|"..sfs[6].."|"..sfs[7] )

	self.settingtoapply = nil

            end
         end
      end
   end
end
	self.hold = nil
end

function ENT.keypress( self, key, scancode, isrepet )

	local escapejam = ""

if self.cursentbox ~= nil then
for z = 1, table.maxn( self.settings ) do if self.settings[z] == key and z ~= self.cursentbox then return false end end
soundsystem.playsound( soundsystem.getgroup( "menubuttonclick_sound" ), 0 )
	self.settings[self.cursentbox] = key
	self.cursentbox = nil
	self.settingtoapply = true
	escapejam = key
end

if self.pauseon == true then
if key == self.pausekey then
if key ~= escapejam then
	local done = false
if self.active ~= 0 then
	self.active, self.darknessdir = 0, 0
levels.freezelevel( false )
if gameindevmode() ~= true then love.mouse.setVisible( false ) end
end
if self.active == 0 then
	self.active, self.darknessdir = 1, 1
levels.freezelevel( true )
if gameindevmode() ~= true then love.mouse.setVisible( true ) end
end
	self.cursentbox = nil
	self.menu = 1
	     end
	  end
   end
end

emitentitytype( "point_mainmenu", ENT )

	local ent = spawnentity( "point_mainmenu", "mainmenu" )
