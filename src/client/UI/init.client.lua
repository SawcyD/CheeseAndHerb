local UIAnimations = require(script.UIAnimations)
local ReplicaController = require(game:GetService("ReplicatedStorage").Util.ReplicaController)
local Inventory = require(script.Inventory)
local Currencies = require(script.Currencies)
local TestButtons = require(script.TestButtons)
local PlayerStats = require(script.PlayerStats)

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
    -- print out the player's level and exp
    print(playerName .. " level:", replicaData.Level)

    print(replicaData)
end)


-- Initialize the UI Modules
UIAnimations.Init()
Inventory.Init()
Currencies.Init()
TestButtons.Init()
PlayerStats.Init()