--// Roblox Optimizer with Toggle UI (Fixed)
-- Jalankan via executor

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- State toggle
local optimizeEnabled = false

-- Fungsi aman destroy
local function safeDestroy(obj)
    if obj and obj.Destroy then
        pcall(function() obj:Destroy() end)
    end
end

-- Fungsi optimasi
local function optimize()
    if not optimizeEnabled then return end

    -- Lighting
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    -- Efek
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            safeDestroy(v)
        elseif v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then
            if v.Material ~= Enum.Material.SmoothPlastic then
                v.Material = Enum.Material.SmoothPlastic
            end
        elseif v:IsA("Decal") or v:IsA("Texture") then
            safeDestroy(v)
        end
    end
end

-- Loop cek tiap 2 detik (biar ga spam CPU)
RunService.Heartbeat:Connect(function()
    if optimizeEnabled then
        optimize()
    end
end)

--// UI Buatan
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OptimizerUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.2,0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "🌿 Optimizer"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = Frame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1,-20,0,50)
ToggleBtn.Position = UDim2.new(0,10,0.5,-25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 16
ToggleBtn.Text = "Optimization: OFF"
ToggleBtn.Parent = Frame

ToggleBtn.MouseButton1Click:Connect(function()
    optimizeEnabled = not optimizeEnabled
    if optimizeEnabled then
        ToggleBtn.Text = "Optimization: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        optimize()
    else
        ToggleBtn.Text = "Optimization: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)
