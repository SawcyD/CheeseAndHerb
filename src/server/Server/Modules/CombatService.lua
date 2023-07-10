local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataService = require(ServerScriptService.Server.Modules.DataService)

local EasyNetwork = require(ReplicatedStorage.Libs.Network)

local Mainmodule = require(ReplicatedStorage.Modules.Combat)
local HitBoxModule = require(ReplicatedStorage.Modules.Hitbox)

local Animations = ReplicatedStorage.Assets.Animations
local Audios = ReplicatedStorage.Assets.Audio

local CombatService = {}

function CombatService.HandleCombat(player, data)
	local character = player.Character
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { character }

	if data.Action == "M1" then
		local combo = data.Combo

		local hitbox = HitBoxModule.CreateHitbox()
		hitbox.Size = Vector3.new(4, 4, 4)
		hitbox.CFrame = humanoidRootPart.CFrame
		hitbox.Offset = CFrame.new(0, 0, -3.5)
		hitbox.Visualizer = false
		hitbox.RaycastParams = params

		hitbox.Touched:Connect(function(hit)
			local eHumanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
			if eHumanoid then
				if combo < 5 then
					if eHumanoid.Parent:FindFirstChild("Block") then
						Mainmodule.Actions.SoundEffect(eHumanoid.Parent, Audios.CombatHit.BlockedSound)
						Mainmodule.Effects.BlockEffect(eHumanoid.Parent)
					else
						eHumanoid:TakeDamage(combo + 4)
						Mainmodule.Effects.HitEffect(eHumanoid.Parent)

						-- Apply the appropriate combat animation based on fighting style
						local fightingStyle = nil

						-- Get the player's fighting style from data service
						DataService:GetReplica(player):andThen(function(replica)
							fightingStyle = replica.Data.fightingStyle.Name
							if fightingStyle then
								-- Apply the corresponding combat animation based on the fighting style
								local combatAnimation = Animations.CombatHit[combo][fightingStyle]
								Mainmodule.Actions.Animation(eHumanoid, combatAnimation)

								Mainmodule.Actions.Stun(eHumanoid.Parent, 2)
							else
								print(player.Name .. " doesn't have a fighting Style Equipped.")
							end
						end)
					end

					Mainmodule.Actions.Knockback(
						eHumanoid.Parent:WaitForChild("HumanoidRootPart"),
						humanoidRootPart,
						10
					)
				else
					if eHumanoid.Parent:FindFirstChild("Block") then
						eHumanoid:TakeDamage(combo + 4)
						Mainmodule.Effects.BlockBreakEffect(eHumanoid.Parent)

						Mainmodule.Actions.SoundEffect(eHumanoid.Parent, Audios.CombatHit.BlockBreak)
						Mainmodule.Actions.Stun(eHumanoid.Parent, 4)
						eHumanoid.Parent:FindFirstChild("Block"):Destroy()
					else
						eHumanoid:TakeDamage(combo + 4)
						Mainmodule.Effects.HitEffect(eHumanoid.Parent)

						Mainmodule.Actions.Stun(eHumanoid.Parent, 2)
						Mainmodule.Actions.SoundEffect(eHumanoid.Parent, Audios.CombatHit[combo])
						Mainmodule.Actions.Knockback(
							eHumanoid.Parent:WaitForChild("HumanoidRootPart"),
							humanoidRootPart,
							45
						)
					end
				end

				Mainmodule.Actions.Knockback(humanoidRootPart, humanoidRootPart, 10)
			end
		end)

		hitbox:Start()
		task.wait(data.CD)
		hitbox:Stop()
	elseif data.Action == "Block" then
		if data.Type == "On" then
			Mainmodule.Actions.Value("BoolValue", true, character, "Block")
			Mainmodule.Actions.Animation(character.Humanoid, Animations.Combat.Blocking)
		elseif data.Type == "Off" then
			local block = character:FindFirstChild("Block")
			if block then
				block:Destroy()
			end
			for _, v in pairs(character.Humanoid:GetPlayingAnimationTracks()) do
				v:Stop()
			end
		end
	end
end

EasyNetwork:BindEvents({
	CombatEvent = function(client, player, data)
		CombatService.HandleCombat(player, data)
	end,
})

return CombatService
