local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EasyNetwork = require(ReplicatedStorage.Libs.Network)
local Modules = ReplicatedStorage.Modules

local Mainmodule = require(Modules.Combat)

local UserInput = game:GetService("UserInputService")

local Animations = ReplicatedStorage.Assets.Animations.Combat
local Audios = ReplicatedStorage.Assets.Audio

local combo = 1

local punched = false
local canpunch = true
local lastpunch = 0

local canblock = true
local blocked = false

local Anim
local CD = 0

UserInput.InputBegan:Connect(function(input, typing)
    if typing then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if punched then return end
        if not canpunch then return end

        punched = true
        canblock = false

        local h = Audios.Punchswing:Clone()
        h.Parent = Character
        h:Play()

        lastpunch = tick()

        local Data = {
            ["Action"] = "M1",
            ["Combo"] = combo,
            ["CD"] = 0.7
        }

        EasyNetwork:FireServer("CombatEvent", Data)

        if combo < 5 then
            Mainmodule.Actions.Animation(Humanoid, Animations[combo])
            combo = combo + 1
            CD = 0.4
        else
            Mainmodule.Actions.Animation(Humanoid, Animations[combo])
            combo = 1
            CD = 3
        end
        Humanoid.WalkSpeed = 0

        if combo == 5 then
            task.wait(0.4)
            canblock = true
            Humanoid.WalkSpeed = 16
            task.wait(CD - 0.6)
        else
            canblock = true
            Humanoid.WalkSpeed = 16
            task.wait(CD)
        end

        punched = false

    elseif input.KeyCode == Enum.KeyCode.F then
        if blocked == true then return end
        if not canblock then return end
        canpunch = false
        blocked = true
        Humanoid.WalkSpeed = 9

        local Data = {
            ["Action"] = "Block",
            ["Type"] = "On"
        }

        EasyNetwork:FireServer("CombatEvent", Data)

    end
end)

UserInput.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if blocked == false then return end
        blocked = false
        canpunch = true

        Humanoid.WalkSpeed = 16
        local Data = {
            ["Action"] = "Block",
            ["Type"] = "Off"
        }

        EasyNetwork:FireServer("CombatEvent", Data)
    end
end)

while true do
    task.wait(2)
    if punched == false then
        combo = 1
    end
end
