--[[


   _____            __    _ __  ___           __           
  / ___/__  _______/ /_  (_)  |/  /___ ______/ /____  _____
  \__ \/ / / / ___/ __ \/ / /|_/ / __ `/ ___/ __/ _ \/ ___/
 ___/ / /_/ (__  ) / / / / /  / / /_/ (__  ) /_/  __/ /    
/____/\__,_/____/_/ /_/_/_/  /_/\__,_/____/\__/\___/_/     
                                                           




____________________________________________________________________________________________________________________________________________________________________________
				
	[ UPDATE LOG v1.2 :]
1. Made the code better

____________________________________________________________________________________________________________________________________________________________________________

	Example code:
		local module = require(game.ServerStorage.MuchachoHitbox)

		local hitbox = module.CreateHitbox()
		hitbox.Visualizer = true
		hitbox.Size = Vector3.new(10,10,10)
		hitbox.CFrame = workspace.Part

		hitbox.Touched:Connect(function(hit, hum)
			print(hit)
			hum:TakeDamage(10)
		end)
		
		hitbox:Start()
	
	
	Alright thats all for the example code, its a pretty simple module, you could make a module similar to this yourself.
	And maybe even make it better.
	
	If you encounter any bugs, please tell me in the comment section, or you could DM me on discord
	sushimaster#7840
	
	❤ SushiMaster
____________________________________________________________________________________________________________________________________________________________________________
	
	
	[MuchachoHitbox API]

		* local Module = require(MuchachoHitbox)
				--- Require the module


			[ FUNCTIONS ]

		* Module.CreateHitbox()
				Description
					--- Creates a hitbox
					
		* Module:FindHitbox(Key)
				Description
					--- Returns a hitbox with specified Key

		* HitboxObject:Start()
				Description
					--- Starts the hitbox. 
					
		* HitboxObject:Stop()
				Description
					--- Stops the hitbox and resets the debounce.
					
			[ EVENTS ]

		* HitboxObject.Touched:Connect(hit, humanoid)
				Description
					--- If hitbox touches a humanoid, it'll return information on them
				Arguments
					--- Instance part: Returns the part that the hitbox hit first
					--- Instance humanoid: Returns the Humanoid object 
					
			[ PROPERTIES ]

		* HitboxObject.OverlapParams: OverlapParams
				Description
					--- Takes in a OverlapParams object

		* HitboxObject.Visualizer: boolean
				Description
					--- Turns on or off the visualizer part

		* HitboxObject.CFrame: CFrame / Instance
				Description
					--- Sets the hitbox CFrame to the CFrame
					--- If its an instance, then the hitbox would follow the instance
					
		* HitboxObject.Shape: Enum.PartType.Block / Enum.PartType.Ball
				Description
					--- Defaults to block
					--- Sets the hitbox shape to the property
					
		* HitboxObject.Size: Vector3 / number 
				Description
					--- Sets the size of the hitbox
					--- It uses Vector3 if the shape is block
					--- It uses number if the shape is ball
					
		* HitboxObject.Offset: CFrame
				Description
					--- Hitbox offset

		* HitboxObject.DetectionMode: string | "Default" , "HitOnce" , "HitParts" , "ConstantDetection"
				Description
					--- Defaults to "Default"
					--- Changes on how the detection works
					
		* HitboxObject.Key: String
				Description
					--- The key property for the find hitbox function
					--- Once you set a key, the module will save the hitbox, and can be found using | Module:FindHitbox(Key)
			
			[ DETECTION MODES ]

		* Default
				Description
					--- Checks if a humanoid exists when this hitbox touches a part. The hitbox will not return humanoids it has already hit for the duration
					--- the hitbox has been active.

		* HitParts
				Description
					--- OnHit will return every hit part, regardless if it's ascendant has a humanoid or not.
					--- OnHit will no longer return a humanoid so you will have to check it. The hitbox will not return parts it has already hit for the
					--- duration the hitbox has been active.

		* HitOnce
				Description
					--- Hitbox will stop as soon as it detects a humanoid
					
		* ConstantDetection
				Description
					--- The default detection mode but no hitlist / debounce
					
____________________________________________________________________________________________________________________________________________________________________________

]]

local GoodSignal = require(script.GoodSignal)
local rs = game:GetService("RunService")

local muchacho_hitbox = {}
muchacho_hitbox.__index = muchacho_hitbox

local HITBOX_COLOR = Color3.fromRGB(255,0,0)
local HITBOX_TRANSPARENCY = 0.8

local form = {
	["Proportion"] = {
		[Enum.PartType.Ball] = "Radius",
		[Enum.PartType.Block] = "Size",
	},
	
	["Shape"] = {
		[Enum.PartType.Ball] = "SphereHandleAdornment",
		[Enum.PartType.Block] = "BoxHandleAdornment",
	},
	
	["Point"] = {
		["Instance"] = function(point)
			return point.CFrame
		end,
		
		["CFrame"] = function(point)
			return point
		end,
	},
}

local spatial_query = {
	[Enum.PartType.Ball] = function(self)
		local point_type = typeof(self.CFrame)
		local point_cframe = form.Point[point_type](self.CFrame)

		local parts = workspace:GetPartBoundsInRadius(point_cframe.p + self.Offset.p, self.Size, self.OverlapParams)

		return parts
	end,
	
	[Enum.PartType.Block] = function(self)
		local point_type = typeof(self.CFrame)
		local point_cframe = form.Point[point_type](self.CFrame)

		local parts = workspace:GetPartBoundsInBox(point_cframe * self.Offset, self.Size, self.OverlapParams)

		return parts
	end,
}

local hitboxes = {}


function muchacho_hitbox.CreateHitbox()
	return setmetatable({
		Visualizer = true,
		DetectionMode = "Default",

		Connection = nil,
		HitList = {},
		Box = nil,
		Key = nil,

		Touched = GoodSignal.new(),

		OverlapParams = OverlapParams.new(),

		Size = Vector3.new(0,0,0),
		Shape = Enum.PartType.Block,
		CFrame = CFrame.new(0,0,0),
		Offset = CFrame.new(0,0,0)

	}, muchacho_hitbox)
end

function muchacho_hitbox:FindHitbox(key)
	if hitboxes[key] then
		return hitboxes[key]
	end
end

function muchacho_hitbox:visualize()
	if not self.Visualizer then return end
	
	local point_type = typeof(self.CFrame)
	local point_cframe = form.Point[point_type](self.CFrame)
	
	local proportion = form.Proportion[self.Shape]
	
	if self.Box then
		self.Box.CFrame = point_cframe * self.Offset
	else
		self.Box = Instance.new(form.Shape[self.Shape])
		self.Box.Name = "Visualizer"
		self.Box.Adornee = workspace.Terrain
		self.Box[proportion] = self.Size
		self.Box.CFrame = point_cframe * self.Offset
		self.Box.Color3 = HITBOX_COLOR
		self.Box.Transparency = HITBOX_TRANSPARENCY
		self.Box.Parent = workspace.Terrain
	end
end


function muchacho_hitbox:cast()
	local mode = self.DetectionMode
	
	local point_type = typeof(self.CFrame)
	local point_cframe = form.Point[point_type](self.CFrame)
	
	local parts = spatial_query[self.Shape](self)
	
	for _, hit in pairs(parts) do
		local character = hit:FindFirstAncestorOfClass("Model") or hit.Parent
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if mode == "Default" and character and humanoid and not self.HitList[table.find(self.HitList, humanoid)] then
			table.insert(self.HitList, humanoid)
			self.Touched:Fire(hit, humanoid)
			
		elseif mode == "ConstantDetection" and character and humanoid then
			self.Touched:Fire(hit, humanoid)
			
		elseif mode == "HitOnce" and character and humanoid then
			self.Touched:Fire(hit, humanoid)
			self:Stop()
			break
			
		elseif mode == "HitParts" then
			self.Touched:Fire(hit)
			
		end
	end
end

function muchacho_hitbox:Start()
	if hitboxes[self.Key] then
		warn("A hitbox with this Key has already been started. Change the key if you want to start this hitbox.")
		return		
	end

	if self.Key then
		hitboxes[self.Key] = self
	end
	
	-- looping the hitbox
	task.spawn(function()
		self.Connection = rs.Heartbeat:Connect(function()
			self:visualize()
			self:cast()
		end)
	end)
	
end

function muchacho_hitbox:Stop()
	self.HitList = {}
	self.Touched:DisconnectAll()

	if self.Key then
		hitboxes[self.Key] = nil
	end

	if self.Connection then
		self.Connection:Disconnect()
	end

	if self.Box then
		self.Box:Destroy()
	end
end

return muchacho_hitbox
