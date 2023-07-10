-- local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local DataService = require(script.Parent.DataService)
-- local CombatService = require(script.Parent.CombatService)
-- local enemiesData = require(ReplicatedStorage.Data.enemiesData)
-- local weaponsData = require(ReplicatedStorage.Data.weaponsData)


-- local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)
-- local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()

-- local WeaponManager = {}

-- local hitboxes = {
--     LightAttack = {
--         size = Vector3.new(5, 5, 5),
--         duration = 0.5,
--         damageMultiplier = 1.0
--     },
--     HeavyAttack = {
--         size = Vector3.new(7, 7, 7),
--         duration = 1.0,
--         damageMultiplier = 1.5
--     },
--     Skill = {
--         size = Vector3.new(10, 10, 10),
--         duration = 1.5,
--         damageMultiplier = 2.0
--     }
-- }


-- local equippedWeapon = nil
-- local canEquip = true -- Track if the player can currently equip a weapon
-- local equipCooldown = 2

-- -- Get the weapon model based on the weapon name
-- local function getWeaponModel(weaponName)
--     local weaponData = ReplicatedStorage.Assets.Weapons

--     if weaponName and type(weaponName) == "string" then
--         for _, weaponType in pairs(weaponData:GetChildren()) do
--             local weaponModel = weaponType:FindFirstChild(weaponName)
--             if weaponModel then
--                 local handle = weaponModel.Handle
--                 if handle then
--                     return weaponModel, weaponType, handle
--                 else
--                     warn("Handle not found for weapon:", weaponName)
--                 end
--             end
--         end
--     end

--     return nil, nil, nil -- Return nil if no matching weapon model is found or if the argument is missing or not a string
-- end

-- local function getWeaponTypeAndHandle(player)
--     DataService:GetReplica(player):andThen(function(replica)
--         local equippedWeaponName = replica.Data.EquippedWeapon.Name

--         local weaponData = weaponsData[equippedWeaponName]
--         if weaponData then
--             local weaponType = weaponData.Type
--             local weaponModel, weaponType, handle = getWeaponModel(equippedWeaponName)
--             if weaponModel and weaponType and handle then
--                 return weaponType, handle
--             else
--                 print("Weapon model or handle not found for weapon: " .. equippedWeaponName)
--             end
--         else
--             print("Weapon data not found for weapon: " .. equippedWeaponName)
--         end
    
--         return nil, nil
        
--     end)
-- end


-- function WeaponManager:HandleBladeTouch(attackType)
--     DataService:GetReplica(Player):andThen(function(replica)
--         local equippedWeaponName = replica.Data.EquippedWeapon.Name
--         local weaponModel = Player.Character and Player.Character:FindFirstChild(equippedWeaponName)
--         if equippedWeapon then
--             local weaponType, handle = replica.Data.EquippedWeapon.WeaponType, weaponModel.Handle
--             if weaponType and handle then
--                 local bladePart = handle:FindFirstChild("Blade")
            
--                 if bladePart then
--                     -- Attach a Touched event to the bladeTouchPart
--                     bladePart.Touched:Connect(function(touchedPart)
--                         -- Check if the touched part belongs to the player
--                         if touchedPart.Parent == Player.Character then
--                             return
--                         end
--                         local humanoid = touchedPart.Parent:FindFirstChildOfClass("Humanoid")
--                         if humanoid then
--                             local enemy = humanoid.Parent
--                             -- Retrieve the name of the enemy
--                             local enemyName = enemy.Name

--                             CombatService:ShowHitEffect(touchedPart.Position)
--                             CombatService:DealDamage(humanoid, hitboxes[attackType])
--                                     -- Add the attack type to the combo
--                             CombatService:AddToCombo(weaponType)

--                             -- Iterate through the enemy data and check if the enemy exists
--                             -- for _, enemyData in ipairs(enemiesData) do
--                             --     if enemyData.Enemy == enemy then
--                             --         -- Enemy exists, perform desired actions
                                    

--                             --         -- Print the enemy name
--                             --         print("Enemy Name: " .. enemyName)

--                             --         return
--                             --     end
--                             -- end

--                             -- Enemy does not exist in enemy data
--                             -- print("Enemy does not exist!")
--                         end
--                     end)
--                 end
--             end
--         end
--     end)
-- end





-- function WeaponManager:EquipWeapon(weaponName)
--     local values = {
--         Equipped = true -- Set the equipped state to true
--     }

--     DataService:GetReplica(Player):andThen(function(replica)
--         if replica.Data.EquippedWeapon.Equipped == true then
--             WeaponManager:UnequipWeapon()
--         end
--         replica:SetValues("EquippedWeapon", values)

--         print(replica.Data.EquippedWeapon.Equipped)

--         -- Weld the weapon to the player's right hand
--         local weaponModel, weaponType, handle = getWeaponModel(weaponName)
--         if weaponModel and weaponType and handle then
--             local character = Player.Character

--             -- Attach the weapon to the character's RightHand part
--             local rightHand = character:WaitForChild("RightHand")


--             weaponModel.Parent = character
--             weaponModel:PivotTo(rightHand.CFrame)
--             print("Pivot to")
--             weaponModel.Handle.CFrame = rightHand.CFrame
--             print("CFrame rightHand")
--             weaponModel.Handle.Anchored = false
--             print("Anchored false")
--             weaponModel.Handle.CanCollide = false


--             weaponModel:PivotTo(rightHand.CFrame)

--             -- Set the primary part of the weapon model
--             weaponModel.PrimaryPart = handle
--             print("PrimaryPart handle")

--             -- Find and update the existing WeldConstraint or create a new one
--             local weld = handle:FindFirstChildOfClass("WeldConstraint")
--             if weld then
--                 weld.Part0 = handle
--                 weld.Part1 = rightHand
--             else
--                 weld = Instance.new("WeldConstraint")
--                 weld.Name = "WeaponWeld"
--                 weld.Part0 = handle
--                 weld.Part1 = rightHand
--                 weld.Parent = handle

--                 local weld2 = Instance.new("WeldConstraint")
--                 weld2.Name = "HandleToMeshWeld"
--                 local mesh = handle:FindFirstChildOfClass("MeshPart")
--                 if mesh then
--                     weld2.Part0 = mesh
--                     weld2.Part1 = handle
--                     weld2.Parent = mesh
--                 end

--                 local weld3 = Instance.new("WeldConstraint")
--                 weld3.Name = "MeshToBladeWeld"
--                 local blade = handle:FindFirstChild("Blade")
--                 if blade then
--                     weld3.Part0 = blade
--                     weld3.Part1 = mesh
--                     weld3.Parent = blade
--                 end
--             end
--         else
--             warn("Weapon model not found for weapon:", weaponName)
--         end
--     end)

--     equippedWeapon = weaponName
-- end



-- function WeaponManager:UnequipWeapon(weaponName)
--     local values = {
--         Equipped = false -- Set the equipped state to false
--     }

--     DataService:GetReplica(Player):andThen(function(replica)
--         replica:SetValues("EquippedWeapon", values)


--         -- Get the weapon model, weapon type, and handle based on the weapon name
--         local weaponModel, weaponType, handle = getWeaponModel(weaponName)

--         if weaponModel and weaponType and handle then
--             local character = Player.Character

--             -- Remove the weapon from the right hand
--             weaponModel.Parent = character.HumanoidRootPart

--             -- Attach the weapon to the player's back
--             local upperTorso = character:WaitForChild("UpperTorso")
--             weaponModel.Position = upperTorso.BodyBackAttachment.OriginalPosition.Value

--             -- Set the primary part of the weapon model
--             weaponModel.PrimaryPart = handle

--             -- Weld the weapon to the player's back
--             local weld = handle:FindFirstChildOfClass("WeldConstraint")
--             weld.Part0 = handle
--             weld.Part1 = upperTorso
--             weld.Parent = handle
--         end
--     end)

--     equippedWeapon = nil
-- end

-- function WeaponManager:TestWeld()
--     -- local character = Player.Character
--     -- local rightHand = character:WaitForChild("RightHand")
--     -- print("RightHand found")
    
--     -- local model = Instance.new("Part")
--     -- model.Name = "TestModel"
--     -- model.Parent = character
--     -- model.Size = Vector3.new(1, 1, 1) -- Set an appropriate size for the model
--     -- model.CanCollide = false
--     -- model.Transparency = 0
--     -- model.Anchored = false
--     -- model.CFrame = rightHand.CFrame
--     -- print("Model created")

--     -- model:PivotTo(rightHand.CFrame)

--     -- local weld = Instance.new("WeldConstraint")
--     -- weld.Name = "TestWeld"
--     -- weld.Part0 = model
--     -- weld.Part1 = rightHand
--     -- weld.Parent = model
--     print("Weld created")
-- end


-- function WeaponManager:Init()
--     self:TestWeld()
    
-- end


-- function WeaponManager:OnEquipButtonPress()
-- 	if not canEquip then
-- 		return -- Exit the function if the player is on cooldown
-- 	end

-- 	DataService:GetReplica(Player):andThen(function(replica)
-- 		local weaponName = replica.Data.EquippedWeapon.Name


-- 		WeaponManager:EquipWeapon(weaponName)


-- 		-- Start the cooldown
-- 		canEquip = false
-- 		task.wait(equipCooldown)
-- 		canEquip = true
-- 	end)
-- end

-- function WeaponManager:OnUnequipButtonPress()
--     DataService:GetReplica(Player):andThen(function(replica)
--         local weaponName = replica.Data.EquippedWeapon.Name

--         WeaponManager:UnequipWeapon(weaponName)

--         -- Start the cooldown
--         canEquip = false
--         task.wait(equipCooldown)
--         canEquip = true
--     end)
-- end


-- EasyNetwork:BindEvents({
--     WeaponEquipping = function(client)
--         if equippedWeapon then
--             print("Unequip")
--             WeaponManager:OnUnequipButtonPress()
--         else
--             print("Equip")
--             WeaponManager:OnEquipButtonPress()
--         end
--     end,
--     PlayAttack = function(client, input, enemy)
--         -- Make sure the input parameter is not nil
--         if input then
--             if input.UserInputType == Enum.UserInputType.MouseButton1 then
--                 CombatService:PlayAttackAnimation(Player.Character, "LightAttack")
--                 WeaponManager:HandleBladeTouch(enemy) -- Call the handleBladeTouch function when a light attack is performed
--             elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
--                 CombatService:PlayAttackAnimation(Player.Character, "HeavyAttack")
--                 WeaponManager:HandleBladeTouch(enemy) -- Call the handleBladeTouch function when a heavy attack is performed
--             end
--         else
--             warn("Input is nil in PlayAttack")
--         end
--     end,
-- 	PlayLightAttack = function(client, enemy)
-- 		CombatService:PlayAttackAnimation(Player.Character, "LightAttack")
--         WeaponManager:HandleBladeTouch("LightAttack")
-- 	end,
-- 	PlayHeavyAttack = function(client, enemy)
-- 		CombatService:PlayAttackAnimation(Player.Character, "HeavyAttack")
--         WeaponManager:HandleBladeTouch("HeavyAttack")
-- 	end,
--     PlayBlock = function(client)
--         CombatService:Block(Player)
--     end,
-- })
-- return WeaponManager
