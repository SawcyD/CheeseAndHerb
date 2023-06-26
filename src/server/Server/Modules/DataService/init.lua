local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")


local Promise = require(ReplicatedStorage.Libs:WaitForChild("Promise"))
local SaveStructure = require(ReplicatedStorage.Data:WaitForChild("playerData"))
local ProfileService = require(ReplicatedStorage.Libs:WaitForChild("ProfileService"))
local ReplicaService = require(script.Parent.Parent.ReplicaService)
local Manager = require(ServerScriptService.Server.PlayerData.Manager)

local Profiles = Manager.Profiles
local Replicas = Manager.Replicas

local PlayerProfileClassToken = ReplicaService.NewClassToken("PlayerProfile")
local ProfileStore = ProfileService.GetProfileStore("PlayerProfile", SaveStructure)

local DataService = {}

local function getLeaderStats(player)
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local HerbalCoins = Instance.new("NumberValue")
	HerbalCoins.Name = "Coins"
	HerbalCoins.Value = profile.Data.HerbalCoins
	HerbalCoins.Parent = leaderstats

	local MysticShards = Instance.new("NumberValue")
	MysticShards.Name = "Shards"
	MysticShards.Value = profile.Data.MysticShards
	MysticShards.Parent = leaderstats

	local Level = Instance.new("NumberValue")
	Level.Name = "Level"
	Level.Value = profile.Data.Level
	Level.Parent = leaderstats

	-- each time the vales changes the leaderstats will update
	

end


function DataService:GetReplica(Player)	
	return Promise.new(function(Resolve, Reject)
		assert(typeof(Player) == "Instance" and Player:IsDescendantOf(Players), "Value passed is not a valid player")

		if not Profiles[Player] and not Replicas[Player] then
			repeat 
				if Player then
					task.wait()
				else
					Reject("Player left the game")
				end
			until Profiles[Player] and Replicas[Player]
		end

		local Profile = Profiles[Player]
		local Replica = Replicas[Player]
		if Profile and Profile:IsActive() then
			if Replica and Replica:IsActive() then
				Resolve(Replica)
			else
				Reject("Replica did not exist or wasn't active")

			end
		else
			Reject("Profile did not exist or wasn't active")
		end
	end)
end

local function PlayerAdded(Player)
	local StartTime = tick()
	local Profile = ProfileStore:LoadProfileAsync("Player_" .. Player.UserId)

	if Profile then
		Profile:AddUserId(Player.UserId)
		Profile:Reconcile()
		Profile:ListenToRelease(function()
			Profiles[Player] = nil
			Replicas[Player]:Destroy()
			Replicas[Player]= nil
			Player:Kick("Profile was released")

		end)

		if Player:IsDescendantOf(Players) == true then
			Profiles[Player] = Profile
			local Replica = ReplicaService.NewReplica({
				ClassToken = PlayerProfileClassToken,
				Tags = {["Player"] = Player},
				Data = Profile.Data,
				Replication = "All"
			})

			Replicas[Player] = Replica
			warn(Player.Name.. "'s profile has been loaded. ".."("..string.sub(tostring(tick()-StartTime),1,5)..")")

		else
			Profile:Release()
		end
	else
		Player:Kick("Profile == nil") 
	end
end

function DataService:Init()
	for _, player in ipairs(Players:GetPlayers()) do
		coroutine.wrap(PlayerAdded)(player)
	end

	Players.PlayerAdded:Connect(PlayerAdded)

	Players.PlayerRemoving:Connect(function(Player)
		if Profiles[Player] then
			Profiles[Player]:Release()
		end
	end)
end


return DataService