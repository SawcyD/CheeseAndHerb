local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(0.3)

local labelTweenMap = {}



local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ScreenGui = PlayerGui.ScreenGui
local HUD = ScreenGui.HUD
local CurrenciesFrame = HUD.CurrenciesFrame

local HerbalCoins = CurrenciesFrame.HerbalCoins
local MysticShards = CurrenciesFrame.MysticShards
local coinsAmount = HerbalCoins.Amount
local shardsAmount = MysticShards.Amount

local Currencies = {}

local ReplicaController = require(game:GetService("ReplicatedStorage").Util.ReplicaController)

ReplicaController.RequestData()

local function RoundNumber(number)
    return math.floor(number + 0.5)
end

local function AnimateNumberLabel(label, goalValue)
    local tween = TweenService:Create(label, tweenInfo, {Text = tostring(goalValue)})
    labelTweenMap[label] = tween
    tween:Play()
    task.spawn(function()
        tween.Completed:Wait()
        -- Play a sound here lol!
    end)
    tween.Changed:Connect(function()
        local newTweenValue = RoundNumber(tween.Text)
        label.Text = tostring(newTweenValue)
    end)
end

function Currencies.Init()
    ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
        local isLocal = replica.Tags.Player == Player
        local playerName = isLocal and "your" or replica.Tags.Player.Name .. "'s"
        local replicaData = replica.Data

        -- Assign the initial values to the text labels
        HerbalCoins.Amount.Text = tostring(replicaData.HerbalCoins)
        MysticShards.Amount.Text = tostring(replicaData.MysticShards)
    
        
        replica:ListenToChange({"HerbalCoins"}, function(newValues)
            local goalValue = replicaData.HerbalCoins
            AnimateNumberLabel(coinsAmount, goalValue)
            print("Received " .. playerName .. " player profile; Cash:", replicaData.HerbalCoins)
        end)
        
        replica:ListenToChange({"MysticShards"}, function(newValues)
            local goalValue = replicaData.MysticShards
            AnimateNumberLabel(shardsAmount, goalValue)
            print("Received " .. playerName .. " player profile; Cash:", replicaData.HerbalCoins)
        end)


    
    
    end)
end



return Currencies