
local Character = script.Parent
local Humanoid = Character:WaitForChild("Humanoid")

local Combat = Character:WaitForChild("Combat").Combat

Character.ChildAdded:Connect(function(newchild)
	if newchild.Name == "Stunned" then
		Humanoid.WalkSpeed = 0
		Combat.Disabled = true
	end
end)

Character.ChildRemoved:Connect(function(removedchild)
	if removedchild.Name == "Stunned" then
		Humanoid.WalkSpeed = 16
		Combat.Disabled = false
	end
end)