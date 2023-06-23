local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Manager = require(script.Parent.Parent.PlayerData.Manager)
local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()


local DataService = require(script.Parent.DataService)

local weaponsData = require(ReplicatedStorage.Data.weaponsData)
local enemiesData = require(ReplicatedStorage.Data.enemiesData)


local CombatService = {}

local comboAnimations = {
    GreatSword = {
        Idle = {
            "rbxassetid://13804839792"
        },
        Block = { AnimationId = "rbxassetid://13804851745" },
        Attacks = {
            LightAttack = {
                AnimationIds = {
                    "rbxassetid://13804867659", -- Attack2
                    "rbxassetid://13804875467", -- Attack1
                 }
            },
            HeavyAttack = {
                AnimationId = "rbxassetid://13804855777", -- animationID
                holdDuration = 1.0
            }
        }

        --ids
    },
    Sword = {
        Idle = {},
        Block = {},
        Attacks = {
            LightAttack = {
                AnimationId = "--lightAttackId"
            },
            HeavyAttack = {
                AnimationId = "", -- animationID
                holdDuration = 0.8
            }
        }
    },
    Axe = {
        Idle = {},
        Block = {},
        Attacks = {
            LightAttack = {
                AnimationId = "--lightAttackId"
            },
            HeavyAttack = {
                AnimationId = "", -- animationID
                holdDuration = 1.2
            }
        }
    }
}

local comboSystem = {
    currentCombo = {},
    maxComboSize = 3, -- Adjust the maximum combo size as needed
}
local hitboxes = {
    LightAttack = {
        size = Vector3.new(5, 5, 5),
        duration = 0.5,
        damageMultiplier = 1.0
    },
    HeavyAttack = {
        size = Vector3.new(7, 7, 7),
        duration = 1.0,
        damageMultiplier = 1.5
    },
    Skill = {
        size = Vector3.new(10, 10, 10),
        duration = 1.5,
        damageMultiplier = 2.0
    }
}

-- Add these at the beginning of the script to load required modules and assets
local TextService = game:GetService("TextService")
local DamageNumberPrefab = ReplicatedStorage.Assets.Prefabs.DamageNumber -- Replace with your own damage number prefab
local HitEffectPrefab = ReplicatedStorage.Assets.Prefabs.Hit-- Replace with your own hit effect prefab

local function GetEquippedWeaponType(character)
    DataService:GetReplica(Player):andThen(function(replica)
        if replica then
            local equippedWeaponType = replica.Data.EquippedWeapon.WeaponType
            if equippedWeaponType then
                return equippedWeaponType
            end
        end
    end)
    return nil -- Return nil if the equipped weapon type is not found or not defined
end

local function GetAttackTypeFromInput(input)
    -- Implement the logic to determine the attack type based on the input
    if input == Enum.UserInputType.MouseButton1 then
        return "LightAttack"
    elseif input == Enum.UserInputType.MouseButton2 then
        return "HeavyAttack"
    end
    return nil
end

-- Implement the logic to retrieve the skill data from the weaponsData table

function CombatService:DealDamage(target, hitbox)
    DataService:GetReplica(Player):andThen(function(replica)
        local weapon = weaponsData[replica.Data.EquippedWeapon.Name]
        local damage = weapon.damage + replica.Data.Damage
        local damageReduction = replica.Data.BlockDamageReduction
        
        damage = damage * hitbox.damageMultiplier

        if math.random() <= replica.data.CriticalChance then
            local criticalMultiplier = replica.Data.CriticalMultiplier
            damage = damage * criticalMultiplier
        end

        if replica.Data.Blocking then
            -- Reduce incoming damage if the player is blocking
            damage = damage * (1 - damageReduction)
        end

        target:SetAttribute("Health", target:GetAttribute("Health") - damage)

        self:ShowDamageNumber(target.Character.HumanoidRootPart, damage)

        self:ShowHitEffect(target.Character.HumanoidRootPart)

        if target:GetAttribute("Health") <= 0 then
            self:HandleDefeat(target)
        end

    end)
end

function CombatService:ShowDamageNumber(position, damage)
    local damageNumber = DamageNumberPrefab:Clone()
    damageNumber.TextLabel.Text = tostring(damage)
    damageNumber.Position = position.Position + Vector3.new(0, 3, 0)
    damageNumber.Parent = workspace

    -- Remove the damage number after a certain duration
    task.delay(
        2,
        function()
            damageNumber:Destroy()
        end
    )
end

function CombatService:Block(player)
    -- Implement the logic for blocking here
    -- For example, you can play the block animation and reduce incoming damage
    DataService:GetReplica(Player):andThen(function(replica)
        replica.Data.Blocking = true
        -- Get the character of the player
        local character = player.Character
        if not character then
            return
        end
        
        -- Play the block animation
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local weaponType = replica.Data.EquippedWeapon.WeaponType
            if weaponType then
                local blockAnimationId = comboAnimations[weaponType].Block.AnimationId
                if blockAnimationId then
                    local animation = Instance.new("Animation")
                    animation.AnimationId = blockAnimationId
                    
                    local loadedAnimation = humanoid:LoadAnimation(animation)
                    loadedAnimation:Play()
                end
            end
        end

        local damageReduction = replica.Data.BlockDamageReduction

        -- Reduce incoming damage
        -- You can use the damageReduction variable to reduce the incoming damage

    end)
    
    
    -- Reduce incoming damage

end

function CombatService:ShowHitEffect(position)
    local hitEffect = HitEffectPrefab:Clone()
    hitEffect.Position = position.Position
    hitEffect.Parent = workspace

    -- Find the attachment inside the hit effect prefab
    local attachment = hitEffect:FindFirstChild("Attachment")
    if attachment then
        -- Find all ParticleEmitters within the attachment
        local particleEmitters = attachment:GetDescendantsOfClass("ParticleEmitter")
        for _, particleEmitter in ipairs(particleEmitters) do
            -- Start emitting particles
            particleEmitter.Enabled = true

            -- Stop emitting particles after a certain duration
            task.delay(
                2,
                function()
                    particleEmitter.Enabled = false
                end
            )
        end
    end
end

function CombatService:HandleDefeat(target)
    DataService:GetReplica(Player):andThen(function(replica)
        local enemyData = enemiesData[target.Name] -- Retrieve the enemy data from the table

        -- Play defeat animation or any other desired logic

        -- Create a fade-up effect
        local fadeUpPart = Instance.new("Part")
        fadeUpPart.Size = Vector3.new(5, 5, 5)
        fadeUpPart.CFrame = target.Character.HumanoidRootPart.CFrame
        fadeUpPart.Transparency = 1
        fadeUpPart.Anchored = true
        fadeUpPart.Parent = workspace

        local fadeUpTween = game:GetService("TweenService"):Create(fadeUpPart, TweenInfo.new(1), { Transparency = 0 })
        fadeUpTween:Play()

        -- Create a small explosion of white particles
        local explosionEmitter = Instance.new("ParticleEmitter")
        explosionEmitter.Parent = target.Character.HumanoidRootPart
        explosionEmitter.Transparency = NumberSequence.new(0.2)
        explosionEmitter.Size = NumberSequence.new(2)
        explosionEmitter.Color = ColorSequence.new(Color3.new(1, 1, 1))
        explosionEmitter.Texture = "rbxassetid://226707243" -- Replace with your desired particle texture ID
        explosionEmitter:Emit(50) -- Adjust the number of particles as needed

        -- Award drops, exp, herbal coins, and mystic shards
        for _, dropItem in ipairs(enemyData.DropsTable) do
            -- Award the drop item to the player here
            print("You obtained: " .. dropItem)
        end
        -- TODO: I need to make the Level/exp System with the stats increase as the level increases
        -- Award experience points
        -- coming soon 
        -- Award herbal coins
        replica:SetValue("HerbalCoins", replica.Data.HerbalCoins + enemyData.HerbalCoinsOnKill)
        -- Award mystic shards
        replica:SetValue("MysticShards", replica.Data.MysticShards + enemyData.MysticShardsOnKill)

        -- Destroy the fade-up part and particle emitter after a certain duration
        task.delay(1, function()
            fadeUpPart:Destroy()
            explosionEmitter:Destroy()
        end)
    end)


end

function CombatService:PlaySkillAnimation(character, skillData)
    -- Implement the logic to play the skill animation based on the skillData
    local skillAnimationId = skillData.AnimationId
    -- Play animation using skillAnimationId
end

function CombatService:ApplySpecialEffects(character, skillData)
    -- Implement the logic to apply special effects based on the skillData
    -- Example: Apply particle effects, sounds, or any other visual/audio effects
    -- based on the skillData properties
end

function CombatService:GetTargetInHitbox(hitbox)
    -- Implement the logic to determine the target within the hitbox
    local region = Region3.new(hitbox.CFrame.Position - hitbox.Size / 2, hitbox.CFrame.Position + hitbox.Size / 2)
    local parts = workspace:GetPartBoundsInBox(region, nil, math.huge)
    local target = nil
    local closestDistance = math.huge

    for _, part in ipairs(parts) do
        local humanoid = part.Parent:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 then
            local distance = (part.Position - hitbox.CFrame.Position).Magnitude
            if distance < closestDistance then
                target = humanoid.Parent
                closestDistance = distance
            end
        end
    end

    return target
end


function CombatService:PlayAttackAnimation(character, attackType)
    DataService:GetReplica(Player):andThen(function(replica)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return
        end
        
        local weaponType = replica.Data.EquippedWeapon.WeaponType
        local animationId
        local holdDuration
        local isAnimationPlaying = false -- Added variable to track animation state

        if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
            -- Only play attack animation if the humanoid is not running

            if attackType == "LightAttack" then
                local lightAttackAnimations = comboAnimations[weaponType].Attacks.LightAttack.AnimationIds
                if lightAttackAnimations and #lightAttackAnimations > 0 then
                    -- Select a random animation ID
                    local randomIndex = math.random(1, #lightAttackAnimations)
                    animationId = lightAttackAnimations[randomIndex]
                end
            elseif attackType == "HeavyAttack" then
                animationId = comboAnimations[weaponType].Attacks.HeavyAttack.AnimationId
                holdDuration = comboAnimations[weaponType].Attacks.HeavyAttack.holdDuration
            end

            if animationId then
                local animation = Instance.new("Animation")
                animation.AnimationId = animationId

                local loadedAnimation = humanoid:LoadAnimation(animation)
                loadedAnimation:Play()
                isAnimationPlaying = true -- Set the animation state to true

                loadedAnimation.Stopped:Wait()
                isAnimationPlaying = false -- Set the animation state to false when animation stops
            end

            if holdDuration then
                -- Add a hold effect for heavy attacks
                task.wait(holdDuration)
            end
        end

        -- Play the idle animation if the player is not moving or attacking
        if attackType == nil and humanoid.MoveDirection.Magnitude == 0 then
            local idleAnimationId = comboAnimations[weaponType].Idle.AnimationId
            if idleAnimationId then
                local idleAnimation = Instance.new("Animation")
                idleAnimation.AnimationId = idleAnimationId

                local loadedIdleAnimation = humanoid:LoadAnimation(idleAnimation)
                loadedIdleAnimation:Play()
                isAnimationPlaying = true -- Set the animation state to true
            end
        end

        -- Do something with the animation state (isAnimationPlaying)
        -- You can access this variable outside the function to check if an animation is playing or not.
        print("Animation state:", isAnimationPlaying)
    end)
end



function CombatService:GetSkillDataFromWeaponsData(skillName)
    if weaponsData[skillName] then
        return weaponsData[skillName]
    end
    return nil
end



function CombatService:OnComboInput(player, input)
    local character = player.Character
    local attackType = self:GetAttackTypeFromInput(input)

    -- Play attack animation based on the attack type and weapon type
    self:PlayAttackAnimation(character, attackType)

    -- Get the hitbox for the attack type
    local hitbox = hitboxes[attackType]

    -- Get the target character based on the hitbox
    local target = self:GetTargetInHitbox(hitbox)

    -- Deal damage to the target
    if target then
        self:DealDamage(character, target, hitbox)
    end
end

function CombatService:ResetCombo()
    comboSystem.currentCombo = {}
end

function CombatService:AddToCombo(attackType)
    table.insert(comboSystem.currentCombo, attackType)

    if #comboSystem.currentCombo > comboSystem.maxComboSize then
        table.remove(comboSystem.currentCombo, 1)
    end

    self:PerformComboAction()
end

function comboSystem:PerformComboAction()
    -- Implement the logic to perform the desired action based on the current combo
    -- For example, you can check the current combo against predefined combo sequences
    -- and execute specific actions when a valid combo sequence is matched.

    -- Here's an example of a predefined combo sequence
    local comboSequence = { "LightAttack", "LightAttack", "HeavyAttack" }

    -- Check if the current combo matches the predefined sequence
    if #self.currentCombo == #comboSequence then
        local comboMatched = true
        for i, attackType in ipairs(self.currentCombo) do
            if attackType ~= comboSequence[i] then
                comboMatched = false
                break
            end
        end

        if comboMatched then
            -- Perform the action for the matched combo sequence
            print("Combo Matched: " .. table.concat(self.currentCombo, " > "))

            -- Reset the combo after performing the action
            self:ResetCombo()
        end
    end
end

function CombatService:OnSkillActivation(player, skillName)
    -- Handle skill activation logic here
    -- Get the skill data from weaponsData table based on the skillName
    local skillData = self:GetSkillDataFromWeaponsData(skillName)

    -- Get the hitbox for the skill
    local hitbox = hitboxes["Skill"]

    -- Get the target character based on the hitbox
    local target = self:GetTargetInHitbox(hitbox)

    -- Deal damage to the target
    if target then
        self:DealDamage(player.Character, target, hitbox)
    end

    -- Play skill animation and apply special effects based on the skillData
    self:PlaySkillAnimation(player.Character, skillData)
    self:ApplySpecialEffects(player.Character, skillData)
end


-- // Connections // --


-- Register combo inputs from the client


return CombatService
