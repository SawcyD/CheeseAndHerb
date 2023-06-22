
local module = {}

module.Profiles = {}
module.Replicas = {}

module.PlayerProfiles = {
    --[[
		_player = player,
	--]]
} 

module.__index = module


-- Helper Functions

function module:IsActive() --> is active
    return module.PlayerProfiles[self._player] ~= nil
end





-- Main Functions

function module:giveCoins(amount)
    if self:IsActive() == false then
        return
    end
    self.Replica:SetValue({"HerbalCoins"}, self.Replica.Data.HerbalCoins + amount)
end


function module:AddPlayerProfile(player, profile)
    module.PlayerProfiles[player] = profile
end

function module:RemovePlayerProfile(player)
    module.PlayerProfiles[player] = nil
end

function module:GetPlayerProfile(player)
    return module.PlayerProfiles[player]
end

--


return module