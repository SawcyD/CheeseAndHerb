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

local function getIngredientModel(ingredientName)
    for _, model in ipairs(IngredientModels) do
        if model.Name == ingredientName then
            return model
        end
    end
    return nil
end

ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
    local replicaData = replica.Data
    local ingredientsBag = replicaData.Inventory.Ingredients.IngredientsBag
    local bagSlots = replicaData.Inventory.Ingredients.BagSlots
    local bagStackAmountMax = replicaData.Inventory.Ingredients.BagStackAmountMax
    warn("--- Client ---")
    print(ingredientsBag)
    print(bagSlots)
    print(bagStackAmountMax)
    warn("--- Client ---")
end)


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
    stackLabel.Text = "x" .. tostring(ingredientName.stackAmount)
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
            stackLabel.Text = "x" .. tostring(ingredientName.Amount)
        else
            -- Create a new slot for the ingredient
            createInventorySlot(ingredientName, ingredientName.Amount)
        end
    end
end

local function updateMaxBagSlotsText(maxSlots)
    MaxBagSlotsText.Text = "Max Bag Slots: " .. maxSlots
end

local function updateMaxBagStackText(maxStack)
    MaxBagStackText.Text = "Max Bag Stack: " .. maxStack
end

local function init()
    ReplicaController.ReplicaOfClassCreated("PlayerProfile", function(replica)
        local replicaData = replica.Data
        local ingredientsBag = replicaData.Inventory.Ingredients.IngredientsBag
        local bagSlots = replicaData.Inventory.Ingredients.BagSlots
        local bagStackAmountMax = replicaData.Inventory.Ingredients.BagStackAmountMax

        updateInventoryUI(ingredientsBag)
        updateMaxBagSlotsText(bagSlots)
        updateMaxBagStackText(bagStackAmountMax)

        replica:ListenToChange({"Inventory", "Ingredients", "IngredientsBag"}, function()
            updateInventoryUI(replicaData.Inventory.Ingredients.IngredientsBag)
        end)

        replica:ListenToChange({"Inventory", "Ingredients", "BagSlots"}, function()
            updateMaxBagSlotsText(replicaData.Inventory.Ingredients.BagSlots)
        end)

        replica:ListenToChange({"Inventory", "Ingredients", "BagStackAmountMax"}, function()
            updateMaxBagStackText(replicaData.Inventory.Ingredients.BagStackAmountMax)
        end)
    end)
end

local ClientInventoryModule = {}
ClientInventoryModule.Init = init
ClientInventoryModule.UpdateInventoryUI = updateInventoryUI

return ClientInventoryModule
