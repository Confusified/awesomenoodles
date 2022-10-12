local settingsTable = {
		Version = '0.1c',
		JumpCanBeHeld = false,
		AutoStrafe = false,
		GameTimer = true,
   		NextbotESP = true,
		NextbotESPColor = '#FF0000',
		PlayerESP = true,
		PlayerESPColor = '#0000FF',
		DownedESPColor = '#FF9B00',
		DownedTimer = true,
		RebelESPColor = '#C86464',
		RebelESP = true,
		ObjectiveESP = true,
		ObjectiveESPColor = '#C800FF',
		CustomFriendESP = true,
		CustomFriendESPColor = '#00FF00'
    }
local fName = "ConConfigs"
local FileName = "Evade.txt"
local fullFileName = fName.."\\"..FileName

if not isfolder(fName) then
    print("Could not find configuration folder, creating a new one.")
    makefolder(fName) 
end
if not isfile(fullFileName) or isfile(fullFileName) and readfile(fullFileName) == "" then
    print("Configuration file for this game is missing or broken, creating a new one.")
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settingsTable))
end

local settings = game:GetService("HttpService"):JSONDecode(readfile(fullFileName))

if settings.Version == nil or settings.Version ~= settingsTable.Version then
	for i,v in pairs(settingsTable) do
    	if settings[i] == nil then
            settings[i] = v
			print(tostring(i).." was not found in config, setting to "..tostring(v))
		elseif i == "Version" then
			print("Updating version (from "..settings[i].." to "..settingsTable[i]..")")
            settings[i] = settingsTable[i]
        end
	end
	writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settings))
	print("Updated config file")
end

local UIS = game:GetService("UserInputService")
local GameFolder = game:GetService("Workspace"):WaitForChild("Game")
local RagdollFolder = GameFolder:WaitForChild("Effects"):WaitForChild("Ragdolls")
local MapFolder = GameFolder:WaitForChild("Map")
local WS_Players = GameFolder:WaitForChild("Players")
local GameStats = GameFolder:WaitForChild("Stats")
local function applyESP(child)
		for i,v in ipairs(child:GetChildren()) do
			if not child:FindFirstChild("Highlight") then
				if v:IsA("MeshPart") and v.Name == "HumanoidRootPart" then
					local a = Instance.new("Highlight",v.Parent)
					a.FillTransparency = 1
					a.OutlineTransparency = 0.1
					if not v:FindFirstChild("TorsoRot") and settings.NextbotESP then
						a.Adornee = v
						v.Transparency = 0
						a.OutlineColor = Color3.fromHex(settings.NextbotESPColor)
					else
						a.Adornee = v.Parent
						if v.Parent.Name == "Rebel" and settings.RebelESP then
							a.OutlineColor = Color3.fromHex(settings.RebelESPColor)
						elseif v.Parent.Name == "Decoy" then
							a:Destroy()
						elseif settings.PlayerESP and child.Name ~= game:GetService("Players").LocalPlayer.Name then
						if game:GetService("Players"):FindFirstChild(child.Name):IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) then
							a.OutlineColor = Color3.fromHex(settings.CustomFriendESPColor)
						else
							a.OutlineColor = Color3.fromHex(settings.PlayerESPColor)
						end
						else
							a:Destroy()
						end
					end
				end
			end
				if child.Name ~= "Decoy" and child.Name ~= "Rebel" and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("HumanoidRootPart"):FindFirstChild("TorsoRot") then
					child.AttributeChanged:Connect(function()
						if child:GetAttribute("Downed") and child:FindFirstChild("Highlight") and child.Name ~= game:GetService("Players").LocalPlayer.Name then
							child:FindFirstChild("Highlight").OutlineColor = Color3.fromHex(settings.DownedESPColor)
						elseif child:FindFirstChild("Highlight") and child.Name ~= game:GetService("Players").LocalPlayer.Name then
							if game:GetService("Players"):FindFirstChild(child.Name):IsFriendsWith(game:GetService("Players").LocalPlayer.UserId) then
							child:FindFirstChild("Highlight").OutlineColor = Color3.fromHex(settings.CustomFriendESPColor)
						else
							child:FindFirstChild("Highlight").OutlineColor = Color3.fromHex(settings.PlayerESPColor)
						end
						end
						if child:GetAttribute("ReviveTimeLeft") and not child:FindFirstChild("BillboardGui") and settings.DownedTimer then
								local bbg = Instance.new("BillboardGui",child)
								bbg.Adornee = child:FindFirstChild("Head")
								bbg.SizeOffset = Vector2.new(0,1.5)
								bbg.Size = UDim2.new(2,0,1,0)
								
								local fr = Instance.new("TextLabel",bbg)
								fr.Size = UDim2.new(1,0,1,0)
								fr.BackgroundTransparency = 1
								fr.Font = Enum.Font.GothamBold
								fr.TextScaled = true
								fr.TextColor3 = Color3.new(1,1,1)
								fr.TextStrokeTransparency = 0.9
								fr.TextStrokeColor3 = Color3.new(0,0,0)
									
								local function updateReviveTimer()
									if child:GetAttribute("ReviveTimeLeft") then
										fr.Text = math.floor(child:GetAttribute("ReviveTimeLeft"))
									end
								end
								
								updateReviveTimer()
									
								child:GetAttributeChangedSignal("ReviveTimeLeft"):Connect(function()
									if child:GetAttribute("ReviveTimeLeft") == nil or not settings.DownedTimer then
										bbg:Destroy()
										return
									end
									updateReviveTimer()
								end)
						end
					end)
				end
		    end
			
		end

for _,child in ipairs(WS_Players:GetChildren()) do
	    applyESP(child)
end
for _,child in ipairs(RagdollFolder:GetChildren()) do
	local function checkForHighlight(child)
		if child:FindFirstChild("Highlight") then
			child:FindFirstChild("Highlight"):Destroy()
		end
	end
	
	checkForHighlight(child)
	
	RagdollFolder.ChildAdded:Connect(checkForHighlight)
end

if not game:GetService("CoreGui"):FindFirstChild("EvadeGui") then
		local MainGui = Instance.new("ScreenGui")
		MainGui.Name = "EvadeGui"
		syn.protect_gui(MainGui) --compatibility with v2
		MainGui.Parent = game:GetService("CoreGui")
	
		local TimeLeft = Instance.new("TextLabel",MainGui)
		TimeLeft.Name = "TimeRemaining"
		TimeLeft.BackgroundTransparency = 1
		TimeLeft.Size = UDim2.new(0.18,0,0.04,0)
		TimeLeft.Position = UDim2.new(0.5-(TimeLeft.Size.X.Scale/2),0,0.13,0)
		TimeLeft.TextScaled = true
		TimeLeft.TextColor3 = Color3.new(1,1,1)
		TimeLeft.TextStrokeTransparency = 0.9
		TimeLeft.TextStrokeColor3 = Color3.new(0,0,0)
		TimeLeft.Font = Enum.Font.GothamBold

		local function updateTimer()
				local maxval = math.max(0, GameStats:GetAttribute("TimeRemaining"));
				TimeLeft.Text = string.sub(string.format("%02d:%02d", math.floor(maxval / 60), math.floor(maxval) % 60), 2);
		end
	
		updateTimer()
	
		workspace.Game.Stats:GetAttributeChangedSignal("TimeRemaining"):Connect(function()
				updateTimer()
		end);
end

local ObjectivesFolder = MapFolder:WaitForChild("Parts"):FindFirstChild("Objectives")
if ObjectivesFolder and #ObjectivesFolder:GetChildren() > 0 and settings.ObjectiveESP then
for i,v in ipairs(ObjectivesFolder:GetChildren()) do
	local toHighlight = nil
	if v.Name == "Switch" then
	    toHighlight = v:WaitForChild("Switch")
	elseif v.Name == "Transportation" then
		toHighlight = v:WaitForChild("Part")
	elseif v.Name == "Generator" then
		toHighlight = v:WaitForChild("Diesel generator")
	elseif v.Name == "Key" then
		toHighlight = v:WaitForChild("Key")
		if not v.Parent:WaitForChild("Doorway"):FindFirstChild("Highlight") then
		local door = Instance.new("Highlight",v.Parent:WaitForChild("Doorway"))
		door.Adornee = v.Parent:WaitForChild("Doorway"):WaitForChild("Door")
		door.FillTransparency = 1
		door.OutlineTransparency = 0.1
		door.OutlineColor = Color3.fromHex(settings.ObjectiveESPColor)
	end
	if toHighlight ~= nil and not v:FindFirstChild("Highlight") then
		local a = Instance.new("Highlight",v)
		a.Adornee = toHighlight
		a.FillTransparency = 1
		a.OutlineTransparency = 0.1
		a.OutlineColor = Color3.fromHex(settings.ObjectiveESPColor)
	end
	print(toHighlight)
end
end
else
print("This map has no objectives. (Objective ESP is "..tostring(settings.ObjectiveESP)..")")
end

--[[UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space and settings.JumpCanBeHeld then
		while settings.JumpCanBeHeld do
			task.wait()
			local Character = game:GetService("Players").LocalPlayer.Character
			local Communicator = Character:FindFirstChild("Communicator")
			if Character:FindFirstChild("Humanoid"):GetState() == Enum.HumanoidStateType.Landed then
				Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				task.wait()
			end
		end
	end
end)]]
