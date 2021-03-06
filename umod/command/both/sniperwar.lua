-- Sniperwar game mode management
-- From kmod script.
-- Require : game mode module

-- Function

-- Callback function when qagame runs a server frame in player loop
-- pending warmup and round.
--  * Add / remove ammo with weapon list.
--  * Force player to use M1 Garand / K43 weapon (FG42 is good also).
--  clientNum is the client slot id.
--  vars is the local vars passed from et_RunFrame function.
function checkSniperwarPlayerRunFrame(clientNum, vars)
    for weaponNum, weaponAmmo in pairs(gameMode["weaponsList"]) do
        if weaponAmmo[1] ~= -1 then
            et.gentity_set(clientNum, "ps.ammoclip", weaponNum, weaponAmmo[1])
        end

        if weaponAmmo[2] ~= -1 then
            et.gentity_set(clientNum, "ps.ammo", weaponNum, weaponAmmo[2])
        end
    end

    if tonumber(et.gentity_get(clientNum, "sess.latchPlayerType")) ~= 4 then
        et.gentity_set(clientNum, "sess.latchPlayerType", 4)
    end

    local latchPlayerWeapon = tonumber(
        et.gentity_get(clientNum, "sess.latchPlayerWeapon")
    )

    if not gameMode["weaponsAllowed"][latchPlayerWeapon] then
        if client[clientNum]["team"] == 1 then
            et.gentity_set(clientNum, "sess.latchPlayerWeapon", 32)
        elseif client[clientNum]["team"] == 2 then
            et.gentity_set(clientNum, "sess.latchPlayerWeapon", 25)
        end
    end
end

-- Enabled / disabled sniperwar game mode.
-- Require : game mode module
--  params is parameters passed from et_ClientCommand / et_ConsoleCommand function.
--   * params["arg1"] => new sniperwar value
function execute_command(params)
    params.say = "chat"

    if params.nbArg < 2 then
        printCmdMsg(params, "Useage: sniperwar [0-1]")
    else
        local sniperwar = tonumber(params["arg1"])

        if sniperwar == 1 then
            if not checkGameMode("sniperwar", "enabled", params) then
                return
            end

            gameMode["weaponsList"] = {
                [2]  = { 0, 0 },   -- Luger
                [4]  = { 0, 0 },   -- Grenade launcher (Axis grenade)
                [7]  = { 0, 0 },   -- Colt
                [9]  = { 0, 0 },   -- Grenade pineapple (Allies grenade)
                [10] = { 0, 0 },   -- Sten
                [14] = { 0, 0 },   -- Silenced Luger
                [19] = { 0, 0 },   -- Medkit
                [24] = { 0, 0 },   -- M1 Garand
                [25] = { -1, 99 }, -- Silenced M1 Garand
                [27] = { 0, 0 },   -- Satchel
                [30] = { 0, 0 },   -- Smoke bomb
                [32] = { -1, 99 }, -- Silenced K43
                [33] = { -1, 99 }, -- FG42
                [37] = { 0, 0 },   -- Akimbo Colt
                [38] = { 0, 0 },   -- Akimbo Luger
                [41] = { 0, 0 },   -- Silenced colt
                [42] = { -1, 99 }, -- M1 Garand scope
                [43] = { -1, 99 }, -- K43 scope
                [44] = { -1, 99 }, -- FG42 scope
                [46] = { 0, 0 },   -- Medic adrenaline
                [47] = { 0, 0 },   -- Akimbo silenced Colt
                [48] = { 0, 0 }    -- Akimbo silenced Luger
            }

            gameMode["weaponsAllowed"] = {
                [25] = true,
                [32] = true,
                [33] = true
            }

            params.gameModeSettings = {
                ["team_maxSoldiers"]      = 0,
                ["team_maxmedics"]        = 0,
                ["team_maxengineers"]     = 0,
                ["team_maxfieldops"]      = 0,
                ["team_maxcovertops"]     = -1,
                ["team_maxriflegrenades"] = 0
            }

            params.clientSettingsCallbackFunction = function(clientNum)
                et.gentity_set(clientNum, "sess.latchPlayerType", 4)

                if client[clientNum]["team"] == 1 then
                    et.gentity_set(clientNum, "sess.latchPlayerWeapon", 32)
                else
                    et.gentity_set(clientNum, "sess.latchPlayerWeapon", 25)
                end
            end

            enabledGameMode("sniperwar", params)
            periodicFrameCallback["checkSniperwarPlayerRunFrame"] = "gameMode"
            addCallbackFunction({ ["RunFramePlayerLoop"] = "checkSniperwarPlayerRunFrame" })

            params.broadcast2allClients = true
            printCmdMsg(params, "Sniperwar has been enabled")
        elseif sniperwar == 0 then
            if not checkGameMode("sniperwar", "disabled", params) then
                return
            end

            periodicFrameCallback["checkSniperwarPlayerRunFrame"] = nil
            removeCallbackFunction("RunFramePlayerLoop", "checkSniperwarPlayerRunFrame")
            disabledGameMode(params)

            _G["checkSniperwarPlayerRunFrame"] = nil
            gameMode["weaponsAllowed"]         = nil

            params.broadcast2allClients = true
            printCmdMsg(params, "Sniperwar has been disabled.")
            collectgarbage()
        else
            printCmdMsg(params, "Valid values are [0-1]")
        end
    end

    return 1
end
