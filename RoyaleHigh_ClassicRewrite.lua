local settingsTable = {
    HideCharacter = false,
    AutoAttend = true,
    AutoFarm = true,
    AntiBubble = true,
    AutoHomework = true,
    HopAfterSchool = false,
    AfterSchoolTable = {"Afternoon","Dance","Night"},
    LockerPin = "0000",
    EnglishClass = false,
    MusicClass = false,
    ChemistryClass = false,
    PEClass = false,
    ComputerClass = false,
    SwimmingClass = false,
    BakingClass = false,
    ArtClass = false,
    LunchToggle = false,
    BreakfastToggle = false,
    DancePrepToggle = false,
    DanceToggle = false,
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RepLockerFolder = ReplicatedStorage:WaitForChild("Lockers")
local CodeRemote = RepLockerFolder:WaitForChild("Code")
local AbandonRemote = RepLockerFolder:WaitForChild("Abandon")
local ContentFunction = RepLockerFolder:WaitForChild("Contents")
local PlayerLocker = LocalPlayer:WaitForChild("Locker")

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
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

local ClassEnglish = Farming_ClassSection:AddToggle({Name = "English Class", Default = RH_Settings.EnglishClass, Callback = function(state)
    RH_Settings.EnglishClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassChemistry = Farming_ClassSection:AddToggle({Name = "Chemistry Class", Default = RH_Settings.ChemistryClass, Callback = function(state)
    RH_Settings.ChemistryClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassSwimming = Farming_ClassSection:AddToggle({Name = "Swimming Class", Default = RH_Settings.SwimmingClass, Callback = function(state)
    RH_Settings.SwimmingClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassBaking = Farming_ClassSection:AddToggle({Name = "Baking Class", Default = RH_Settings.BakingClass, Callback = function(state)
    RH_Settings.BakingClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassComputer = Farming_ClassSection:AddToggle({Name = "Computer Class", Default = RH_Settings.ComputerClass, Callback = function(state)
    RH_Settings.ComputerClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassPE = Farming_ClassSection:AddToggle({Name = "PE Class", Default = RH_Settings.PEClass, Callback = function(state)
    RH_Settings.PEClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassMusic = Farming_ClassSection:AddToggle({Name = "Music Class", Default = RH_Settings.MusicClass, Callback = function(state)
    RH_Settings.MusicClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local ClassArt = Farming_ClassSection:AddToggle({Name = "Art Class", Default = RH_Settings.ArtClass, Callback = function(state)
    RH_Settings.ArtClass = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local Farming_LesserClassSection = FarmingTab:AddSection({Name = "Others - THESE DO NOT GRANT XP"})


local LunchToggle = Farming_LesserClassSection:AddToggle({Name = "Lunch", Default = RH_Settings.LunchToggle, Callback = function(state)
    RH_Settings.LunchToggle = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local BreakfastToggle = Farming_LesserClassSection:AddToggle({Name = "Breakfast", Default = RH_Settings.BreakfastToggle, Callback = function(state)
    RH_Settings.BreakfastToggle = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local DancePrepToggle = Farming_LesserClassSection:AddToggle({Name = "Dance Preparations", Default = RH_Settings.DancePrepToggle, Callback = function(state)
    RH_Settings.DancePrepToggle = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local DanceToggle = Farming_LesserClassSection:AddToggle({Name = "Dance", Default = RH_Settings.DanceToggle, Callback = function(state)
    RH_Settings.DanceToggle = state
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(RH_Settings)) --update config
end})

local MiscFarmingTab = Main:MakeTab({Name = "Misc Farming", PremiumOnly = false,Icon = "rbxassetid://7059346373"})

local MiscFarming_SectionBooks = MiscFarmingTab:AddSection({Name = "Books"})


local function GrabBooks()
    local Lockers = game:GetService("Workspace"):FindFirstChild("Lockers")
    if not Lockers then Lockers = game:GetService("Workspace"):WaitForChild("Lockers") end

    local LockerDoor = Lockers:FindFirstChild("LockerDoor")
    if not LockerDoor then LockerDoor = Lockers:WaitForChild("LockerDoor") end

    local ClickDetector = LockerDoor:FindFirstChildWhichIsA("ClickDetector")
    if not ClickDetector then repeat task.wait() ClickDetector = LockerDoor:FindFirstChildWhichIsA("ClickDetector") until ClickDetector end

    if #PlayerLocker:GetChildren() == 0 then return end
	
	AbandonRemote:FireServer()
	task.wait()
    fireclickdetector(ClickDetector,1)
    task.wait()
	
    CodeRemote:FireServer(LockerDoor,RH_Settings.LockerPin,"Create")
    task.wait()
    CodeRemote:FireServer(LockerDoor,RH_Settings.LockerPin,"Enter")

    while #PlayerLocker:GetChildren() ~= 0 do task.wait()
        for _,Book in ipairs(PlayerLocker:GetChildren()) do
            if PlayerLocker:FindFirstChild(Book.Name) then
                ContentFunction:InvokeServer("Take",PlayerLocker[Book.Name])
            end
            task.wait()
        end
    end

    task.wait()
    fireclickdetector(ClickDetector,0)
    AbandonRemote:FireServer()
end

if RH_Settings.onJoinGetBooks then GrabBooks() end

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


OrionLib:MakeNotification({Name = "Orion", Content = "Orion has successfully loaded!", Icon = "", Time = 5})
OrionLib:Init() --end of script
