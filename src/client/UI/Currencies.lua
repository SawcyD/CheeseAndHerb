local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(0.299)

local labelTweenMap = {}

local Abbreviations = require(game:GetService("ReplicatedStorage").Libs.Abbreviations)



local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ScreenGui = PlayerGui.ScreenGui
local HUD = ScreenGui.HUD
local CurrenciesFrame = HUD.CurrenciesFrame

local HerbalCoins = CurrenciesFrame.HerbalCoins
local MysticShards = CurrenciesFrame.MysticShards
local coinsAmount = HerbalCoins.Amount
local shardsAmount = MysticShards.Amount

local TweenNumberCoins = Instance.new("NumberValue")
TweenNumberCoins.Parent = coinsAmount

local TweenNumberShards = Instance.new("NumberValue")
TweenNumberShards.Parent = shardsAmount

local Currencies = {}

local ReplicaController = require(game:GetService("ReplicatedStorage").Util.ReplicaController)

ReplicaController.RequestData()

local function RoundNumber(number)
    return math.floor(number + 0.5)
end

local function AnimateNumberLabel(label, tweenNumber, goalValue)
    local startValue = tweenNumber.Value
    local tween = TweenService:Create(tweenNumber, tweenInfo, { Value = goalValue })
    labelTweenMap[tweenNumber] = tween
    tween:Play()

    task.spawn(function()
        tween.Completed:Wait()
    end)
    tween.Changed:Connect(function()
        local newTweenValue = RoundNumber(tweenNumber.Value)
        label.Text = Abbreviations.AbbreviateNumber(newTweenValue, 2)
    end)

    local goalAbbreviated = Abbreviations.AbbreviateNumber(goalValue, 2)
    for i = 0, tweenInfo.Time, 0.1 do
        local value = RoundNumber(startValue + (goalValue - startValue) * i / tweenInfo.Time)
        tweenNumber.Value = value
        label.Text = Abbreviations.AbbreviateNumber(value, 2)
        task.wait(0.1)
    end
    tweenNumber.Value = goalValue
    label.Text = goalAbbreviated
end


function Currencies.Init()
    ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
        local isLocal = replica.Tags.Player == Player
        local playerName = isLocal and "your" or replica.Tags.Player.Name .. "'s"
        local replicaData = replica.Data

        -- Assign the initial values to the text labels
        HerbalCoins.Amount.Text = tostring(Abbreviations.AbbreviateNumber(replicaData.HerbalCoins, 2))
        MysticShards.Amount.Text = tostring(Abbreviations.AbbreviateNumber(replicaData.MysticShards, 2))
    
        
        replica:ListenToChange({"HerbalCoins"}, function(newValues)
            local goalValue = replicaData.HerbalCoins
            AnimateNumberLabel(coinsAmount, TweenNumberCoins, goalValue)
        end)
        
        replica:ListenToChange({"MysticShards"}, function(newValues)
            local goalValue = replicaData.MysticShards
            AnimateNumberLabel(shardsAmount, TweenNumberShards, goalValue)
        end)

        print("Received " .. playerName .. " player profile; HerbalCoins:", replicaData.HerbalCoins)
        print("Received " .. playerName .. " player profile; MysticShards:", replicaData.MysticShards)
    
    
    end)
end



return Currencies