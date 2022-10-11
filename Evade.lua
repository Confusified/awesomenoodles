local settingsTable = {
		JumpCanBeHeld = false,
		GameTimer = true,
   		NextbotESP = true,
		NextbotESPColor = {255,0,0},
       		PlayerESP = true,
		PlayerESPColor = {0,0,255},
		DownedESP = true,
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

for _,b in ipairs(WS_Players:GetChildren()) do
	if not b:FindFirstChild("Highlight") then
	    for i,v in ipairs(b:GetChildren()) do
		if v:IsA("MeshPart") and v.Name == "HumanoidRootPart" then
		    if not v:FindFirstChild("TorsoRot") then
						local a = Instance.new("Highlight",v.Parent)
						a.Adornee = v
						v.Transparency = 0
						a.OutlineColor = Color3.fromRGB(settings.NextbotESPColor[1],settings.NextbotESPColor[2],settings.NextbotESPColor[3])
						a.OutlineTransparency = 0.1
						a.FillTransparency = 1
				elseif b.Name ~= game:GetService("Players").LocalPlayer.Name then
						local a = Instance.new("Highlight",v.Parent)
						a.Adornee = v.Parent
						a.FillTransparency = 1
						a.OutlineTransparency = 0.1
						if v.Parent.Name == "Rebel" then
			    			a.OutlineColor = Color3.fromRGB(settings.RebelESPColor[1],settings.RebelESPColor[2],settings.RebelESPColor[3])
						elseif v.Parent.Name == "Decoy" then
			    			a:Destroy()
						else
						a.OutlineColor = Color3.fromRGB(settings.PlayerESPColor[1],settings.PlayerESPColor[2],settings.PlayerESPColor[3])
						end
					
			if b.Name ~= game:GetService("Players").LocalPlayer.Name and b.Name ~= "Decoy" and b.Name ~= "Rebel" and b:FindFirstChild("HumanoidRootPart"):FindFirstChild("TorsoRot") then
			    b.AttributeChanged:Connect(function()
				if b:GetAttribute("Downed") and b:FindFirstChild("Highlight") then
				    b:FindFirstChild("Highlight").OutlineColor = Color3.fromRGB(settings.DownedESPColor[1],settings.DownedESPColor[2],settings.DownedESPColor[3])
					if b:GetAttribute("ReviveTimeLeft") and not b:FindFirstChild("BillboardGui") then
                       				local bbg = Instance.new("BillboardGui",b)
					       	bbg.Adornee = b:FindFirstChild("Head")
					       	bbg.SizeOffset = Vector2.new(0,1.5)
						bbg.Size = UDim2.new(2,0,1,0)
					       	local fr = Instance.new("TextLabel",bbg)
					       	fr.Size = UDim2.new(1,0,1,0)
						fr.BackgroundTransparency = 1
					       	fr.Font = Enum.Font.GothamBold
					       	fr.TextScaled = true
					       	
					       	local function updateReviveTimer()
					       	    fr.Text = math.floor(b:GetAttribute("ReviveTimeLeft"))
					       	end
					       	
					       	updateReviveTimer()
					       	
					       	workspace.Game.Stats:GetAttributeChangedSignal("TimeRemaining"):Connect(function()
				                updateReviveTimer()
					       	end);
                    			end
				else
				    b:FindFirstChild("Highlight").OutlineColor = Color3.fromRGB(settings.PlayerESPColor[1],settings.PlayerESPColor[2],settings.PlayerESPColor[3])
				end
			end)
			end
		    end
		end
	    end
	end
end
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
if ObjectivesFolder then
for i,v in ipairs(ObjectivesFolder:GetChildren()) do
	if v.Name == "Switch" then
	local toHighlight = v:WaitForChild("Switch")
	elseif v.Name == "Transportation" then
	local toHighlight = v:WaitForChild("Part")
	local a = Instance.new("Highlight",v)
	a.Adornee = toHighlight
	a.FillTransparency = 1
	a.OutlineTransparency = 0.1
	a.OutlineColor = Color3.fromRGB(settings.ObjectiveESPColor[1],settings.ObjectiveESPColor[2],settings.ObjectiveESPColor[3])
	end
end
