Config = {
    -- REQUIRED: Your Discord Application ID (number, NO quotes)
    DiscordAppId = 123456789012345678,

    -- Art assets (upload in Discord Dev Portal > Rich Presence > Art Assets)
    LargeAssetKey = 'server_logo_large',
    LargeAssetText = 'Welcome to our server',
    SmallAssetKey = 'server_logo_small',
    SmallAssetText = 'FiveM',

    -- Optional buttons (max 2). Leave nil or {} to disable.
    Buttons = {
        { label = 'Join our Discord', url = 'https://discord.gg/yourinvite' },
        { label = 'Direct Connect',    url = 'fivem://connect/your.ip:30120' }
    },

    -- Update interval (ms). 15000–30000 is safe for Discord rate limits.
    UpdateInterval = 15000,

    -- Fallback max players; server will send the real value via event.
    DefaultMaxPlayers = 64,

    -- Text template (placeholders: {id}, {name}, {count}, {max}, {street}, {zone}, {time}, {ping}, {srv})
    Template = 'ID: {id} • {count}/{max} • {name} • {srv}',

    -- Show {ping} in template? (add {ping} in Template too if true)
    ShowPing = false,

    -- Use in-game clock for {time} (e.g. 14:05)? Set false to disable.
    UseIngameClock = true,

    -- Server name source: 'hostname' (sv_hostname) or 'project' (sv_projectName). Or nil to ignore.
    ServerNameSource = 'hostname'
}
