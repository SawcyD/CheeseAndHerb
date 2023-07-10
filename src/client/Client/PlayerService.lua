local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local PlayerService = {}

PlayerService.Animations = {
    RunAnimation = {
        "rbxassetid://13864567779",
    },
    walkAnimation = {
        "rbxassetid://13864575130",
    },
    downedAnimation = {
        "rbxassetid://13864579517",
    },
    DashAnimation = {
        "animationId"
    },
}

local function toggleShiftLock()
    local player = Players.LocalPlayer
    if player then
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid") 
        if humanoid then
            humanoid.AutoRotate = not humanoid.AutoRotate
        end
    end
end

function PlayerService:loadMouseIcon()
    local player = Players.LocalPlayer
    local mouse = player:GetMouse()
    mouse.Icon = "rbxassetid://13887383674"
    mouse.IconSize = Vector2.new(10, 10)
end

function PlayerService.Init()
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.Z then
            toggleShiftLock()
        end
    end)
    PlayerService:loadMouseIcon()
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.Z then
        toggleShiftLock()
    end
end)



return PlayerService