local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AutoShoot = false
local InfRangeShoot = false

function shoot()
local args = {
	{
		["name"] = "defense",
		["origin"] = "balltargets"
	},
	{}
}
pcall(function()
ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(unpack(args))
end)
end

function InfRangeParry()
local args = {
	[1] = {
		["success"] = true,
		["reason"] = "blocked"
	}
}
pcall(function()
ReplicatedStorage:WaitForChild("resources"):WaitForChild("assets"):WaitForChild("balls"):WaitForChild("communication"):WaitForChild("network_remote_event"):FireServer(unpack(args))
end)
end

-- Turtle Ui Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LittenHub/Fuckyouman/refs/heads/main/TurtleUI.lua"))()

-- Making a window
local Window = library:Window({Name = "Gun Ball"})

local AutoShootToogle = Window:Toogle({
    Name = "Auto Shoot",
    Default = false,
    Callback = function()
        shoot()
        shoot()
        shoot()
    end
})

local InfRangeShootToogle = Window:Toogle({
    Name = "Inf Range Shoot",
    Default = false,
    Callback = function()
        InfRangeParry()
    end
})

Window:Label({
   Name = "By LucidSc1pt", 
   Color = Color3.fromRGB(127, 143, 166)
})

library:Notification({
	Title = "Loaded!",
	Content = "Script loaded for Gun Ball game!",
	Time = 5
})
