
--  params is parameters passed from et_ClientCommand / et_ConsoleCommand function.
--   * params["arg1"] => client
function execute_command(params)
    if params.nbArg < 2 then
        printCmdMsg(params, "Useage: removeshoutcaster \[partname/id#\]\n")
    else
        clientNum = client2id(params["arg1"], params)

        if clientNum ~= nil then
            et.trap_SendConsoleCommand( et.EXEC_APPEND, "ref removeshoutcaster " .. clientNum .. "\n" )
        end
    end

    return 1
end