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

}
local Animation = " "

function PlayerService:PlayAnimation(character, animationId)
    -- Implement your logic to play the animation here
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:LoadAnimation(Animation:FindFirstChild(animationId)):Play()
    end
end

function PlayerService:ToggleMouseLock(player, isLocked)
    -- Implement your logic to lock or unlock the mouse here
    if isLocked then
        player.PlayerGui:SetTopbarTransparency(1)
        player.PlayerGui:SetMouseVisible(false)
        
        -- Set a custom mouse lock icon
        local mouseLockIcon = "rbxassetid://123456789" -- Replace with your custom icon asset ID
        player.PlayerGui.CustomMouseLockIcon.Image = mouseLockIcon
        player.PlayerGui.CustomMouseLockIcon.Visible = true
    else
        player.PlayerGui:SetTopbarTransparency(0)
        player.PlayerGui:SetMouseVisible(true)
        
        -- Hide the custom mouse lock icon
        player.PlayerGui.CustomMouseLockIcon.Visible = false
    end
end

function PlayerService:Init()
    
end





return PlayerService