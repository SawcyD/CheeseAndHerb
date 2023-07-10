local playerGui = game.Players.LocalPlayer.PlayerGui
local screenGui = playerGui:WaitForChild("ScreenGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

 -- get the mouse posititon x and y
local Mouse = game.Players.LocalPlayer:GetMouse()


local UIAnimations = {}

UIAnimations.buttonToFrameMap = {
    InventoryButton = "InventoryFrame", -- Mapping: Button1 corresponds to Frame1
    Button2 = "Frame2",
    StatsButton = "StatsFrame",
}

UIAnimations.labelOriginalValues = {}
UIAnimations.labelAnimationValues = {}
UIAnimations.frameSizes = {}
UIAnimations.frameAnimationDuration = 0.3

function UIAnimations.Init()
    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)

    UIAnimations.FindAndConnectButtonEvents()
    UIAnimations.FindAndConnectLabelEvents()
    UIAnimations.RainbowText("Hello, world!", Enum.Font.FredokaOne, 24)
end

function UIAnimations.FindAndConnectButtonEvents()
    local buttons = screenGui:GetDescendants()
    for _, button in ipairs(buttons) do
        if button:IsA("TextButton") or button:IsA("ImageButton") then
            button.MouseEnter:Connect(function()
                UIAnimations.HandleButtonHover(button, 1.3)
            end)
            button.MouseLeave:Connect(function()
                UIAnimations.HandleButtonHover(button, 1)
                UIAnimations.HideTooltip(button)
            end)
            button.MouseButton1Click:Connect(function()
                UIAnimations.PlayButtonSound("rbxassetid://5393362166")
                UIAnimations.HandleButtonClick(button)
                UIAnimations.PlayRippleConfetti(Mouse.X, Mouse.Y) -- Pass the mouse position as arguments
            end)
        end
    end
end

function UIAnimations.FindAndConnectLabelEvents()
    local labels = screenGui:GetDescendants()
    for _, label in ipairs(labels) do
        if label:IsA("TextLabel") then
            UIAnimations.StoreLabelOriginalValue(label)
            label.Changed:Connect(function(property)
                if property == "Text" then
                    UIAnimations.AnimateTextLabelValue(label)
                end
            end)
        end
    end
end

function UIAnimations.StoreLabelOriginalValue(label)
    UIAnimations.labelOriginalValues[label.Name] = tonumber(label.Text) or 0
end

function UIAnimations.AnimateTextLabelValue(label)
    local originalValue = UIAnimations.labelOriginalValues[label.Name]
    local targetValue = tonumber(label.Text) or 0
    local scaleFactor = UIAnimations.GetLabelScaleFactor(targetValue)
    local animatedValue = originalValue + (targetValue - originalValue) * scaleFactor

    local tweenInfo = TweenInfo.new(UIAnimations.frameAnimationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(label, tweenInfo, { Text = tostring(animatedValue) })
    tween:Play()
end

function UIAnimations.GetLabelScaleFactor(targetValue)
    local animationValues = UIAnimations.labelAnimationValues
    local maxScaleFactor = 2 -- Adjust this value as needed
    local scaleFactor = targetValue / animationValues.MaxValue
    return math.min(scaleFactor, maxScaleFactor)
end

function UIAnimations.HandleButtonClick(button)
    local frameName = UIAnimations.buttonToFrameMap[button.Name]
    if frameName then
        local frame = screenGui:FindFirstChild(frameName)
        if frame then
            frame.Visible = not frame.Visible
            if frame.Visible then
                UIAnimations.OpenFrame(frame)
            else
                UIAnimations.CloseFrame(frame)
            end
        else
            warn("Frame not found:", frameName)
        end
    end
end

function UIAnimations.HideTooltip(button)
    local tooltips = button:GetChildren()
    for i = 1, #tooltips do
        if tooltips[i].Name == "Tooltip" then
            tooltips[i].Visible = false
            tooltips[i]:Destroy()
        end
    end
end

function UIAnimations.OpenFrame(frame)
    if frame then
        local frameSize = UIAnimations.frameSizes[frame.Name]
        if frameSize then
            local tweenInfo = TweenInfo.new(UIAnimations.frameAnimationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(frame, tweenInfo, { Size = frameSize })
            tween:Play()
        end
    end
end

function UIAnimations.CloseFrame(frame)
    if frame then
        local frameSize = UDim2.new(0, 0, 0, 0)
        local tweenInfo = TweenInfo.new(UIAnimations.frameAnimationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tween = TweenService:Create(frame, tweenInfo, { Size = frameSize })
        tween:Play()
    end
end

function UIAnimations.RainbowText(text, font, textSize)
    local rainbowColors = {
        Color3.fromRGB(255, 0, 0), -- Red
        Color3.fromRGB(255, 127, 0), -- Orange
        Color3.fromRGB(255, 255, 0), -- Yellow
        Color3.fromRGB(0, 255, 0), -- Green
        Color3.fromRGB(0, 0, 255), -- Blue
        Color3.fromRGB(75, 0, 130), -- Indigo
        Color3.fromRGB(148, 0, 211) -- Violet
    }
    
    local textSizeX = 0
    local textSizeY = 0
    local wrappedText = UIAnimations.WrapText(text, font, textSize, math.huge)
    
    for i, line in ipairs(wrappedText) do
        for j = 1, #line do
            local char = line:sub(j, j)
            local charSize = TextService:GetTextSize(char, textSize, font, Vector2.new(math.huge, math.huge))
            local charColor = rainbowColors[(i + j) % #rainbowColors + 1]
            
            local charLabel = Instance.new("TextLabel")
            charLabel.Text = char
            charLabel.Font = font
            charLabel.TextSize = textSize
            charLabel.TextColor3 = charColor
            charLabel.BackgroundTransparency = 1
            charLabel.Position = UDim2.new(0, textSizeX, 0, textSizeY)
            charLabel.Size = UDim2.new(0, charSize.X, 0, charSize.Y)
            charLabel.Parent = screenGui
            
            textSizeX = textSizeX + charSize.X
        end
        
        textSizeX = 0
        textSizeY = textSizeY + textSize
    end
end

function UIAnimations.WrapText(text, font, textSize, maxWidth)
    local lines = {}
    local line = ""
    
    for word in text:gmatch("%S+") do
        local wordSize = TextService:GetTextSize(word, textSize, font, Vector2.new(math.huge, math.huge))
        
        if #line == 0 or TextService:GetTextSize(line .. " " .. word, textSize, font, Vector2.new(math.huge, math.huge)).X <= maxWidth then            line = line .. " " .. word
        else
            table.insert(lines, line)
            line = word
        end
    end
    
    if #line > 0 then
        table.insert(lines, line)
    end
    
    return lines
end

function UIAnimations.HandleButtonHover(button, scaleFactor)
    local originalSize = button.Size
    local scaledSize = UDim2.new(originalSize.X.Scale * scaleFactor, originalSize.X.Offset * scaleFactor, originalSize.Y.Scale * scaleFactor, originalSize.Y.Offset * scaleFactor)
    UIAnimations.PlayButtonSound("rbxassetid://5393362166")
    button:TweenSize(scaledSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, UIAnimations.frameAnimationDuration, true)
    
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Parent = button
    tooltip.BackgroundTransparency = 1
    tooltip.Position = UDim2.new(0, 0, 1, 5)
    tooltip.Size = UDim2.new(0, 100, 0, 20)
    tooltip.Font = Enum.Font.FredokaOne
    tooltip.TextSize = 14
    tooltip.ZIndex = 2
    tooltip.TextColor3 = Color3.new(1, 1, 1)
    tooltip.Text = "This is a tooltip!"
    
    tooltip.Visible = true
end

function UIAnimations.PlayButtonSound(soundId)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Parent = workspace
    sound:Play()
    task.delay(sound.TimeLength, function()
        sound:Destroy()
    end)
end

function UIAnimations.PlayRippleConfetti(mouseX, mouseY)
    local rippleContainer = Instance.new("ScreenGui")
    rippleContainer.Name = "RippleContainer"
    rippleContainer.Parent = playerGui

    local ripple = Instance.new("Frame")
    ripple.Name = "RippleConfetti"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 1
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0, mouseX, 0, mouseY)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = 2 -- Adjust the ZIndex as needed
    ripple.Parent = rippleContainer

    local rippleSize = UDim2.new(0, 2 * 50, 0, 2 * 50)
    local rippleTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(ripple, rippleTweenInfo, { Size = rippleSize, BackgroundTransparency = 0.5 }):Play()

    for i = 1, 30 do
        task.spawn(function()
            local particle = Instance.new("ImageLabel")
            particle.Name = "ConfettiParticle"
            particle.BackgroundTransparency = 1
            particle.Image = "rbxassetid://13219651918" -- Replace with the image ID of your confetti sprite
            particle.ImageColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            particle.Position = UDim2.new(0.5, 0, 0.5, 0)
            particle.Size = UDim2.new(0, 10, 0, 10)
            particle.ZIndex = 2 -- Adjust the ZIndex as needed
            particle.Parent = rippleContainer

            local angle = math.rad(math.random(0, 360))
            local radius = math.random(10, 50)
            local offsetX = math.cos(angle) * radius
            local offsetY = math.sin(angle) * radius

            local particlePosition = UDim2.new(0.5, offsetX, 0.5, offsetY)
            local particleTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local particleProperties = {
                Position = particlePosition,
                Size = UDim2.new(0, 30, 0, 30),
                Rotation = math.random(-180, 180),
                BackgroundTransparency = 0,
                ImageTransparency = 0.5,
            }
            TweenService:Create(particle, particleTweenInfo, particleProperties):Play()

            task.wait(0.5)

            particle:Destroy()
        end)
    end

    task.wait(0.5)

    ripple:Destroy()
    rippleContainer:Destroy()
end




return UIAnimations
