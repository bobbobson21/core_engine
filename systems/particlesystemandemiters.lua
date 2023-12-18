	
	particlesystem = {}

emithook( "think.bypass", "particlesystem_pausefix", function()
for k,v in pairs( particlesystem.particles ) do
if v.pauselifetime == nil then v.pauselifetime = v.lifetime -emittime() end
	v.lifetime = emittime() +v.pauselifetime
if v.fadedata ~= nil then
for l,w in pairs( v.fadedata ) do
if w.endtime ~= nil then
if w.pauseendtime == nil then w.pauseendtime = w.endtime -emittime() end
	w.endtime = emittime() +w.pauseendtime
	        end
	     end
      end
   end
end)

function particlesystem.adddepth( mind, maxd ) --particles use there own render depth system which can be controlled here
	local addedpartcore = false
for z = mind, maxd do
	local ent = spawnentity( "particleemiter", "partemiter_"..tostring( z ) )
	ent.renderlevel = z
	ent.active = 1
if addedpartcore ~= true then ent.runparticlecore, addedpartcore = 1, true end
   end
end

function particlesystem.removeparticle( identifyer, confirm ) --removes a particle
if identifyer == nil and confirm == true then
for k,v in pairs( particlesystem.particles ) do runhook( "particle_onremove", {v} ) end
mua.tableempty( particlesystem.particles ) --removes all particles with confirmation
end
if identifyer ~= nil then
runhook( "particle_onremove", particlesystem["particles"][identifyer] )
	particlesystem["particles"][identifyer] = nil --removes a particle with an identifyer
   end
end

function particlesystem.spawnparticles( identifyer ) --spawns a particle
if emittimesync() <= 2 then 
if particlesystem.particles == nil then particlesystem.particles = {} end

	local id = {[1]=1,[2]=false}

if identifyer == nil then			
for z = 1, table.maxn( particlesystem.particles ) +1 do
if particlesystem.particles[z] == nil and id[2] == false then
	id = {[1]=z,[2]=true}
      end
   end
else
	id = {[1]=identifyer}
end

	particlesystem["particles"][id[1]] = {}
return _G["particlesystem"]["particles"][id[1]]
else
return {}
   end
end

function particlesystem.getparticle( identifyer ) --gets a particle
if particlesystem.particles == nil then particlesystem.particles = {} end
if identifyer ~= nil then
return particlesystem.particles[identifyer]
else
   return particlesystem.particles
   end
end

function particlesystem.emiteffect( identifyer, effect ) --creates effects
if particlesystem.effects == nil then particlesystem.effects = {} end
particlesystem["effects"][identifyer] = effect
end

function particlesystem.spawneffect( identifyer, tbl ) --spawns effects
if particlesystem.effects == nil then particlesystem.effects = {} end
if particlesystem["effects"][identifyer] ~= nil then
particlesystem["effects"][identifyer]( particlesystem.spawnparticles, tbl )
   end
end

function particlesystem.loadresources()
emitresources( "XimageX", "normalparicletexture", "textures/part.png" )
emitresources( "XpartrenderX", "normalparicle", function( r, g, b, a, x, y, ang, size ) 
love.graphics.setColor( r, g, b, a )
love.graphics.push()
love.graphics.translate( x, y )
love.graphics.rotate( ang )
love.graphics.translate( -2 *size, -2 *size )
love.graphics.rectangle("fill", 0, 0, 4 *size, 4 *size )
love.graphics.pop()
   end)
end

function particlesystem.think( self ) --updates particles
if self.runparticlecore == 1 then
if emittime ~= nil then
if particlesystem.particles == nil then particlesystem.particles = {} end
if mua.tableisempty( particlesystem.particles ) == false then
for k,v in pairs( particlesystem.particles ) do
if v.active ~= 0 then
	v.pauselifespan = nil
runhook( "particle_think", {v} )
end

if v.thinkfunc ~= nil then v.thinkfunc( v ) end
if v.velocityx ~= 0 then v.x = v.x +v.velocityx end
if v.velocityy ~= 0 then v.y = v.y +v.velocityy end
if v.velocityang ~= 0 then v.ang = v.ang +v.velocityang end

if v.fadedata ~= nil then
for l,w in pairs( v.fadedata ) do
	w.pauseendtime = nil
if w.starttime == nil then w.starttime = emittime() end
if w.endtime == nil then w.endtime = v.lifetime end
	local lifespan =  math.min( ( emittime() -w.starttime ) /( w.endtime -w.starttime ), 1 ) 
	local fadecode = ( w.max +lifespan *( w.min -w.max ) )
	v[tostring( w.var )] = fadecode
   end
end

if v.lifetime <= emittime() then
	runhook( "particle_onremove", {v} )
	v.active = 0
	v.fadedata = nil
if v.disallowremove ~= 1 then
	particlesystem.particles[v] = nil
	particlesystem.particles[k] = nil
                  end
               end
		    end
         end
      end
   end
end

function particlesystem.draw( self )
if self.resources == nil and mua.tableisempty( getresources() ) == false then self.resources = getresources() end
if self.resources ~= nil and self.active ~= 0 then

if particlesystem.particles ~= nil then
for k,v in pairs( particlesystem.particles ) do
if v.active ~= 0 and v.renderlevel == self.renderlevel then

	local returned = {[1]=runhook( "particle_predraw", {v} ),} --use this to draw before all particles

if returned[1] ~= nil then for k,v in pairs( returned[1] ) do if v == false then returned[2] = false end end end

if returned[2] ~= false then
if v.image ~= nil and v.renderable == nil then
love.graphics.setColor( v.r, v.g, v.b, v.a )
love.graphics.draw( v.image, v.x, v.y, v.ang, v.size, v.size, v.image:getWidth() /2, v.image:getHeight() /2 )
love.graphics.setColor( 1, 1, 1, 1 )
end
if v.image == nil and v.renderable ~= nil then
v.renderable( v.r, v.g, v.b, v.a, v.x, v.y, v.ang, v.size )
   end
end

runhook( "particle_postdraw", {v} ) --use this to draw after all particles

            end
         end
      end
   end
end

emitentitytype( "particleemiter", particlesystem )

	local ent = spawnentity( "particleemiter", "particalcontrol" )
