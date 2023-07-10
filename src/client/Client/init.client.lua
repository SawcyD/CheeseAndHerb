local PlayerService = require(script.PlayerService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

-- Configurable, and you can choose multiple keys
Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })

PlayerService.Init()