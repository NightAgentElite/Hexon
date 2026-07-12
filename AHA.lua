local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local DKey = loadstring(game:HttpGet("https://raw.githubusercontent.com/36kshania-jpg/ahahexon.lua/refs/heads/main/DKey.lua"))()

local Window = Rayfield:CreateWindow({
Name = "Hexon",
ShowText = "Hexon",

LoadingTitle = "Initializing Hexon...",  
LoadingSubtitle = "Tip: Patience is always the key...",  

Theme = "Green",  

ConfigurationSaving = {  
    Enabled = false,  
    FolderName = "Hexon AHA",  
    FileName = "Helixified File"  
},  

KeySystem = true,

KeySettings = {
Title = "Hexon Authentication...",
Subtitle = "Verifying Core Access..",
Note = "Enter Your Core Access Key To Continue Further Ado.",

FileName = "???",  
SaveKey = false,  

GrabKeyFromSite = false,  

Key = {  
    DKey  
}

}
})
--  ✨ Main Tab
local Main = Window:CreateTab("Main", "Leaf")

local WelcomeTitles = {
"Welcome!",
"Salute!",
"Hello!",
"Gotcha!",
"Ooh!"
}

local RandomWelcomeTitle = WelcomeTitles[math.random(1, #WelcomeTitles)]

Main:CreateParagraph({
Title = RandomWelcomeTitle,
Content = "Hello there, "..game.Players.LocalPlayer.Name.."! 🍃\n\nWelcome to Hexon, a nature-inspired control system built around precision, automation, and powerful utilities. ✨\n\nExplore intelligent toggles and advanced systems designed to bring control and efficiency together through a sleek organic interface. 🌿"
})

local Player = game.Players.LocalPlayer

local SessionStart = tick()

local function FormatTime(seconds)
seconds = math.floor(seconds)

local years = math.floor(seconds / (365 * 86400))  
seconds = seconds % (365 * 86400)  

local months = math.floor(seconds / (30 * 86400))  
seconds = seconds % (30 * 86400)  

local weeks = math.floor(seconds / (7 * 86400))  
seconds = seconds % (7 * 86400)  

local days = math.floor(seconds / 86400)  
seconds = seconds % 86400  

local hours = math.floor(seconds / 3600)  
seconds = seconds % 3600  

local minutes = math.floor(seconds / 60)  
local secs = seconds % 60  

local result = {}  

if years > 0 then  
    table.insert(result, string.format("%02d Years", years))  
end  

if months > 0 then  
    table.insert(result, string.format("%02d Months", months))  
end  

if weeks > 0 then  
    table.insert(result, string.format("%d Weeks", weeks))  
end  

if days > 0 then  
    table.insert(result, string.format("%03d Days", days))  
end  

if hours > 0 then  
    table.insert(result, string.format("%02d Hours", hours))  
end  

if minutes > 0 then  
    table.insert(result, string.format("%02d Minutes", minutes))  
end  

table.insert(result, string.format("%02d Seconds.", secs))  

return table.concat(result, "\n")

end

local PanelStatus = "Fine."

local VersionStatus = "Testing."

local Version = "v0.0.1"

local SessionInfo = Main:CreateParagraph({
Title = "Session Info",
Content =

"----------Version:\n"..Version..  
     "\n\n----------Version Status:\n"..VersionStatus..  
    "\n\n----------Panel Status:\n"..PanelStatus..  
    "\n\n----------Server Uptime:\n"..FormatTime(workspace.DistributedGameTime)..  
    "\n\n----------Runtime:\n"..FormatTime(tick() - SessionStart)

})

task.spawn(function()
while task.wait(1) do
SessionInfo:Set({
Title = "Session Info",
Content =

"----------Version:\n"..Version..  
            "\n\n----------Version Status:\n"..VersionStatus..  
            "\n\n----------Panel Status:\n"..PanelStatus..  
            "\n\n----------Server Uptime:\n"..FormatTime(workspace.DistributedGameTime)..  
            "\n\n----------Runtime:\n"..FormatTime(tick() - SessionStart)  
    })  
end

end)

-- 🤖 Automation Tab
local Automation = Window:CreateTab("Automation", "Cog")

Automation:CreateSection("------------------------------------------ Cameras Section.")

local CameraFixEnabled = false
local CameraConnections = {}
local FixingCameras = false

local CameraLocations = {
workspace.Misc.Cameras["Check-In"].MainLook,
workspace.Misc.Cameras.Lobby.MainLook,
workspace.Misc.Cameras.Medical.MainLook,
workspace.Misc.Cameras2.Emergency.MainLook
}

local function FixCamera(mainLook)
local player = game.Players.LocalPlayer
local character = player.Character
if not character then return end

local root = character:FindFirstChild("HumanoidRootPart")  
if not root then return end  

local pp = mainLook:FindFirstChild("PP")  

if pp and pp:IsA("ProximityPrompt") then  
    local oldPosition = root.CFrame  

    root.CFrame = mainLook.CFrame  

    if fireproximityprompt then  
        fireproximityprompt(pp)  
    end  

    task.wait()  

    root.CFrame = oldPosition  
end

end

local function FixAllCameras()
if not CameraFixEnabled then return end
if FixingCameras then return end
FixingCameras = true

task.spawn(function()  
    while CameraFixEnabled == true do  
        local foundBroken = false  

        for _, mainLook in ipairs(CameraLocations) do  
            if mainLook:FindFirstChild("PP") then  
                foundBroken = true  
                FixCamera(mainLook)  
                task.wait()  
            end  
        end  

        if not foundBroken then  
            break  
        end  
    end  

    FixingCameras = false  
end)

end

Automation:CreateToggle({
Name = "Auto Camera Fix",
CurrentValue = false,
Callback = function(Value)
CameraFixEnabled = Value

if Value then  
        FixAllCameras()  

        for _, mainLook in ipairs(CameraLocations) do  
            CameraConnections[#CameraConnections + 1] =  
                mainLook.ChildAdded:Connect(function(child)  
                    if child.Name == "PP" then  
                        FixAllCameras()  
                    end  
                end)  
        end  

    else  
        for _, connection in ipairs(CameraConnections) do  
            connection:Disconnect()  
        end  

        table.clear(CameraConnections)  
    end  
end

})

Automation:CreateSection("------------------------------------------ Check-In Section.")

-- 🏥 Auto Check-In
local AutoCheckInEnabled = false

local CheckInDelay = 0.5

local CheckInFolder = workspace.Misc.CheckIn
local NPCFolder = workspace.NPCs

local CheckInOrder = {
"Form",
"Camera",
"Computer",
"Printer"
}

local function GetPlayerRoot()
local character = game.Players.LocalPlayer.Character
if not character then return end

return character:FindFirstChild("HumanoidRootPart")

end

local function GetModelPosition(model)

local part = model:FindFirstChildWhichIsA("BasePart")  

if part then  
    return part.CFrame  
end  

return nil

end

local function TeleportAndFire(model)

local root = GetPlayerRoot()  
if not root then return end  


local position = GetModelPosition(model)  

if position then  
    root.CFrame = position  
end  


local pp = model:FindFirstChild("PP")  

if pp and pp:IsA("ProximityPrompt") then  

    if fireproximityprompt then  
        fireproximityprompt(pp)  
    end  

end  


task.wait(CheckInDelay)

end

local function WaitForModel(name)

local model = CheckInFolder:FindFirstChild(name)  

if model then  
    return model  
end  


return CheckInFolder.ChildAdded:Wait()

end

local function WaitForNPC()

while AutoCheckInEnabled do  

    for _, npc in ipairs(NPCFolder:GetChildren()) do  

        local highlight = npc:FindFirstChild("CheckStepHighlight")  
        local pp = npc:FindFirstChild("PP")  


        if highlight and pp then  
            return npc  
        end  

    end  


    task.wait(0.2)  

end

end

local function HandleNPC(npc)

local root = GetPlayerRoot()  
local npcRoot = npc:FindFirstChild("HumanoidRootPart")  
local pp = npc:FindFirstChild("PP")  


if root and npcRoot and pp then  

    root.CFrame = npcRoot.CFrame  


    if fireproximityprompt then  
        fireproximityprompt(pp)  
    end  

end

end

local function RunCheckIn()

for _, name in ipairs(CheckInOrder) do  

    if not AutoCheckInEnabled then  
        return  
    end  


    local model = CheckInFolder:FindFirstChild(name)  

    if model then  
        TeleportAndFire(model)  
    end  

end  



-- Wait for PrintedBadge  
local printedBadge = WaitForModel("PrintedBadge")  

if printedBadge and AutoCheckInEnabled then  

    task.wait(CheckInDelay)  

    TeleportAndFire(printedBadge)  
end  



-- Wait for NPC CheckStepHighlight  
local npc = WaitForNPC()  

if npc and AutoCheckInEnabled then  
    HandleNPC(npc)  
end

end

Automation:CreateToggle({
Name = "Auto Check-In",
CurrentValue = false,

Callback = function(Value)  

    AutoCheckInEnabled = Value  

    if Value then  

        task.spawn(function()  
            RunCheckIn()  
        end)  

    end  

end

})

CheckInFolder.ChildAdded:Connect(function(child)

if not AutoCheckInEnabled then  
    return  
end  

if child.Name == "Form" then  

    task.spawn(function()  
        RunCheckIn()  
    end)  

end

end)

local CheckInDelaySlider = Automation:CreateSlider({
Name = "Check-In Delay",
Range = {0.75, 10},
Increment = 0.25,
Suffix = " Seconds",
CurrentValue = 0.5,

Callback = function(Value)  
    CheckInDelay = Value  
end

})

Automation:CreateSection("------------------------------------------ Fire Section.")

local AutoPutOutFire = false

local LastPosition = nil

local function GetRoot()
local char = game.Players.LocalPlayer.Character
if char then
return char:FindFirstChild("HumanoidRootPart")
end
end

local function FirePrompt(part)
local pp = part:FindFirstChildOfClass("ProximityPrompt")

if pp and fireproximityprompt then  
    fireproximityprompt(pp)  
end

end

local function HandleFireRoom(room)

local fireRoom = room:FindFirstChild(room.Name)  

if not fireRoom then  
    return  
end  


local fireModel = fireRoom:FindFirstChild("Fire")  

if not fireModel then  
    return  
end  


while AutoPutOutFire and fireRoom.Parent do  

    for _,part in ipairs(fireModel:GetChildren()) do  

        if part:IsA("BasePart") then  

            local root = GetRoot()  

            if root then  

                root.CFrame =  
                    part.CFrame + Vector3.new(0,1,0)  

                task.wait()  

                FirePrompt(part)  

                task.wait()  

            end  

        end  

    end  


    if not room:FindFirstChild(room.Name) then  
        break  
    end  


    task.wait()  

end

end

local function ScanFires()

while AutoPutOutFire do  

    local roomsFolder = workspace:FindFirstChild("Rooms")  

    if roomsFolder then  


        for _,department in ipairs(roomsFolder:GetChildren()) do  


            if department:IsA("Folder") or department:IsA("Model") then  


                for _,room in ipairs(department:GetChildren()) do  


                    if room:FindFirstChild(room.Name) then  

                        task.spawn(function()  
                            HandleFireRoom(room)  
                        end)  

                    end  


                end  

            end  

        end  

    end  


    task.wait()  

end

end

Automation:CreateToggle({
    Name = "Auto Put Out Room Fire",
    CurrentValue = false,
    Callback = function(value)
        AutoPutOutFire = value

        if value then
            task.spawn(function()
                ScanFires()
            end)
        end
    end
})


local AutoPutOutPatientFire = false
local PatientFireRunning = false
local HandlingPatientFire = false

local OintmentedPatients = {}

local OintmentCFrame = CFrame.new(
-153.742203, 3.518641, -80.3524628,
0.017775692, 1.42741783e-08, 0.999841988,
6.70652911e-09, 1, -1.4395666e-08,
-0.999841988, 6.9613626e-09, 0.017775692
)

local function SafeFirePrompt(prompt)
    if prompt and fireproximityprompt then
        fireproximityprompt(prompt)
    end
end

local function GetNearestPrompt(maxDistance)
    local root = GetRoot()
    if not root then return nil end

    local nearest
    local distanceCheck

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            local parent = obj.Parent

            if parent and parent:IsA("Model") then
                local distance = (parent:GetPivot().Position - root.Position).Magnitude

                if distance <= maxDistance and (not distanceCheck or distance < distanceCheck) then
                    nearest = obj
                    distanceCheck = distance
                end
            end
        end
    end

    return nearest
end

local function HandlePatientFire(npc)

    if HandlingPatientFire then return end

    HandlingPatientFire = true

    local root = GetRoot()
    local firePP = npc:FindFirstChild("FirePP")
    local npcRoot = npc:FindFirstChild("HumanoidRootPart")

    if not root or not firePP or not npcRoot then
        HandlingPatientFire = false
        return
    end


    -- Get ointment
    root.CFrame = OintmentCFrame
    task.wait(0.1)

    local ointmentPP = GetNearestPrompt(10)

    SafeFirePrompt(ointmentPP)

    task.wait()

    -- Return to patient
    root.CFrame = npcRoot.CFrame
    task.wait(0.1)

    SafeFirePrompt(firePP)

    OintmentedPatients[npc] = true

    task.wait(0.1)

    HandlingPatientFire = false
end

local function ScanPatientFires()

    if PatientFireRunning then return end

    PatientFireRunning = true

    task.spawn(function()

        while AutoPutOutPatientFire do

            local npcs = workspace:FindFirstChild("NPCs")

            if npcs then
                for _, npc in ipairs(npcs:GetChildren()) do

                    if npc:FindFirstChild("FirePP")
                    and not OintmentedPatients[npc]
                    then
                        HandlePatientFire(npc)
                        task.wait(5)
                    end

                end
            end

            task.wait(0.1)
        end

        PatientFireRunning = false

    end)
end

Automation:CreateToggle({
Name = "Auto Put Out Patient Fire",
CurrentValue = false,

Callback = function(Value)  

    AutoPutOutPatientFire = Value  

    if Value then  
        ScanPatientFires()  
    end  

end

})

-- 🔧 Utilities Tab
local Utilities = Window:CreateTab("Utilities", "Wrench")
-- 👁 Visuals Tab
local Visuals = Window:CreateTab("Visuals", "scan-eye")
-- 😗 Player Tab
local Player = Window:CreateTab("Player", "Accessibility")
