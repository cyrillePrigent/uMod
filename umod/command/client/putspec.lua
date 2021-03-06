-- Put player to spectator.
-- From kmod script.
--  params is parameters passed from et_ClientCommand function.
--   * params["arg1"] => client
function execute_command(params)
    params.say = "chat"

    if params.nbArg < 2 then
        printCmdMsg(params, "Useage: putspec [partname/id#]\n")
    else
        clientNum = client2id(params["arg1"], params)

        if clientNum ~= nil then 
            if params.clientNum == clientNum
              or getAdminLevel(params.clientNum) > getAdminLevel(clientNum) then
                if client[clientNum]['team'] == 1 or client[clientNum]['team'] == 2 then
                    et.trap_SendConsoleCommand(
                        et.EXEC_APPEND,
                        "ref remove " .. clientNum .. "\n"
                    )

                    params.broadcast2allClients = true

                    printCmdMsg(
                        params,
                        client[clientNum]["name"] .. color1 .. " has been putted spectator\n"
                    )
                else
                    printCmdMsg(
                        params,
                        client[clientNum]["name"] .. color1 .. " is already spectator\n"
                    )
                end
            else
                printCmdMsg(params, "Cannot put spectator a higher admin\n")
            end
        end
    end

    return 1
end
