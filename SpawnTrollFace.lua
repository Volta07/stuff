local speed = 50
if not isfile("Troll.rbxm") then
    writefile("Troll.rbxm", game:HttpGet("https://github.com/Volta07/stuff/raw/main/Troll.rbxm"))
end
local rush = game:GetObjects((getcustomasset or getsynasset)("Troll.rbxm"))[1]
rush.Name = "RushMoving"
rush.RushNew.CanCollide = false
local tweensv = game:GetService("TweenService")
local currentLoadedRoom
local firstLoadedRoom

local function setRooms()
	local tb = {}
	table.foreach(workspace.CurrentRooms:GetChildren(), function(_, r)
		if r:FindFirstChild("RoomStart") and r.Name~="6" then
			table.insert(tb, tonumber(r.Name))
		end
	end)
	firstLoadedRoom = workspace.CurrentRooms[tostring(math.min(unpack(tb)))]
	currentLoadedRoom = workspace.CurrentRooms[tostring(math.max(unpack(tb)) - 1)]
	workspace.CurrentRooms.ChildAdded:Connect(function()
		local tb = {}
		table.foreach(workspace.CurrentRooms:GetChildren(), function(_, r)
			if r:FindFirstChild("RoomStart") and r.Name~="6" then
				table.insert(tb, tonumber(r.Name))
			end
		end)
		currentLoadedRoom = workspace.CurrentRooms[tostring(math.max(unpack(tb)) - 1)]
	end)
end
setRooms()

rush.Parent = workspace
rush:MoveTo(firstLoadedRoom.RoomStart.Position + Vector3.new(0, 5.2, 0))
require(game.ReplicatedStorage.ClientModules.Module_Events).flickerLights(tonumber(currentLoadedRoom.Name), 0.5)

rush.RushNew.PlaySound:Play()
rush.RushNew.Footsteps:Play()
wait(5)
for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
	if not room:FindFirstChild("Nodes") then
		continue
	end
	local nodeNum = #room.Nodes:GetChildren()
	for _, node in pairs(room.Nodes:GetChildren()) do
		local timeC = (math.abs((node.Position - rush.RushNew.Position).Magnitude)) / speed
		tweensv
			:Create(rush.RushNew, TweenInfo.new(timeC, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				CFrame = CFrame.new(node.CFrame.X, node.CFrame.Y + 5.2, node.CFrame.Z),
			})
			:Play()
		local random = math.random(1, nodeNum)
		if tonumber(node.Name) == random then -- first or last node? just choose please
			require(game.ReplicatedStorage.ClientModules.Module_Events).breakLights(room)
		end
		task.wait(timeC)
	end
	if room == currentLoadedRoom then
		task.wait(1)
		tweensv
			:Create(rush.RushNew, TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				CFrame = CFrame.new(rush.RushNew.CFrame.X, -50, rush.RushNew.CFrame.Z),
			})
			:Play()
		wait(0.5)
		rush:Destroy()
		currentLoadedRoom:WaitForChild("Door").ClientOpen:FireServer()
	end
end