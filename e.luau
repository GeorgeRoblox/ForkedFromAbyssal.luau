while not game:IsLoaded() do
	task.wait(1)
end

print("Abysall Hub death farm for DOORS, created by FireBacon (bocaj111004)")
print("dsc.gg/abysallhub")

local Services = setmetatable({}, {
	__index = function(self, Key)
		return game:GetService(Key)
	end
})

local QueueTeleport = queue_on_teleport or queueonteleport

local TeleportCode = [==[
	loadstring(game:HttpGet("https://raw.githubusercontent.com/GeorgeRoblox/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
]==]

local LocalPlayer = Services.Players.LocalPlayer
local RemotesFolder = Services.ReplicatedStorage:FindFirstChild("RemotesFolder")
local CurrentRooms = Services.Workspace:FindFirstChild("CurrentRooms")
local GameData = Services.ReplicatedStorage:FindFirstChild("GameData")

local function SendCaption(Text)
	if firesignal then
		firesignal(
			RemotesFolder.Caption.OnClientEvent,
			"[Abysall Hub] " .. Text
		)
	else
		RemotesFolder.CaptionClient:Fire(
			"[Abysall Hub] " .. Text
		)
	end
end

if game.PlaceId == 6516141723 then
	SendCaption("Joining a run...")
	QueueTeleport(TeleportCode)
	RemotesFolder.CreateElevator:FireServer({
		Mods = {},
		Settings = {},
		Destination = "Hotel",
		FriendsOnly = false,
		MaxPlayers = "1"
	})

	return
end

if GameData and GameData.Floor.Value ~= "Hotel" then
	QueueTeleport([==[
		local RemotesFolder = game:GetService("ReplicatedStorage").RemotesFolder

		local function SendCaption(Text)
			if firesignal then
				firesignal(
					RemotesFolder.Caption.OnClientEvent,
					"[Abysall Hub] " .. Text
				)
			else
				RemotesFolder.CaptionClient:Fire(
					"[Abysall Hub] " .. Text
				)
			end
		end

		local QueueTeleport = queue_on_teleport or queueonteleport

		QueueTeleport([=[
			loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
		]=])

		SendCaption("Joining a run...")

		RemotesFolder.CreateElevator:FireServer({
			Mods = {},
			Settings = {},
			Destination = "Hotel",
			FriendsOnly = false,
			MaxPlayers = "1"
		})
	]==])
	RemotesFolder.Lobby:FireServer()
	return
end

if game.PlaceId ~= 6839171747 then
	QueueTeleport([==[
		local RemotesFolder = game:GetService("ReplicatedStorage").RemotesFolder

		local function SendCaption(Text)
			if firesignal then
				firesignal(
					RemotesFolder.Caption.OnClientEvent,
					"[Abysall Hub] " .. Text
				)
			else
				RemotesFolder.CaptionClient:Fire(
					"[Abysall Hub] " .. Text
				)
			end
		end

		local QueueTeleport = queue_on_teleport or queueonteleport

		QueueTeleport([=[
			loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/Abysall/refs/heads/main/Scripts/DeathFarm.luau"))()
		]=])

		SendCaption("Joining a run...")

		RemotesFolder.CreateElevator:FireServer({
			Mods = {},
			Settings = {},
			Destination = "Hotel",
			FriendsOnly = false,
			MaxPlayers = "1"
		})
	]==])
	Services.TeleportService:Teleport(6516141723)
	return
end

if #CurrentRooms:GetChildren() > 1 or LocalPlayer.Character then
	SendCaption("Run has already started, joining a new run for best experience...")
	QueueTeleport(TeleportCode)
	RemotesFolder.PlayAgain:FireServer()
	return
end

while #CurrentRooms:GetChildren() < 1 or not LocalPlayer.Character do
	task.wait(1)
end

local MainUI = LocalPlayer.PlayerGui:WaitForChild("MainUI", 9e9)
if MainUI:FindFirstChild("ItemShop") then
	MainUI.ItemShop.Visible = false

	RemotesFolder.PreRunShop:FireServer({}, true)
end

task.wait(1)

local SkipPrompt = Services.Workspace:FindFirstChild("SkipPrompt",true)

if SkipPrompt then
	fireproximityprompt(SkipPrompt)
end

local Luggage = Services.Workspace:FindFirstChild("Luggage_Cart_Crouch",true)

if Luggage then
	Luggage:Destroy()
end

local function WalkPosition(TargetPosition)

	local Character = LocalPlayer.Character
	local RootPart = Character:WaitForChild("HumanoidRootPart",9e9)

	local Humanoid = Character:WaitForChild("Humanoid",9e9)

	local Finished = false
	local Connection
	Connection = Services.RunService.RenderStepped:Connect(function()
		if not Character or not Character.Parentor not Humanoid.Parent then
			Finished = true
			return
		end
		Humanoid:MoveTo(TargetPosition)
		if LocalPlayer:DistanceFromCharacter(TargetPosition) < 6 then
			Finished = true
		end
	end)
	while not Finished do
		task.wait()
	end
	if Connection then
		Connection:Disconnect()
	end
	task.wait()
	return true
end

task.wait(1)

for _, Object in pairs(CurrentRooms["0"].Assets:GetChildren()) do
	if Object.Name == "Potted_Plant" then
		if Object:FindFirstChild("Collision") then
			Object.Collision.CanCollide = false
		end
	end
end

SendCaption("Getting the key...")

local Door = CurrentRooms["0"]:FindFirstChild("Door")

if Door and Door:FindFirstChild("Lock") then
	Door.Lock.CanCollide = false
	WalkPosition(Door.Lock.Position)
end

local Key = CurrentRooms["0"]:FindFirstChild("KeyObtain",true)
if Key then
	WalkPosition(Key.Hitbox.Position)
	local Prompt = Key:FindFirstChild(
		"ModulePrompt", true)
	if Prompt then
		fireproximityprompt(Prompt)
	end
end

SendCaption("Got the key, opening the door...")
Door = CurrentRooms["0"]:FindFirstChild("Door")
if Door and Door:FindFirstChild("Lock") then
	Door.Lock.CanCollide = false
	WalkPosition(Door.Lock.Position)
end
if Door then
	local UnlockPrompt = Door:FindFirstChild("UnlockPrompt",true)
	if UnlockPrompt then
		fireproximityprompt(UnlockPrompt)
	end
end

while not CurrentRooms:FindFirstChild("2") do
	task.wait()
end


SendCaption("Starting death sequence...")

if replicatesignal then
	replicatesignal(LocalPlayer.Kill)
else
	SendCaption("Please wait around 20 seconds to die")
	RemotesFolder.Underwater:FireServer(true)
end

repeat
	task.wait()
until LocalPlayer:GetAttribute("Alive") == false

task.wait(2)

local Revives = LocalPlayer.PlayerGui.TopbarUI.Topbar.Revives

local ReviveCount = tonumber(Revives.Text:match("%d+")) or 0

if ReviveCount > 0 then
	SendCaption("Player has died, Reviving.....")
	task.wait(1.5)
	local OldCharacter = LocalPlayer.Character
	RemotesFolder.Revive:FireServer()

	repeat
		task.wait()
	until LocalPlayer:GetAttribute("Alive") == true

	SendCaption("Waiting for new character...")

	repeat
		task.wait()
	until LocalPlayer.Character and LocalPlayer.Character ~= OldCharacter and LocalPlayer.Character.Parent
	local NewCharacter = LocalPlayer.Character
	local NewHumanoid = NewCharacter:WaitForChild("Humanoid",10)
	local NewRootPart = NewCharacter:WaitForChild("HumanoidRootPart", 10)

	task.wait(3)

	SendCaption("Revived, dying again...")

	if replicatesignal then
		replicatesignal(LocalPlayer.Kill)
	else
		SendCaption("Please wait around 20 seconds to die")
		RemotesFolder.Underwater:FireServer(true)
	end
	repeat
		task.wait()
	until LocalPlayer:GetAttribute("Alive") == false
	SendCaption("Player died after reviving, joining a new run...")
	task.wait(2)
else
	SendCaption("Player has died, joining a new run...")
	task.wait(2)
end

SendCaption("Starting a new run...")
RemotesFolder.PlayAgain:FireServer()
QueueTeleport(TeleportCode)
