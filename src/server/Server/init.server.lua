local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.Server.Modules.DataService)
local UserInputService = game:GetService("UserInputService")
local CraftingService = require(ServerScriptService.Server.Modules.CraftingService)
local ZoneService = require(ServerScriptService.Server.Modules.ZoneService)
local BagService = require(ServerScriptService.Server.Modules.BagService)
local TestService = require(ServerScriptService.Server.Modules.TestService)
local EnemyService = require(ServerScriptService.Server.Modules.EnemyService)

local WeaponService = require(ServerScriptService.Server.Modules.WeaponService)

DataService:Init()
task.wait(5)

local player = game.Players.LocalPlayer

-- Initialize the crafting service for the player
CraftingService:Initialize(player)
ZoneService.Init()
BagService:Init()
EnemyService:SetUp()


-- Test adding a bag
TestService:testing()
-- Test adding ingredients
CraftingService:AddIngredient(player, "Herb", 5)
CraftingService:AddIngredient(player, "Mushroom", 3)
CraftingService:AddIngredient(player, "Water", 1)

-- Test adding a recipe
CraftingService:AddRecipe(player, "HealingPill")

-- Test crafting a pill
CraftingService:CraftPill(player, "HealingPill")


UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.E then
        print("E : From Server")
        WeaponService:EquipWeapon(player)
    end
end)