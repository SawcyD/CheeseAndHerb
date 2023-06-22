-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Modules
local Manager = require(game:GetService("ServerScriptService").Server.PlayerData.Manager)

-- Create the crafting service
local CraftingService = {}


local profile = {
    Data = {
        Recipes = {},
        Inventory = {
            Ingredients = {
                Herb = 5,
                Water = 5,
                Mushroom = 5,
                },
            Pills = {}
        }
    }
}





-- Load recipe and ingredient data
local recipeData = require(ReplicatedStorage.Data.recipeData)
local ingredientData = require(ReplicatedStorage.Data.ingredientsData)


-- Function to check if a player has the required ingredients for a recipe
local function hasEnoughIngredients(player, recipe)
    local inventory =profile.Data.Inventory.Ingredients

    -- Debug statement: print out the contents of the player's inventory data
    for ingredientName, amount in pairs(inventory) do
        print(ingredientName, amount)
    end

    for _, ingredient in ipairs(recipe.Ingredients) do
        local requiredAmount = ingredient.Amount
        local availableAmount = inventory[ingredient.Name] or 0

        -- Debug statement: print out the required and available amounts for each ingredient
        print("Ingredient: ".. ingredient.Name ..", Required: ".. requiredAmount ..", Available: ".. availableAmount)

        if availableAmount < requiredAmount then
            return false
        end
    end

    return true
end

-- Function to deduct ingredients from a player's inventory
local function deductIngredients(player, recipe)
    local profile = Manager.PlayerProfiles[player]
    if not profile then return end

    local inventory = profile.Data.Inventory.Ingredients

    for _, ingredient in ipairs(recipe.Ingredients) do
        inventory[ingredient.Name] = inventory[ingredient.Name] - ingredient.Amount
    end
end

-- Function to simulate the crafting process
local function simulateCraftingProcess(craftingTime)
    -- Simulate the crafting process here (e.g., wait for the specified crafting time)
    task.wait(craftingTime)
end

-- Function to add a recipe to a player's collection
function CraftingService:AddRecipe(player, recipeName)
    

    local recipe = recipeData[recipeName]

    if not recipe then
        -- Recipe not found, handle the error or return an error message
        warn("Recipe not found | AddRecipe")
        return
    end

    -- Remove any existing recipes from the player's collection
    for existingRecipeName, _ in pairs(profile.Data.Recipes) do
        if existingRecipeName ~= recipeName then
            profile.Data.Recipes[existingRecipeName] = nil
        end
    end

    -- Add the recipe to the player's collection
    profile.Data.Recipes[recipeName] = recipe

    print(profile.Data.Recipes)
    -- Return a success message or any relevant data
    return "Successfully added recipe: " .. recipeName
end

-- Function to craft a pill based on the provided recipe
function CraftingService:CraftPill(player, recipeName)

    local recipe = profile.Data.Recipes[recipeName]

    if not recipe then
        -- Recipe not found, handle the error or return an error message
        warn("Recipe not found | CraftPill")
        return
    end

    if not hasEnoughIngredients(player, recipe) then
        -- Player does not have enough ingredients, handle the error or return an error message
        warn("Player does not have enough ingredients")
        return
    end

    -- Deduct the ingredients from the player's inventory
    deductIngredients(player, recipe)

    -- Simulate the crafting process
    simulateCraftingProcess(recipe.CraftingTime)

    -- Add the crafted pill item to the player's inventory
    profile.Data.Inventory.Pills[recipeName] = (profile.Data.Inventory.Pills[recipeName] or 0) + 1

    -- Save the updated player data to the data store (using the appropriate data store service)

    -- Return a success message or any relevant data
    print("Successfully crafted " .. recipeName .. " Pill.")

    print(profile.Data.Inventory.Pills)
    return "Successfully crafted " .. recipeName .. " Pill."
end

-- Function to add an ingredient to a player's inventory
function CraftingService:AddIngredient(player, ingredientName, amount)


    local ingredient = ingredientData[ingredientName]

    if not ingredient then
        -- Ingredient not found, handle the error or return an error message
        warn("Ingredient not found: ".. ingredientName)
        return
    end

    -- Add the specified amount of ingredient to the player's inventory
    local inventory = profile.Data.Inventory.Ingredients
    inventory[ingredientName] = (inventory[ingredientName] or 0) + amount

    -- Add the ingredient name to the list of all ingredients in the player's inventory
    if not inventory._allIngredients then
        inventory._allIngredients = {}
    end
    table.insert(inventory._allIngredients, ingredientName)

    -- Check if the player has all the ingredients for any recipe
    local missingIngredients = {}

    for recipeName, recipe in pairs(recipeData) do
        if not hasEnoughIngredients(player, recipe) then
            table.insert(missingIngredients, recipeName)
        end
    end

    -- Return the missing ingredients, if any
    if #missingIngredients > 0 then
        local missingIngredientsMessage = "Missing ingredients:"

        for _, recipeName in ipairs(missingIngredients) do
            local recipe = recipeData[recipeName]

            for _, ingredient in ipairs(recipe.Ingredients) do
                local requiredAmount = ingredient.Amount - (profile.Data.Inventory.Ingredients[ingredient.Name] or 0)
                missingIngredientsMessage = missingIngredientsMessage .. "\n" .. requiredAmount .. " " .. ingredient.Name .. " for " .. recipeName
            end
        end

        return missingIngredientsMessage
    end

    -- Save the updated player data to the data store (using the appropriate data store service)

    -- Return a success message or any relevant data
    return "Successfully added " .. amount .. " " .. ingredientName
end

-- Initialize the crafting service for each player
function CraftingService:Initialize(player)
    -- Get or create the player's data  
    local profile = Manager.PlayerProfiles[player]
    if not profile then return end

    -- Initialize the player's crafting data
    RunService.Heartbeat:Connect(function()
        local lastPayout = os.clock()
        if os.clock() - lastPayout > 3 then
            lastPayout = os.clock()
            print("Payout!")
            for _, player_profile in pairs(Manager) do
                player_profile:giveCoins(100)
            end
        end
    end)

    -- Add additional initialization code here if needed
end

-- Hook the crafting service into player joining
Players.PlayerAdded:Connect(function(player)
    CraftingService:Initialize(player)
end)

return CraftingService
