local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ReplicaController = require(ReplicatedStorage.Util.ReplicaController)
local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)

ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
    UserInputService.InputBegan:Connect(function(input, isProcessed)
        if input.KeyCode == Enum.KeyCode.E then
            EasyNetwork:FireServer("WeaponEquipping")
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            EasyNetwork:FireServer("PlayLightAttack", input)

        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            EasyNetwork:FireServer("PlayHeavyAttack", input)
        end
        
        
    end)
end)