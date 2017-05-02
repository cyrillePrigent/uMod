

-- part2id

function execute_command(params)
    target = part2id(params.target)

    if target ~= nil then
        local sessionTeam = et.gentity_get(params.playerId, "sess.sessionTeam")

        if et.gentity_get(params.playerId, "pers.connected") == 2 and (sessionTeam > 0 or sessionTeam < 4) then
            local targetOrigin = et.gentity_get(target, "origin")
            targetOrigin[2] = targetOrigin[2] + 40
            et.gentity_set(params.playerId, "origin", targetOrigin)
        end
    end
end
