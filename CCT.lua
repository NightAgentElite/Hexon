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
    FolderName = "Hexon CCT",  
    FileName = "AutomaticSave"  
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
-- ✨ Main Tab
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

-- 👁️ Visuals Tab
local Visuals = Window:CreateTab("Visuals", "scan-eye")

Visuals:CreateSection("------------------------------------------ Dangerous Section.")

local C4HighlightEnabled = false
local C4Highlights = {}

local function AddC4Highlight(part)
    if not part:IsA("BasePart") then return end
    if C4Highlights[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Adornee = part

    C4Highlights[part] = highlight
end

local function RemoveC4Highlights()
    for part, highlight in pairs(C4Highlights) do
        if highlight then
            highlight:Destroy()
        end
    end

    table.clear(C4Highlights)
end

local function ScanC4()
    for _, obj in ipairs(workspace:GetDescendants()) do
        
        if obj.Name == "FL"
        and obj:IsA("BasePart")
        and obj.Parent
        and obj.Parent:IsA("Model") then
            
            AddC4Highlight(obj)
        end

    end
end

Visuals:CreateToggle({
    Name = "C4 Highlight",
    CurrentValue = false,

    Callback = function(Value)
        C4HighlightEnabled = Value

        if Value then
            ScanC4()
        else
            RemoveC4Highlights()
        end
    end
})

workspace.DescendantAdded:Connect(function(obj)

    if not C4HighlightEnabled then
        return
    end

    if obj.Name == "FL"
    and obj:IsA("BasePart")
    and obj.Parent
    and obj.Parent:IsA("Model") then

        AddC4Highlight(obj)

    end

end)

local MolotovHighlightEnabled = false
local MolotovHighlights = {}

local function AddMolotovHighlight(part)
    if not part:IsA("BasePart") then return end
    if MolotovHighlights[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Adornee = part

    MolotovHighlights[part] = highlight
end

local function RemoveMolotovHighlights()
    for part, highlight in pairs(MolotovHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end

    table.clear(MolotovHighlights)
end

local function ScanMolotov()
    for _, obj in ipairs(workspace:GetChildren()) do

        if obj.Name == "noucrash"
        and obj:IsA("BasePart") then

            local creator = obj:FindFirstChild("creator")

            if creator and creator:IsA("ObjectValue") then
                AddMolotovHighlight(obj)
            end

        end

    end
end

Visuals:CreateToggle({
    Name = "Molotov Highlight",
    CurrentValue = false,

    Callback = function(Value)
        MolotovHighlightEnabled = Value

        if Value then
            ScanMolotov()
        else
            RemoveMolotovHighlights()
        end
    end
})

workspace.ChildAdded:Connect(function(obj)

    if not MolotovHighlightEnabled then
        return
    end

    if obj.Name == "noucrash"
    and obj:IsA("BasePart") then

        task.wait()

        local creator = obj:FindFirstChild("creator")

        if creator and creator:IsA("ObjectValue") then
            AddMolotovHighlight(obj)
        end

    end

end)

local FireHighlightEnabled = false
local FireHighlights = {}

local function AddFireHighlight(part)
    if not part:IsA("MeshPart") then return end
    if FireHighlights[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Adornee = part

    FireHighlights[part] = highlight
end

local function RemoveFireHighlights()
    for part, highlight in pairs(FireHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end

    table.clear(FireHighlights)
end

local function ScanFire()
    for _, obj in ipairs(workspace:GetChildren()) do

        if obj.Name == "Fire"
        and obj:IsA("MeshPart") then
            
            AddFireHighlight(obj)

        end

    end
end

Visuals:CreateToggle({
    Name = "Fire Highlight",
    CurrentValue = false,

    Callback = function(Value)
        FireHighlightEnabled = Value

        if Value then
            ScanFire()
        else
            RemoveFireHighlights()
        end
    end
})

workspace.ChildAdded:Connect(function(obj)

    if not FireHighlightEnabled then
        return
    end

    if obj.Name == "Fire"
    and obj:IsA("MeshPart") then
        
        AddFireHighlight(obj)

    end

end)

local BombHighlightEnabled = false
local BombHighlights = {}

local function AddBombHighlight(part)
    if not part:IsA("BasePart") then return end
    if BombHighlights[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Adornee = part

    BombHighlights[part] = highlight
end

local function RemoveBombHighlights()
    for part, highlight in pairs(BombHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end

    table.clear(BombHighlights)
end

local function ScanBombs()
    for _, obj in ipairs(workspace:GetChildren()) do

        if obj.Name == "TimeBomb"
        and obj:IsA("BasePart") then

            local creator = obj:FindFirstChild("creator")

            if creator and creator:IsA("ObjectValue") then
                AddBombHighlight(obj)
            end

        end

    end
end

Visuals:CreateToggle({
    Name = "Bomb Highlight",
    CurrentValue = false,

    Callback = function(Value)
        BombHighlightEnabled = Value

        if Value then
            ScanBombs()
        else
            RemoveBombHighlights()
        end
    end
})

workspace.ChildAdded:Connect(function(obj)

    if not BombHighlightEnabled then
        return
    end

    if obj.Name == "TimeBomb"
    and obj:IsA("BasePart") then

        task.wait()

        local creator = obj:FindFirstChild("creator")

        if creator and creator:IsA("ObjectValue") then
            AddBombHighlight(obj)
        end

    end

end)

local BarrelHighlightEnabled = false
local BarrelHighlights = {}

local function AddBarrelHighlight(part)
    if not part:IsA("BasePart") then return end
    if BarrelHighlights[part] then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = part
    highlight.Adornee = part

    BarrelHighlights[part] = highlight
end

local function RemoveBarrelHighlights()
    for part, highlight in pairs(BarrelHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end

    table.clear(BarrelHighlights)
end

local function ScanBarrels()
    for _, obj in ipairs(workspace:GetDescendants()) do

        if obj.Name == "barrel"
        and obj:IsA("BasePart") then
            
            AddBarrelHighlight(obj)

        end

    end
end

Visuals:CreateToggle({
    Name = "Barrel Highlight",
    CurrentValue = false,

    Callback = function(Value)
        BarrelHighlightEnabled = Value

        if Value then
            ScanBarrels()
        else
            RemoveBarrelHighlights()
        end
    end
})

workspace.DescendantAdded:Connect(function(obj)

    if not BarrelHighlightEnabled then
        return
    end

    if obj.Name == "barrel"
    and obj:IsA("BasePart") then
        
        AddBarrelHighlight(obj)

    end

end)

Visuals:CreateSection("------------------------------------------ Settings Section.")

local HeldItemHighlightEnabled = false
local HeldItemHighlights = {}

local function AddToolHighlight(tool)
    if not tool:IsA("Tool") then return end
    if HeldItemHighlights[tool] then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = tool
    highlight.Adornee = tool

    HeldItemHighlights[tool] = highlight
end

local function RemoveToolHighlights()
    for tool, highlight in pairs(HeldItemHighlights) do
        if highlight then
            highlight:Destroy()
        end
    end

    table.clear(HeldItemHighlights)
end

local function ScanTools()
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("Tool") then
            AddToolHighlight(obj)
        end
    end
end

Visuals:CreateToggle({
    Name = "Held Items Highlight",
    CurrentValue = false,

    Callback = function(Value)
        HeldItemHighlightEnabled = Value

        if Value then
            ScanTools()
        else
            RemoveToolHighlights()
        end
    end
})

game.DescendantAdded:Connect(function(obj)

    if not HeldItemHighlightEnabled then
        return
    end

    if obj:IsA("Tool") then
        AddToolHighlight(obj)
    end

end)
