
	local ENT = {}

function ENT.setposandsize( self, xa, ya, sxa, sya )
	self.x, self.y, self.sizex, self.sizey = xa, ya, sxa, sya
end

function ENT.init( self )
	self.x, self.y = 0, 0
	self.sizex, self.sizey = 0, 0
end

function ENT.think( self )
if self.active ~= 0 then
if playerget() ~= nil then
	local ply = playerget()
if mua.isboxinbox( self.x, self.y, self.sizex, self.sizey, ply.x, ply.y, ply.hboxsx, ply.hboxsy ) == true then
if self.triggeractive ~= true then --is trigger on also note active genrally means dose it exsist in rendering and physicality
	self.triggeractive = true
if self.triggeroutput ~= nil and self.firstentered ~= true then self.triggeroutput( self, ply, "firstentered" ) end --self.triggeroutput exsists it runs that
if self.triggeroutput ~= nil then self.triggeroutput( self, ply, "entered" ) end
	self.firstentered = true
end
else
if self.triggeractive ~= nil then
	self.triggeractive = nil
if self.triggeroutput ~= nil and self.firstleft ~= true then self.triggeroutput( self, ply, "firstleft" ) end
if self.triggeroutput ~= nil then self.triggeroutput( self, ply, "left" ) end
	self.firstleft = true
            end
         end
      end
   end
end

function ENT.draw( self )
	local distrig = 80
if self.triggeractive == true then distrig = 255 end
if self.active ~= 0 then mua.drawdevbox( self.x, self.y, self.sizex, self.sizey, {["r"]=255,["g"]=distrig,["b"]=0} ) end
return 1
end

emitentitytype( "obj_trigger", ENT )
