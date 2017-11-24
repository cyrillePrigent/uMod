-- Reset all player ownage.
--  params is parameters passed from et_ClientCommand / et_ConsoleCommand function.
--   * params["arg1"] => client
function execute_command(params)
    local count = 0

    for i = 0, clientsLimit, 1 do
        if client[i]["own"] == 1 then
            client[i]["own"] = 0
            count = count + 1
        end
    end

    printCmdMsg(params, "^1" .. count .. " ^7players was ownage stopped\n")

    return 1
end
