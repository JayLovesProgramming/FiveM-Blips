lib.callback.register('zombie_blips:updateBlips', function(source)
  local src = source
  local collectedPlayersInfo = {}
  local players = exports.qbx_core:GetQBPlayers()
  for _, v in pairs(players) do
    local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
    local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
    collectedPlayersInfo[#collectedPlayersInfo + 1] = {
        source = v.PlayerData.source,
        label = v.PlayerData.charinfo.firstname,
        location = {
            x = coords.x,
            y = coords.y,
            z = coords.z,
            w = heading
        }
    }
  end
  return collectedPlayersInfo
end)

-- ZOMBIE.addCommand(require"shared.config".commandToSetMarkerColour, {
--   help = 'This changes your marker colour for player/vehicle blips',
--   params = {{
--       name = 'colour',
--       type = 'colour',
--       help = 'Colour to change to',
--       },
--   },
-- }, function(source, args)
--   TriggerClientEvent("ZOMBIE-Blips:setMarkerColour", source, args.colour)
-- end)