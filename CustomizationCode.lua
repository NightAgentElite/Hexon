local CoreGui = game:GetService("CoreGui")

local Rayfield

for _, child in ipairs(CoreGui:GetChildren()) do
local found = child:FindFirstChild("Rayfield")

if found then  
    Rayfield = found  
    break  
end

end

if not Rayfield then
error("Rayfield not found in CoreGui")
end

local RayfieldGUIButtons

for _, obj in ipairs(game:GetService("CoreGui"):GetDescendants()) do
    if obj.Name == "Rayfield" and obj:IsA("ScreenGui") then
        RayfieldGUIButtons = obj
        break
    end
end


if not RayfieldGUIButtons then
    error("Rayfield GUI not found")
end


local function IsExcluded(Object)

    return Object.Name == "SectionSpacing"
    or Object.Name == "SectionTitle"
    or Object.Name == "Divider"

end


local function CreateStrokeOverlay(Button)

    if IsExcluded(Button) then
        return
    end


    if not Button:IsA("GuiObject") then
        return
    end


    -- Remove rayfield's default stroke
    local OldStroke = Button:FindFirstChild("UIStroke")

    if OldStroke then
        OldStroke:Destroy()
    end


    if Button:FindFirstChild("Overlay") then
        return
    end


    local Overlay = Button:Clone()

    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(
    Button.Size.X.Scale,
    0,
    Button.Size.Y.Scale,
    Button.Size.Y.Offset
)
    Overlay.BackgroundTransparency = 1
    Overlay.BackgroundColor3 = Color3.fromRGB(255,255,255)

    -- Remove everything inside clone
    for _, child in ipairs(Overlay:GetDescendants()) do

        if child ~= Overlay then
            child:Destroy()
        end

    end


    Overlay.Parent = Button


    Overlay.Active = false
    Overlay.Selectable = false

local Outline = Instance.new("UIStroke")
Outline.Name = "UIStroke"
Outline.Color = Color3.fromRGB(0,0,0)
Outline.Thickness = 3
Outline.LineJoinMode = Enum.LineJoinMode.Round
Outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
Outline.Parent = Button


    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0,9)
    Corner.Parent = Overlay


    local Stroke = Instance.new("UIStroke")
    Stroke.Name = "UIStroke"
    Stroke.Color = Color3.fromRGB(189,189,189)
    Stroke.Thickness = 1
    Stroke.LineJoinMode = Enum.LineJoinMode.Round
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    Stroke.Parent = Overlay


    local Gradient = Instance.new("UIGradient")
    Gradient.Name = "UIGradient"
    Gradient.Rotation = 90
    Gradient.Transparency = NumberSequence.new(0)
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(189,189,189)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(22,22,22))
    })
    Gradient.Parent = Stroke

end


local Elements = RayfieldGUIButtons.Main.Elements


local function Scan()

    for _, Object in ipairs(Elements:GetDescendants()) do

        if Object:IsA("ScrollingFrame") then

            for _, Child in ipairs(Object:GetChildren()) do
                CreateStrokeOverlay(Child)
            end


            Object.ChildAdded:Connect(function(Child)

                task.wait()

                CreateStrokeOverlay(Child)

            end)

        end

    end

end


Scan()

-- Tab Customization System

local TabGradients = {
Main = {
ColorSequenceKeypoint.new(0, Color3.fromRGB(238,119,116)),
ColorSequenceKeypoint.new(0.4, Color3.fromRGB(242,84,67)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(242,84,67))
},

Navigation = {  
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,181,93)),  
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(242,157,65)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(242,157,65))  
},  

Visuals = {  
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,240,150)),  
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,204,69)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,204,69))  
},  

["Local Player"] = {  
    ColorSequenceKeypoint.new(0, Color3.fromRGB(183,202,96)),  
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(95,200,93)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(95,200,93))  
},  

Automation = {  
    ColorSequenceKeypoint.new(0, Color3.fromRGB(135,164,220)),  
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(62,130,204)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(62,130,204))  
},  

Fun = {  
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,160,190)),  
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(250,115,230)),  
    ColorSequenceKeypoint.new(1, Color3.fromRGB(250,115,230))  
}

}

local function SetupTab(Tab)

if not Tab:IsA("Frame") then  
    return  
end  


-- Force colors automatically  

Tab.BackgroundColor3 = Color3.fromRGB(255,255,255)  
Tab.BackgroundTransparency = 0  


local Title = Tab:FindFirstChildWhichIsA("TextLabel", true)  

if Title then  

    Title.TextColor3 = Color3.fromRGB(255,255,255)  


    local Stroke = Title:FindFirstChild("UIStroke")  

    if not Stroke then  
        Stroke = Instance.new("UIStroke")  
        Stroke.Parent = Title  
    end  


    Stroke.LineJoinMode = Enum.LineJoinMode.Miter  
    Stroke.Thickness = 2  
    Stroke.Color = Color3.fromRGB(0,0,0)  


    Title:GetPropertyChangedSignal("TextColor3"):Connect(function()  
        Title.TextColor3 = Color3.fromRGB(255,255,255)  
    end)  

end  



local Image = Tab:FindFirstChildWhichIsA("ImageLabel", true)  

if Image then  

    Image.ImageColor3 = Color3.fromRGB(255,255,255)  


    Image:GetPropertyChangedSignal("ImageColor3"):Connect(function()  
        Image.ImageColor3 = Color3.fromRGB(255,255,255)  
    end)  

end  



Tab:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()  
    Tab.BackgroundColor3 = Color3.fromRGB(255,255,255)  
end)  


Tab:GetPropertyChangedSignal("BackgroundTransparency"):Connect(function()  
    Tab.BackgroundTransparency = 0  
end)  



-- Gradient  

local OldGradient = Tab:FindFirstChild("NoxiusGradient")  

if OldGradient then  
    OldGradient:Destroy()  
end  


local Colors = TabGradients[Tab.Name]  

if Colors then  

    local Gradient = Instance.new("UIGradient")  

    Gradient.Name = "NoxiusGradient"  
    Gradient.Offset = Vector2.new(0,0)  
    Gradient.Rotation = 90  
    Gradient.Transparency = NumberSequence.new(0)  
    Gradient.Color = ColorSequence.new(Colors)  

    Gradient.Parent = Tab  

end

end

local TabList = Rayfield:WaitForChild("Main"):WaitForChild("TabList")

for _, Tab in ipairs(TabList:GetChildren()) do
SetupTab(Tab)
end

TabList.ChildAdded:Connect(function(Tab)

task.wait()  

SetupTab(Tab)

end)

local ImageButton = Instance.new("ImageButton")
ImageButton.Name = "ImageButton"
ImageButton.Parent = Rayfield

ImageButton.Active = true
ImageButton.Draggable = true
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.AutoButtonColor = false
ImageButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
ImageButton.BackgroundTransparency = 0
ImageButton.BorderColor3 = Color3.fromRGB(27,42,53)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.5, 0, 0, 119)
ImageButton.Size = UDim2.new(0,64,0,64)
ImageButton.SizeConstraint = Enum.SizeConstraint.RelativeXY
ImageButton.ZIndex = 100000
ImageButton.Visible = true
ImageButton.ClipsDescendants = false

-- Rounded corners
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,17)
Corner.Parent = ImageButton

-- Main gradient
local Gradient = Instance.new("UIGradient")
Gradient.Rotation = 90
Gradient.Offset = Vector2.new(0,0)
Gradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(69,69,69)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22,22,22))
})
Gradient.Parent = ImageButton

-- Black outer stroke
local BlackStroke = Instance.new("UIStroke")
BlackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
BlackStroke.Color = Color3.fromRGB(0,0,0)
BlackStroke.Thickness = 3
BlackStroke.Transparency = 0
BlackStroke.Parent = ImageButton
BlackStroke.Enabled = true

-- UI scale
local Scale = Instance.new("UIScale")
Scale.Scale = 0.5
Scale.Parent = ImageButton

-- Icon
local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Name = "ImageLabel"
ImageLabel.Parent = ImageButton

ImageLabel.Active = false
ImageLabel.BackgroundTransparency = 1
ImageLabel.Position = UDim2.new(0,-14,0,-14)
ImageLabel.Size = UDim2.new(0,92,0,92)
ImageLabel.ZIndex = 100001
ImageLabel.Image = "rbxassetid://100574547642033"
ImageLabel.ImageColor3 = Color3.fromRGB(255,255,255)
ImageLabel.ScaleType = Enum.ScaleType.Stretch

local RayfieldParent = ImageButton.Parent

local MainFrame = RayfieldParent:WaitForChild("Main")
local DragFrame = RayfieldParent:WaitForChild("Drag")

ImageButton.MouseButton1Click:Connect(function()
local NewState = not MainFrame.Visible

MainFrame.Visible = NewState  
DragFrame.Visible = NewState

end)

local Topbar = ImageButton.Parent
:WaitForChild("Main")
:WaitForChild("Topbar")

local Hide = Topbar:FindFirstChild("Hide")

if Hide then
Hide:Destroy()
end

local NoxiusToggleOutline = Instance.new("ImageLabel")
NoxiusToggleOutline.Name = "ImageOutline"
NoxiusToggleOutline.Parent = ImageButton

NoxiusToggleOutline.AnchorPoint = Vector2.new(0, 0)
NoxiusToggleOutline.BackgroundTransparency = 1
NoxiusToggleOutline.BackgroundColor3 = Color3.fromRGB(255,255,255)
NoxiusToggleOutline.BorderSizePixel = 0
NoxiusToggleOutline.Position = UDim2.new(0, 0, 0, 0)
NoxiusToggleOutline.Size = UDim2.new(1, 0, 1, 0)
NoxiusToggleOutline.ZIndex = 100002
NoxiusToggleOutline.ImageTransparency = 1
NoxiusToggleOutline.ClipsDescendants = false

local OutlineCorner = Instance.new("UICorner")
OutlineCorner.CornerRadius = UDim.new(0,17)
OutlineCorner.Parent = NoxiusToggleOutline

local OutlineStroke = Instance.new("UIStroke")
OutlineStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
OutlineStroke.Color = Color3.fromRGB(189,189,189)
OutlineStroke.LineJoinMode = Enum.LineJoinMode.Round
OutlineStroke.Thickness = 1
OutlineStroke.Transparency = 0
OutlineStroke.Parent = NoxiusToggleOutline

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Rotation = 90
StrokeGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(189,189,189)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(22,22,22))
})
StrokeGradient.Parent = OutlineStroke

-- Hover Sound
local HoverSound = Instance.new("Sound")
HoverSound.Name = "TinyTick"
HoverSound.Parent = Rayfield

-- Data
HoverSound.EmitterSize = 10
HoverSound.MaxDistance = 10000
HoverSound.MinDistance = 10

-- Behavior
HoverSound.Archivable = true
HoverSound.PlayOnRemove = false

-- Asset
HoverSound.SoundId = "rbxassetid://147982968"

-- Playback
HoverSound.Looped = false
HoverSound.PlaybackRegionsEnabled = false
HoverSound.PlaybackSpeed = 2
HoverSound.TimePosition = 0.1
HoverSound.Volume = 0.150

-- Regions
HoverSound.LoopRegion = NumberRange.new(0, 60000)
HoverSound.PlaybackRegion = NumberRange.new(0, 60000)

-- Emitter
HoverSound.RollOffMaxDistance = 10000
HoverSound.RollOffMinDistance = 10
HoverSound.RollOffMode = Enum.RollOffMode.InverseTapered

-- Routing
HoverSound.SoundGroup = nil

-- Click Sound
local ClickSound = Instance.new("Sound")
ClickSound.Name = "Click"
ClickSound.Parent = Rayfield

-- Data
ClickSound.EmitterSize = 10
ClickSound.MaxDistance = 10000
ClickSound.MinDistance = 10

-- Behavior
ClickSound.Archivable = true
ClickSound.PlayOnRemove = false

-- Asset
ClickSound.SoundId = "rbxassetid://552900451"

-- Playback
ClickSound.Looped = false
ClickSound.PlaybackRegionsEnabled = false
ClickSound.PlaybackSpeed = 1
ClickSound.TimePosition = 0
ClickSound.Volume = 0.5

-- Regions
ClickSound.LoopRegion = NumberRange.new(0, 60000)
ClickSound.PlaybackRegion = NumberRange.new(0, 60000)

-- Emitter
ClickSound.RollOffMaxDistance = 10000
ClickSound.RollOffMinDistance = 10
ClickSound.RollOffMode = Enum.RollOffMode.InverseTapered

-- Routing
ClickSound.SoundGroup = nil

-- Events
local function ConnectButton(Button)
if Button:GetAttribute("NoxiusConnected") then
return
end

Button:SetAttribute("NoxiusConnected", true)  

Button.MouseEnter:Connect(function()
    HoverSound:Play()
end)

Button.MouseButton1Click:Connect(function()
    ClickSound:Play()
end)
end

for _, Object in ipairs(Rayfield:GetDescendants()) do
if Object:IsA("ImageButton") or Object:IsA("TextButton") then
ConnectButton(Object)
end
end

Rayfield.DescendantAdded:Connect(function(Object)
if Object:IsA("ImageButton") or Object:IsA("TextButton") then
ConnectButton(Object)
end
end)
