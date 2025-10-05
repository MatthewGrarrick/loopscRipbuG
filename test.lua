-- main_autofarm.lua
-- Auto Farm NPC + Kill Counter + GodMode + Respawn Fix + UI đẹp
-- Tích hợp persistent config/whitelist (nạp từ file nếu có) và lắng nghe shared.ConfigUpdated

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- File storage (same filename as controller)
local configFile = "autofarm_config.json"
local canFile = (type(readfile) == "function" and type(isfile) == "function" and type(writefile) == "function")

-- Defaults (fallback)
local defaultWhitelist = {
    3779522767,
    2058617750,
    2058763991,
    8915652979,
    8915705692,
    6129034026,
    8915696182,
}
local defaultConfig = {
    AutoFarm = false,
    FarmDelay = 0.2,
    TargetRange = 100,
    Weapon = nil
}

-- Ensure shared tables exist and load file if available
shared.Config = shared.Config or defaultConfig
shared.Whitelist = shared.Whitelist or defaultWhitelist
if not shared.ConfigUpdated or typeof(shared.ConfigUpdated) ~= "Instance" then
    shared.ConfigUpdated = Instance.new("BindableEvent")
end

-- Load from file (if exists)
local function loadFromFile()
    if not canFile then return end
    if isfile(configFile) then
        local ok, raw = pcall(function() return readfile(configFile) end)
        if ok and raw then
            local suc, tbl = pcall(function() return HttpService:JSONDecode(raw) end)
            if suc and type(tbl) == "table" then
                shared.Config = tbl.Config or shared.Config
                shared.Whitelist = tbl.Whitelist or shared.Whitelist
            end
        end
    end
end

-- Save to file (main can optionally write when it updates)
local function saveToFile()
    if not canFile then return false end
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode({ Config = shared.Config, Whitelist = shared.Whitelist })
    end)
    if ok then
        pcall(function() writefile(configFile, encoded) end)
        return true
    end
    return false
end

-- initial load
loadFromFile()

-- Local mirrors (script logic uses these)
local whitelist = shared.Whitelist
local cfg = shared.Config

-- Update local mirrors when controller fires event (or someone changes shared directly)
shared.ConfigUpdated.Event:Connect(function()
    whitelist = shared.Whitelist
    cfg = shared.Config
    -- persist the change (optional; controller already saves but main double-checks)
    pcall(saveToFile)
end)

-- If shared mutated directly elsewhere, poll occasionally to sync (defensive)
task.spawn(function()
    while task.wait(1) do
        if shared.StopAllScripts then
            -- cleanup and exit
            if gui and gui.Parent then pcall(function() gui:Destroy() end) end
            shared.AutoFarm = false
            shared.StopAllScripts = false
            return
        end
        -- sync config mirror
        if shared.Config ~= cfg then
            cfg = shared.Config
        end
        if shared.Whitelist ~= whitelist then
            whitelist = shared.Whitelist
        end
    end
end)

-- === WHITELIST CHECK ===
local allowed = false
for _, id in ipairs(whitelist) do
    if player.UserId == id then
        allowed = true
        break
    end
end
if not allowed then
    player:Kick("❌ Bạn không có quyền dùng script này!")
    return
end

-- === REST OF ORIGINAL SCRIPT (slightly adapted to use cfg values) ===
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local weaponName = cfg.Weapon
local farming = cfg.AutoFarm
local killCount = 0

local blacklist = {
    ["Lv186 Cave Demon"] = true,
    ["Lv188 Cave Demon"] = true,
    ["Lv198 Cave Demon"] = true,
    ["Lv200 Vokun"] = true,
    ["Lv219 Cave Demon"] = true,
    ["Lv40 Cave Demon"] = true,
}

local function setupCharacter(c)
    char = c
    humanoid = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")

    task.spawn(function()
        while humanoid and humanoid.Parent do
            task.wait(0.1)
            pcall(function()
                humanoid.Health = humanoid.MaxHealth
            end)
        end
    end)
end
player.CharacterAdded:Connect(setupCharacter)

-- UI (main) — minimal, keep if needed
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoFarmMainGUI"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,160)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "⚡ Auto Farm NPC"
title.TextColor3 = Color3.fromRGB(0,255,200)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9,0,0.2,0)
button.Position = UDim2.new(0.05,0,0.2,0)
button.Text = "Farm: "..(farming and "ON" or "OFF")
button.BackgroundColor3 = farming and Color3.fromRGB(50,180,80) or Color3.fromRGB(180,50,50)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)
button.MouseButton1Click:Connect(function()
    farming = not farming
    cfg.AutoFarm = farming
    shared.AutoFarm = farming
    saveToFile()
    pcall(function() shared.ConfigUpdated:Fire() end)
    button.Text = "Farm: "..(farming and "ON" or "OFF")
    button.BackgroundColor3 = farming and Color3.fromRGB(50,180,80) or Color3.fromRGB(180,50,50)
end)

local killLabel = Instance.new("TextLabel", frame)
killLabel.Size = UDim2.new(0.9,0,0.15,0)
killLabel.Position = UDim2.new(0.05,0,0.45,0)
killLabel.BackgroundTransparency = 1
killLabel.Text = "Kills: 0"
killLabel.TextColor3 = Color3.fromRGB(255,255,0)
killLabel.Font = Enum.Font.GothamBold
killLabel.TextSize = 16

local weaponLabel = Instance.new("TextLabel", frame)
weaponLabel.Size = UDim2.new(0.9,0,0.15,0)
weaponLabel.Position = UDim2.new(0.05,0,0.62,0)
weaponLabel.BackgroundTransparency = 1
weaponLabel.Text = "Weapon: "..tostring(cfg.Weapon or "None")
weaponLabel.TextColor3 = Color3.fromRGB(0,200,255)
weaponLabel.Font = Enum.Font.GothamBold
weaponLabel.TextSize = 16

-- Helper functions
local function equipWeapon(name)
    local tool = player.Backpack:FindFirstChild(name)
    if tool then
        humanoid:EquipTool(tool)
        return tool
    end
    return nil
end

local function getValidNPCs()
    local npcs = {}
    if not workspace:FindFirstChild("Enemies") then return npcs end
    for _, npc in pairs(workspace.Enemies:GetChildren()) do
        if npc:FindFirstChild("Humanoid") 
        and npc.Humanoid.Health > 0 
        and npc:FindFirstChild("HumanoidRootPart") 
        and not blacklist[npc.Name] then
            table.insert(npcs, npc)
        end
    end
    return npcs
end

-- Auto farm loop: uses cfg.FarmDelay and cfg.TargetRange and cfg.Weapon
task.spawn(function()
    while task.wait(cfg.FarmDelay or 0.2) do
        if shared.StopAllScripts then
            if gui and gui.Parent then pcall(function() gui:Destroy() end) end
            shared.AutoFarm = false
            shared.StopAllScripts = false
            return
        end

        -- sync from shared if controller changed
        if shared.Config then
            cfg = shared.Config
            weaponName = cfg.Weapon
            farming = cfg.AutoFarm
            -- update GUI labels
            pcall(function()
                button.Text = "Farm: "..(farming and "ON" or "OFF")
                button.BackgroundColor3 = farming and Color3.fromRGB(50,180,80) or Color3.fromRGB(180,50,50)
                weaponLabel.Text = "Weapon: "..tostring(cfg.Weapon or "None")
            end)
        end

        if farming and humanoid and hrp and weaponName then
            local tool = player.Character:FindFirstChild(weaponName) or player.Backpack:FindFirstChild(weaponName)
            if tool and tool.Parent == player.Backpack then
                humanoid:EquipTool(tool)
            end

            if not tool then
                warn("⚠ Không tìm thấy vũ khí: "..tostring(weaponName))
                task.wait(1)
                continue
            end

            local npc = nil
            while farming and not npc do
                local npcs = getValidNPCs()
                local nearest, dist = nil, math.huge
                for _, v in pairs(npcs) do
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local success, d = pcall(function() return (v.HumanoidRootPart.Position - hrp.Position).Magnitude end)
                        if success and d and d < dist and d <= (cfg.TargetRange or 100) then
                            dist = d
                            nearest = v
                        end
                    end
                end
                npc = nearest
                if not npc then task.wait(1) end
            end

            while farming and npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 and humanoid and humanoid.Parent do
                if shared.StopAllScripts then
                    if gui and gui.Parent then pcall(function() gui:Destroy() end) end
                    shared.AutoFarm = false
                    shared.StopAllScripts = false
                    return
                end
                pcall(function()
                    if npc and npc:FindFirstChild("HumanoidRootPart") and hrp then
                        hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                    end
                    if tool and tool.Parent then
                        tool:Activate()
                    end
                end)
                task.wait(0.2)
            end

            if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health <= 0 then
                killCount = killCount + 1
                killLabel.Text = "Kills: "..killCount
            end
        end
    end
end)

-- Auto Haki
task.spawn(function()
    while task.wait(5) do
        if shared.StopAllScripts then
            if gui and gui.Parent then pcall(function() gui:Destroy() end) end
            shared.AutoFarm = false
            shared.StopAllScripts = false
            return
        end
        if shared.Config and shared.Config.AutoFarm and humanoid and humanoid.Parent then
            pcall(function()
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                task.wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
            end)
        end
    end
end)

-- On start, persist current shared to file (so controller or main both create file)
pcall(saveToFile)
