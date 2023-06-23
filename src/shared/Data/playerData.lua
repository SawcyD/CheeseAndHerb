local playerData = {
    Inventory = {
        Ingredients = {
            BagStackAmountMax = 25,
            BagSlots = 10,
            IngredientsBag = {},

        },
        Pills = {},
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
    EquippedWeapon = {
        Name = "Excalibur",
        WeaponType = "GreatSword",
        Equipped = true
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
    PillBags = {
        "Novice's Pill Bag",
        --more
    },

    -- Stats
    StatPoints = 3, -- The number of available stat points for the player to allocate
    Damage = 0, -- increases the damage of the player by .1% per point
    Health = 0, -- increases the health of the player by .1% per point
    Stamina = 0, -- increases the stamina of the player by .1% per point
    Blocking = false,

    BlockDamageReduction = .4,

    CriticalChance = 0.1,

    CriticalMultiplier = 1.5,

    -- Achievements
    EnemiesKilled = 0

    

}

return playerData
