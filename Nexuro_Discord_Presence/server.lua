-- Sends server info (max players + name) to client on request
local function getMaxPlayers()
    local v = GetConvarInt('sv_maxclients', Config.DefaultMaxPlayers or 64)
    if v <= 0 then v = Config.DefaultMaxPlayers or 64 end
    return v
end

local function getServerName()
    local srcType = Config.ServerNameSource
    if srcType == 'project' then
        return GetConvar('sv_projectName', '')
    elseif srcType == 'hostname' then
        return GetConvar('sv_hostname', '')
    end
    return ''
end

RegisterNetEvent('nexuro:presence:requestInfo', function()
    local src = source
    TriggerClientEvent('nexuro:presence:setInfo', src, {
        max = getMaxPlayers(),
        srv = getServerName()
    })
end)

-- Periodically broadcast updates (handles runtime convar changes)
CreateThread(function()
    while true do
        TriggerClientEvent('nexuro:presence:broadcastInfo', -1, {
            max = getMaxPlayers(),
            srv = getServerName()
        })
        Wait(60000) -- sync every minute
    end
end)
