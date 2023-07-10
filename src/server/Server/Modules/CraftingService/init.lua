-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = game.Players:GetPlayers()[1] or game.Players.PlayerAdded:Wait()

-- Modules
local Manager = require(game:GetService("ServerScriptService").Server.PlayerData.Manager)
local DataService = require(game:GetService("ServerScriptService").Server.Modules.DataService)
local EasyNetwork = require(game:GetService("ReplicatedStorage").Libs.Network)

-- Create the crafting service
local CraftingService = {}

-- Load recipe and ingredient data
local recipeData = require(ReplicatedStorage.Data.recipeData)
local ingredientData = require(ReplicatedStorage.Data.ingredientsData)

CraftingService.Passes = {
    x2LuckChance = 1, -- do
}


-- Function to check if a player has the required ingredients for a recipe
local function hasEnoughIngredients(recipe)
    DataService:GetReplica(Player):andThen(function(replica)
        local inventory = replica.Data.Inventory.Ingredients.IngredientsBag

        -- Debug statement: print out the contents of the player's inventory data
        for ingredientName, amount in pairs(inventory) do
            print(ingredientName, amount)
        end

        for _, ingredient in ipairs(recipe.Ingredients) do
            local requiredAmount = ingredient.Amount
            local availableAmount = inventory[ingredient.Name].Amount or 0


            if availableAmount < requiredAmount then
                return false
            end
        end

        return true

    end)
end

-- Function to deduct ingredients from a player's inventory
local function deductIngredients(recipe)
    DataService:GetReplica(Player):andThen(function(replica)
        local inventory = replica.Data.Inventory.Ingredients.IngredientsBag

        for _, ingredient in ipairs(recipe.Ingredients) do
            inventory[ingredient.Name] = inventory[ingredient.Name] - ingredient.Amount
        end
    end)
end

-- Function to simulate the crafting process
local function simulateCraftingProcess(craftingTime)
    -- Simulate the crafting process here (e.g., wait for the specified crafting time)
    task.wait(craftingTime)
end

-- Function to add a recipe to a player's collection
function CraftingService:AddRecipe(recipeName)
    DataService:GetReplica(Player):andThen(function(replica)
        local recipe = recipeData[recipeName]

        if not recipe then
            -- Recipe not found, handle the error or return an error message
            warn("Recipe not found | AddRecipe")
            return
        end

        -- Remove any existing recipes from the player's collection
        for existingRecipeName, _ in pairs(replica.Data.Recipes) do
            if existingRecipeName ~= recipeName then
                replica.Data.Recipes[existingRecipeName] = nil
            end
        end

        -- Add the recipe to the player's collection
        replica.Data.Recipes[recipeName] = recipe

        print(replica.Data.Recipes)
        -- Return a success message or any relevant data
        return "Successfully added recipe: " .. recipeName
    end)
end

-- Function to craft a pill based on the provided recipe
function CraftingService:CraftPill(recipeName)
    DataService:GetReplica(Player):andThen(function(replica)
        local recipe = replica.Data.Recipes[recipeName]

        if not recipe then
            -- Recipe not found, handle the error or return an error message
            warn("Recipe not found | CraftPill")
            return
        end

        if not hasEnoughIngredients(recipe) then
            -- Player does not have enough ingredients, handle the error or return an error message
            warn("Player does not have enough ingredients")
            return
        end

        -- Deduct the ingredients from the player's inventory
        deductIngredients(recipe)

        -- Simulate the crafting process
        simulateCraftingProcess(recipe.CraftingTime)

        -- Add the crafted pill item to the player's inventory
        replica.Data.Inventory.Pills[recipeName] = (replica.Data.Inventory.Pills[recipeName] or 0) + 1

        -- Save the updated player data to the data store (using the appropriate data store service)

        -- Return a success message or any relevant data
        print("Successfully crafted " .. recipeName .. " Pill.")

        print(replica.Data.Inventory.Pills)
        return "Successfully crafted " .. recipeName .. " Pill."
    end)
end

-- Function to add an ingredient to a player's inventory
-- function CraftingService:AddIngredient(ingredientName, amount)
--     DataService:GetReplica(Player):andThen(function(replica)
--         local ingredient = ingredientData[ingredientName]

--         if not ingredient then
--             -- Ingredient not found, handle the error or return an error message
--             warn("Ingredient not found: ".. ingredientName)
--             return
--         end

--         -- Add the specified amount of ingredient to the player's inventory
--         local inventory = replica.Data.Inventory.Ingredients.IngredientsBag
--         inventory[ingredientName] = {Amount = amount}

--         -- Add the ingredient name to the list of all ingredients in the player's inventory
       
--         replica:SetValue({"Inventory.Ingredients.IngredientsList", ingredientName}, {Amount = amount})
       

--         -- Check if the player has all the ingredients for any recipe
--         local missingIngredients = {}

--         for recipeName, recipe in pairs(recipeData) do
--             if not hasEnoughIngredients(recipe) then
--                 table.insert(missingIngredients, recipeName)
--             end
--         end

--         -- Return the missing ingredients, if any
--         if #missingIngredients > 0 then
--             local missingIngredientsMessage = "Missing ingredients:"

--             for _, recipeName in ipairs(missingIngredients) do
--                 local recipe = recipeData[recipeName]

--                 for _, ingredient in ipairs(recipe.Ingredients) do
--                     local requiredAmount = ingredient.Amount - (replica.Data.Inventory.Ingredients.IngredientsBag[ingredient.Name] or 0)
--                     missingIngredientsMessage = missingIngredientsMessage .. "\n" .. requiredAmount .. " " .. ingredient.Name .. " for " .. recipeName
--                 end
--             end

--             return missingIngredientsMessage
--         end

--         -- Save the updated player data to the data store (using the appropriate data store service)

--         -- Return a success message or any relevant data
--         return "Successfully added " .. amount .. " " .. ingredientName
--     end)
-- end

-- Initialize the crafting service for each player
function CraftingService:Initialize(player)
    print("hello")
    -- Add additional initialization code here if needed
end

-- Hook the crafting service into player joining
Players.PlayerAdded:Connect(function(player)
    print("Started Crafting Service for " .. player.Name)
end)

-- Connections

EasyNetwork:BindFunctions({
    CraftPill = CraftingService.CraftPill,
    AddRecipe = CraftingService.AddRecipe

})

return CraftingService
