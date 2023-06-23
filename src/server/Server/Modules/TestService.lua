local DataService = require(game:GetService("ServerScriptService").Server.Modules.DataService)
local Player = game.Players.LocalPlayer
local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)
local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()

local Test = {}

function Test:AddCoins(amount)
    local PPLayer = Player
    DataService:GetReplica(PPLayer):andThen(function(replica)
        replica:SetValue("HerbalCoins", replica.Data.HerbalCoins + amount)
    end)
end
-- functions to add MysticShards
function Test:AddMysticShards(amount)
    local PPLayer = Player
    DataService:GetReplica(PPLayer):andThen(function(replica)
        replica:SetValue("MysticShards", replica.Data.MysticShards + amount)
    end)
end


EasyNetwork:BindFunctions({
    AddTestCoins = function(amount)
        Test:AddCoins(amount)
    end,
    AddTestMysticShards = function(amount)
        Test:AddMysticShards(amount)
    end
    
})

return Test