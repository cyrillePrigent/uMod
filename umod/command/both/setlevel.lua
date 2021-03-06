-- Give admin level to a player.
-- From kmod script.
-- Require : admins module
--  params is parameters passed from et_ClientCommand / et_ConsoleCommand function.
--   * params["arg1"] => client ID
--   * params["arg2"] => level
function execute_command(params)
    params.say = "chat"

    if params.nbArg < 3 then
        printCmdMsg(
            params,
            "Useage: setlevel [partname/id#] [level 0-" .. maxAdminLevel .. "]\n"
        )
    else
        local clientNum = client2id(params["arg1"], params)

        if clientNum ~= nil then
            local level = tonumber(params["arg2"])

            if level < 0 or level > maxAdminLevel then
                printCmdMsg(
                    params,
                    "Admin level does not exist! \[0-" .. maxAdminLevel .. "\]\n"
                )
            else
                local name = et.Q_CleanStr(client[clientNum]["name"])

                if level == 0 then
                    if admin["name"][client[clientNum]["guid"]] ~= nil then
                        removeAdmin(client[clientNum]["guid"])

                        printCmdMsg(params, name .. " is now a regular user!\n")
                    else
                        printCmdMsg(params, name .. " is already a regular user!\n")
                    end
                else
                    setAdmin(name, client[clientNum]["guid"], level)

                    printCmdMsg(
                        params,
                        name .. " is now a level " .. color4 .. level .. color1 .. " user!\n"
                    )
                end
            end
        end
    end

    return 1
end
