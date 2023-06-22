-- this is the data table for the ingredient bags
-- Here is the legend
-- MaxStackAmount == The Max Number of ingredient a player can have in on slot
-- Slots == The number of slots in the bag
-- UniqueFeature == The unique feature of the bag
-- IngredientMultiplier == The multiplier for the ingredient when  picked up
-- Price == The price of the bag



local ingredientBags = {
    {
        Name = "Novice's Ingredient Bag",
        Description = "A small bag for novice alchemists",
        MaxStackAmount = 25,
        Slots = 10,
        UniqueFeature = "Beginner's Luck: Increased chance of finding rare ingredients",
        IngredientMultiplier = 1.0,
        Price = 100
    },
    {
        Name = "Apprentice's Ingredient Bag",
        Description = "A bag for apprentice alchemists",
        MaxStackAmount = 30,
        Slots = 12,
        UniqueFeature = "Sturdy Construction: Reduced chance of ingredient spoilage",
        IngredientMultiplier = 1.0,
        Price = 200
    },
    {
        Name = "Adept's Ingredient Bag",
        Description = "A bag for adept alchemists",
        MaxStackAmount = 35,
        Slots = 14,
        UniqueFeature = "Alchemy Pouch: Chance to multiply harvested ingredients",
        IngredientMultiplier = 1.2,
        Price = 300
    },
    {
        Name = "Journeyman's Ingredient Bag",
        Description = "A bag for journeyman alchemists",
        MaxStackAmount = 40,
        Slots = 16,
        UniqueFeature = "Gatherer's Satchel: Increased chance of finding rare and exotic ingredients",
        IngredientMultiplier = 1.0,
        Price = 400
    },
    {
        Name = "Expert's Ingredient Bag",
        Description = "A bag for expert alchemists",
        MaxStackAmount = 45,
        Slots = 18,
        UniqueFeature = "Efficient Organization: Increased efficiency in ingredient management",
        IngredientMultiplier = 1.0,
        Price = 500
    },
    {
        Name = "Artisan's Ingredient Bag",
        Description = "A bag crafted by skilled artisans",
        MaxStackAmount = 50,
        Slots = 20,
        UniqueFeature = "Chance to multiply harvested ingredients",
        IngredientMultiplier = 1.5,
        Price = 600
    },
    {
        Name = "Master's Ingredient Bag",
        Description = "A bag for master alchemists",
        MaxStackAmount = 55,
        Slots = 22,
        UniqueFeature = "Mystical Enchantment: Enhanced effects of brewed potions",
        IngredientMultiplier = 1.0,
        Price = 700
    },
    {
        Name = "Grandmaster's Ingredient Bag",
        Description = "A bag for grandmaster alchemists",
        MaxStackAmount = 60,
        Slots = 24,
        UniqueFeature = "Potion Master's Secret: Unlocks rare potion recipes",
        IngredientMultiplier = 1.0,
        Price = 800
    },
    {
        Name = "Elder's Ingredient Bag",
        Description = "A bag used by revered alchemists",
        MaxStackAmount = 65,
        Slots = 26,
        UniqueFeature = "Ageless Wisdom: Increased knowledge of potion properties",
        IngredientMultiplier = 1.1,
        Price = 900
    },
    {
        Name = "Sage's Ingredient Bag",
        Description = "A bag for wise alchemists",
        MaxStackAmount = 70,
        Slots = 28,
        UniqueFeature = "Elixir of Abundance: Higher chance of obtaining bonus ingredients",
        IngredientMultiplier = 1.0,
        Price = 1000
    },
    {
        Name = "Enlightened Ingredient Bag",
        Description = "A bag that radiates enlightenment",
        MaxStackAmount = 75,
        Slots = 30,
        UniqueFeature = "Transcendent Insight: Ability to unlock hidden alchemical secrets",
        IngredientMultiplier = 1.2,
        Price = 1100
    },
    {
        Name = "Sorcerer's Ingredient Bag",
        Description = "A bag for magical alchemists",
        MaxStackAmount = 80,
        Slots = 32,
        UniqueFeature = "Arcane Channeling: Amplifies magical properties of ingredients",
        IngredientMultiplier = 1.0,
        Price = 1200
    },
    {
        Name = "Wizard's Ingredient Bag",
        Description = "A bag for skilled alchemists",
        MaxStackAmount = 85,
        Slots = 34,
        UniqueFeature = "Ethereal Nexus: Connects with otherworldly sources of ingredients",
        IngredientMultiplier = 1.0,
        Price = 1300
    },
    {
        Name = "Archmage's Ingredient Bag",
        Description = "A bag for masterful alchemists",
        MaxStackAmount = 90,
        Slots = 36,
        UniqueFeature = "Essence Fusion: Combines multiple ingredients for powerful results",
        IngredientMultiplier = 1.5,
        Price = 1400
    },
    {
        Name = "Celestial Ingredient Bag",
        Description = "A bag infused with celestial energy",
        MaxStackAmount = 95,
        Slots = 38,
        UniqueFeature = "Starlight Blessing: Unlocks divine ingredient sources",
        IngredientMultiplier = 1.0,
        Price = 1500
    },
    {
        Name = "Ascendant's Ingredient Bag",
        Description = "A bag for ascendant alchemists",
        MaxStackAmount = 100,
        Slots = 40,
        UniqueFeature = "Eternal Alchemy: Ingredients never spoil or degrade",
        IngredientMultiplier = 1.0,
        Price = 1600
    },
    {
        Name = "Legendary Ingredient Bag",
        Description = "A bag steeped in legends",
        MaxStackAmount = 105,
        Slots = 42,
        UniqueFeature = "Ancient Relic: Grants access to mythical ingredients",
        IngredientMultiplier = 1.3,
        Price = 1700
    },
    {
        Name = "Mythical Ingredient Bag",
        Description = "A bag that holds mythical ingredients",
        MaxStackAmount = 110,
        Slots = 44,
        UniqueFeature = "Mythical Essence: Enhances the properties of all ingredients",
        IngredientMultiplier = 1.0,
        Price = 1800
    },
    {
        Name = "Epic Ingredient Bag",
        Description = "An epic bag for alchemists",
        MaxStackAmount = 115,
        Slots = 46,
        UniqueFeature = "Prime Catalyst: Increases the potency of crafted potions",
        IngredientMultiplier = 1.0,
        Price = 1900
    },
    {
        Name = "Titan's Ingredient Bag",
        Description = "A bag worthy of a titan alchemist",
        MaxStackAmount = 120,
        Slots = 48,
        UniqueFeature = "Unyielding Storage: Doubles the storage capacity for ingredients",
        IngredientMultiplier = 1.2,
        Price = 2000
    },
    {
        Name = "Divine Ingredient Bag",
        Description = "A bag infused with divine power",
        MaxStackAmount = 125,
        Slots = 50,
        UniqueFeature = "Divine Harvest: Guaranteed bonus ingredients from gathering",
        IngredientMultiplier = 1.0,
        Price = 2100
    },
    {
        Name = "Celestial Essence Bag",
        Description = "A bag containing celestial essences",
        MaxStackAmount = 130,
        Slots = 52,
        UniqueFeature = "Celestial Fusion: Infuses potions with celestial energy",
        IngredientMultiplier = 1.0,
        Price = 2200
    },
    {
        Name = "Chronomancer's Ingredient Bag",
        Description = "A bag for time-manipulating alchemists",
        MaxStackAmount = 135,
        Slots = 54,
        UniqueFeature = "Temporal Nexus: Access to rare ingredients from different time periods",
        IngredientMultiplier = 1.4,
        Price = 2300
    },
    {
        Name = "Voidborne Ingredient Bag",
        Description = "A bag imbued with the power of the void",
        MaxStackAmount = 140,
        Slots = 56,
        UniqueFeature = "Void Transmutation: Converts regular ingredients into exotic ones",
        IngredientMultiplier = 1.0,
        Price = 2400
    },
    {
        Name = "Harbinger's Ingredient Bag",
        Description = "A bag that foretells great alchemical discoveries",
        MaxStackAmount = 145,
        Slots = 58,
        UniqueFeature = "Prophetic Vision: Reveals hidden ingredient locations",
        IngredientMultiplier = 1.0,
        Price = 2500
    },
    {
        Name = "Transcendent Ingredient Bag",
        Description = "A bag for alchemists who have reached transcendence",
        MaxStackAmount = 150,
        Slots = 60,
        UniqueFeature = "Transmutation Mastery: Transforms ingredients into rare variants",
        IngredientMultiplier = 1.5,
        Price = 2600
    },
}

return ingredientBags
