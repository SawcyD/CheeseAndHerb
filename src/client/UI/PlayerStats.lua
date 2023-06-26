local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)
local ReplicaController = require(game:GetService("ReplicatedStorage").Util.ReplicaController)

local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local ScreenGui = PlayerGui.ScreenGui
local StatsFrame = ScreenGui.StatsFrame
local InnerFrame = StatsFrame.Frame

-- Stats
local DamageStat = InnerFrame.DamageStat
local DamageAmounText = DamageStat.StatAmount
local DamageStatButton = DamageStat.TextButton

local HealthStat = InnerFrame.HealthStat
local HealthAmountText = HealthStat.StatAmount
local HealthStatButton = HealthStat.TextButton

local StaminaStat = InnerFrame.StaminaStat
local StaminaAmountText = StaminaStat.StatAmount
local StaminaStatButton = StaminaStat.TextButton

local StatsPointText = StatsFrame.StatsPoints

local AmountStatPoints = StatsFrame.TextBox

local PlayerStats = {}

ReplicaController.RequestData()

local function GetNumberFromTextBox(textBox)
    local text = textBox.Text
    local number = tonumber(text) or 1 -- if there is no number then it will be 200
    
    if number then
        return number
    else
        return nil
    end
end

ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
    local data = replica.Data
    DamageAmounText.Text = data.Stats.Damage
    HealthAmountText.Text = data.Stats.Health
    StaminaAmountText.Text = data.Stats.Stamina
    StatsPointText.Text = data.StatPoints
end)


function PlayerStats:UpdateData()
    ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
        local isLocal = replica.Tags.Player == Player
        local playerName = isLocal and "your" or replica.Tags.Player.Name .. "'s"
        local replicaData = replica.Data

        replica:ListenToChange({"Stats", "Damage"}, function(newValues)
            local value = replicaData.Stats.Damage 
            DamageAmounText.Text = tostring(value)
        end)

        replica:ListenToChange({"Stats", "Health"}, function(newValues)
            local value = replicaData.Stats.Health 
            HealthAmountText.Text = tostring(value)
        end)

        replica:ListenToChange({"Stats", "Stamina"}, function(newValues)
            local value = replicaData.Stats.Stamina 
            StaminaAmountText.Text = tostring(value)
        end)
        replica:ListenToChange({"StatPoints"}, function(newValues)
            local value = replicaData.StatPoints 
            StatsPointText.Text = tostring(value)
        end)

    end)

    
end

function PlayerStats:Init()
    DamageStatButton.MouseButton1Click:Connect(function()
        local amount = GetNumberFromTextBox(AmountStatPoints)
        EasyNetwork:FireServer("AddTestDamageStat", amount)
    end)

    HealthStatButton.MouseButton1Click:Connect(function()
        local amount = GetNumberFromTextBox(AmountStatPoints)
        EasyNetwork:FireServer("AddTestHealthStat", amount)
    end)

    StaminaStatButton.MouseButton1Click:Connect(function()
        local amount = GetNumberFromTextBox(AmountStatPoints)
        EasyNetwork:FireServer("AddTestStaminaStat", amount)
    end)
    
end


return PlayerStats