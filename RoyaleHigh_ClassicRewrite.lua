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
    ArtClass = false
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

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Main = OrionLib:MakeWindow({Name = "Royale High", HidePremium = true, SaveConfig = false, ConfigFolder = "ConConfigs", IntroEnabled = false,Icon = "rbxassetid://4469750911"})

local FarmingTab = Main:MakeTab({Name = "Farming", PremiumOnly = false,Icon = "rbxassetid://7059346373"})
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

local UnnamedTab = Main:MakeTab({Name = "TBA", PremiumOnly = false,Icon = ""})


OrionLib:MakeNotification({Name = "Orion", Content = "Orion has successfully loaded!", Icon = "", Time = 5})
OrionLib:Init() --end of script
