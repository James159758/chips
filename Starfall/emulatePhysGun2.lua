--@server
local target = nil
local dist = 0

hook.add("tick", "player_grab", function()
    local ply = owner()
    local currentWeapon = ply:getActiveWeapon()
    if ply:keyDown(1) and currentWeapon:getClass() == "weapon_physgun" then --  
        if not target then
            local tr = ply:getEyeTrace()
            target = tr.Entity
            dist = tr.HitPos:getDistance(ply:getShootPos())
            return
        local newPos = ply:getShootPos() + ply:getAimVector() * dist
        target:setPos(newPos)
        return
    end
    target = nil
end)