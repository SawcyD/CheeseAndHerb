local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SaveStructure = require(ReplicatedStorage.Data.playerData)

local directories = {}

for directory in pairs(SaveStructure) do
    table.insert(directories, directory)
end

return function (registry)
    registry:RegisterType("dataDirectory", registry.Cmdr.Util.MakeEnumType("dataDirectory", directories))
end