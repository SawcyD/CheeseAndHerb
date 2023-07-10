local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assetsFolder = ReplicatedStorage:WaitForChild("Assets")
local effects = assetsFolder:WaitForChild("Effects")

local combatModule = {}

combatModule.Actions = {
    ["Animation"] = function(humanoid, animation)
        local anim = humanoid:LoadAnimation(animation)
        anim:Play()
    end,

    ["SoundEffect"] = function(parent, sound, time)
        local newSound = sound:Clone()
        newSound.Parent = parent
        newSound:Play()
        game.Debris:AddItem(newSound, time)
    end,

    ["Stun"] = function(parent, duration)
        local stun = Instance.new("BoolValue")
        stun.Name = "Stunned"
        stun.Parent = parent
        game.Debris:AddItem(stun, duration)
    end,

    ["Knockback"] = function(targetHRP, lookHRP, force)
        local velocity = Instance.new("BodyVelocity")
        velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        velocity.Velocity = lookHRP.CFrame.lookVector * force
        velocity.Parent = targetHRP
        game.Debris:AddItem(velocity, 0.2)
    end,

    ["Value"] = function(valueType, value, parent, name)
        local newValue = Instance.new(valueType)
        newValue.Name = name
        newValue.Value = value
        newValue.Parent = parent
    end
}

combatModule.Effects = {
    ["HitEffect"] = function(target)
        local hitAttachment = effects.HitEffect.Attachment:Clone()
        hitAttachment.Parent = target.HumanoidRootPart
        hitAttachment.Ring:Emit(1)
        hitAttachment.Sparks:Emit(20)
        hitAttachment.Residue:Emit(20)
        hitAttachment.CenterSpark:Emit(1)
        game.Debris:AddItem(hitAttachment, 0.5)
    end,

    ["BlockEffect"] = function(target)
        local hitAttachment = effects.BlockEffect.Attachment:Clone()
        hitAttachment.Parent = target.HumanoidRootPart
        hitAttachment.Radial:Emit(1)
        hitAttachment.CenterStar:Emit(30)
        hitAttachment.Sparks:Emit(30)
        game.Debris:AddItem(hitAttachment, 2)
    end,

    ["BlockBreakEffect"] = function(target)
        local hitAttachment = effects.BreakEffect.Attachment:Clone()
        hitAttachment.Parent = target.HumanoidRootPart
        hitAttachment.Radial:Emit(1)
        hitAttachment.CenterPiece:Emit(3)
        hitAttachment.Sparks:Emit(30)
        hitAttachment.Crack:Emit(1)
        game.Debris:AddItem(hitAttachment, 2)
    end,
}

return combatModule
