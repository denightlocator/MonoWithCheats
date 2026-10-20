local WindUI = getgenv().WindUI
if not WindUI then return warn("[Mono] WindUI not loaded!") end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- State Variables
local S100 = {
    FlySpeed = 80,
    FlyEnabled = false,
    SpeedEnabled = false,
    WalkSpeed = 50,
    InfJumpEnabled = false,
    NoclipEnabled = false,
    FullbrightEnabled = false,
    NoFogEnabled = false,
    ESPEnabled = false,
    KillAuraEnabled = false,
    KillAuraRange = 150,
}

local FlyBV, FlyBG = nil, nil
local espFolder = Instance.new("Folder", game:GetService("CoreGui"))
espFolder.Name = "MonoESP"
local highlights = {}
local swingRemote = nil

-- Try to automatically find the swing remote for Kill Aura
for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
    if obj:IsA("RemoteEvent") and obj.Name:lower():find("swing") then
        swingRemote = obj
        break
    end
end

-- Fly Logic
local function updateFly()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if S100.FlyEnabled then
        hum.PlatformStand = true
        if not FlyBV then
            FlyBV = Instance.new("BodyVelocity")
            FlyBV.Name = "CheatFlyBV"
            FlyBV.MaxForce = Vector3.one * 9e9
            FlyBV.Velocity = Vector3.zero
            FlyBV.Parent = hrp
        end
        if not FlyBG then
            FlyBG = Instance.new("BodyGyro")
            FlyBG.Name = "CheatFlyBG"
            FlyBG.MaxTorque = Vector3.one * 9e9
            FlyBG.P = 9e4
            FlyBG.D = 500
            FlyBG.CFrame = hrp.CFrame
            FlyBG.Parent = hrp
        end
    else
        hum.PlatformStand = false
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
    end
end

-- Noclip Logic
local function applyNoclip()
    local char = LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Kill Aura Logic
local function getNearestTarget()
    local best, dist = nil, S100.KillAuraRange
    local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    for _, model in ipairs(Workspace:GetChildren()) do
        if model:IsA("Model") and model ~= LP.Character then
            local hum = model:FindFirstChildOfClass("Humanoid")
            local root = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso")
            if hum and root and hum.Health > 0 then
                local d = (root.Position - myRoot.Position).Magnitude
                if d < dist then
                    best, dist = model, d
                end
            end
        end
    end
    return best
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Fly
    if S100.FlyEnabled and FlyBV and FlyBG and hrp then
        local cam = workspace.CurrentCamera
        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end
        
        FlyBV.Velocity = move * S100.FlySpeed
        FlyBG.CFrame = cam.CFrame
    end

    -- Speed
    if S100.SpeedEnabled then
        hum.WalkSpeed = S100.WalkSpeed
    else
        hum.WalkSpeed = 16
    end

    -- Noclip
    if S100.NoclipEnabled then
        applyNoclip()
    end

    -- Kill Aura
    if S100.KillAuraEnabled and swingRemote then
        local target = getNearestTarget()
        if target and hrp then
            local targetRoot = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso")
            if targetRoot then
                local dir = (targetRoot.Position - hrp.Position).Unit
                pcall(function()
                    swingRemote:FireServer(Vector3.new(dir.X, 0, dir.Z), nil)
                end)
            end
        end
    end
end)

-- Visuals Loop
task.spawn(function()
    while task.wait(0.1) do
        -- Fullbright / Fog
        if S100.FullbrightEnabled then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = Color3.fromRGB(70, 70, 70)
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end

        if S100.NoFogEnabled then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            if workspace.CurrentCamera:FindFirstChildOfClass("Atmosphere") then
                workspace.CurrentCamera.Atmosphere.Density = 0
            end
        else
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
            if workspace.CurrentCamera:FindFirstChildOfClass("Atmosphere") then
                workspace.CurrentCamera.Atmosphere.Density = 0.3
            end
        end

        -- Player ESP
        for p, hl in pairs(highlights) do
            if not p.Parent or not p.Character or not S100.ESPEnabled then
                hl:Destroy()
                highlights[p] = nil
            end
        end

        if S100.ESPEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    if not highlights[p] or not highlights[p].Parent then
                        local hl = Instance.new("Highlight")
                        hl.Name = "CheatHL"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.5
                        hl.OutlineTransparency = 0
                        hl.Adornee = p.Character
                        hl.Parent = espFolder
                        highlights[p] = hl
                    else
                        highlights[p].Adornee = p.Character
                    end
                end
            end
        end
    end
end)

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if S100.InfJumpEnabled then
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(1)
    updateFly()
end)

-- Build the UI
local Window = WindUI:CreateWindow({
    Title = "Mono", Icon = "circle",
    Size = UDim2.fromOffset(680, 580),
    ToggleKey = Enum.KeyCode.Z,
})

local GamesTab = Window:Tab({ Title = "Games", Icon = "gamepad-2", IconColor = Color3.fromRGB(255, 255, 255) })
local GameTab = GamesTab:Tab({ Title = "Survive 100 Days", Icon = "shield", IconColor = Color3.fromRGB(255, 255, 255) })

GameTab:Section({ Title = "Movement" })

GameTab:Toggle({
    Title = "Fly", Desc = "WASD to fly, Space/Ctrl to go up/down.", Icon = "wind",
    Callback = function(state)
        S100.FlyEnabled = state
        updateFly()
    end
})

GameTab:Slider({
    Title = "Fly Speed", Value = { Min = 10, Max = 300, Default = S100.FlySpeed }, Step = 5,
    Callback = function(val) S100.FlySpeed = val end
})

GameTab:Toggle({
    Title = "Speed Hack", Desc = "Increases walkspeed.", Icon = "gauge",
    Callback = function(state) S100.SpeedEnabled = state end
})

GameTab:Slider({
    Title = "Walk Speed", Value = { Min = 16, Max = 200, Default = S100.WalkSpeed }, Step = 1,
    Callback = function(val) S100.WalkSpeed = val end
})

GameTab:Toggle({
    Title = "Infinite Jump", Desc = "Press space in mid-air to jump again.", Icon = "move-vertical",
    Callback = function(state) S100.InfJumpEnabled = state end
})

GameTab:Toggle({
    Title = "Noclip", Desc = "Walk through walls.", Icon = "shield-check",
    Callback = function(state) S100.NoclipEnabled = state end
})

GameTab:Section({ Title = "Combat" })

GameTab:Toggle({
    Title = "Kill Aura", Desc = "Automatically swings at NPCs in range.", Icon = "crosshair",
    Callback = function(state) S100.KillAuraEnabled = state end
})

GameTab:Slider({
    Title = "Aura Range", Value = { Min = 10, Max = 500, Default = S100.KillAuraRange }, Step = 5,
    Callback = function(val) S100.KillAuraRange = val end
})

GameTab:Section({ Title = "Visuals" })

GameTab:Toggle({
    Title = "Fullbright", Desc = "Removes shadows and lights up the map.", Icon = "eye",
    Callback = function(state) S100.FullbrightEnabled = state end
})

GameTab:Toggle({
    Title = "No Fog", Desc = "Removes distance fog.", Icon = "wind",
    Callback = function(state) S100.NoFogEnabled = state end
})

GameTab:Toggle({
    Title = "Player ESP", Desc = "Highlights all other players through walls.", Icon = "users",
    Callback = function(state) S100.ESPEnabled = state end
})

-- Visual toggle button
local openBtn = Instance.new("TextButton")
openBtn.Parent = game:GetService("CoreGui")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openBtn.BackgroundTransparency = 0.3
openBtn.Text = "MENU"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.BorderSizePixel = 0
openBtn.Active = true
openBtn.Draggable = true

local corner = Instance.new("UICorner", openBtn)
corner.CornerRadius = UDim.new(1, 0)

openBtn.MouseButton1Click:Connect(function()
    if Window.Visible then
        WindUI.hide()
    else
        WindUI.show()
    end
end)

WindUI:Notify({ Title = "Mono", Content = "Survive 100 Days loaded.", Duration = 4, Icon = "check" })
