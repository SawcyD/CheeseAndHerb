local Players = game:GetService("Players")
local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local ScreenGui = PlayerGui.ScreenGui
local HUD = ScreenGui.HUD
local TestButtonsFrame = HUD.TestButtons

local AddCoinsButton = TestButtonsFrame.AddCoinsButton
local AddMysticShardsButton = TestButtonsFrame.AddShardsButton

local AddCoinsTextBox = AddCoinsButton.AmountTextBox
local AddMysticShardsTextBox = AddMysticShardsButton.AmountTextBox

local TestButtons = {}

local function GetNumberFromTextBox(textBox)
    local text = textBox.Text
    local number = tonumber(text)
    
    if number then
        return number
    else
        return nil
    end
end
function TestButtons.Init()
    AddCoinsButton.MouseButton1Click:Connect(function()
        local amount = GetNumberFromTextBox(AddCoinsTextBox)
        
        if amount and amount > 0 then
            EasyNetwork:InvokeServer("AddTestCoins", amount)
        else
            print("Invalid amount!")
        end
    end)
    
    AddMysticShardsButton.MouseButton1Click:Connect(function()
        local amount = GetNumberFromTextBox(AddMysticShardsTextBox)
        
        if amount and amount > 0 then
            EasyNetwork:InvokeServer("AddTestMysticShards", amount)
        else
            print("Invalid amount!")
        end
    end)
end





return TestButtons