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
	ChemistryMinWait = 4,
	ChemistryMaxWait = 7.5,
    PE = false,
    Computer = false,
	ComputerMinWait = 6.5,
	ComputerMaxWait = 8,
    Swimming = false,
    Baking = false,
    Art = false,
	ArtMinWait = 0.6,
	ArtMaxWait = 0.85,
    Lunch = false,
    Breakfast = false,
    Dance = false,
    LimboFarm = true,
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

for i,v in pairs(settingsTable) do
	if RH_Settings[i] == nil then
		RH_Settings[i] = v
	end
end

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if not LocalPlayer.Character then LocalPlayer.CharacterAdded:Wait() end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TriggerCaptcha = ReplicatedStorage:WaitForChild("CaptchaRemote"):WaitForChild("TriggerCaptcha")
local SolvedCaptcha = ReplicatedStorage:WaitForChild("CaptchaRemote"):WaitForChild("SolvedRemoteEvent")
local CurrentClass = ReplicatedStorage:WaitForChild("CurrentActivity")
local RepLockerFolder = ReplicatedStorage:WaitForChild("Lockers")
local ReplicatedClasses = ReplicatedStorage:WaitForChild("Classes")
local ClassRemote = ReplicatedClasses:WaitForChild("Starting")
local ArtRemote = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Paint"):WaitForChild("SetColor")
local EnglishRemote = ReplicatedClasses:WaitForChild("English")
local ComputerRemote = ReplicatedClasses:WaitForChild("Computer")
local InstructionRemote = ReplicatedClasses:WaitForChild("Instructions")
local ChemistryRemote = ReplicatedClasses:WaitForChild("Chemistry")
local CodeRemote = RepLockerFolder:WaitForChild("Code")
local AbandonRemote = RepLockerFolder:WaitForChild("Abandon")
local ContentFunction = RepLockerFolder:WaitForChild("Contents")
local PlayerLocker = LocalPlayer:WaitForChild("Locker")
local ChatBar = PlayerGui:WaitForChild("Chat"):WaitForChild("Frame"):WaitForChild("ChatBarParentFrame"):WaitForChild("Frame"):WaitForChild("BoxFrame"):WaitForChild("Frame"):WaitForChild("ChatBar")
local wordList = {"Amateur","Wednesday","Until","a lot","Dessert","Embarrassing","Enough","Argument","February","Library","Tongue","Camouflage","Accommodate","Beautiful"}

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

local ChemistryWaitMin = Farming_ClassSection:AddTextbox({Name = "Minimum wait to complete", Default = RH_Settings.ChemistryMinWait,TextDisappear = false,Callback = function(value)
	if type(tonumber(value)) ~= "number" or tonumber(value) < 0 or tonumber(value) > RH_Settings.ChemistryMaxWait then
        OrionLib:MakeNotification({Name = "Art", Content = "The inputted wait time is invalid.", Icon = "", Time = 5})
        return
    end
	
	RH_Settings.ChemistryMinWait = tonumber(value)
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ChemistryWaitMax = Farming_ClassSection:AddTextbox({Name = "Maximum wait to complete", Default = RH_Settings.ChemistryMaxWait,TextDisappear = false,Callback = function(value)
	if type(tonumber(value)) ~= "number" or tonumber(value) < 0 then
        OrionLib:MakeNotification({Name = "Art", Content = "The inputted wait time is invalid.", Icon = "", Time = 5})
        return
    end
	
	RH_Settings.ChemistryMaxWait = tonumber(value)
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

local ComputerWaitMin = Farming_ClassSection:AddTextbox({Name = "Minimum wait per sentence", Default = RH_Settings.ComputerMinWait,TextDisappear = false,Callback = function(value)
	if type(tonumber(value)) ~= "number" or tonumber(value) < 0 or tonumber(value) > RH_Settings.ComputerMaxWait then
        OrionLib:MakeNotification({Name = "Art", Content = "The inputted wait time is invalid.", Icon = "", Time = 5})
        return
    end
	
	RH_Settings.ComputerMinWait = tonumber(value)
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ChemistryWaitMax = Farming_ClassSection:AddTextbox({Name = "Maximum wait per sentence", Default = RH_Settings.ChemistryMaxWait,TextDisappear = false,Callback = function(value)
	if type(tonumber(value)) ~= "number" or tonumber(value) < 0 then
        OrionLib:MakeNotification({Name = "Art", Content = "The inputted wait time is invalid.", Icon = "", Time = 5})
        return
    end
	
	RH_Settings.ChemistryMaxWait = tonumber(value)
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

local ArtWaitMin = Farming_ClassSection:AddTextbox({Name = "Minimum wait per square", Default = RH_Settings.ArtMinWait,TextDisappear = false,Callback = function(value)
	if type(tonumber(value)) ~= "number" or tonumber(value) < 0 or tonumber(value) > RH_Settings.ArtMaxWait then
        OrionLib:MakeNotification({Name = "Art", Content = "The inputted wait time is invalid.", Icon = "", Time = 5})
        return
    end
	
	RH_Settings.ArtMinWait = tonumber(value)
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ArtWaitMax = Farming_ClassSection:AddTextbox({Name = "Maximum wait per square", Default = RH_Settings.ArtMaxWait,TextDisappear = false,Callback = function(value)
	if type(tonumber(value)) ~= "number" or tonumber(value) < 0 then
        OrionLib:MakeNotification({Name = "Art", Content = "The inputted wait time is invalid.", Icon = "", Time = 5})
        return
    end
	
	RH_Settings.ArtMaxWait = tonumber(value)
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local Farming_LesserClassSection = FarmingTab:AddSection({Name = "Others - THESE DO NOT GRANT XP"})

local BreakfastToggle = Farming_LesserClassSection:AddToggle({Name = "Breakfast", Default = RH_Settings.Breakfast, Callback = function(state)
    RH_Settings.Breakfast = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local LunchToggle = Farming_LesserClassSection:AddToggle({Name = "Lunch", Default = RH_Settings.Lunch, Callback = function(state)
    RH_Settings.Lunch = state
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

local MiscFarming_SectionDance = MiscFarmingTab:AddSection({Name = "Dance"})

local DanceFarmToggle = MiscFarming_SectionDance:AddToggle({Name = "Auto Limbo",Default = RH_Settings.LimboFarm,Callback = function(state)
    RH_Settings.LimboFarm = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

ClassRemote.OnClientEvent:Connect(function()
	if RH_Settings.AutoAttend then
		if RH_Settings[CurrentClass.Value] then
			ClassRemote:FireServer()
			task.wait()
			firesignal(PlayerGui:WaitForChild("ClassNotifications"):WaitForChild("Teleport"):WaitForChild("Close").MouseButton1Click)
		end
	end
end)

TriggerCaptcha.OnClientEvent:Connect(function(Bubble)
	if RH_Settings.AntiBubble	then
		for i=1,3 do
			SolvedCaptcha:FireServer("FloatingBubble_" .. i, Bubble)
		end
		task.wait()
		firesignal(PlayerGui:WaitForChild("CaptchaGui"):WaitForChild("Award"):WaitForChild("Close").MouseButton1Down)
	end
end)

EnglishRemote.OnClientEvent:Connect(function(...)
	if RH_Settings.English then
	task.wait()
		local args = {...}
		for i,w in pairs(args) do
			if type(w) == "table" and i == 2 then
				for __,r in pairs(w) do
					if type(r)=="table" then
						if type(r)=="table" then
							for t,y in pairs(r) do
								for z,x in pairs(wordList) do
									if y == x then
										EnglishRemote:FireServer(tostring(x))
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

ChemistryRemote.OnClientEvent:Connect(function(value)
	if RH_Settings.Chemistry then
		if value == "StartRound" then
			local i=0
			repeat i=i+task.wait() until i>=(math.random(RH_Settings.ChemistryMinWait*100,RH_Settings.ChemistryMaxWait*100)/100) --lower chance of suspicion :D
			ChemistryRemote:FireServer("SequenceDone")
		end
	end
end)

ComputerRemote.OnClientEvent:Connect(function(p1)
	if RH_Settings.Computer then
		if p1 ~= true and p1 ~= false then
			local p1=tostring(p1)
			local TtW = #p1/(math.random(RH_Settings.ComputerMinWait*100,RH_Settings.ComputerMaxWait*100)/100)
			task.wait(TtW)
			lockwindow()
			ChatBar:CaptureFocus()
			task.wait()
			ChatBar:SetTextFromInput(p1)
			keyclick(Enum.KeyCode.Return)
			task.wait()
			ChatBar:ReleaseFocus()
			unlockwindow()
		end
	end
end)

local function getEasel()
	local ClassLocation = workspace:FindFirstChild("ArtClassReal")
	if not ClassLocation then repeat task.wait() ClassLocation = workspace:FindFirstChild("ArtClassReal") until ClassLocation end
	
	for _,Easel in pairs(ClassLocation:GetChildren()) do
		if Easel.Name == "Easel" and Easel:WaitForChild("Owner").Value == LocalPlayer then
			return Easel
		end
	end
end

InstructionRemote.OnClientEvent:Connect(function(...)
	if RH_Settings.Art then
		local args = {...}
		if args[1] == "Art" then
			local ownEasel = getEasel().Canvas
			local character = LocalPlayer.Character
			task.wait()
			character:WaitForChild("HumanoidRootPart").CFrame = getEasel():WaitForChild("Seat").CFrame
			character:WaitForChild("Paint Brush")
			task.wait()
			local ClassLocation = workspace:FindFirstChild("ArtClassReal")
			if not ClassLocation then repeat task.wait() ClassLocation = workspace:FindFirstChild("ArtClassReal") until ClassLocation end
			
			for u = 1,5 do --total of 25
				for i = 1,5 do
					task.wait((math.random(RH_Settings.ArtMinWait*100,RH_Settings.ArtMaxWait*100))/100)
					local MainEasel = ClassLocation.MainEasel.CanvasToCopy
					local CurrentTile = MainEasel[tostring(u..","..i)] 
					local EaselTile = ownEasel[tostring(u..","..i)] 
					local TileColor = CurrentTile.BrickColor.Number
					ArtRemote:FireServer(EaselTile,BrickColor.new(TileColor))
				end
			end
			task.wait()
		end
	end
end)

local function WinPE()
	local ClassModel = game:GetService("Workspace"):FindFirstChild("PE")
	if not ClassModel then repeat task.wait() ClassModel = game:GetService("Workspace"):FindFirstChild("PE") until ClassModel end
	
	local PEBell = ClassModel:FindFirstChild("Bell")
	if not PEBell then repeat task.wait() PEBell = game:GetService("Workspace"):FindFirstChild("Bell") until PEBell end
	
	while PEBell do task.wait()
		if PEBell then
			fireclickdetector(PEBell:WaitForChild("ClickDetector"),1)
			fireclickdetector(PEBell:WaitForChild("ClickDetector"),0)
		end
	end
end

local function RemoveSwimmingMinigame()
	local ClassModel = game:GetService("Workspace"):FindFirstChild("SpinnerClass")
	if not ClassModel then repeat task.wait() ClassModel = game:GetService("Workspace"):FindFirstChild("SpinnerClass") until ClassModel end
	
	local Sensor = ClassModel:FindFirstChild("Sensor")
	if not Sensor then repeat task.wait() Sensor = game:GetService("Workspace"):FindFirstChild("Sensor") until Sensor end
	
	local Spinner = ClassModel:FindFirstChild("Spinner")
	if not Spinner then repeat task.wait() Spinner = game:GetService("Workspace"):FindFirstChild("Spinner") until Spinner end
	
	Sensor:Destroy()
	for _,v in ipairs(Spinner:GetChildren()) do
		v:Destroy()
	end
end

CurrentClass.Changed:Connect(function()
	if CurrentClass.Value == "Swimming" and RH_Settings.Swimming then
		RemoveSwimmingMinigame()
	elseif CurrentClass.Value == "PE" and RH_Settings.PE then
		WinPE()
	elseif CurrentClass.Value == "Baking" and RH_Settings.Baking then
		print("Nothing for Baking Class yet.")
	end
end)

task.spawn(function()
	if RH_Settings.onJoinGetBooks then task.wait() GrabBooks() end
	if RH_Settings.AutoHomework then task.wait() DoHomework() end
end)

OrionLib:MakeNotification({Name = "Orion", Content = "'Royale High - Classic' has successfully loaded!", Icon = "", Time = 4})
OrionLib:Init()
