
--  params is parameters passed from et_ClientCommand / et_ConsoleCommand function.
--   * params["arg1"] => client
function execute_command(params)
    if params.nbArg < 2 then
        printCmdMsg(params, "Useage: pmute \[partname/id#\]\n")
    else
        clientNum = client2id(params["arg1"], params)

        if clientNum ~= nil then
            if getAdminLevel(params.clientNum) >= getAdminLevel(clientNum) then
                et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref mute " .. clientNum .. "\n")
                client[clientNum]['muteEnd'] = -1
                setMute(clientNum, -1)
                local name = et.gentity_get(clientNum, "pers.netname")
                printCmdMsg(params, name .. " ^7has been muted\n")
            else
                printCmdMsg(params, "Cannot mute a higher admin\n")
            end
        end
    end

    return 1
end
