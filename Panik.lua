local settingsTable = {
    ShowExit = false,
    ShowHappy = false,
    ShowNeededItems = false,
    NoFog = false
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
        syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Confusified/awesomenoodles/main/Panik.lua'))()")
    end
end)
return
end

local ScriptData = Instance.new("Folder",game)
ScriptData.Name = "PanikGui_gc"
local Highlight = Instance.new("Highlight")


local settings = game:GetService("HttpService"):JSONDecode(readfile(fullFileName))
local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local main = SolarisLib:New({
    Name = "Panik",
    FolderToSave = "SolarisLibStuff"
})
syn.protect_gui(main) --idk!!!!

local tab = main:Tab("Main")
local sec = tab:Section("Rendering")

local exittoggle = sec:Toggle("Highlight Exits",settings.ShowExit,"Toggle",function(a)
    settings.ShowExit = a
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settings)) --update config
    
    if settings.ShowExit then
            for i,v in ipairs(game:GetService("Workspace"):WaitForChild("Trapdoors"):GetChildren()) do
                local ExitHighlight = Highlight:Clone()
                ExitHighlight.Parent = ScriptData
                ExitHighlight.Adornee = v
                ExitHighlight.Name = "Exit"
            end
        print("Highlighting Exits")
    elseif not settings.ShowExit then
            for i,v in ipairs(game:GetService("Workspace"):WaitForChild("Trapdoors"):GetChildren()) do
                local ExitHighlight = ScriptData:FindFirstChild("Exit")
                if ExitHighlight == nil then
                    print("Could not find highlight")
                    return
                end
                ExitHighlight:Destroy()
                print("No longer highlighting Exits")
            end
    end
end)
local happytoggle = sec:Toggle("Highlight Happy",settings.ShowHappy,"Toggle",function(a)
    settings.ShowHappy = a
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settings)) --update config
    
    if settings.ShowHappy then
        local HappyHighlight = Highlight:Clone()
        HappyHighlight.Parent = ScriptData
        HappyHighlight.Adornee = game:GetService("Workspace"):WaitForChild("MovingMop") or game:GetService("Workspace"):WaitForChild("Happy")
        HappyHighlight.Name = "Happy"
        print("Highlighting Happy")
    else
        local HappyHighlight = ScriptData:FindFirstChild("Happy")
        if HappyHighlight == nil then
            print("Could not find highlight")
            return
        end
        HappyHighlight:Destroy()
        print("No longer highlighting Happy")
    end
end)

local fogtoggle = sec:Toggle("Toggle Fog",settings.NoFog,"Toggle",function(a)
    settings.NoFog = a
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settings)) --update config
    
    while settings.NoFog do
        task.wait()
        game:GetService("Lighting").FogEnd = 1e9
    end
    if not settings.NoFog then
        game:GetService("Lighting").FogEnd = 1e2
    end
end)

local itemtoggle = sec:Toggle("Highlight Required Items",settings.ShowNeededItems,"Toggle",function(a)
    settings.ShowNeededItems = a
    writefile(fullFileName,game:GetService("HttpService"):JSONEncode(settings)) --update config
    print("This is not a functional toggle, yet")
end)
