local playerData = {
    Inventory = {
        Ingredients = {
            BagStackAmountMax = 25,
            BagSlots = 10,
            IngredientsBag = {},

        },
        Elixirs = {
            BagStackAmountMax = 25,
            BagSlots = 10,
            ElixirsBag = {},
        },
        Weapons = {},
    },
    Recipes = {},
    UnlockedZones = {
        "StartingZone",
        -- more zones
    },
    Gamepasses = {},
    RobuxSpent = 0,

    Exp = 0,
    ExpGained = 0,
    Level = 0,
    HerbalCoins = 100,
    MysticShards = 0,
    RobuxTokens = 0, -- this allows the player to spend the token instead of robux, but it has the same eviquincy to robux, 1 == 1 
    FightingStyle = {
        Name = "Excalibur",

    },
    Quests = {
        Active = {},
        Completed = {}
    },
    Multiplier = 1,
    IngredientsBag = {
        OwnedBags = {
            "Novice's Ingredients Bag",
            --more
        },
        EquippedBag = "Novice's Ingredients Bag"
        
    },
    Elixirs = {
        "Novice's Pill Bag",
        --more
    },

    -- Stats
    StatPoints = 4, -- The number of available stat points for the player to allocate
    Attributes = {
        Damage = 0, -- increases the damage of the player by .1% per point
        Health = 0, -- increases the health of the player by .1% per point
        Stamina = 0, -- increases the stamina of the player by .1% per point
        Critical = 0, -- increases the critical chance of the player by .1% per point
        Luck = 0, -- increases the chance of getting a rare item by .1% per point
    },
    

    -- Achievements
    EnemiesKilled = 0

    

}

return playerData
