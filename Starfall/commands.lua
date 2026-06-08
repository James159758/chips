--@author DELETED
--@shared


local mainClient = function()

    local function sendData(data)
        net.start("connection")
        net.writeTable(data)
        net.send()
    end

    local function killData(message, replace, attacker)
        local nickName = string.replace(message, replace, "")
        if nickName == "" then return end
        local target = find.playersByName(nickName, true, true)[1]

        if attacker == "random" then
            attacker = table.random(find.allPlayers(function(ply) return (ply ~= owner() and ply ~= target) end))
        end
        
        if not attacker then
            print("Can't kill")
            return
        end

        localData = {}
        localData["flag"] = "kill"
        localData["target"] = target
        localData["attacker"] = attacker

        sendData(localData)
    end

    local function bringTP(message, replace)
        local nickName = string.replace(message, replace, "")
        if nickName == "" then return end
        local target = find.playersByName(nickName, true, true)[1]

        local localData = {}
        localData["flag"] = (replace == "!!bring " and "bring" or "tp")
        localData["ply"] = target


        sendData(localData)
    end

    hook.add("PlayerChat", "", function(ply, message, team, isdead)
        if ply ~= owner() then return end
        local data = {}

        if string.startsWith(message, "!!bring") then
            bringTP(message, "!!bring ")
        elseif string.startsWith(message, "!!god") then
            data["flag"] = "god"
            sendData(data)
        elseif string.startsWith(message, "!!tp") then
            bringTP(message, "!!tp ")
        elseif string.startsWith(message, "!!kill") then
            killData(message, "!!kill ", owner())
        elseif string.startsWith(message, "!!hkill") then
            killData(message, "!!hkill ", "random")
        elseif string.startsWith(message, "!!wkill") then
            killData(message, "!!wkill ", game.getWorld())
        end
    end)
end

local mainServer = function()
    net.receive("connection", function(len, ply)
        if(ply ~= owner()) then return end
        local data = net.readTable()

        if data["flag"] == "bring" then
            data["ply"]:setPos(owner():getPos()+Vector(0, 50, 0))
        elseif data["flag"] == "god" then
            owner():setHealth(10000)
        elseif data["flag"] == "tp" then
            owner():setPos(data["ply"]:getPos()+Vector(0, 50, 0))
        elseif data["flag"] == "kill" then
            data["target"]:applyDamage(math.huge, data["attacker"], nil, nil, nil)
        end
        
    end)
end




if SERVER then
    mainServer()
else
    mainClient()
end
