local recipeData = {
    -- Existing Recipes
    HealingPill = {
        DisplayName = "Healing Pill",
        Description = "A pill that restores health.",
        Ingredients = {
            { Name = "Herb", Amount = 5 },
            { Name = "Mushroom", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 10,
        CraftingTime = 5, -- Crafting time in seconds
    },
    EnergyPill = {
        DisplayName = "Energy Pill",
        Description = "A pill that boosts energy.",
        Ingredients = {
            { Name = "Herb", Amount = 3 },
            { Name = "Flower", Amount = 1 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 15,
        CraftingTime = 3, -- Crafting time in seconds
    },
    InvisibilityPill = {
        DisplayName = "Invisibility Pill",
        Description = "A pill that grants invisibility.",
        Ingredients = {
            { Name = "Mushroom", Amount = 3 },
            { Name = "Flower", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 20,
        CraftingTime = 8, -- Crafting time in seconds
    },
    StrengthPill = {
        DisplayName = "Strength Pill",
        Description = "A pill that enhances physical strength.",
        Ingredients = {
            { Name = "GinsengRoot", Amount = 4 },
            { Name = "TurmericPowder", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 25,
        CraftingTime = 10, -- Crafting time in seconds
    },
    ShieldPill = {
        DisplayName = "Shield Pill",
        Description = "A pill that provides temporary protection against attacks.",
        Ingredients = {
            { Name = "GingerRoot", Amount = 3 },
            { Name = "LicoriceRoot", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 30,
        CraftingTime = 12, -- Crafting time in seconds
    },
    FirePill = {
        DisplayName = "Fire Pill",
        Description = "A pill that imbues the user with the power of fire.",
        Ingredients = {
            { Name = "Mushroom", Amount = 4 },
            { Name = "GingerRoot", Amount = 3 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 35,
        CraftingTime = 15, -- Crafting time in seconds
    },
    IcePill = {
        DisplayName = "Ice Pill",
        Description = "A pill that imbues the user with the power of ice.",
        Ingredients = {
            { Name = "GinsengRoot", Amount = 3 },
            { Name = "ChamomileFlowers", Amount = 3 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 40,
        CraftingTime = 15, -- Crafting time in seconds
    },
    LightningPill = {
        DisplayName = "Lightning Pill",
        Description = "A pill that imbues the user with the power of lightning.",
        Ingredients = {
            { Name = "GingerRoot", Amount = 2 },
            { Name = "Echinacea", Amount = 2 },
            { Name = "ChamomileFlowers", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 45,
        CraftingTime = 18, -- Crafting time in seconds
    },
    UltimatePill = {
        DisplayName = "Ultimate Pill",
        Description = "The ultimate pill that grants extraordinary abilities.",
        Ingredients = {
            { Name = "GinsengRoot", Amount = 5 },
            { Name = "TurmericPowder", Amount = 4 },
            { Name = "GingerRoot", Amount = 3 },
            { Name = "Echinacea", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 50,
        CraftingTime = 20, -- Crafting time in seconds
    },
    
    -- Additional Recipes
    QuickPotion = {
        DisplayName = "Quick Potion",
        Description = "A potion that enhances movement speed temporarily.",
        Ingredients = {
            { Name = "LicoriceRoot", Amount = 3 },
            { Name = "MintLeaf", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 15,
        CraftingTime = 6, -- Crafting time in seconds
    },
    FocusElixir = {
        DisplayName = "Focus Elixir",
        Description = "An elixir that improves mental focus and concentration.",
        Ingredients = {
            { Name = "RosemaryLeaves", Amount = 3 },
            { Name = "GinkgoBiloba", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 20,
        CraftingTime = 8, -- Crafting time in seconds
    },
    RagePotion = {
        DisplayName = "Rage Potion",
        Description = "A potion that increases physical strength and aggression.",
        Ingredients = {
            { Name = "GingerRoot", Amount = 4 },
            { Name = "Ashwagandha", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 25,
        CraftingTime = 10, -- Crafting time in seconds
    },
    StealthTonic = {
        DisplayName = "Stealth Tonic",
        Description = "A tonic that makes the user less noticeable and harder to detect.",
        Ingredients = {
            { Name = "ChamomileFlowers", Amount = 3 },
            { Name = "LicoriceFernRoot", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 30,
        CraftingTime = 12, -- Crafting time in seconds
    },
    ResistanceElixir = {
        DisplayName = "Resistance Elixir",
        Description = "An elixir that enhances resistance to various elements and ailments.",
        Ingredients = {
            { Name = "GinsengRoot", Amount = 3 },
            { Name = "TurmericPowder", Amount = 2 },
            { Name = "Ashwagandha", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 35,
        CraftingTime = 15, -- Crafting time in seconds
    },
    FlamePotion = {
        DisplayName = "Flame Potion",
        Description = "A potion that creates a burst of flames upon impact.",
        Ingredients = {
            { Name = "GingerRoot", Amount = 3 },
            { Name = "Dragonfruit", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 40,
        CraftingTime = 15, -- Crafting time in seconds
    },
    FrostElixir = {
        DisplayName = "Frost Elixir",
        Description = "An elixir that freezes enemies and reduces their movement.",
        Ingredients = {
            { Name = "ChamomileFlowers", Amount = 3 },
            { Name = "PeppermintLeaves", Amount = 3 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 45,
        CraftingTime = 18, -- Crafting time in seconds
    },
    ThunderTonic = {
        DisplayName = "Thunder Tonic",
        Description = "A tonic that releases powerful electric shocks upon contact.",
        Ingredients = {
            { Name = "GingerRoot", Amount = 2 },
            { Name = "Echinacea", Amount = 2 },
            { Name = "RosemaryLeaves", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 50,
        CraftingTime = 20, -- Crafting time in seconds
    },
    ElixirOfEternity = {
        DisplayName = "Elixir of Eternity",
        Description = "An elixir that grants immortality for a short period.",
        Ingredients = {
            { Name = "GinsengRoot", Amount = 5 },
            { Name = "ChamomileFlowers", Amount = 4 },
            { Name = "LicoriceRoot", Amount = 3 },
            { Name = "Ashwagandha", Amount = 2 },
            { Name = "Water", Amount = 1 },
        },
        SkillRequirement = 55,
        CraftingTime = 25, -- Crafting time in seconds
    },
}

return recipeData
