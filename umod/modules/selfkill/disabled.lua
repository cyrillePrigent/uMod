------------------------------------------------------------------------
-- nokill.lua -- Version 1.1
--
-- (c) 2005 infty -- guidebot@gmx.net
--
------------------------------------------------------------------------

-- Disabled selfkill

addSlashCommand("client", "kill", {"function", "selfkillLimitSlashCommand"})

-- Function

-- Function executed when slash command is called in et_ClientCommand function.
--  params is parameters passed to the function executed in command file.
function selfkillDisabledSlashCommand(params)
    if client[params.clientNum]["team"] ~= 3 and et.gentity_get(params.clientNum, "health") > 0 then
        et.trap_SendServerCommand(params.clientNum, "cp \"^1Sorry, selfkilling is disabled on this server.\n\"")
    end

    return 1
end