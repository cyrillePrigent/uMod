-- Private message admins

-- Global var


addSlashCommand("console", "m2", {"function", "privateMessage2SlashCommand"})

addSlashCommand("client", "m", {"function", "privateMessageSlashCommand"})
addSlashCommand("client", "pm", {"function", "privateMessageSlashCommand"})
addSlashCommand("client", "msg", {"function", "privateMessageSlashCommand"})

-- Function

-- Function executed when slash command is called in et_ClientCommand function.
-- Note in ETpro, m / pm / msg don't work in server console. Use m2 command instead.
--  params is parameters passed to the function executed in command file.
function privateMessageSlashCommand(params)
    
    if params.nbArg < 2 then
        et.trap_SendServerCommand(params.clientNum, "print \"Useage: /m \[pname/ID\] \[message\]\n")
    else
        params.pm = true
        local pmContent = et.ConcatArgs(2)
        local targetNum = client2id(et.trap_Argv(1), params)

        if targetNum ~= nil then
            local name  = et.gentity_get(params.clientNum, "pers.netname")
            local rname = et.gentity_get(targetNum, "pers.netname")

            if k_logchat == 1 then
                logPrivateMessage(targetNum, pmContent, nil, rname)
            end

            et.trap_SendServerCommand(params.clientNum, "b 8 \"^dPrivate message sent to " .. rname .. "^d --> ^3" .. pmContent .. "^7")
            et.G_ClientSound(params.clientNum, pmSound)

            et.trap_SendServerCommand(targetNum, "b 8 \"^dPrivate message from " .. name .. "^d --> ^3" .. pmContent .. "^7")
            et.G_ClientSound(targetNum, pmSound)
        end
    end

    return 1
end

function privateMessage2SlashCommand(params)
    if params.nbArg < 2 then 
        et.G_Print("Useage: /m2 \[pname/ID\] \[message\]\n")
    else
        params.pm = true
        local message   = et.ConcatArgs(2)
        local targetNum = client2id(et.trap_Argv(1), params)

        if targetNum ~= nil then
            local rname = et.gentity_get(targetNum, "pers.netname")

            et.G_Print("Private message sent to " .. rname .. "^d --> ^3" .. message .. "^7\n")
            et.trap_SendServerCommand(targetNum, "b 8 \"^dPrivate message from ^1SERVER ^d--> ^3" .. message .. "^7")
            et.G_ClientSound(targetNum, pmSound)

            if k_logchat == 1 then
                logPrivateMessage(1022, message, nil, rname)
            end
        end
    end

    return 1
end