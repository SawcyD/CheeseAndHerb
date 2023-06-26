local DataService = require(game:GetService("ServerScriptService").Server.Modules.DataService)
local Player = game.Players.LocalPlayer
local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)
local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()

local Test = {}

function Test:AddCoins(player, amount)

    DataService:GetReplica(player):andThen(function(replica)
        local coins = replica.Data.HerbalCoins or 0
        replica:SetValue("HerbalCoins", coins + amount)
    end)
end
-- functions to add MysticShards
function Test:AddMysticShards(player, amount)

    DataService:GetReplica(player):andThen(function(replica)
        local shards = replica.Data.MysticShards or 0
        replica:SetValue("MysticShards", shards + amount)
    end)
end

function Test:AddDamageStat(player,  amount)
    DataService:GetReplica(player):andThen(function(replica)
        local statValue = replica.Data.Stats.Damage or 0
        replica:SetValue({"Stats", "Damage"}, statValue + amount)
    end)
end

function Test:AddHealthStat(player,  amount)
    DataService:GetReplica(player):andThen(function(replica)
        local statValue = replica.Data.Stats.Health or 0
        replica:SetValue({"Stats", "Health"}, statValue + amount)
    end)
end


function Test:AddStaminaStat(player,  amount)
    DataService:GetReplica(player):andThen(function(replica)
        local statValue = replica.Data.Stats.Stamina or 0
        replica:SetValue({"Stats", "Stamina"}, statValue + amount)
    end)
end

function Test:SubtractStatPoint(player, amount)
    DataService:GetReplica(player):andThen(function(replica)
        local statPoints = replica.Data.StatPoints or 0
        replica:SetValue("StatPoints", statPoints - amount)
    end)
end



EasyNetwork:BindEvents({
    AddTestCoins = function(client, player, amount)
        Test:AddCoins(player, amount)
    end,
    AddTestMysticShards = function(client, player, amount)
        Test:AddMysticShards(player, amount)
    end,
    AddTestDamageStat = function(client, player, amount)
        Test:AddDamageStat(player, amount)
    end,
    AddTestHealthStat = function(client, player, amount)
        Test:AddHealthStat(player, amount)
    end,
    AddTestStaminaStat = function(client, player, amount)
        Test:AddStaminaStat(player, amount)
    end,
    SubtractTestStatPoint = function(client, player, amount)
        Test:SubtractStatPoint(player, amount)
    end,
})

return Test