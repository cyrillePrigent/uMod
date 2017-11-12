-- Gib protector

-- Global var

-- Set default client data.
clientDefaultData["teamGib"] = 0

gibWeapon = (
   17 => true,    -- PANZERFAUST
   18 => true,    -- GRENADE LAUNCHER
   19 => true,    -- FLAMETHROWER
   25 => true,    -- GRENADE_LAUNCHER
   26 => true,    -- DYNAMITE
   27 => true,    -- AIRSTRIKE
   30 => true,    -- ARTY
   43 => true,    -- GPG40 (Grenade Launcher)
   44 => true,    -- M7 (Grenade Launcher)
   45 => true,    -- LANDMINE
   46 => true,    -- SATCHEL
   49 => true,    -- MOBILE_MG42
   52 => true,    -- CONSTRUCTION
   57 => true     -- MORTAR
 );

-- Function


function checkGibProtectorPrint(vars)
    -- Workaround for shrub bug (gibs in warmup)
    if game["state"] == 0 then
        if vars["arg"][1] == "Gib:" then
            -- /Gib: (\d+) (\d+) (\d+): (.+) gibbed (.+) by MOD_([A-Z_0-9]+)/i
            local killerId = vars["arg"][2]
            local killedId = vars["arg"][3]
            local weaponId = vars["arg"][4]

            if killerId != 1022 and getAdminLevel(killerId) > 1 and killerId != killedId and client[killerId]["team"] > 0 and client[killerId]["team"] < 3 and client[killerId]["team"] == client[killedId]["team"] and not gib_weapon[weapon_id] then
                client[killerId]["teamGib"] = client[killerId]["teamGib"] + 1

                if client[killerId]["teamGib"] < 3 then
                    local msg = "^7You just gibbed a teammate! Don't do this again! (" .. client[killerId]["teamGib"] .. " time)/n"
                    
                    if advancedPms == 1 then
                        et.trap_SendConsoleCommand(et.EXEC_APPEND, "m2 " .. killerId .. " " .. msg)
                    else
                        et.trap_SendConsoleCommand(et.EXEC_APPEND, "m " .. client[killerId]["name"] .. " " .. msg)
                    end
                elseif client[killerId]["teamGib"] >= 3 then
                    local msg = "^7You are gibbing too much teammates! Don't do this again or you will be kicked! (" .. client[killerId]["teamGib"] .. " time)\n"

                    if advancedPms == 1 then
                        et.trap_SendConsoleCommand(et.EXEC_APPEND, "m2 " .. killerId .. " " .. msg)
                    else
                        et.trap_SendConsoleCommand(et.EXEC_APPEND, "m " .. client[killerId]["name"] .. " " .. msg)
                    end
                elseif client[killerId]["teamGib"] > 4 then
                    local msg = "^7" .. client[killerId]["name"] .. " is gibbing teammates (to collect binoculars) ... 5 minute temp ban!\n"
                    
                    if advancedPms == 1 then
                        et.trap_SendConsoleCommand(et.EXEC_APPEND, "m2 " .. killerId .. " " .. msg)
                    else
                        et.trap_SendConsoleCommand(et.EXEC_APPEND, "m " .. client[killerId]["name"] .. " " .. msg)
                    end

                    kick(killerId, "You too many team gibs!")
                end
            end
        end
    end
end
    
addCallbackFunction({
    ["Print"] = "checkGibProtectorPrint"
})