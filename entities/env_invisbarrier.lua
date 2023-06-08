
	local ENT = {}

function ENT.setposandsize( self, xa, ya, sxa, sya )
	self.x, self.y, self.sizex, self.sizey = xa, ya, sxa, sya
	self.hboxsx, self.hboxsy = sxa, sya
end

function ENT.init( self )
	self.x, self.y = 0, 0
	self.sizex, self.sizey = 0, 0
	self.setposandsize = ENT.setposandsize
	self.collideable = true
end

function ENT.draw( self )
mua.drawdevbox( self.x, self.y, self.sizex, self.sizey, {["r"]=180,["g"]=0,["b"]=180} )
return -1
end

emitentitytype( "env_invisbarrier", {["loadresourcetypes"]=ENT.loadresourcetypes,["loadresources"]=ENT.loadresources,["init"]=ENT.init,["onremove"]=ENT.onremove,["think"]=ENT.think,["draw"]=ENT.draw,["mousepress"]=ENT.mousepress,["keypress"]=ENT.keypress,} )
