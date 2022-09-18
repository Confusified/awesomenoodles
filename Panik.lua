local settingsTable = {
    ShowExit = true,
    ShowHappy = false,
    ShowAllItems = false,
    ShowNeededItems = false,
    NoFog = true
    }
local fName = "ConConfigs"
local FileName = "Panik.txt"
local fullFileName = fName.."\\"..FileName

if not isfolder(fName) then
    print("Could not find configuration folder, creating a new one.")
   makefolder(fName) 
end
if not isfile(fullFileName) or isfile(fullFileName) and readfile(fullFileName) == "" then
    print("Configuration file for this game is missing or broken, creating a new one.")
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settingsTable))
end
if game.PlaceId == 8511615377 then
    print("You are currently in the lobby, script has been queued for teleport.")
    game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        syn.queue_on_teleport(loadstring(game:HttpGet('https://raw.githubusercontent.com/Confusified/awesomenoodles/main/Panik.lua')))
    end
end)
end

local settings = game:GetService("HttpService"):JSONDecode(readfile(fullFileName))
print("Settings have been loaded!")
