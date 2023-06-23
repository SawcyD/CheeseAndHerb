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


EasyNetwork:BindEvents({
    AddTestCoins = function(client, player, amount)
        Test:AddCoins(player, amount)
    end,
    AddTestMysticShards = function(client, player, amount)
        Test:AddMysticShards(player, amount)
    end
    
})

return Test