local ReplicaController = require(game:GetService("ReplicatedStorage").Util.ReplicaController)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

ReplicaController.RequestData()

ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
    local isLocal = replica.Tags.Player == LocalPlayer
    local playerName = isLocal and "your" or replica.Tags.Player.Name .. "'s"
    local replicaData = replica.Data

    print("Received " .. playerName .. " player profile; Cash:", replicaData.HerbalCoins)
    replica:ListenToChange({"HerbalCoins"}, function(newValues)
        print(playerName .. " cash changed:", replicaData.HerbalCoins)
    end)

    -- Print out the player's HerbalCoins
    print(playerName .. " cash:", replicaData.HerbalCoins)
end)