local lastPresence = nil
local serverInfo = { max = Config.DefaultMaxPlayers or 64, srv = '' }

-- --- Helpers ---
local function safe(v) return v or '' end

local function replaceTemplate(tmpl, data)
    local out = tmpl
    for k, v in pairs(data) do
        out = out:gsub('{' .. k .. '}', safe(v))
    end
    -- Remove any leftover placeholders cleanly
    out = out:gsub('{%w+}', '')
    return out
end

local function getStreetAndZone()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local sHash, cHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street = GetStreetNameFromHashKey(sHash)
    local cross = GetStreetNameFromHashKey(cHash)
    local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z)) or ''
    if cross and cross ~= '' then
        street = (street or 'Somewhere') .. ' / ' .. cross
    end
    return street or 'Somewhere', zone
end

local function getClock()
    if not Config.UseIngameClock then return '' end
    local h = GetClockHours()
    local m = GetClockMinutes()
    return (('%02d:%02d'):format(h, m))
end

local function updateButtons()
    if Config.Buttons and type(Config.Buttons) == 'table' then
        for i = 0, 1 do
            local btn = Config.Buttons[i + 1]
            if btn and btn.label and btn.url then
                SetDiscordRichPresenceAction(i, tostring(btn.label), tostring(btn.url))
            end
        end
    end
end

local function initDiscord()
    if not Config.DiscordAppId or type(Config.DiscordAppId) ~= 'number' then
        print('^1[nexuro_discord_presence]^7 Missing or invalid DiscordAppId (config.lua).')
        return
    end
    SetDiscordAppId(Config.DiscordAppId)

    if Config.LargeAssetKey then
        SetDiscordRichPresenceAsset(Config.LargeAssetKey)
        if Config.LargeAssetText then SetDiscordRichPresenceAssetText(Config.LargeAssetText) end
    end
    if Config.SmallAssetKey then
        SetDiscordRichPresenceAssetSmall(Config.SmallAssetKey)
        if Config.SmallAssetText then SetDiscordRichPresenceAssetSmallText(Config.SmallAssetText) end
    end

    updateButtons()
end

local function setPresence(text)
    if text ~= lastPresence then
        SetRichPresence(text)
        lastPresence = text
    end
end

-- --- Net events ---
RegisterNetEvent('nexuro:presence:setInfo', function(info)
    if type(info) == 'table' then
        if tonumber(info.max or 0) and (info.max or 0) > 0 then serverInfo.max = info.max end
        serverInfo.srv = info.srv or serverInfo.srv
    end
end)

RegisterNetEvent('nexuro:presence:broadcastInfo', function(info)
    if type(info) == 'table' then
        if tonumber(info.max or 0) and (info.max or 0) > 0 then serverInfo.max = info.max end
        serverInfo.srv = info.srv or serverInfo.srv
    end
end)

-- Force refresh command (handy for testing)
RegisterCommand('presence', function()
    lastPresence = nil
end, false)

-- --- Main loop ---
CreateThread(function()
    initDiscord()
    -- Request initial server info
    TriggerServerEvent('nexuro:presence:requestInfo')

    while true do
        local id = GetPlayerServerId(PlayerId())
        local name = GetPlayerName(PlayerId())
        local count = #GetActivePlayers()
        local street, zone = getStreetAndZone()
        local timeStr = getClock()

        local pingStr = ''
        if Config.ShowPing then
            local p = GetPlayerPing(PlayerId())
            if p and p >= 0 then pingStr = tostring(p) .. 'ms' end
        end

        local text = replaceTemplate(Config.Template, {
            id = tostring(id),
            name = tostring(name),
            count = tostring(count),
            max = tostring(serverInfo.max or Config.DefaultMaxPlayers or 64),
            street = street,
            zone = zone,
            time = timeStr,
            ping = pingStr,
            srv = serverInfo.srv or ''
        })

        setPresence(text)
        Wait(Config.UpdateInterval or 15000)
    end
end)
