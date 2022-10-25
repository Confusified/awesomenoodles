if not game:IsLoaded() then
    game.Loaded:Wait()
end
if game.PlaceId ~= 1187101243 then return end

local settingsTable = {
    HideCharacter = false,
    AutoAttend = true,
    AutoFarm = true,
    AntiBubble = true,
    AutoHomework = true,
    HopAfterSchool = false,
    AfterSchoolTable = {"Afternoon","Dance","Night"},
    LockerPin = "0000",
    English = false,
    Music = false,
    Chemistry = false,
    PE = false,
    Computer = false,
    Swimming = false,
    Baking = false,
    Art = false,
    Lunch = false,
    Breakfast = false,
    Dance = false,
    onJoinGetBooks = true
    }

local fName = "ConConfigs"
local FileName = "RoyaleHigh.txt"
local fullFileName = fName.."\\"..FileName

if not isfolder(fName) then
    print("Could not find configuration folder, creating a new one.")
   makefolder(fName) 
end
if not isfile(fullFileName) or isfile(fullFileName) and readfile(fullFileName) == "" then
    print("Configuration file for this game is missing or broken, creating a new one.")
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settingsTable))
end

local RH_Settings = game:GetService("HttpService"):JSONDecode(readfile(fullFileName))

local LocalPlayer = game:GetService("Players").LocalPlayer

if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrentClass = ReplicatedStorage:WaitForChild("CurrentActivity")
local RepLockerFolder = ReplicatedStorage:WaitForChild("Lockers")
local ReplicatedClasses = ReplicatedStorage:WaitForChild("Classes")
local ClassRemote = ReplicatedClasses:WaitForChild("Starting")
local CodeRemote = RepLockerFolder:WaitForChild("Code")
local AbandonRemote = RepLockerFolder:WaitForChild("Abandon")
local ContentFunction = RepLockerFolder:WaitForChild("Contents")
local PlayerLocker = LocalPlayer:WaitForChild("Locker")

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local HomeworkFolder = LocalPlayer:FindFirstChild("Homework")
task.spawn(function()
	if not HomeworkFolder then 
		repeat task.wait() HomeworkFolder = LocalPlayer:FindFirstChild("Homework") until HomeworkFolder
		if RH_Settings.AutoHomework then
			OrionLib:MakeNotification({Name = "Homework", Content = "Fetched 'Homework' folder.", Icon = "", Time = 5})
		end
	end
end)

local Main = OrionLib:MakeWindow({Name = "Royale High - Classic", HidePremium = true, SaveConfig = false, ConfigFolder = "ConConfigs", IntroEnabled = false,Icon = "rbxassetid://4469750911"})

local FarmingTab = Main:MakeTab({Name = "Class Farming", PremiumOnly = false,Icon = "rbxassetid://7059346373"})
local Farming_ToggleSection = FarmingTab:AddSection({Name = "Toggles"})

local FarmClasses = Farming_ToggleSection:AddToggle({Name = "Farm Selected Classes", Default = RH_Settings.AutoFarm, Callback = function(state)
    RH_Settings.AutoFarm = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config

end})

local AttendClasses = Farming_ToggleSection:AddToggle({Name = "Attend Selected Classes", Default = RH_Settings.AutoAttend, Callback = function(state)
    RH_Settings.AutoAttend = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config

end})

local Farming_ClassSection = FarmingTab:AddSection({Name = "Class Toggles"})

local ClassEnglish = Farming_ClassSection:AddToggle({Name = "English Class", Default = RH_Settings.English, Callback = function(state)
    RH_Settings.English = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassChemistry = Farming_ClassSection:AddToggle({Name = "Chemistry Class", Default = RH_Settings.Chemistry, Callback = function(state)
    RH_Settings.Chemistry = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassSwimming = Farming_ClassSection:AddToggle({Name = "Swimming Class", Default = RH_Settings.Swimming, Callback = function(state)
    RH_Settings.Swimming = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassBaking = Farming_ClassSection:AddToggle({Name = "Baking Class", Default = RH_Settings.Baking, Callback = function(state)
    RH_Settings.Baking = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassComputer = Farming_ClassSection:AddToggle({Name = "Computer Class", Default = RH_Settings.Computer, Callback = function(state)
    RH_Settings.Computer = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassPE = Farming_ClassSection:AddToggle({Name = "PE Class", Default = RH_Settings.PE, Callback = function(state)
    RH_Settings.PE = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassMusic = Farming_ClassSection:AddToggle({Name = "Music Class", Default = RH_Settings.Music, Callback = function(state)
    RH_Settings.Music = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassArt = Farming_ClassSection:AddToggle({Name = "Art Class", Default = RH_Settings.Art, Callback = function(state)
    RH_Settings.Art = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local Farming_LesserClassSection = FarmingTab:AddSection({Name = "Others - THESE DO NOT GRANT XP"})


local LunchToggle = Farming_LesserClassSection:AddToggle({Name = "Lunch", Default = RH_Settings.Lunch, Callback = function(state)
    RH_Settings.Lunch = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local BreakfastToggle = Farming_LesserClassSection:AddToggle({Name = "Breakfast", Default = RH_Settings.BreakfastToggle, Callback = function(state)
    RH_Settings.Breakfast = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local DanceToggle = Farming_LesserClassSection:AddToggle({Name = "Dance", Default = RH_Settings.Dance, Callback = function(state)
    RH_Settings.Dance = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local MiscFarmingTab = Main:MakeTab({Name = "Misc Farming", PremiumOnly = false,Icon = "rbxassetid://7059346373"})

local MiscFarming_SectionBooks = MiscFarmingTab:AddSection({Name = "Books"})

local function GrabBooks()
    local LockerDoor = nil
	local ClickDetector = nil
	for _,TextLabel in ipairs(game:GetService("Workspace"):GetDescendants()) do
		if TextLabel.ClassName == "TextLabel" and TextLabel.Text == "Claim" then
			LockerDoor = TextLabel.Parent.Parent
			ClickDetector = LockerDoor:FindFirstChildWhichIsA("ClickDetector")
			break
		end
	end
	
	if #PlayerLocker:GetChildren() == 0 then return end
	
	fireclickdetector(ClickDetector,1)
	task.wait()
	CodeRemote:FireServer(LockerDoor,RH_Settings.LockerPin,"Create")
	task.wait()
	CodeRemote:FireServer(LockerDoor,RH_Settings.LockerPin,"Enter")
	task.wait()

	while #PlayerLocker:GetChildren() ~= 0 do task.wait()
	local CurrentBooksInLocker = #PlayerLocker:GetChildren()
		for _,Book in ipairs(PlayerLocker:GetChildren()) do
			if PlayerLocker:FindFirstChild(Book.Name) then
					CodeRemote:FireServer(LockerDoor,RH_Settings.LockerPin,"Enter")
					task.wait()
					ContentFunction:InvokeServer("Take",PlayerLocker[Book.Name])
					task.wait()
			end
			task.wait()
		end
	end

	task.wait()
	fireclickdetector(ClickDetector,0)
	AbandonRemote:FireServer()
end

local BooksButton = MiscFarming_SectionBooks:AddButton({Name = "Get Books",Callback = function() GrabBooks() end})

local BooksToggle = MiscFarming_SectionBooks:AddToggle({Name = "Get Books on Launch",Default = RH_Settings.onJoinGetBooks,Callback = function(state)
    RH_Settings.onJoinGetBooks = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local LockerInput = MiscFarming_SectionBooks:AddTextbox({Name = "Locker Code (max. 4 numbers)",Default = RH_Settings.LockerPin,TextDisappear = false,Callback = function(pinValue)
	if type(tonumber(pinValue)) ~= "number" or #pinValue > 4 or pinValue == "" then
        OrionLib:MakeNotification({Name = "Locker Code", Content = "The inputted code is invalid.", Icon = "", Time = 5})
        return
    end

    RH_Settings.LockerPin = pinValue
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local MiscFarming_SectionHomework = MiscFarmingTab:AddSection({Name = "Homework"})

local function DoHomework()
	if not HomeworkFolder then OrionLib:MakeNotification({Name = "Homework", Content = "Missing 'Homework' folder.", Icon = "", Time = 5}) return end
		while #HomeworkFolder:GetChildren() ~= 0 do task.wait()
		for _,Homework in ipairs(HomeworkFolder:GetChildren()) do
			if HomeworkFolder:FindFirstChild(Homework.Name) then
				Homework:WaitForChild("Complete"):FireServer()
				local HomeworkCollector = game:GetService("Workspace"):WaitForChild("Homeworkbox_"..Homework.Name):WaitForChild("Click"):WaitForChild("ClickDetector")
				fireclickdetector(HomeworkCollector,1)
				fireclickdetector(HomeworkCollector,0)
				task.wait()
			end
			task.wait()
		end
	end
end

local HomeworkButton = MiscFarming_SectionHomework:AddButton({Name = "Do Homework",Callback = function() DoHomework() end})

local HomeworkToggle = MiscFarming_SectionHomework:AddToggle({Name = "Auto Homework",Default = RH_Settings.AutoHomework,Callback = function(state)
    RH_Settings.AutoHomework = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

ClassRemote.OnClientEvent:Connect(function()
	if RH_Settings.AutoAttend then
		if RH_Settings[CurrentClass.Value] then
			ClassRemote:FireServer()
			task.wait()
			firesignal(LocalPlayer.PlayerGui.ClassNotifications.Teleport.Close.MouseButton1Down)
		end
	end
end)

task.spawn(function()
	if RH_Settings.onJoinGetBooks then task.wait() GrabBooks() end
	if RH_Settings.AutoHomework then task.wait() DoHomework() end
end)

OrionLib:MakeNotification({Name = "Orion", Content = "Orion has successfully loaded!", Icon = "", Time = 4})
OrionLib:Init()
