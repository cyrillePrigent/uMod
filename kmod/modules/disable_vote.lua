-- Disabled vote

-- Global var

voteDisabled = {
    ["active"]   = false,
    ["mode"]     = tonumber(et.trap_Cvar_Get("k_dvmode")),
    ["modeTime"] = tonumber(et.trap_Cvar_Get("k_dvtime"))
}

-- Function

-- Callback function when qagame runs a server frame.
--  vars is the local vars passed from et_RunFrame function.
function disableVoteRunFrame(vars)
    if voteDisabled["mode"] == 1 then
        local cancelTime = (tonumber(et.trap_Cvar_Get("timelimit")) - voteDisabled["modeTime"]) * 60
    elseif voteDisabled["mode"] == 3 then
        local cancelTime = voteDisabled["modeTime"] * 60
    else
        local cancelTime = (tonumber(et.trap_Cvar_Get("timelimit")) * (voteDisabled["modeTime"] / 100)) * 60
    end

    if time["counter"] >= cancelTime then
        if not voteDisabled["active"] then
            voteDisabled["active"] = true
            et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings are now DISABLED\n")
        end
    else
        if voteDisabled["active"] then
            et.trap_SendConsoleCommand(et.EXEC_APPEND, "qsay XP-Shuffle / Map Restart / Swap Teams  / Match Reset and New Campaign votings have been reenabled due to timelimit change\n")
        end

        voteDisabled["active"] = false
    end
end

-- Add callback disabled vote function.
addCallbackFunction({
    ["RunFrame"] = "disableVoteRunFrame"
})