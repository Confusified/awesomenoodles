local settingsTable = {
		JumpCanBeHeld = false,
		GameTimer = true,
   		NextbotESP = true,
		NextbotESPColor = {255,0,0},
		PlayerESP = true,
		PlayerESPColor = {0,0,255},
		DownedESPColor = {255,155,0},
		DownedTimer = true,
		RebelESP = true,
		RebelESPColor = {200,100,100},
		ObjectiveESP = true,
		ObjectiveESPColor = {200,0,255}
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

local BadgeService = game:GetService("BadgeService")
local GameFolder = game:GetService("Workspace"):WaitForChild("Game")
local MapFolder = GameFolder:WaitForChild("Map")
local WS_Players = GameFolder:WaitForChild("Players")
local GameStats = GameFolder:WaitForChild("Stats")
local function applyESP(child)
	if not child:FindFirstChild("Highlight") then
		for i,v in ipairs(child:GetChildren()) do
			if v:IsA("MeshPart") and v.Name == "HumanoidRootPart" then
				local a = Instance.new("Highlight",v.Parent)
				a.FillTransparency = 1
				a.OutlineTransparency = 0.1
				if not v:FindFirstChild("TorsoRot") and settings.NextbotESP then
					a.Adornee = v
					v.Transparency = 0
					a.OutlineColor = Color3.fromRGB(settings.NextbotESPColor[1],settings.NextbotESPColor[2],settings.NextbotESPColor[3])
				else
					a.Adornee = v.Parent
					if v.Parent.Name == "Rebel" and settings.RebelESP then
						a.OutlineColor = Color3.fromRGB(settings.RebelESPColor[1],settings.RebelESPColor[2],settings.RebelESPColor[3])
					elseif v.Parent.Name == "Decoy" then
						a:Destroy()
					elseif settings.PlayerESP then
					a.OutlineColor = Color3.fromRGB(settings.PlayerESPColor[1],settings.PlayerESPColor[2],settings.PlayerESPColor[3])
					else
						a:Destroy()
					end
				end
			
				if child.Name ~= "Decoy" and child.Name ~= "Rebel" and child:FindFirstChild("HumanoidRootPart"):FindFirstChild("TorsoRot") then
					child.AttributeChanged:Connect(function()
						if child:GetAttribute("Downed") and child:FindFirstChild("Highlight") then
							child:FindFirstChild("Highlight").OutlineColor = Color3.fromRGB(settings.DownedESPColor[1],settings.DownedESPColor[2],settings.DownedESPColor[3])
							if child:GetAttribute("ReviveTimeLeft") and not child:FindFirstChild("BillboardGui") then
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
									if child:GetAttribute("ReviveTimeLeft") == nil then
										bbg:Destroy()
										return
									end
									updateReviveTimer()
								end)
							end
						else
							child:FindFirstChild("Highlight").OutlineColor = Color3.fromRGB(settings.PlayerESPColor[1],settings.PlayerESPColor[2],settings.PlayerESPColor[3])
						end
					end)
				end
		    end
		end
	end
end

for _,child in ipairs(WS_Players:GetChildren()) do
    if child.Name ~= game:GetService("Players").LocalPlayer.Name then
	    applyESP(child)
	end
end

-[[WS_Players.ChildAdded:Connect(function(child)
    repeat task.wait() until #child:GetChildren() >= 5
    if child.Name ~= game:GetService("Players").LocalPlayer.Name then
        applyESP(child)
    end
end)]]

if not game:GetService("CoreGui"):FindFirstChild("EvadeGui") then
		local MainGui = Instance.new("ScreenGui")
		MainGui.Name = "EvadeGui"
		syn.protect_gui(MainGui)
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
		local door = Instance.new("Highlight",v.Parent:WaitForChild("Doorway"))
		door.Adornee = v.Parent:WaitForChild("Doorway"):WaitForChild("Door")
		door.FillTransparency = 1
		door.OutlineTransparency = 0.1
		door.OutlineColor = Color3.fromRGB(settings.ObjectiveESPColor[1],settings.ObjectiveESPColor[2],settings.ObjectiveESPColor[3])	
	end
	if toHighlight ~= nil then
		local a = Instance.new("Highlight",v)
		a.Adornee = toHighlight
		a.FillTransparency = 1
		a.OutlineTransparency = 0.1
		a.OutlineColor = Color3.fromRGB(settings.ObjectiveESPColor[1],settings.ObjectiveESPColor[2],settings.ObjectiveESPColor[3])	
	    local b = a:Clone()
	    b.Parent = v.Parent.Doorway.Door
	    b.Adornee = v.Parent.Doorway.Door
	end
end
else
print("This map has no objectives or objective ESP is disabled.")
end
