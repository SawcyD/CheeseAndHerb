local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.Server.Modules.DataService)

return function (context, player: Player, amount: number)
    DataService:GetReplica(player):andThen(function (replica)
        replica:SetValue("HerbalCoins", replica.Data.HerbalCoins + amount)
    end)
    
end