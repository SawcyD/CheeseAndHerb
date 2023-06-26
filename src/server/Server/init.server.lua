local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.Server.Modules.DataService)
local UserInputService = game:GetService("UserInputService")
local CraftingService = require(ServerScriptService.Server.Modules.CraftingService)
local ZoneService = require(ServerScriptService.Server.Modules.ZoneService)
local BagService = require(ServerScriptService.Server.Modules.BagService)
local TestService = require(ServerScriptService.Server.Modules.TestService)
local EnemyService = require(ServerScriptService.Server.Modules.EnemyService)

local Cmdr = require(ServerScriptService.Server.Libs.Cmdr)

local WeaponService = require(ServerScriptService.Server.Modules.WeaponService)

local CommandsFolder = ServerScriptService.Server.Modules.Cmdr.Commands
local TypesFolder = ServerScriptService.Server.Modules.Cmdr.Types
local HooksFolder = ServerScriptService.Server.Modules.Cmdr.Hooks

DataService:Init()
task.wait(5)

local player = game.Players.LocalPlayer

-- Initialize the crafting service for the player
CraftingService:Initialize(player)
ZoneService.Init()
BagService:Init()
EnemyService:SetUp()

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterCommandsIn(CommandsFolder)
Cmdr:RegisterTypesIn(TypesFolder)
Cmdr:RegisterHooksIn(HooksFolder)


WeaponService:Init()



-- Test adding a recipe
CraftingService:AddRecipe("HealingPill")

-- Test crafting a pill
CraftingService:CraftPill("HealingPill")


