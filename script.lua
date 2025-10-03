--// Roblox Low-End Optimizer (Client-Side)
--// Untuk Plants Vs Brainrots (atau game mirip tower defense / wave NPC)
--// Jalankan via executor

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local lp = Players.LocalPlayer

-- Fungsi aman untuk destroy / disable
local function safeDestroy(obj)
    if obj and obj.Destroy then
        pcall(function() obj:Destroy() end)
    end
end

-- 1. Kurangi efek lighting
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
end)

-- 2. Hapus efek yang berat (ParticleEmitter, Trail, Beam)
for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
        safeDestroy(v)
    end
end

-- 3. Hilangkan benda "dekorasi" yang bukan core gameplay
for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("MeshPart") or v:IsA("UnionOperation") or v:IsA("Part") then
        if v.Transparency == 0 and v.CanCollide == false then
            v.Transparency = 1
        end
        if v.Material ~= Enum.Material.SmoothPlastic then
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- 4. Matikan GUI yang tidak penting
for _,gui in pairs(lp.PlayerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then
        if gui.Name:lower():find("shop") or gui.Name:lower():find("event") then
            gui.Enabled = false
        end
    end
end

-- 5. Loop untuk auto-clean setiap beberapa detik
RunService.Stepped:Connect(function()
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            safeDestroy(v)
        end
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "Optimizer Active",
    Text = "Efek & object berat sudah diminimalisir",
    Duration = 5
})
