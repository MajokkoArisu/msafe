safezone = {}
safezone.plugin = RegisterPlugin('msafezone','1.0.0')
if GetMap() ~= 'mp/ffa3' then return end
safezone.players = {}
safezone.gatedests = {}
--safezone.bardests = {}
safezone.gatesafe = nil
safezone.inside = {}
--safezone.barsafe = nil
safezone.gatestr = "Disabled"
--safezone.barstr = "Disabled"
safezone.gateturn = true
--safezone.barturn = false
local max = GetCvar('sv_maxclients'):GetInteger()

safezone.gatedests['mp/ffa3'] = {525, 870, -1460, -1274, -120, 200}
--safezone.bardests['mp/ffa3'] = {1238, 2961, -943, 317, -168, 667}

function safezone.Gatecheck(k)
	if 
		k.x >= safezone.gatedests[GetMap()][1]
			and 
		k.x <= safezone.gatedests[GetMap()][2]
			and
		k.y >= safezone.gatedests[GetMap()][3]
			and 
		k.y <= safezone.gatedests[GetMap()][4]
			and
		k.z >= safezone.gatedests[GetMap()][5]
			and
		k.z <= safezone.gatedests[GetMap()][6]
	then
		return true
	else
		return false
	end
end

--[[function safezone.Barcheck(k)
	if 
		k.x >= safezone.bardests[GetMap()][1]
			and 
		k.x <= safezone.bardests[GetMap()][2]
			and
		k.y >= safezone.bardests[GetMap()][3]
			and 
		k.y <= safezone.bardests[GetMap()][4]
			and
		k.z >= safezone.bardests[GetMap()][5]
			and
		k.z <= safezone.bardests[GetMap()][6]
	then
		return true
	else
		return false
	end
end

function safezone.checksafe(k)
	if k.isDueling == false and k.isBot == false then 
		return true 
	else 
		return false 
	end
end

function safezone.regreg(k)
	if safezone.players[ply.id] then return end
	
	local tt = {}
	
	tt.on = false
	
	safezone.players[ply.id] = tt
end--]]

function safezone.gatezone()
	if safezone.gateturn == true then
		for i = 0,max do
			if GetPlayer(i) ~= nil and GetPlayer(i).team ~= 'spectator' then
				local ply = GetPlayer(i)
					--safezone.regreg(ply)
					if safezone.Gatecheck(ply.position) == true then
					safezone.gateenter(ply)
					else
					safezone.gateexit(ply)
					end
			end
		end
	end
end

--[[function safezone.gateply2(ply)
	if safezone.checksafe(ply) == true and safezone.Gatecheck(ply.position) == true then
			if not tt or tt == 0 then
				SendConsoleCommand(2, 'zzf '..ply.id..'')
				tt = 1
			elseif tt == 1 then
				ply.weapon = 3
				ply.force = 10
				ply.isHolstered = 3
			else
				tt = 0
			end
	elseif safezone.checksafe(ply) == false and safezone.Gatecheck(ply.position) == false then
			if tt == 1 then
				tt = 0
				SendReliableCommand(-1, 'print "checksafe false tt = 0 \n"')
			end
	end
end--]]

function safezone.gateply(k)
k.weapon = 3
k.force = 10
k.isHolstered = 3
end

function safezone.gateenter(ply)
if safezone.inside[ply.id] ~= true then
		for w=0,19 do 
		ply:Take('weapon',w)
		end
		safezone.inside[ply.id] = true
end
end

function safezone.gateexit(ply)
if safezone.inside[ply.id] == true
		safezone.inside[ply.id] = false
		ply.weapon = 3
end
end

AddListener('JPLUA_EVENT_RUNFRAME', safezone.gatezone)
