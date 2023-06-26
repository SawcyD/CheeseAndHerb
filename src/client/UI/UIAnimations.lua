local playerGui = game.Players.LocalPlayer.PlayerGui
local screenGui = playerGui:WaitForChild("ScreenGui")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local UIAnimations = {}

UIAnimations.buttonToFrameMap = {
    InventoryButton = "InventoryFrame", -- Mapping: Button1 corresponds to Frame1
    Button2 = "Frame2",
    StatsButton = "StatsFrame",

}

UIAnimations.labelOriginalValues = {
    TextLabel1 = 0, -- Original value for TextLabel1
    TextLabel2 = 0, -- Original value for TextLabel2
    -- Add more original values as needed
}

UIAnimations.labelAnimationValues = {
    TextLabel1 = 100, -- Animation value for TextLabel1
    TextLabel2 = 200, -- Animation value for TextLabel2
    -- Add more animation values as needed
}

UIAnimations.frameSizes = {
    Frame1 = UDim2.new(0.535, 0,0.569, 0), -- Size for Frame1
    Frame2 = UDim2.new(.5, 0, .5, 0), -- Size for Frame2
    -- Add more frame sizes as needed
}

UIAnimations.frameAnimationDuration = 0.3 -- Duration (in seconds) for frame animations

function UIAnimations.Init()
    -- Find and connect button events
    local buttons = screenGui:GetDescendants()
    for _, button in ipairs(buttons) do
        if button:IsA("TextButton") or button:IsA("ImageButton") then
            button.MouseEnter:Connect(function()
                UIAnimations.HandleButtonHover(button, 1.3)
            end)
            button.MouseLeave:Connect(function()
                UIAnimations.HandleButtonHover(button, 1)
                UIAnimations.hideTooltip(button)
            end)
            button.MouseButton1Click:Connect(function()
                UIAnimations.PlayButtonSound("rbxassetid://5393362166")
                UIAnimations.HandleButtonClick(button)
                UIAnimations.PlayRippleConfetti(button)
            end)
        end
    end

    UIAnimations.rainbowText("Hello, world!", Enum.Font.FredokaOne, 24)

    -- find and connect label events
    local labels = screenGui:GetDescendants()
    for _, label in ipairs(labels) do
        if label:IsA("TextLabel") then
            -- Store the original value of the label
            UIAnimations.labelOriginalValues[label.Name] = tonumber(label.Text) or 0

            -- Connect events to handle label animations
            label.Changed:Connect(function(property)
                if property == "Text" then
                    -- Calculate the target value for animation
                    local targetValue = tonumber(label.Text) or 0

                    -- Animate the label value
                    UIAnimations.AnimateTextLabelValue(label, targetValue, 1)
                end
            end)
        end
    end
end

local function wrapText(text, font, textSize, maxWidth)
    local lines = {}
    local line = ""
    
    for word in text:gmatch("%S+") do
        local wordSize = TextService:GetTextSize(word, textSize, font, Vector2.new(math.huge, math.huge))
        
        if #line == 0 or TextService:GetTextSize(line .. " " .. word, textSize, font, Vector2.new(math.huge, math.huge)).X <= maxWidth then
            line = line .. " " .. word
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

function UIAnimations.rainbowText(text, font, textSize)
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
    local wrappedText = wrapText(text, font, textSize, math.huge)
    
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
            
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
            -- local tween = TweenService:Create(charLabel, tweenInfo, {TextColor3 = rainbowColors[(i + j + 1) % #rainbowColors + 1]})
            -- tween:Play()
            
            textSizeX = textSizeX + charSize.X
        end
        
        textSizeX = 0
        textSizeY = textSizeY + textSize
    end
end
function UIAnimations.AnimateTextLabelValue(label, targetValue, scaleFactor)
    -- Get the original value and calculate the animated value
    local originalValue = UIAnimations.labelOriginalValues[label.Name]
    local animatedValue = originalValue + (targetValue - originalValue) * scaleFactor

    -- Create a new Tween
    local tweenService = game:GetService("TweenService")
    -- local tweenInfo = TweenInfo.new(UIAnimations.frameAnimationDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    -- local tween = tweenService:Create(label, tweenInfo, { Text = tostring(animatedValue) })

    -- Play the Tween
    -- tween:Play()
end

function UIAnimations.HandleButtonClick(button)
    -- Check if the button is associated with a frame
    local frameName = UIAnimations.buttonToFrameMap[button.Name]
    print(frameName)
    if frameName then
        -- Find the frame
        local frame = screenGui:FindFirstChild(frameName)
        print(frame.Name)
        if frame then
            -- Toggle the visibility of the frame
            frame.Visible = not frame.Visible
            -- Perform animations based on visibility state
            if frame.Visible then
                UIAnimations.OpenFrame(frame, UIAnimations.frameSizes[frameName])
            else
                UIAnimations.CloseFrame(frame, UDim2.new(0, 0, 0, 0))
            end
        end
    end
end

function UIAnimations.hideTooltip(button)
    local tooltips = button:GetChildren()
    for i = 1, #tooltips do
        if tooltips[i].Name == "Tooltip" then
            tooltips[i].Visible = false
            tooltips[i]:Destroy()
        end
    end
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

function UIAnimations.HandleButtonHover(button, scaleFactor)
    -- Calculate the scale factor based on the original size of the button
    local originalSize = button.Size
    local scaledSize = UDim2.new(originalSize.X.Scale * scaleFactor, originalSize.X.Offset * scaleFactor, originalSize.Y.Scale * scaleFactor, originalSize.Y.Offset * scaleFactor)
    -- Tween the button's size to make it slightly bigger while preserving aspect ratio
    UIAnimations.PlayButtonSound("rbxassetid://5393362166")
    button:TweenSize(scaledSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, UIAnimations.frameAnimationDuration, true)
    
    -- Create a TextLabel to display the tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Name = "Tooltip"
    tooltip.Parent = button
    tooltip.BackgroundTransparency = 1
    tooltip.Position = UDim2.new(0, 0, 1, 5)
    tooltip.Size = UDim2.new(0, 100, 0, 20)
    tooltip.Font = Enum.Font.FredokaOne
    tooltip.TextSize = 14
    tooltip.TextColor3 = Color3.new(1, 1, 1)
    tooltip.Text = "This is a tooltip!"
    
    -- Show the tooltip
    tooltip.Visible = true
end

function UIAnimations.OpenFrame(frame, frameSize)
    -- Example: Tween the frame's position or size to animate its opening
    frame:TweenSize(frameSize, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, UIAnimations.frameAnimationDuration, true)
end

function UIAnimations.CloseFrame(frame, frameSize)
    -- Example: Tween the frame's position or size to animate its closing
    frame:TweenSize(frameSize, Enum.EasingDirection.In, Enum.EasingStyle.Sine, UIAnimations.frameAnimationDuration, true)
end

function UIAnimations.PlayRippleConfetti(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "RippleConfetti"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 1
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button

    ripple:TweenSize(
        UDim2.new(0, 2 * 50, 0, 2 * 50),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Quad,
        0.5,
        false
    )

    for i = 1, 30 do
        task.spawn(function()
            local particle = Instance.new("ImageLabel")
            particle.Name = "ConfettiParticle"
            particle.BackgroundTransparency = 1
            particle.Image = "rbxassetid://13219651918" -- Replace with the image ID of your confetti sprite
            particle.ImageColor3 = Color3.fromRGB(255, 255, 255)
            particle.Position = UDim2.new(0.5, 0, 0.5, 0)
            particle.Size = UDim2.new(0, 10, 0, 10)
            particle.ZIndex = button.ZIndex + 1
            particle.Parent = button

            local angle = math.rad(math.random(0, 360))
            local radius = math.random(10, 50)
            local offsetX = math.cos(angle) * radius
            local offsetY = math.sin(angle) * radius

            particle:TweenPosition(
                UDim2.new(0.5, offsetX, 0.5, offsetY),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quad,
                0.5,
                false
            )

            task.wait(0.5)

            particle:Destroy()
        end)
    end

    task.wait(0.5)

    ripple:Destroy()
end

return UIAnimations