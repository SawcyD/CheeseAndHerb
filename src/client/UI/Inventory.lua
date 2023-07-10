-- ClientInventoryModule.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIFolder = ReplicatedStorage.Assets.UI
local Player = game.Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local ScreenGui = PlayerGui.ScreenGui
local Frame = ScreenGui.InventoryFrame
local Inventory = Frame.Inventory
local SlotTemplate = UIFolder.Slot
local IngredientModels = ReplicatedStorage.Assets.Ingredients:GetChildren()
local MaxBagSlotsText = Frame.slot
local MaxBagStackText = Frame.Stack

local ReplicaController = require(ReplicatedStorage.Util.ReplicaController)

local inventory = {} -- New inventory table to store ingredient data

local function getIngredientModel(ingredientName)
    for _, model in ipairs(IngredientModels) do
        if model.Name == ingredientName then
            return model
        end
    end
    return nil
end



local function clearInventoryUI()
    for _, child in ipairs(Inventory:GetChildren()) do
        if child ~= SlotTemplate then
            child:Destroy()
        end
    end
end

local function createInventorySlot(ingredientName, stackAmount)
    local slot = SlotTemplate:Clone()
    slot.Name = ingredientName

    local nameLabel = slot.ItemName
    local stackLabel = slot.Amount
    local viewportImage = slot.ViewportFrame

    nameLabel.Text = ingredientName
    stackLabel.Text = "x" .. tostring(stackAmount) -- Update to use stackAmount parameter
    local ingredientModel = getIngredientModel(ingredientName)
    if ingredientModel then
        local modelCopy = ingredientModel:Clone()
        modelCopy.Parent = viewportImage
        modelCopy.CFrame = CFrame.new(Vector3.new(), Vector3.new(0, 0, -1))
    end

    slot.Parent = Inventory
end

local function updateInventoryUI(inventory)
    -- Clear the inventory UI
    clearInventoryUI()

    -- Iterate over the inventory data
    for ingredientName, stackAmount in pairs(inventory) do
        -- Check if a slot already exists for the ingredient
        local slot = Inventory:FindFirstChild(ingredientName)
        if slot then
            -- Update the stack amount in the existing slot
            local stackLabel = slot.Amount
            stackLabel.Text = "x" .. tostring(stackAmount)
        else
            -- Create a new slot for the ingredient
            createInventorySlot(ingredientName, stackAmount)
        end
    end
end

local function updateMaxBagSlotsText(maxSlots)
    MaxBagSlotsText.Text = "Max Bag Slots: " .. maxSlots
end

local function updateMaxBagStackText(maxStack)
    MaxBagStackText.Text = "Max Bag Stack: " .. maxStack
end

local function refreshInventory()
    ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
        if replica then
            local replicaData = replica.Data
            local ingredientsBag = replicaData.Inventory.Ingredients.IngredientsBag
            local bagSlots = replicaData.Inventory.Ingredients.BagSlots
            local bagStackAmountMax = replicaData.Inventory.Ingredients.BagStackAmountMax

            updateInventoryUI(ingredientsBag)
            updateMaxBagSlotsText(bagSlots)
            updateMaxBagStackText(bagStackAmountMax)
        end
    end)
end

local function init()
    ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
        refreshInventory()

        replica:ListenToChange({"Inventory", "Ingredients", "IngredientsBag"}, function()
            refreshInventory()
        end)

        replica:ListenToChange({"Inventory", "Ingredients", "BagSlots"}, function()
            refreshInventory()
        end)

        replica:ListenToChange({"Inventory", "Ingredients", "BagStackAmountMax"}, function()
            refreshInventory()
        end)
    end)
end

ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
    local replicaData = replica.Data
    local ingredientsBag = replicaData.Inventory.Ingredients.IngredientsBag
    local bagSlots = replicaData.Inventory.Ingredients.BagSlots
    local bagStackAmountMax = replicaData.Inventory.Ingredients.BagStackAmountMax

    -- Update the inventory UI
    updateInventoryUI(ingredientsBag)
    updateMaxBagSlotsText(bagSlots)
    updateMaxBagStackText(bagStackAmountMax)
end)

local ClientInventoryModule = {}
ClientInventoryModule.Init = init
ClientInventoryModule.UpdateInventoryUI = updateInventoryUI

return ClientInventoryModule
