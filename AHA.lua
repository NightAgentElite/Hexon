local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local DKey = loadstring(game:HttpGet("https://raw.githubusercontent.com/36kshania-jpg/ahahexon.lua/refs/heads/main/DKey.lua"))()

local FunFacts = loadstring(game:HttpGet("https://raw.githubusercontent.com/NightAgentElite/Noxius/refs/heads/main/FunFacts.lua"))()

local RandomFact = FunFacts[math.random(1, #FunFacts)]

local Window = Rayfield:CreateWindow({
Name = "Morse",
Icon = 90484559502038,
ShowText = "Debugs",

LoadingTitle = "Loading UI and Code...",
LoadingSubtitle = "Checking for Files and Assets..",  

Theme = "Ocean",  

ConfigurationSaving = { 
    Enabled = true, 
    FolderName = "Morse AHA",  
    FileName = "AutomaticSave"  
},  

KeySystem = true,

KeySettings = {
Title = "Morse's Daily Key System",
Subtitle = "Enter your key, Obtained from something.",
Note = "Fun Fact: "..RandomFact,

FileName = "???",  
SaveKey = false,  

GrabKeyFromSite = false,  

Key = {  
    DKey  
}

}
})

loadstring(game:HttpGet("https://raw.githubusercontent.com/NightAgentElite/Noxius/refs/heads/main/CustomizationCode.lua"))()

--  🏡 Main  Tab
local Main = Window:CreateTab("Main", "Home")
-- 🕳️ Navigation Tab
local Navigation = Window:CreateTab("Navigation", "Navigation")
-- 👁 Visuals Tab
local Visuals = Window:CreateTab("Visuals", "Eye")
-- 👤 Local Player Tab
local LocalPlayer = Window:CreateTab("Local Player", "User")
-- ▶️ Automation Tab
local Automation = Window:CreateTab("Automation", "Play")
-- 🙂 Fun Tab
local Fun = Window:CreateTab("Fun", "Smile")


Main:CreateSection(" Interface")

local CoreGui = game:GetService("CoreGui")

local RayfieldGUI

for _, obj in ipairs(CoreGui:GetDescendants()) do
    if obj.Name == "Rayfield" and obj:IsA("ScreenGui") then
        RayfieldGUI = obj
        break
    end
end

if not RayfieldGUI then
    error("Rayfield GUI not found in CoreGui")
end

local LockToggleEnabled = false

local function UpdateImageButton(Button)

    if Button:IsA("ImageButton") then
        Button.Draggable = not LockToggleEnabled
    end

end


local function UpdateAllImageButtons()

    for _, Button in ipairs(RayfieldGUI:GetChildren()) do
        UpdateImageButton(Button)
    end

end


RayfieldGUI.ChildAdded:Connect(function(Child)

    task.wait()

    if Child:IsA("ImageButton") then
        UpdateImageButton(Child)
    end

end)

Main:CreateToggle({
    Name = "Lock Toggle Button",
    CurrentValue = false,

    Callback = function(Value)

        LockToggleEnabled = Value

        UpdateAllImageButtons()

    end
})

Main:CreateLabel("Toggles the ability to drag the toggle button.")

local DestroyConfirm = false

Main:CreateButton({
    Name = "Destroy Interface",

    Callback = function()

        if not DestroyConfirm then

            DestroyConfirm = true

            Rayfield:Notify({
                Title = "Destroy Interface?",
                Content = "Are you sure you want to DESTROY the interface?\nClick again within 5 seconds to confirm.",
                Image = 100574547642033,
                Duration = 5
            })

            task.delay(5, function()
                DestroyConfirm = false
            end)

            return
        end


        if RayfieldGUI then
            RayfieldGUI:Destroy()
        end

    end
})

if not RayfieldGUI then
    error("Rayfield GUI not found in CoreGui")
end

Main:CreateLabel("Destroys the interface.")

Main:CreateSection(" Developer")

local Version = "v0.0.1"

Main:CreateButton({
    Name = "Notify Version",

    Callback = function()

        Rayfield:Notify({
            Title = "Noxius Version",
            Content = "Current Version: "..Version,
            Image = 100574547642033,
            Duration = 5
        })

    end
})

Main:CreateLabel("Notifies you the current version of the script.")

Main:CreateButton({
    Name = "Show Console",

    Callback = function()

        game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)

    end
})

Main:CreateLabel("Shows the Roblox Developer Console.")

Automation:CreateSection(" Player")

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
Name = "Auto Fix Cameras",
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

Automation:CreateLabel("Automatically repairs broken security cameras.")

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
CurrentValue = 1,

Callback = function(Value)  
    CheckInDelay = Value  
end

})

Automation:CreateLabel("Automatically completes the patient check-in process.")

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

    task.wait(1) -- wait before starting for editing

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
    task.wait(0.25)

    local ointmentPP = GetNearestPrompt(10)

    SafeFirePrompt(ointmentPP)

    task.wait(0.25)

    -- Return to patient
    root.CFrame = npcRoot.CFrame
    task.wait(0.25)

    SafeFirePrompt(firePP)

    OintmentedPatients[npc] = true

    task.wait(0.25)

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

            task.wait(0.25)
        end

        PatientFireRunning = false

    end)
end

Automation:CreateLabel("Automatically extinguishes fires in hospital rooms.")

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

Automation:CreateLabel("Automatically applies ointment and extinguishes burning patients.")

local AutoTrashFaintedPatients = false
local TrashRunning = false

local TrashFaintedsDelay = 0.25 -- value for slider setting


local TrashTP = CFrame.new(
    -137.000916, 3.45753121, -70.3865509,
    0.0145357512, -3.07224113e-08, -0.999894321,
    -4.26894875e-09, 1, -3.07877173e-08,
    0.999894321, 4.71602046e-09, 0.0145357512
)

local TrashPivotPosition = Vector3.new(
    -134.350006,
    2.19999957,
    -70.399971
)


local function FirePrompt(prompt)

    if prompt
    and prompt:IsA("ProximityPrompt")
    and fireproximityprompt then

        fireproximityprompt(prompt)

    end

end


local function FireFaintedPP(npc)

    local rootPart = npc:FindFirstChild("RootPart")

    if not rootPart then
        return
    end


    local faintedPP = rootPart:FindFirstChild("FaintedPP", true)

    if faintedPP then
        FirePrompt(faintedPP)
    end

end


local function GetCorrectTrash()

    local closestTrash
    local closestDistance = math.huge


    for _, obj in ipairs(workspace:GetDescendants()) do

        if obj:IsA("Model")
        and obj.Name == "Trash" then


            local distance =
                (obj:GetPivot().Position - TrashPivotPosition).Magnitude


            if distance < closestDistance then

                closestDistance = distance
                closestTrash = obj

            end

        end

    end


    return closestTrash

end


local function FireTrashPP()

    local trash = GetCorrectTrash()

    if not trash then
        return
    end


    local pp = trash:FindFirstChild("PP")


    if pp then
        FirePrompt(pp)
    end

end


local function HandleFaintedPatient(npc)

    local character = game.Players.LocalPlayer.Character

    if not character then
        return
    end


    local root = character:FindFirstChild("HumanoidRootPart")
    local npcRoot = npc:FindFirstChild("HumanoidRootPart")


    if not root or not npcRoot then
        return
    end


    -- Teleport to patient
    root.CFrame = npcRoot.CFrame
    task.wait(TrashFaintedsDelay)


    -- Fire patient fainted prompt
    FireFaintedPP(npc)
    task.wait(TrashFaintedsDelay)


    -- Teleport to trash
    root.CFrame = TrashTP
    task.wait(TrashFaintedsDelay)


    -- Fire trash prompt
    FireTrashPP()
    task.wait(TrashFaintedsDelay)

end


local function ScanFaintedPatients()

    if TrashRunning then
        return
    end


    TrashRunning = true


    task.spawn(function()

        while AutoTrashFaintedPatients do


            local npcFolder = workspace:FindFirstChild("NPCs")


            if npcFolder then

                for _, npc in ipairs(npcFolder:GetChildren()) do


                    if npc:IsA("Model")
                    and npc:FindFirstChild("PatientHighlight")
                    and npc:FindFirstChild("RagdollScript") then


                        HandleFaintedPatient(npc)

                        task.wait(TrashFaintedsDelay)

                    end

                end

            end


            task.wait(TrashFaintedsDelay)

        end


        TrashRunning = false

    end)

end


Automation:CreateToggle({
    Name = "Auto Trash Fainted Patients",
    CurrentValue = false,

    Callback = function(Value)

        AutoTrashFaintedPatients = Value


        if Value then

            ScanFaintedPatients()

        end

    end
})


Automation:CreateSlider({
    Name = "Auto Trash Fainted Patients Delay",
    Range = {0.15, 10},
    Increment = 0.05,
    Suffix = " Seconds",
    CurrentValue = 0.25,

    Callback = function(Value)
        TrashFaintedsDelay = Value
    end
})

Automation:CreateLabel("Automatically disposes of fainted patients.")

Navigation:CreateSection(" Teleports")

Navigation:CreateButton({
    Name = "Teleport to Office",
    Callback = function()
        local Character = game.Players.LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = CFrame.new(
                -106.709076, 3.41253114, 6.77596378,
                0.999785542, -3.1757974e-08, 0.0207103845,
                3.02453671e-08, 1, 7.33493621e-08,
                -0.0207103845, -7.27072376e-08, 0.999785542
            )
        end
    end
})

Navigation:CreateLabel("Teleports you to the office.")

Navigation:CreateButton({
    Name = "Teleport to Medical",
    Callback = function()
        local Character = game.Players.LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = CFrame.new(
                -144.882294, 3.45753074, -69.8499908,
                0.99998498, 9.19015477e-08, -0.00548297819,
                -9.15779381e-08, 1, 5.92714642e-08,
                0.00548297819, -5.87684532e-08, 0.99998498
            )
        end
    end
})

Navigation:CreateLabel("Teleports you to the medical hall.")

Navigation:CreateButton({
    Name = "Teleport to Emergency",
    Callback = function()
        local Character = game.Players.LocalPlayer.Character
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = CFrame.new(
                -145.219116, 3.45753026, 39.4612732,
                -0.999900162, 8.14113505e-08, 0.0141292699,
                8.25948234e-08, 1, 8.31767863e-08,
                -0.0141292699, 8.43354897e-08, -0.999900162
            )
        end
    end
})

Navigation:CreateLabel("Teleports you to the emergency hall.")

Navigation:CreateToggle({
    Name = "Teleport Tool",
    CurrentValue = false,

    Callback = function(Value)

        if Value then

            -- tp

            mouse = game.Players.LocalPlayer:GetMouse()
            tool = Instance.new("Tool")
            tool.RequiresHandle = false
            tool.Name = "Teleport Tool"

            tool.Activated:connect(function()
                local pos = mouse.Hit + Vector3.new(0,2.5,0)
                pos = CFrame.new(pos.X,pos.Y,pos.Z)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pos
            end)

            tool.Parent = game.Players.LocalPlayer.Backpack

        else

            local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild("Teleport Tool")

            if Tool then
                Tool:Destroy()
            end

            local EquippedTool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Teleport Tool")

            if EquippedTool then
                EquippedTool:Destroy()
            end

        end

    end
})

Navigation:CreateLabel("Gives you a teleport tool. Click anywhere while having it equipped to teleport to the clicked position.")

Navigation:CreateInput({
    Name = "Teleport To Player",
    CurrentValue = "",
    PlaceholderText = "> Target",
    RemoveTextAfterFocusLost = true,

    Callback = function(Text)

        local Search = Text:lower()
        local Target = nil

        for _, Player in ipairs(game.Players:GetPlayers()) do
            if Player.Name:lower():sub(1, #Search) == Search then
                Target = Player
                break
            end
        end

        if Target 
        and Target.Character 
        and Target.Character:FindFirstChild("HumanoidRootPart") then
            
            local LocalCharacter = game.Players.LocalPlayer.Character

            if LocalCharacter 
            and LocalCharacter:FindFirstChild("HumanoidRootPart") then
                
                LocalCharacter.HumanoidRootPart.CFrame =
                    Target.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

Navigation:CreateLabel("Teleports you to the target player.")

Fun:CreateSection("  Character")

local ThirdPersonEnabled = false

Fun:CreateToggle({
	Name = "Enable Third Person",
	CurrentValue = false,

	Callback = function(Value)
		ThirdPersonEnabled = Value

		local Player = game:GetService("Players").LocalPlayer

		if Value then
			Player.CameraMode = Enum.CameraMode.Classic
		else
			Player.CameraMode = Enum.CameraMode.LockFirstPerson
		end
	end
})

Fun:CreateLabel("Allows you to switch between first and third person.")

local FlipToolsEnabled = false

local plr = game.Players.LocalPlayer


local function performflip(character, flipdirection)

    local hum = character:WaitForChild("Humanoid")
    local rootpart = character:WaitForChild("HumanoidRootPart")

    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    hum.Sit = true

    local lookvector = rootpart.CFrame.LookVector
    local spindirection = Vector3.new(-lookvector.Z, 0, lookvector.X)

    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

    if torso then

        local bodyvelocity = Instance.new("BodyAngularVelocity")
        bodyvelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyvelocity.AngularVelocity = spindirection * (flipdirection * 10)
        bodyvelocity.P = 1000
        bodyvelocity.Parent = torso

        task.wait(0.4)

        bodyvelocity:Destroy()

    end

    task.wait(0.2)

    hum.Sit = false

end



local function connecttoolevents(tool)

    if tool:IsA("Tool") then

        tool.RequiresHandle = false

        tool.Activated:Connect(function()

            local char = plr.Character

            if char then

                if tool.Name == "Frontflip" then
                    performflip(char, -1)

                elseif tool.Name == "Backflip" then
                    performflip(char, 1)

                end

            end

        end)

    end

end



local function givetools()

    local backpack = plr:FindFirstChild("Backpack")

    if not backpack then return end


    if not backpack:FindFirstChild("Frontflip") then

        local frontfliptool = Instance.new("Tool")
        frontfliptool.Name = "Frontflip"
        frontfliptool.RequiresHandle = false
        frontfliptool.Parent = backpack

        connecttoolevents(frontfliptool)

    end


    if not backpack:FindFirstChild("Backflip") then

        local backfliptool = Instance.new("Tool")
        backfliptool.Name = "Backflip"
        backfliptool.RequiresHandle = false
        backfliptool.Parent = backpack

        connecttoolevents(backfliptool)

    end

end



local function RemoveFlipTools()

    local containers = {
        plr:FindFirstChild("Backpack"),
        plr.Character
    }


    for _, container in ipairs(containers) do

        if container then

            for _, tool in ipairs(container:GetChildren()) do

                if tool:IsA("Tool")
                and (tool.Name == "Frontflip" or tool.Name == "Backflip") then

                    tool:Destroy()

                end

            end

        end

    end

end



plr.CharacterAdded:Connect(function()

    task.wait(1)

    if FlipToolsEnabled then

        givetools()

    end

end)



Fun:CreateToggle({
    Name = "Flip Tools",
    CurrentValue = false,

    Callback = function(Value)

        FlipToolsEnabled = Value

        if Value then

            givetools()

        else

            RemoveFlipTools()

        end

    end
})

Fun:CreateLabel("Gives you tools that can perform either a backflip or frontflip.")

local SpinEnabled = false
local SpinSpeed = 10
local SpinObject = nil

local function StartSpin()

    local character = plr.Character
    if not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if SpinObject then
        SpinObject:Destroy()
    end

    local spin = Instance.new("BodyAngularVelocity")
    spin.Name = "NoxiusSpin"
    spin.MaxTorque = Vector3.new(0, math.huge, 0)
    spin.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
    spin.P = 1000
    spin.Parent = root

    SpinObject = spin

end


local function StopSpin()

    if SpinObject then
        SpinObject:Destroy()
        SpinObject = nil
    end

end


Fun:CreateToggle({
    Name = "Spin",
    CurrentValue = false,

    Callback = function(Value)

        SpinEnabled = Value

        if Value then
            StartSpin()
        else
            StopSpin()
        end

    end
})


Fun:CreateSlider({
    Name = "Spin Speed",
    Range = {1, 20},
    Increment = 1,
    Suffix = "",
    CurrentValue = 10,

    Callback = function(Value)

        SpinSpeed = Value

        if SpinObject then
            SpinObject.AngularVelocity = Vector3.new(0, SpinSpeed, 0)
        end

    end
})

Fun:CreateLabel("Makes you spin with the specified speed.")

Visuals:CreateSection(" ESPs")

local Players = game:GetService("Players")

local PlayerESPEnabled = false
local PlayerESPObjects = {}

local LocalPlayer3 = Players.LocalPlayer


local function AddPlayerESP(Character)

    if not Character or Character == LocalPlayer3.Character then
        return
    end

    if PlayerESPObjects[Character] then
        return
    end


    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end


    -- Highlight

    local Highlight = Instance.new("Highlight")
    Highlight.Name = "Highlight"
    Highlight.FillColor = Color3.fromRGB(0, 0, 255)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0
    Highlight.Adornee = Character
    Highlight.Parent = Character


    -- Name Billboard

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "BillboardGui"
    Billboard.Adornee = Root
    Billboard.Parent = Root

    Billboard.Size = UDim2.fromOffset(150, 40)
    Billboard.StudsOffset = Vector3.new(0, 0, 0)
    Billboard.AlwaysOnTop = true
    Billboard.MaxDistance = 250

    local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Padding = UDim.new(0, -20)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

UIListLayout.Parent = Billboard

    local Text = Instance.new("TextLabel")
    Text.Parent = Billboard
	Text.Name = "Name"
    Text.Size = UDim2.fromScale(1, 1)
    Text.BackgroundTransparency = 1
    Text.TextScaled = false
    Text.TextSize = 18
    Text.Font = Enum.Font.FredokaOne
    Text.TextColor3 = Color3.fromRGB(0,0,255)
    Text.TextStrokeTransparency = 0
    Text.LayoutOrder = 2
    local Player = Players:GetPlayerFromCharacter(Character)

    local StrokeName = Instance.new("UIStroke")
StrokeName.Color = Color3.fromRGB(255,255,255)
StrokeName.Thickness = 1
StrokeName.Parent = Text

local UsernameText = Text:Clone()
UsernameText.Parent = Billboard
UsernameText.Name = "Username"
UsernameText.LayoutOrder = 1

if Player then
    UsernameText.Text = "(@" .. Player.Name .. ")"
else
    UsernameText.Text = "(@" .. Character.Name .. ")"
end

    local StrokeUserName = Instance.new("UIStroke")
StrokeUserName.Color = Color3.fromRGB(255,255,255)
StrokeUserName.Thickness = 1
StrokeUserName.Parent = UsernameText

local SanityText = Instance.new("TextLabel")
SanityText.Parent = Billboard
SanityText.Name = "Sanity"
SanityText.Size = UDim2.fromScale(1, 1)
SanityText.BackgroundTransparency = 1
SanityText.TextScaled = false
SanityText.TextSize = 18
SanityText.Font = Enum.Font.FredokaOne
SanityText.TextColor3 = Color3.fromRGB(0,0,255)
SanityText.TextStrokeTransparency = 0
SanityText.LayoutOrder = 3

 local StrokeSanity = Instance.new("UIStroke")
StrokeSanity.Color = Color3.fromRGB(255,255,255)
StrokeSanity.Thickness = 1
StrokeSanity.Parent = SanityText

local Player = Players:GetPlayerFromCharacter(Character)

local function UpdateSanity()
    if Player then
        local Sanity = Player:GetAttribute("Sanity")

        if Sanity then
            SanityText.Text = "Sanity: "..Sanity
        else
            SanityText.Text = "Sanity: N/A"
        end
    end
end

UpdateSanity()

if Player then
    Player:GetAttributeChangedSignal("Sanity"):Connect(function()
        UpdateSanity()
    end)
end

if Player then
    Text.Text = Player.DisplayName
else
    Text.Text = Character.Name
end


    PlayerESPObjects[Character] = {
        Highlight = Highlight,
        Billboard = Billboard
    }

end



local function RemovePlayerESP()

    for Character, Objects in pairs(PlayerESPObjects) do

        if Objects.Highlight then
            Objects.Highlight:Destroy()
        end

        if Objects.Billboard then
            Objects.Billboard:Destroy()
        end

    end

    table.clear(PlayerESPObjects)

end



local function ScanPlayers()

    for _, Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer3 and Player.Character then

            AddPlayerESP(Player.Character)

        end

    end

end



local function SetupPlayer(Player)

    Player.CharacterAdded:Connect(function(Character)

        task.wait(1)

        if PlayerESPEnabled then
            AddPlayerESP(Character)
        end

    end)

end



for _, Player in ipairs(Players:GetPlayers()) do
    SetupPlayer(Player)
end


Players.PlayerAdded:Connect(SetupPlayer)



Visuals:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,

    Callback = function(Value)

        PlayerESPEnabled = Value

        if Value then

            ScanPlayers()

        else

            RemovePlayerESP()

        end

    end
})

Visuals:CreateLabel("Toggles ESP for Players.")


local MimicESPEnabled = false
local MimicObjects = {}

local MimicFolder = workspace:WaitForChild("NPCs")

local function AddMimicESP(npc)
	if MimicObjects[npc] then
		return
	end

	if not (npc:GetAttribute("Skinwalker") or npc.Name == "TallMonster") then
		return
	end

	local Root = npc:FindFirstChild("HumanoidRootPart")
	if not Root then
		return
	end

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "MimicESP"
	Highlight.FillColor = Color3.fromRGB(255, 0, 0)
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = npc
	Highlight.Parent = npc

	local Billboard = Instance.new("BillboardGui")
	Billboard.Name = "BillboardGui"
	Billboard.Adornee = Root
	Billboard.Parent = Root
	Billboard.Size = UDim2.fromOffset(150, 40)
	Billboard.StudsOffset = Vector3.new(0, 0, 0)
	Billboard.AlwaysOnTop = true
	Billboard.MaxDistance = 250

	local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Padding = UDim.new(0, -20)
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

UIListLayout.Parent = Billboard

	local Text = Instance.new("TextLabel")
	Text.Parent = Billboard
	Text.Name = "Name"
	Text.Size = UDim2.fromScale(1, 1)
	Text.BackgroundTransparency = 1
	Text.Text = npc.Name
	Text.TextSize = 18
	Text.Font = Enum.Font.FredokaOne
	Text.TextColor3 = Color3.fromRGB(255, 0, 0)
	Text.TextStrokeTransparency = 0
	Text.TextScaled = false

	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.fromRGB(255, 255, 255)
	Stroke.Thickness = 1
	Stroke.Parent = Text

	MimicObjects[npc] = {
		Highlight = Highlight,
		Billboard = Billboard
	}
end

local function RemoveMimicESP()
	for _, objects in pairs(MimicObjects) do
		if objects.Highlight then
			objects.Highlight:Destroy()
		end
		if objects.Billboard then
			objects.Billboard:Destroy()
		end
	end

	table.clear(MimicObjects)
end

local function ScanMimics()
	for _, npc in ipairs(MimicFolder:GetChildren()) do
		AddMimicESP(npc)
	end
end

MimicFolder.ChildAdded:Connect(function(npc)
	task.wait(0.1)

	if MimicESPEnabled then
		AddMimicESP(npc)
	end
end)

Visuals:CreateToggle({
	Name = "Mimic ESP",
	CurrentValue = false,

	Callback = function(Value)
		MimicESPEnabled = Value

		if Value then
			ScanMimics()
		else
			RemoveMimicESP()
		end
	end
})

Visuals:CreateLabel("Toggles ESP for Mimics.")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local NoclipEnabled = false
local NoclipConnection

local function ToggleNoclip()

    NoclipEnabled = not NoclipEnabled

    if NoclipEnabled then

        NoclipConnection = RunService.Stepped:Connect(function()

            if Player.Character then

                for _, part in pairs(Player.Character:GetDescendants()) do

                    if part:IsA("BasePart") then

                        part.CanCollide = false

                    end

                end

            end

        end)

    else

        if NoclipConnection then

            NoclipConnection:Disconnect()

            NoclipConnection = nil

        end


        if Player.Character then

            for _, part in pairs(Player.Character:GetDescendants()) do

                if part:IsA("BasePart") then

                    part.CanCollide = true

                end

            end

        end

    end

end


LocalPlayer:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,

    Callback = function(Value)

        if Value ~= NoclipEnabled then
            ToggleNoclip()
        end

    end
})

LocalPlayer:CreateLabel("Gives you the ability to phase through objects.")
