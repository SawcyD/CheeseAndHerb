local Suffixes = {"k","M","B","T","qd","Qn","sx","Sp","O","N","de","Ud","DD","tdD","qdD","QnD","sxD","SpD","OcD","NvD","Vgn","UVg","DVg","TVg","qtV","QnV","SeV","SPG","OVG","NVG","TGN","UTG","DTG","tsTG","qtTG","QnTG","ssTG","SpTG","OcTG","NoTG","QdDR","uQDR","dQDR","tQDR","qdQDR","QnQDR","sxQDR","SpQDR","OQDDr","NQDDr","qQGNT","uQGNT","dQGNT","tQGNT","qdQGNT","QnQGNT","sxQGNT","SpQGNT", "OQQGNT","NQQGNT","SXGNTL"}

local Module = {}

function Module.AbbreviateNumber(Number, Places)
    if not Number then return error("Nil Number argument") and 0 end
    Places = Places or 1

    for Index = #Suffixes, 1, -1 do
        local Value = math.pow(10, Index * 3)
        if Number >= Value then
            return ("%." .. Places .. "f"):format(Number/Value) .. Suffixes[Index]
        end
    end
    return Number
end

return Module