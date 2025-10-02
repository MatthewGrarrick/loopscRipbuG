local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- 🟢 Whitelist UserIds (giả lập HWID)
local whitelist = {
    3779522767,
    2058617750,
    2058763991,
    6129034026,
	8915705692,
}

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

local weaponName = nil
local farming = false
local killCount = 0

local blacklist = {
    ["Lv186 Cave Demon"] = true,
    ["Lv188 Cave Demon"] = true,
    ["Lv198 Cave Demon"] = true,
    ["Lv200 Vokun"] = true,
    ["Lv219 Cave Demon"] = true,
}

-- 🛡 Setup khi respawn
local function setupCharacter(c)
    char = c
    humanoid = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")

    -- God Mode
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

-- UI 📌
local gui = Instance.new("ScreenGui", game.CoreGui)

-- Main frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,160)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- Shadow effect
local shadow = Instance.new("ImageLabel", frame)
shadow.Size = UDim2.new(1,20,1,20)
shadow.Position = UDim2.new(-0.05,0,-0.05,0)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0,0,0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = -1

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,25)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundTransparency = 1
title.Text = "⚡ Auto Farm NPC"
title.TextColor3 = Color3.fromRGB(0,255,200)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Nút bật farm
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9,0,0.2,0)
button.Position = UDim2.new(0.05,0,0.2,0)
button.Text = "Farm: OFF"
button.BackgroundColor3 = Color3.fromRGB(180,50,50)
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBold
button.TextSize = 16
Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)

-- Kill counter
local killLabel = Instance.new("TextLabel", frame)
killLabel.Size = UDim2.new(0.9,0,0.15,0)
killLabel.Position = UDim2.new(0.05,0,0.45,0)
killLabel.BackgroundTransparency = 1
killLabel.Text = "Kills: 0"
killLabel.TextColor3 = Color3.fromRGB(255,255,0)
killLabel.Font = Enum.Font.GothamBold
killLabel.TextSize = 16

-- Weapon label
local weaponLabel = Instance.new("TextLabel", frame)
weaponLabel.Size = UDim2.new(0.9,0,0.15,0)
weaponLabel.Position = UDim2.new(0.05,0,0.62,0)
weaponLabel.BackgroundTransparency = 1
weaponLabel.Text = "Weapon: None"
weaponLabel.TextColor3 = Color3.fromRGB(0,200,255)
weaponLabel.Font = Enum.Font.GothamBold
weaponLabel.TextSize = 16

-- Dropdown button
local dropdownBtn = Instance.new("TextButton", frame)
dropdownBtn.Size = UDim2.new(0.9,0,0.15,0)
dropdownBtn.Position = UDim2.new(0.05,0,0.8,0)
dropdownBtn.Text = "🔽 Select Weapon"
dropdownBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdownBtn.TextColor3 = Color3.new(1,1,1)
dropdownBtn.Font = Enum.Font.Gotham
dropdownBtn.TextSize = 16
Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0,8)

local dropdownFrame = Instance.new("ScrollingFrame", frame)
dropdownFrame.Size = UDim2.new(0.9,0,2,0)
dropdownFrame.Position = UDim2.new(0.05,0,1,0)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Visible = false
dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0,8)

-- Toggle farm
button.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        button.Text = "Farm: ON"
        button.BackgroundColor3 = Color3.fromRGB(50,180,80)
    else
        button.Text = "Farm: OFF"
        button.BackgroundColor3 = Color3.fromRGB(180,50,50)
    end
end)

-- Toggle dropdown
dropdownBtn.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
    if dropdownFrame.Visible then
        for _, child in pairs(dropdownFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local y = 0
        for _, tool in pairs(player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local item = Instance.new("TextButton", dropdownFrame)
                item.Size = UDim2.new(1,0,0,25)
                item.Position = UDim2.new(0,0,0,y)
                item.BackgroundColor3 = Color3.fromRGB(70,70,70)
                item.TextColor3 = Color3.new(1,1,1)
                item.Font = Enum.Font.Gotham
                item.TextSize = 14
                item.Text = tool.Name
                Instance.new("UICorner", item).CornerRadius = UDim.new(0,6)

                item.MouseButton1Click:Connect(function()
                    weaponName = tool.Name
                    weaponLabel.Text = "Weapon: "..weaponName
                    dropdownFrame.Visible = false
                end)
                y = y + 25
            end
        end
        dropdownFrame.CanvasSize = UDim2.new(0,0,0,y)
    end
end)

-- Equip vũ khí
local function equipWeapon(name)
    local tool = player.Backpack:FindFirstChild(name)
    if tool then
        humanoid:EquipTool(tool)
        return tool
    end
    return nil
end

-- Tìm NPC hợp lệ
local function getValidNPCs()
    local npcs = {}
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

-- ✅ Auto farm loop (đã fix: giết hết quái rồi lặp lại)
task.spawn(function()
    while task.wait(0.5) do
        if farming and humanoid and hrp and weaponName then
            local tool = equipWeapon(weaponName)
            if tool then
                local npcs = getValidNPCs()

                -- Nếu chưa có NPC thì chờ NPC respawn
                if #npcs == 0 then
                    continue
                end

                -- Lặp qua tất cả NPC
                for _, npc in pairs(npcs) do
                    if farming and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                        -- Teleport đến NPC
                        hrp.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0,0,3)

                        -- Đánh liên tục cho đến khi NPC chết
                        while farming 
                        and npc 
                        and npc:FindFirstChild("Humanoid") 
                        and npc.Humanoid.Health > 0 
                        and humanoid 
                        and humanoid.Parent do
                            tool:Activate()
                            task.wait(0.2)
                        end

                        -- Khi NPC chết thì cộng kill
                        if npc and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health <= 0 then
                            killCount += 1
                            killLabel.Text = "Kills: "..killCount
                        end
                    end
                end
            else
                warn("⚠ Không tìm thấy vũ khí: "..weaponName)
            end
        end
    end
end)

-- Setup lần đầu
setupCharacter(char)

-- 🔥 Auto bật Haki bằng phím Q
task.spawn(function()
    while task.wait(5) do -- mỗi 5 giây bật lại 1 lần
        if farming and humanoid and humanoid.Parent then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Q, false, game)
            task.wait(0.1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Q, false, game)
        end
    end
end)
