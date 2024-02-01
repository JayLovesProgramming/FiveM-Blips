local config = require("shared.config")
local markerInfo = GetResourceKvpInt("ZOMBIE-Blips:ShouldSeeOwnMarkerKVP")
local blips = {} -- Store a table of all the blips client side
local collectedBlips = {} -- Store them so we can remove the blips and update

local function createAllPlayerBlips(playerId, playerLabel, playerLocation)
			if collectedBlips then
				for _, v in pairs(collectedBlips) do
					RemoveBlip(v)
					end
			end
			collectedBlips = {}
			local ped = GetPlayerPed(playerId)
			local blip = GetBlipFromEntity(ped)
			if not DoesBlipExist(blip) then
			if NetworkIsPlayerActive(playerId) then
					blip = AddBlipForEntity(ped)
			else
					blip = AddBlipForCoord(playerLocation.x, playerLocation.y, playerLocation.z)
			end
			if config.drawNameTags then
			Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, playerLabel, false, false, "", false )
			end
			SetBlipCategory(blip, 2)
			SetBlipRotation(blip, math.ceil(playerLocation.w))
			SetBlipScale(blip, 1.5)
			SetBlipColour(blip, 38)
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 480)
			SetBlipRotation(blip, math.ceil(playerLocation.w))
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName(playerLabel)
			EndTextCommandSetBlipName(blip)
			collectedBlips[#collectedBlips + 1] = blip
		end
		if GetBlipFromEntity(PlayerPedId()) == blip then
		-- RemoveBlip(blip) -- Ensure we remove our own blip.
	end
end

CreateThread(function()
	while true do
	Wait(10)
	local players = lib.callback.await('zombie_blips:updateBlips', 500)
		if (players) ~= nil then
			for _, data in pairs(players) do
				if not data then 
					Wait(2000)
				elseif #data >= 0 then
					local id = GetPlayerFromServerId(data.source)
					createAllPlayerBlips(id, data.label, data.location)
				end
			end
		end
	end
end)
