local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local DataService = require(script.Parent.DataService)
local CombatService = require(script.Parent.CombatService)


local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)
local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()

local WeaponManager = {}

local weaponsData = require(ReplicatedStorage.Data.weaponsData)

local equippedWeapon = nil
local canEquip = true -- Track if the player can currently equip a weapon
local equipCooldown = 2

-- Get the weapon model based on the weapon name
local function getWeaponModel(weaponName)
	local weaponData = ReplicatedStorage.Assets.Weapons

	for _, weaponType in pairs(weaponData:GetChildren()) do
		local weaponModel = weaponType[weaponName]
		if weaponModel then
			return weaponModel
		end
	end

	return nil -- Return nil if no matching weapon model is found
end

local function storeEquippedWeapon(weaponName)
    local backpack = Player:FindFirstChild("Backpack")
    if not backpack then
        backpack = Instance.new("Folder")
        backpack.Name = "Backpack"
        backpack.Parent = Player
    end

    local equippedWeaponModel = getWeaponModel(weaponName)
    if equippedWeaponModel then
        local weaponClone = equippedWeaponModel:Clone()
        weaponClone.Parent = backpack
    end
end

function WeaponManager:EquipWeapon(weaponName)
    local values = {
        Equipped = true -- Set the equipped state to true
    }

    DataService:GetReplica(Player):andThen(function(replica)
        if replica.Data.EquippedWeapon.Equipped == true then
            WeaponManager:UnequipWeapon()
        end
        replica:SetValues("EquippedWeapon", values)

        print(replica.Data.EquippedWeapon.Equipped)

        -- Weld the weapon to the player's right hand
        local weaponModel = getWeaponModel(weaponName)
        if weaponModel then
            local character = Player.Character

            local handle = weaponModel:WaitForChild("Handle")

            -- Attach the weapon to the RightGripAttachment
            local rightGripAttachment = character:WaitForChild("RightHand"):WaitForChild("RightGripAttachment")

            handle.CFrame = rightGripAttachment.WorldCFrame
            handle.Parent = character

            -- Find and update the existing WeldConstraint or create a new one
            local weld = handle:FindFirstChildOfClass("WeldConstraint")
            if weld then
                weld.Part0 = handle
                weld.Part1 = rightGripAttachment.Parent
            else
                weld = Instance.new("WeldConstraint")
                weld.Name = "WeaponWeld"
                weld.Part0 = handle
                weld.Part1 = rightGripAttachment.Parent
                weld.Parent = handle
            end
        else
            warn("Weapon model not found for weapon:", weaponName)
        end
    end)

    equippedWeapon = weaponName
end


function WeaponManager:UnequipWeapon(weaponName)
	local values = {
		Equipped = false -- Set the equipped state to false
	}

	DataService:GetReplica(Player):andThen(function(replica)
		replica:SetValues("EquippedWeapon", values)

		print(replica.Data.EquippedWeapon.Equipped)

		-- Get the weapon model based on the weapon name
		local weaponModel = getWeaponModel(weaponName)
		if weaponModel then
			local character = Player.Character
			local humanoid = character:WaitForChild("Humanoid")

			local handle = weaponModel.Handle

			-- Remove the weapon from the right hand
			local weaponWeld = handle:FindFirstChild("WeaponWeld")
			if weaponWeld then
				weaponWeld:Destroy()
			end

			-- Attach the weapon to the player's back
			local backpack = Player:FindFirstChild("Backpack")
			if backpack then
				local weaponClone = backpack:FindFirstChild(weaponName)
				if weaponClone then
					-- Set the primary part of the weapon clone
					weaponClone.PrimaryPart = weaponClone:FindFirstChild("Handle")

					weaponClone.Parent = character
					weaponClone:SetPrimaryPartCFrame(humanoid.RootPart.CFrame)
				end
			end
		else
			warn("Weapon model not found for weapon:", weaponName)
		end
	end)

	equippedWeapon = nil
end

function WeaponManager:OnEquipButtonPress()
	if not canEquip then
		return -- Exit the function if the player is on cooldown
	end

	DataService:GetReplica(Player):andThen(function(replica)
		local weaponName = replica.Data.EquippedWeapon.Name


		WeaponManager:EquipWeapon(weaponName)

		if equippedWeapon then
			storeEquippedWeapon(equippedWeapon)
		end

		-- Start the cooldown
		canEquip = false
		task.wait(equipCooldown)
		canEquip = true
	end)
end

function WeaponManager:OnUnequipButtonPress()
    DataService:GetReplica(Player):andThen(function(replica)
        local weaponName = replica.Data.EquippedWeapon.Name

        WeaponManager:UnequipWeapon(weaponName)

        -- Start the cooldown
        canEquip = false
        task.wait(equipCooldown)
        canEquip = true
    end)
end


EasyNetwork:BindEvents({
    WeaponEquipping = function(client)
        if equippedWeapon then
            print("Unequip")
            WeaponManager:OnUnequipButtonPress()
        else
            print("Equip")
            WeaponManager:OnEquipButtonPress()
        end
    end,
    PlayAttack = function(client, input)
        -- Make sure the input parameter is not nil
        if input then
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                CombatService:PlayAttackAnimation(Player.Character, "LightAttack")
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                CombatService:PlayAttackAnimation(Player.Character, "HeavyAttack")
            end
        else
            warn("Input is nil in PlayAttack")
        end
    end,
	PlayLightAttack = function(client)
		CombatService:PlayAttackAnimation(Player.Character, "LightAttack")
	end,
	PlayHeavyAttack = function(client)
		CombatService:PlayAttackAnimation(Player.Character, "HeavyAttack")
	end,
})
return WeaponManager
