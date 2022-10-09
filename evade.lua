local BadgeService = game:GetService("BadgeService")
local GameFolder = game:GetService("Workspace"):WaitForChild("Game")
local WS_Players = GameFolder:WaitForChild("Players")
local GameStats = GameFolder:WaitForChild("Stats")

local bots = {}
for _,b in ipairs(WS_Players:GetChildren()) do
print(b:GetAttribute("Downed"))
if not b:FindFirstChild("Highlight") then
    for i,v in ipairs(b:GetChildren()) do
        if v:IsA("MeshPart") and v.Name == "HumanoidRootPart" then
            if not v:FindFirstChild("TorsoRot") then
                table.insert(bots,v.Parent)
                local a = Instance.new("Highlight",v.Parent)
                a.Adornee = v
                v.Transparency = 0
                a.FillColor = Color3.fromRGB(255,0,0)
                a.OutlineColor = Color3.fromRGB(200,0,0)
                a.OutlineTransparency = 0.1
            elseif b.Name ~= game:GetService("Players").LocalPlayer.Name then
                local a = Instance.new("Highlight",v.Parent)
                a.Adornee = v.Parent
                if v.Parent.Name == "Rebel" then
                    a.OutlineColor = Color3.fromRGB(255,0,0)
                elseif v.Parent.Name == "Decoy" then
                    a.OutlineColor = Color3.fromRGB(0,255,0)
                end
                a.FillTransparency = 1
                a.OutlineColor = Color3.fromRGB(0,0,255)
                a.OutlineTransparency = 0.1
                
                if b.Name ~= game:GetService("Players").LocalPlayer.Name and b.Name ~= "Decoy" and b.Name ~= "Rebel" then
                    b.AttributeChanged:Connect(function()
                        if b:GetAttribute("Downed") and b:FindFirstChild("Highlight") then
                            b:FindFirstChild("Highlight").OutlineColor = Color3.fromRGB(255,155,0)
                        else
                            b:FindFirstChild("Highlight").OutlineColor = Color3.fromRGB(0,0,255)
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
gethui(MainGui)
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

local ObjectivesFolder = GameFolder:WaitForChild("Parts"):WaitForChild("Objectives")
if ObjectivesFolder then



end
