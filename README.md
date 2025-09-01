Nexuro Discord Rich Presence (Standalone)
Version: v1.0
Author: Nexuro Development / Liquid_Juice

A lightweight, framework-agnostic Discord Rich Presence resource for FiveM.
No ESX/QBCore imports — works on any server. Shows player ID, player count,
current street/zone, optional server name, buttons, and more.

======================================================================
FEATURES =====================
----------------------------------------------------------------------
- Standalone (no framework dependencies)
- Dynamic location (street / crossing, zone)
- Player counter {count}/{max} (reads sv_maxclients)
- Server name from sv_hostname or sv_projectName
- Optional in-game clock {time} and ping {ping}
- Up to two buttons (Discord invite, Direct Connect, etc.)
- Template-based presence text
- Rate-limit aware update loop & periodic re-sync (every 60s)

======================================================================
REQUIREMENTS ================
----------------------------------------------------------------------
- FiveM server (latest recommended)
- A Discord Application with Rich Presence Art Assets uploaded

======================================================================
INSTALLATION GUIDE ============
----------------------------------------------------------------------
1) Create a Discord Application
   - Open the Discord Developer Portal -> New Application
   - Copy the Application ID
   - Go to Rich Presence -> Art Assets:
     * Upload a Large Image and (optionally) a Small Image
     * Note the asset keys (exact names)

2) Add the resource
   - Place the folder 'Nexuro_Discord_Presence' inside your 'resources/'

3) Configure (config.lua)
   - DiscordAppId (number, NO quotes; e.g., 123456789012345678)
   - LargeAssetKey / SmallAssetKey (+ optional hover texts)
   - Buttons (0–2) with 'label' and 'url'
   - Customize Template, ShowPing, UseIngameClock, ServerNameSource

4) Enable in server.cfg
   --------------------------------------------------------------
   ensure Nexuro Discord Presence
   --------------------------------------------------------------

5) Start & Test
   - Start the server and join
   - Open your Discord desktop client profile to see the presence
   - In-game, use '/presence' to force-refresh during testing

NOTE: Rich Presence is primarily shown in the desktop client, mobile clients
often do not display it.

======================================================================
USAGE ======================
----------------------------------------------------------------------
- Command: /presence
  Forces a refresh of the presence text (handy while configuring).

- Buttons:
  Configure up to two in 'Config.Buttons' (e.g., Discord invite, Tebex,
  Direct Connect, website).

======================================================================
PLACEHOLDERS FOR TEMPLATE ======
----------------------------------------------------------------------
{id}   Your server ID, 
{name} Your in-game name, 
{count} Current player count, 
{max}   Max players (reads sv_maxclients, with fallback), 
{street} Current street (and crossing if present), 
{zone}  Current zone label (e.g., Downtown Vinewood), 
{time}  In-game time HH:MM (if UseIngameClock = true), 
{ping}  Player ping in ms (if ShowPing = true), 
{srv}   Server name (from sv_hostname or sv_projectName), 

Unresolved placeholders are removed cleanly.

======================================================================
TROUBLESHOOTING =============
----------------------------------------------------------------------
- No presence shown:
  * Ensure Discord desktop client is running
  * Verify DiscordAppId is a valid number (no quotes)
  * Confirm Art Asset keys match exactly and have propagated

- Images not showing:
  * Asset keys must exactly match LargeAssetKey / SmallAssetKey
  * Allow up to a minute after upload for caching

- Buttons not visible:
  * Max two buttons, each needs 'label' and 'url'
  * Buttons visibility depends on Discord desktop client

- Wrong max players:
  * Reads sv_maxclients; falls back to DefaultMaxPlayers
  * The script broadcasts updates every 60s; use /presence to refresh

- Rate limits / flicker:
  * Keep UpdateInterval >= 15000 ms; script avoids redundant updates


======================================================================
CREDITS =====================
----------------------------------------------------------------------
Nexuro Development / Liquid_Juice
Resource scaffolding & docs: Nexuro Development
