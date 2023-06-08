	mua = {}

function mua.drawdevbox( x, y, sx, sy, col )
if gameindevmode() == true then
love.graphics.setLineWidth( 2 )
love.graphics.setColor( col["r"] /255, col["g"] /255, col["b"] /255, 0.80 )
love.graphics.rectangle("fill", x, y, sx, sy )
love.graphics.setColor( 1, 1, 1, 1 )
love.graphics.rectangle("line", x, y, sx, sy )
love.graphics.setLineWidth( 1 )
   end
end

function mua.controlemaster( key, ... )
if type( key ) == "string" then return love.keyboard.isDown( key, ... ) else return love.mouse.isDown( key ) end
end 

function mua.stringsplit( orgstr, spliter, pattern )
	local str, searchfind, tbl = orgstr..spliter, 1, {}
if spliter == "" then for z = 1, string.len( orgstr ) do tbl[z] = string.sub( orgstr, z, z ) end end
if spliter ~= "" then
if string.find( str, spliter, 1, pattern ) == nil then
	tbl[1] = orgstr
else
for z = 1, string.len( str ) do
	local searchstart, searchend = string.find( str, spliter, z, pattern )
if searchstart == nil and searchend == nil then return tbl end
if searchstart ~= nil and searchend ~= nil and z >= searchfind then
if string.sub( str, searchfind, searchstart -1 ) ~= "" then tbl[table.maxn( tbl ) +1] = string.sub( str, searchfind, searchstart -1 ) end

	searchfind = searchend +1

         end
      end
   end
end
return tbl
end

function mua.emitreindextable( tbl, keystoremove )

	local tblb = tbl

if keystoremove ~= nil then
if type( keystoremove ) ~= "table" then
	tblb[keystoremove] = nil
else
for z = 1, table.maxn( tblb ) do
for y = 1, table.maxn( keystoremove ) do
if tblb[z] == keystoremove[y] then
	tblb[z] = nil
            end
         end
      end
   end 
end

for z = 1, table.maxn( tblb ) do
if tblb[z] == nil then

for y = z, table.maxn( tblb ) do
if tblb[y] ~= nil and tblb[z] == nil then	
	
	tblb[z] = tblb[y]
	tblb[y] = nil
	
            end	
         end
      end
   end
return tblb
end

function mua.tableisempty( tbl )
return next( tbl ) == nil
end

function mua.tableempty( tbl )
for k, v in pairs( tbl ) do
	tbl[k] = nil
   end
end

function mua.tablecount( tbl )
	local count = 0
for k,v in pairs( tbl ) do count = count +1 end
return count
end

function mua.resizeto( ixa, iya, ixb, iyb )
if ixa ~= nil and iya ~= nil and ixb ~= nil and iyb ~= nil then

	local sx = ixb /ixa
	local sy = iyb /iya

return sx, sy
else
   return 1, 1
   end
end

function mua.numbertocharter( num )
local converter = {[1]="A",[2]="B",[3]="C",[4]="D",[5]="E",[6]="F",[7]="G",[8]="H",[9]="I",[10]="J",[11]="K",[12]="L",[13]="M",[14]="N",[15]="O",[16]="P",[17]="Q",[18]="R",[19]="S",[20]="T",[21]="U",[22]="V",[23]="W",[24]="X",[25]="Y",[26]="Z",}
if num ~= nil then return converter[num] else return converter end
end

function mua.chartertonumber( charter )
local converter = {["A"]=1,["B"]=2,["C"]=3,["D"]=4,["E"]=5,["F"]=6,["G"]=7,["H"]=8,["I"]=9,["J"]=10,["K"]=11,["L"]=12,["M"]=13,["N"]=14,["O"]=15,["P"]=16,["Q"]=17,["R"]=18,["S"]=19,["T"]=20,["U"]=21,["V"]=22,["W"]=23,["X"]=24,["Y"]=25,["Z"]=26,}
if charter ~= nil then return converter[string.upper( charter )] else return converter end
end

function mua.invertinrange( num, minn, maxn )
	local maxv, inverter = maxn +1, {}
for z = minn, maxn do inverter[z]=( maxv -z ) end
if num == nil or num > maxn or num < minn then return inverter end
return inverter[num]
end

function mua.randompoint( low, high )
return low +( high -low ) *math.random()
end

function mua.isboxinbox( xa, ya, wa, ha, xb, yb, wb, hb )
return xa < xb+wb and xb < xa+wa and ya < yb+hb and yb < ya+ha
end

function mua.distance( xa, ya, xb, yb )
return math.sqrt( ( xa - xb )^2 +( ya - yb )^2 )
end