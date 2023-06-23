return {
    Name = "addcoins",
    Aliases = {"ac", "addCoins"},
    Description = "Adds coins to a player's account.",
    Group = "Admin",
    Args = {
        {
            Type = "player",
            Name = "player",
            Description = "The player to add coins to.",
        },
        {
            Type = "number",
            Name = "amount",
            Description = "The amount of coins to add.",
        },
    },
}