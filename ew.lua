-- 🚀 ULTIMATE SCRIPT WITH RAYFIELD UI 🚀
-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Configuration
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = 196.2,
    FOV = 70,
    Flying = false,
    Noclip = false,
    InfiniteJump = false,
    GodMode = false,
    ESP = false,
    Rainbow = false,
    TPSpeed = 1,
}

-- Connections
local Connections = {}

-- ========================================
-- 🎨 CREATE RAYFIELD WINDOW
-- ========================================

local Window = Rayfield:CreateWindow({
    Name = "🚀 Ultimate Script Hub",
    LoadingTitle = "Ultimate Script",
    LoadingSubtitle = "by Your Name",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UltimateScript",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- ========================================
-- 📱 TABS
-- ========================================

local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local MovementTab = Window:CreateTab("🏃 Movement", 4483362458)
local TeleportTab = Window:CreateTab("📍 Teleport", 4483362458)
local VehicleTab = Window:CreateTab("🚗 Vehicles", 4483362458)
local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
local AnimationTab = Window:CreateTab("🎭 Animations", 4483362458)
local VisualTab = Window:CreateTab("🌟 Visuals", 4483362458)
local MiscTab = Window:CreateTab("🔧 Misc", 4483362458)

-- ========================================
-- 🏠 MAIN TAB
-- ========================================

local MainSection = MainTab:CreateSection("Player Info")

MainTab:CreateLabel("Player: " .. Player.Name)
MainTab:CreateLabel("User ID: " .. Player.UserId)

local MainSection2 = MainTab:CreateSection("Quick Actions")

MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        Character:BreakJoints()
    end,
})

MainTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        Player:LoadCharacter()
    end,
})

MainTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end,
})

-- ========================================
-- 🏃 MOVEMENT TAB
-- ========================================

local MovementSection = MovementTab:CreateSection("Speed & Jump")

local WalkSpeedSlider = MovementTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        Config.WalkSpeed = Value
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end,
})

local JumpPowerSlider = MovementTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        Config.JumpPower = Value
        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end,
})

local GravitySlider = MovementTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 196.2},
    Increment = 1,
    CurrentValue = 196.2,
    Flag = "Gravity",
    Callback = function(Value)
        Config.Gravity = Value
        workspace.Gravity = Value
    end,
})

local MovementSection2 = MovementTab:CreateSection("Flight & Movement")

local FlyToggle = MovementTab:CreateToggle({
    Name = "Fly (Space/Shift for Up/Down)",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        Config.Flying = Value
        ToggleFly(Value)
    end,
})

local NoclipToggle = MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        Config.Noclip = Value
        ToggleNoclip(Value)
    end,
})

local InfiniteJumpToggle = MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        Config.InfiniteJump = Value
        ToggleInfiniteJump(Value)
    end,
})

-- ========================================
-- 📍 TELEPORT TAB
-- ========================================

local TeleportSection = TeleportTab:CreateSection("Teleport Settings")

local TPSpeedSlider = TeleportTab:CreateSlider({
    Name = "TP Animation Speed",
    Range = {0, 5},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "TPSpeed",
    Callback = function(Value)
        Config.TPSpeed = Value
    end,
})

local TeleportSection2 = TeleportTab:CreateSection("Teleport to Players")

local SelectedPlayer = nil

local PlayerDropdown = TeleportTab:CreateDropdown({
    Name = "Select Player",
    Options = {},
    CurrentOption = "None",
    Flag = "SelectedPlayer",
    Callback = function(Option)
        SelectedPlayer = Option
    end,
})

-- Update player list
task.spawn(function()
    while task.wait(2) do
        local playerNames = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                table.insert(playerNames, player.Name)
            end
        end
        PlayerDropdown:Refresh(playerNames, true)
    end
end)

TeleportTab:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if SelectedPlayer then
            TPToPlayer(SelectedPlayer)
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to " .. SelectedPlayer,
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Bring All Players to You",
    Callback = function()
        TPAllPlayersToYou()
        Rayfield:Notify({
            Title = "Teleported",
            Content = "Brought all players to you",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local TeleportSection3 = TeleportTab:CreateSection("Custom Position")

local TPX = 0
local TPY = 0
local TPZ = 0

TeleportTab:CreateInput({
    Name = "Position X",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TPX = tonumber(Text) or 0
    end,
})

TeleportTab:CreateInput({
    Name = "Position Y",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TPY = tonumber(Text) or 0
    end,
})

TeleportTab:CreateInput({
    Name = "Position Z",
    PlaceholderText = "0",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        TPZ = tonumber(Text) or 0
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Position",
    Callback = function()
        AnimatedTP(Vector3.new(TPX, TPY, TPZ), Config.TPSpeed)
    end,
})

-- ========================================
-- 🚗 VEHICLE TAB
-- ========================================

local VehicleSection = VehicleTab:CreateSection("Spawn Vehicles")

local CarSpeedSlider = VehicleTab:CreateSlider({
    Name = "Car Speed",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 200,
    Flag = "CarSpeed",
    Callback = function(Value)
        -- Update car speed config
    end,
})

VehicleTab:CreateButton({
    Name = "🚗 Spawn Car",
    Callback = function()
        SpawnCar()
        Rayfield:Notify({
            Title = "Vehicle Spawned",
            Content = "Car has been spawned nearby!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

VehicleTab:CreateButton({
    Name = "✈️ Spawn Plane",
    Callback = function()
        SpawnPlane()
        Rayfield:Notify({
            Title = "Vehicle Spawned",
            Content = "Plane has been spawned nearby!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

VehicleTab:CreateButton({
    Name = "🚁 Spawn Helicopter",
    Callback = function()
        SpawnHelicopter()
        Rayfield:Notify({
            Title = "Vehicle Spawned",
            Content = "Helicopter has been spawned nearby!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

VehicleTab:CreateButton({
    Name = "🏍️ Spawn Bike",
    Callback = function()
        SpawnBike()
        Rayfield:Notify({
            Title = "Vehicle Spawned",
            Content = "Bike has been spawned nearby!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- ========================================
-- ⚔️ COMBAT TAB
-- ========================================

local CombatSection = CombatTab:CreateSection("Combat Abilities")

CombatTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        Config.GodMode = Value
        ToggleGodMode(Value)
    end,
})

CombatTab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Flag = "Invisibility",
    Callback = function(Value)
        ToggleInvisibility(Value)
    end,
})

CombatTab:CreateToggle({
    Name = "Force Field",
    CurrentValue = false,
    Flag = "ForceField",
    Callback = function(Value)
        ToggleForcefield(Value)
    end,
})

CombatTab:CreateButton({
    Name = "Give Super Punch Tool",
    Callback = function()
        SuperPunch()
    end,
})

local CombatSection2 = CombatTab:CreateSection("Offensive Actions")

CombatTab:CreateButton({
    Name = "Kill All Players",
    Callback = function()
        KillAll()
        Rayfield:Notify({
            Title = "Action Executed",
            Content = "Attempted to kill all players",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

CombatTab:CreateButton({
    Name = "Fling Selected Player",
    Callback = function()
        if SelectedPlayer then
            FlingPlayer(SelectedPlayer)
        end
    end,
})

-- ========================================
-- 🎭 ANIMATION TAB
-- ========================================

local AnimationSection = AnimationTab:CreateSection("Play Animations")

local Animations = {
    ["Dance 1"] = "5917459365",
    ["Dance 2"] = "3333499508",
    ["Dance 3"] = "4049037604",
    ["Sit"] = "2506281703",
    ["Wave"] = "5915779043",
    ["Point"] = "5915781890",
    ["Laugh"] = "5915784515",
    ["Cheer"] = "5915786874",
    ["Stadium"] = "3333432454",
    ["Shuffle"] = "3333499508",
}

for animName, animId in pairs(Animations) do
    AnimationTab:CreateButton({
        Name = animName,
        Callback = function()
            PlayAnimation(animId)
        end,
    })
end

local AnimationSection2 = AnimationTab:CreateSection("Custom Animation")

local CustomAnimID = ""

AnimationTab:CreateInput({
    Name = "Animation ID",
    PlaceholderText = "Enter Animation ID",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        CustomAnimID = Text
    end,
})

AnimationTab:CreateButton({
    Name = "Play Custom Animation",
    Callback = function()
        if CustomAnimID ~= "" then
            PlayAnimation(CustomAnimID)
        end
    end,
})

-- ========================================
-- 🌟 VISUAL TAB
-- ========================================

local VisualSection = VisualTab:CreateSection("Visual Effects")

VisualTab:CreateToggle({
    Name = "ESP (Player Highlights)",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        Config.ESP = Value
        ToggleESP(Value)
    end,
})

VisualTab:CreateToggle({
    Name = "Rainbow Character",
    CurrentValue = false,
    Flag = "Rainbow",
    Callback = function(Value)
        Config.Rainbow = Value
        ToggleRainbow(Value)
    end,
})

VisualTab:CreateButton({
    Name = "Create Trail Effect",
    Callback = function()
        CreateTrail()
    end,
})

VisualTab:CreateButton({
    Name = "Create Particle Aura",
    Callback = function()
        CreateParticleAura()
    end,
})

local VisualSection2 = VisualTab:CreateSection("Camera & Lighting")

local FOVSlider = VisualTab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
    end,
})

VisualTab:CreateButton({
    Name = "Fullbright",
    Callback = function()
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
    end,
})

VisualTab:CreateButton({
    Name = "Reset Lighting",
    Callback = function()
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
    end,
})

-- ========================================
-- 🔧 MISC TAB
-- ========================================

local MiscSection = MiscTab:CreateSection("Misc Features")

MiscTab:CreateButton({
    Name = "Remove Fog",
    Callback = function()
        Lighting.FogEnd = 100000
        for _, v in pairs(Lighting:GetDescendants()) do
            if v:IsA("Atmosphere") then
                v:Destroy()
            end
        end
    end,
})

MiscTab:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        Player.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Rayfield:Notify({
            Title = "Anti-AFK",
            Content = "Anti-AFK has been enabled",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

MiscTab:CreateButton({
    Name = "Free Camera",
    Callback = function()
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        workspace.CurrentCamera.CameraSubject = workspace
    end,
})

MiscTab:CreateButton({
    Name = "Reset Camera",
    Callback = function()
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        workspace.CurrentCamera.CameraSubject = Humanoid
    end,
})

MiscTab:CreateButton({
    Name = "Copy Game Link",
    Callback = function()
        setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
        Rayfield:Notify({
            Title = "Copied",
            Content = "Game link copied to clipboard!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local MiscSection2 = MiscTab:CreateSection("Script Loaders")

MiscTab:CreateButton({
    Name = "Load Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})

MiscTab:CreateButton({
    Name = "Load Dex Explorer",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    end,
})

-- ========================================
-- 🔧 FUNCTIONS
-- ========================================

-- Fly Function
function ToggleFly(enabled)
    if enabled then
        local BV = Instance.new("BodyVelocity")
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = HumanoidRootPart
        
        local BG = Instance.new("BodyGyro")
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.P = 9e9
        BG.Parent = HumanoidRootPart
        
        Connections.Fly = RunService.Heartbeat:Connect(function()
            local Camera = workspace.CurrentCamera
            local MoveDirection = Vector3.new(0, 0, 0)
            local Speed = Config.WalkSpeed or 50
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                MoveDirection = MoveDirection + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                MoveDirection = MoveDirection - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                MoveDirection = MoveDirection - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                MoveDirection = MoveDirection + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
            end
            
            BV.Velocity = MoveDirection * Speed
            BG.CFrame = Camera.CFrame
        end)
    else
        if Connections.Fly then
            Connections.Fly:Disconnect()
        end
        for _, v in pairs(HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
end

-- Noclip Function
function ToggleNoclip(enabled)
    if enabled then
        Connections.Noclip = RunService.Stepped:Connect(function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if Connections.Noclip then
            Connections.Noclip:Disconnect()
        end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

-- Infinite Jump Function
function ToggleInfiniteJump(enabled)
    if enabled then
        Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if Connections.InfiniteJump then
            Connections.InfiniteJump:Disconnect()
        end
    end
end

-- Teleport Functions
function TPTo(position)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

function AnimatedTP(position, duration)
    duration = duration or 1
    local TweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local Goal = {CFrame = CFrame.new(position)}
    local Tween = TweenService:Create(HumanoidRootPart, TweenInfo, Goal)
    Tween:Play()
end

function TPToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        AnimatedTP(targetPlayer.Character.HumanoidRootPart.Position, Config.TPSpeed)
    end
end

function TPAllPlayersToYou()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame
        end
    end
end

-- Vehicle Spawn Functions
function SpawnCar()
    local Car = Instance.new("Model")
    Car.Name = "CustomCar"
    
    local Body = Instance.new("Part")
    Body.Name = "Body"
    Body.Size = Vector3.new(6, 2, 12)
    Body.BrickColor = BrickColor.new("Really red")
    Body.Material = Enum.Material.SmoothPlastic
    Body.Anchored = false
    Body.Parent = Car
    
    local Seat = Instance.new("VehicleSeat")
    Seat.Size = Vector3.new(4, 1, 2)
    Seat.CFrame = Body.CFrame * CFrame.new(0, 1.5, 0)
    Seat.MaxSpeed = 200
    Seat.Torque = 10000
    Seat.TurnSpeed = 50
    Seat.Parent = Car
    
    local Weld = Instance.new("WeldConstraint")
    Weld.Part0 = Body
    Weld.Part1 = Seat
    Weld.Parent = Body
    
    -- Wheels
    local wheelPositions = {
        {-3, -2, 4}, {3, -2, 4},
        {-3, -2, -4}, {3, -2, -4}
    }
    
    for i, pos in ipairs(wheelPositions) do
        local Wheel = Instance.new("Part")
        Wheel.Name = "Wheel" .. i
        Wheel.Shape = Enum.PartType.Cylinder
        Wheel.Size = Vector3.new(1, 2, 2)
        Wheel.BrickColor = BrickColor.new("Black")
        Wheel.Material = Enum.Material.Rubber
        Wheel.CFrame = Body.CFrame * CFrame.new(pos[1], pos[2], pos[3])
        Wheel.Parent = Car
        
        local WheelWeld = Instance.new("WeldConstraint")
        WheelWeld.Part0 = Body
        WheelWeld.Part1 = Wheel
        WheelWeld.Parent = Body
    end
    
    Car.Parent = workspace
    Car:MoveTo(HumanoidRootPart.Position + Vector3.new(5, 2, 0))
end

function SpawnPlane()
    local Plane = Instance.new("Model")
    Plane.Name = "CustomPlane"
    
    local Body = Instance.new("Part")
    Body.Name = "Body"
    Body.Size = Vector3.new(8, 3, 15)
    Body.BrickColor = BrickColor.new("Cyan")
    Body.Material = Enum.Material.SmoothPlastic
    Body.Anchored = false
    Body.Parent = Plane
    
    local Wing1 = Instance.new("Part")
    Wing1.Size = Vector3.new(20, 0.5, 5)
    Wing1.BrickColor = BrickColor.new("White")
    Wing1.CFrame = Body.CFrame
    Wing1.Parent = Plane
    
    local WingWeld = Instance.new("WeldConstraint")
    WingWeld.Part0 = Body
    WingWeld.Part1 = Wing1
    WingWeld.Parent = Body
    
    local Seat = Instance.new("VehicleSeat")
    Seat.Size = Vector3.new(3, 1, 2)
    Seat.CFrame = Body.CFrame * CFrame.new(0, 2, 2)
    Seat.MaxSpeed = 300
    Seat.Torque = 20000
    Seat.Parent = Plane
    
    local SeatWeld = Instance.new("WeldConstraint")
    SeatWeld.Part0 = Body
    SeatWeld.Part1 = Seat
    SeatWeld.Parent = Body
    
    Plane.Parent = workspace
    Plane:MoveTo(HumanoidRootPart.Position + Vector3.new(10, 5, 0))
end

function SpawnHelicopter()
    local Heli = Instance.new("Model")
    Heli.Name = "CustomHelicopter"
    
    local Body = Instance.new("Part")
    Body.Name = "Body"
    Body.Size = Vector3.new(6, 3, 8)
    Body.BrickColor = BrickColor.new("Dark green")
    Body.Material = Enum.Material.SmoothPlastic
    Body.Anchored = false
    Body.Parent = Heli
    
    local Rotor = Instance.new("Part")
    Rotor.Size = Vector3.new(12, 0.3, 1)
    Rotor.BrickColor = BrickColor.new("Black")
    Rotor.CFrame = Body.CFrame * CFrame.new(0, 3, 0)
    Rotor.Parent = Heli
    
    local RotorWeld = Instance.new("WeldConstraint")
    RotorWeld.Part0 = Body
    RotorWeld.Part1 = Rotor
    RotorWeld.Parent = Body
    
    local Seat = Instance.new("VehicleSeat")
    Seat.Size = Vector3.new(2, 1, 2)
    Seat.CFrame = Body.CFrame
    Seat.Parent = Heli
    
    local SeatWeld = Instance.new("WeldConstraint")
    SeatWeld.Part0 = Body
    SeatWeld.Part1 = Seat
    SeatWeld.Parent = Body
    
    Heli.Parent = workspace
    Heli:MoveTo(HumanoidRootPart.Position + Vector3.new(8, 5, 0))
end

function SpawnBike()
    local Bike = Instance.new("Model")
    Bike.Name = "CustomBike"
    
    local Body = Instance.new("Part")
    Body.Name = "Body"
    Body.Size = Vector3.new(2, 3, 5)
    Body.BrickColor = BrickColor.new("Bright blue")
    Body.Material = Enum.Material.SmoothPlastic
    Body.Anchored = false
    Body.Parent = Bike
    
    local Seat = Instance.new("VehicleSeat")
    Seat.Size = Vector3.new(1.5, 0.5, 1.5)
    Seat.CFrame = Body.CFrame * CFrame.new(0, 1, 0)
    Seat.MaxSpeed = 150
    Seat.Torque = 8000
    Seat.Parent = Bike
    
    local SeatWeld = Instance.new("WeldConstraint")
    SeatWeld.Part0 = Body
    SeatWeld.Part1 = Seat
    SeatWeld.Parent = Body
    
    -- Wheels
    for i, pos in ipairs({{0, -1.5, 2}, {0, -1.5, -2}}) do
        local Wheel = Instance.new("Part")
        Wheel.Shape = Enum.PartType.Cylinder
        Wheel.Size = Vector3.new(0.5, 1.5, 1.5)
        Wheel.BrickColor = BrickColor.new("Black")
        Wheel.CFrame = Body.CFrame * CFrame.new(pos[1], pos[2], pos[3])
        Wheel.Parent = Bike
        
        local WheelWeld = Instance.new("WeldConstraint")
        WheelWeld.Part0 = Body
        WheelWeld.Part1 = Wheel
        WheelWeld.Parent = Body
    end
    
    Bike.Parent = workspace
    Bike:MoveTo(HumanoidRootPart.Position + Vector3.new(3, 2, 0))
end

-- Animation Function
function PlayAnimation(animationId)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = "rbxassetid://" .. animationId
    
    local Animator = Humanoid:FindFirstChildOfClass("Animator")
    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end
    
    local AnimTrack = Animator:LoadAnimation(Animation)
    AnimTrack:Play()
    
    return AnimTrack
end

-- Combat Functions
function ToggleGodMode(enabled)
    if enabled then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
    else
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
    end
end

function ToggleInvisibility(enabled)
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if enabled then
                part.Transparency = 1
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            else
                part.Transparency = 0
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        if part:IsA("Accessory") and part:FindFirstChild("Handle") then
            part.Handle.Transparency = enabled and 1 or 0
        end
    end
    if Character:FindFirstChild("Head") and Character.Head:FindFirstChild("face") then
        Character.Head.face.Transparency = enabled and 1 or 0
    end
end

function ToggleForcefield(enabled)
    if enabled then
        local FF = Instance.new("ForceField")
        FF.Parent = Character
    else
        for _, v in pairs(Character:GetChildren()) do
            if v:IsA("ForceField") then
                v:Destroy()
            end
        end
    end
end

function SuperPunch()
    local Tool = Instance.new("Tool")
    Tool.Name = "SuperPunch"
    Tool.RequiresHandle = false
    
    Tool.Activated:Connect(function()
        local Mouse = Player:GetMouse()
        local Target = Mouse.Target
        
        if Target and Target.Parent:FindFirstChild("Humanoid") then
            Target.Parent.Humanoid.Health = 0
        end
    end)
    
    Tool.Parent = Player.Backpack
end

function KillAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end

function FlingPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Power = 5000
        targetPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(Power, Power, Power)
    end
end

-- Visual Functions
function ToggleESP(enabled)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            if enabled then
                if not player.Character:FindFirstChildOfClass("Highlight") then
                    local Highlight = Instance.new("Highlight")
                    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    Highlight.FillTransparency = 0.5
                    Highlight.Parent = player.Character
                end
            else
                local Highlight = player.Character:FindFirstChildOfClass("Highlight")
                if Highlight then
                    Highlight:Destroy()
                end
            end
        end
    end
end

function ToggleRainbow(enabled)
    if enabled then
        Connections.Rainbow = RunService.Heartbeat:Connect(function()
            local hue = tick() % 5 / 5
            local color = Color3.fromHSV(hue, 1, 1)
            
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = color
                end
            end
        end)
    else
        if Connections.Rainbow then
            Connections.Rainbow:Disconnect()
        end
    end
end

function CreateTrail()
    if HumanoidRootPart:FindFirstChild("Trail") then return end
    
    local Attachment0 = Instance.new("Attachment", HumanoidRootPart)
    local Attachment1 = Instance.new("Attachment", HumanoidRootPart)
    Attachment1.Position = Vector3.new(0, -2, 0)
    
    local Trail = Instance.new("Trail")
    Trail.Attachment0 = Attachment0
    Trail.Attachment1 = Attachment1
    Trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 255))
    Trail.Lifetime = 1
    Trail.Transparency = NumberSequence.new(0, 1)
    Trail.Parent = HumanoidRootPart
end

function CreateParticleAura()
    if HumanoidRootPart:FindFirstChild("ParticleEmitter") then return end
    
    local Particle = Instance.new("ParticleEmitter")
    Particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    Particle.Rate = 50
    Particle.Lifetime = NumberRange.new(1, 2)
    Particle.Speed = NumberRange.new(2, 5)
    Particle.SpreadAngle = Vector2.new(360, 360)
    Particle.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    Particle.Parent = HumanoidRootPart
end

-- Auto-Update on Respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Reapply settings
    if Config.WalkSpeed ~= 16 then
        Humanoid.WalkSpeed = Config.WalkSpeed
    end
    if Config.JumpPower ~= 50 then
        Humanoid.JumpPower = Config.JumpPower
    end
    if Config.Flying then
        ToggleFly(true)
    end
    if Config.Noclip then
        ToggleNoclip(true)
    end
    if Config.InfiniteJump then
        ToggleInfiniteJump(true)
    end
end)

-- Notification
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "Ultimate Script with Rayfield UI is ready!",
    Duration = 5,
    Image = 4483362458,
})

print("🚀 Ultimate Script with Rayfield UI loaded successfully!")
