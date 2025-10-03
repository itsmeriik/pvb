--// Roblox Optimizer with Toggle UI
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

--// UI
local ScreenGui = Instance.new("ScreenGui", lp.PlayerGui)
local Frame = Instance.new("Frame", ScreenGui)
local ToggleBtn = Instance.new("TextButton", Frame)

ScreenGui.ResetOnSpawn = false

Frame.Size = UDim2.new(0,200,0,100)
Frame.Position = UDim2.new(0.5,-100,0.1,0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

ToggleBtn.Size = UDim2.new(1, -20, 0, 50)
ToggleBtn.Position = UDim2.new(0,10,0.5,-25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Text = "Optimization: OFF"

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
