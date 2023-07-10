local module = {}

module.Passes = { --- GamePassName = GamePassId
    --- BagSlots 
    Plus50BagSlots = 1, -- add 50 the bag slots
    AncientBag = 0, -- this give a player 300 bag slots and 100 stack amount --- 499 Robux
    ElementalBag = 2, -- this give a player 500 bag slots and 200 stack amount --- ElementalBag: 799 Robux
    VIP = 3, --- Get VIP bag, 1.5x slots, 1.5x stack amount --- 999 Robux
    x2LuckyChance = 4, -- doubles the chance of items being dupelicated when crafted --- 99 Robux
    x2DropChance = 5, -- doubles the chance of items being dropped when enemies are killed --- 99 Robux
    x2Exp = 6, -- doubles the amount of exp gained when killing enemies --- 199 Robux
    x2HerbalCoins = 7, -- doubles the amount of gold gained when killing enemies --- 299 Robux
    x2MysticShards = 8, -- doubles the amount of gems gained when killing enemies --- 299 Robux
    InfiniteFastTravel = 9, -- allows the player to fast travel without using fast travel points --- 99 Robux
    x2CraftingSpeed = 10, -- doubles the speed of crafting --- 199 Robux
    AutoCrafting = 11, -- automatically crafts items when the player has the required ingredients, when the player picks the recipe and the amount the player wants --- 299 Robux or get from the challenge
    IngredientTracker = 12, -- allows the player to track ingredients, the player can pick the ingredient they want to track through the UI --- 99 Robux
    x2ChanceIngredients = 13, -- doubles the chance of ingredients being dropped when enemies are killed and when being collected --- 99 Robux
    DoaFightingStyle = 14, -- allows the player to use the fighting style of the Doa --- 399 Robux




}   


return module