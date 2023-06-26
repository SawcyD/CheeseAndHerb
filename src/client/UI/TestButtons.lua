local Players = game:GetService("Players")
local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)

local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = Player.PlayerGui
local ScreenGui = PlayerGui.ScreenGui
local HUD = ScreenGui.HUD
local TestButtonsFrame = HUD.TestButtons

local AddCoinsButton = TestButtonsFrame.AddCoinsButton
local AddMysticShardsButton = TestButtonsFrame.AddShardsButton
local AddLevelButton = TestButtonsFrame.AddLevelButton

local AddCoinsTextBox = AddCoinsButton.AmountTextBox
local AddMysticShardsTextBox = AddMysticShardsButton.AmountTextBox

local TestButtons = {}

local function GetNumberFromTextBox(textBox)
    local text = textBox.Text
    local number = tonumber(text) or 200 -- if there is no number then it will be 200
    
    if number then
        return number
    else
        return nil
    end
end
function TestButtons.Init()
    AddCoinsButton.MouseButton1Click:Connect(function()
        local amount = GetNumberFromTextBox(AddCoinsTextBox)
        EasyNetwork:FireServer("AddTestCoins", Player, amount)
    end)

    AddLevelButton.MouseButton1Click:Connect(function()
        EasyNetwork:FireServer("LevelUP")
    end)
    
    AddMysticShardsButton.MouseButton1Click:Connect(function()
        local amount = GetNumberFromTextBox(AddMysticShardsTextBox)
        EasyNetwork:FireServer("AddTestMysticShards", Player,  amount)
    end)
end





return TestButtons