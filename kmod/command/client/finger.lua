

function execute_command(params)
    if params.nbArg < 3 then
        et.trap_SendConsoleCommand(et.EXEC_APPEND, params.say .. " ^3Finger:^7 \[partname/id#\]\n")
    else
        clientNum = client2id(params["arg1"], 'Finger', params)

        if clientNum ~= nil
            adminStatus(clientNum, 'finger')
        end
    end

    return 1
end
