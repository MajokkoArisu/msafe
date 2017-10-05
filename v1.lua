local safezoneregister = RegisterPlugin('msafezone','1.0.0')
if GetMap() ~= 'mp/ffa3' then return end
local gatedests = {}
local bardests = {}
local gatesafe
local barsafe
local max = GetCvar('sv_maxclients'):GetInteger()

gatedests['mp/ffa3'] = {525, 870, -1460, -1274, -120, 200}
bardests['mp/ffa3'] = {1238, 2961, -943, 317, -168, 667}



function Gatecheck(k)
	if 
		k.x >= gatedests[GetMap()][1]
			and 
		k.x <= gatedests[GetMap()][2]
			and
		k.y >= gatedests[GetMap()][3]
			and 
		k.y <= gatedests[GetMap()][4]
			and
		k.z >= gatedests[GetMap()][5]
			and
		k.z <= gatedests[GetMap()][6]
	then
		return true
	end
end

function Barcheck(k)
	if 
		k.x >= bardests[GetMap()][1]
			and 
		k.x <= bardests[GetMap()][2]
			and
		k.y >= bardests[GetMap()][3]
			and 
		k.y <= bardests[GetMap()][4]
			and
		k.z >= bardests[GetMap()][5]
			and
		k.z <= bardests[GetMap()][6]
	then
		return true
	end
end

AddClientCommand('napole', function(ply)
if Barcheck(ply.position) == true then
SendReliableCommand(-1, 'chat "' .. ply.name .. ' na pole\n"')
else
SendReliableCommand(-1, 'chat "' .. ply.name .. ' ne na pole\n"')
end
end)

function barzone(args)
	local onoff = 0
	local stronoff = "Disabled"
		if #args < 1 then
			SendReliableCommand(-1, 'chat "Barzone ' .. stronoff .. '\n"')
		end
		
		if args[1] == 'on' then
			onoff = 1
			stronoff = "Enabled"
				for i = 0,max do
					if GetPlayer(i) ~= nil then
						local ply = GetPlayer(i)
							if Barcheck(ply.position) == true then
								barsafe = 0
							else
								barsage = 1
							end
					end
				end
		end
		
		if args[1] == 'off' then
			onoff = 0
			stronoff = "Disabled"
		end
end


function safezone()
	for i = 0,max do
		if GetPlayer(i) ~= nil then
			local ply = GetPlayer(i)
			
			if ply.team ~= 'spectator' then
	
			if Gatecheck(ply.position) == true then
				gatesafe = 0
			else
				gatesafe = 1
			end
			
			
			if ply.isDueling == true then
				gatesafe = 1
			end
			
			if ply.isBot == true then
				gatesafe = 1
			end
				
			
			if gatesafe == 0 then
				ply:Give('powerup',15,1000)
				ply.flags = Flags.UNDYING | Flags.DMG_BY_SABER_ONLY | Flags.NO_KNOCKBACK | Flags.GODMODE
				ply.weapon = 3
				ply.force = 10
				ply.isHolstered = 3
				--ply.eFlags = EFlags.FIRING
				--[[if ply.isProtected == false then
					ply.isProtected = true
				end--]]
			else
				--[[if ply.isProtected == true then
					ply.isProtected = false
				end--]]
				ply.flags = 0
				--ply.eFlags = 0
				ply:Take('powerup',15)
			end
			end
		end
	end	
end


function gate()
vars = {}
vars['classname'] = 'fx_runner'
vars['fxFile'] = 'force/kothos_beam'
vars['origin'] = Vector3(865, -1253, -145)
--vars['angle'] = -180
vars['angles'] = Vector3(180, 0, 0)
portal = CreateEntity(vars)
vars2 = {}
vars2['classname'] = 'fx_runner'
vars2['fxFile'] = 'force/kothos_beam'
vars2['origin'] = Vector3(542, -1253, -145)
--vars2['angle'] = 0
vars2['angles'] = Vector3(0, 0, -90)
portal2 = CreateEntity(vars2)

flagent = {}
flagent['classname'] = 'misc_model'
flagent['model'] = 'models/flags/b_flag.md3'
flagent['origin'] = Vector3(503, -1232, -140)
flagent['angles'] = Vector3(0, 20, 0)
flagspawn = CreateEntity(flagent)
flagent2 = {}
flagent2['classname'] = 'misc_model'
flagent2['model'] = 'models/flags/r_flag.md3'
flagent2['origin'] = Vector3(904, -1232, -140)
flagent2['angles'] = Vector3(0, 160, 0)
flagspawn2 = CreateEntity(flagent2)

local old = 'powerups/ysalimarishell'
local new = 'clear'
SendConsoleCommand(2, 'amremap ' .. old .. ' ' .. new .. '')
local old = 'effects/refract_2'
local new = 'clear'
SendConsoleCommand(2, 'amremap ' .. old .. ' ' .. new .. '')
end

gate()

function gateoff()
portal:Free()
portal2:Free()
flagspawn:Free()
flagspawn2:Free()
end

local function disco(ply)
gatesafe = nil
end

AddListener('JPLUA_EVENT_RUNFRAME', safezone)
AddListener('JPLUA_EVENT_UNLOAD', gateoff)
AddListener('JPLUA_EVENT_CLIENTDISCONNECT', disco)

AddServerCommand('barzone',barzone)
