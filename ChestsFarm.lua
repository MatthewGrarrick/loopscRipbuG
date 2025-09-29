-- ⚡ Auto Chest + Random Hop + Stylish GUI + Configurable Recent Server Timer + Chest Count + HWID Lock ⚡
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 🟢 Access Codes
local accessCodes = {
    "vlRPlUJMfn0cWZ6i7U8eAn5kNSw0Q0JntvQNYGyyFYLU4IxxJH0AAA2",
    "allT3KVE92KpYi1VEMDJNqRIJG2wdEAlvFoZT1lXrUvU4IxxJH0AAA2",
}

local placeid = game.PlaceId
local recentServers = {}
local recentServerTimer = 90
local remainingChests = 0

-- 🟢 GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 200, 255)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "⚡ Auto Chest System ⚡"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "⏳ Initializing..."
statusLabel.Parent = frame
Instance.new("UICorner", statusLabel).CornerRadius = UDim.new(0, 8)

-- Toggle Chest Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -60, 1, -50)
toggleBtn.Text = "Chest: ON"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextScaled = true
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local chestEnabled = true
toggleBtn.MouseButton1Click:Connect(function()
    chestEnabled = not chestEnabled
    if chestEnabled then
        toggleBtn.Text = "Chest: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        statusLabel.Text = "▶ Auto Chest running"
        statusLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    else
        toggleBtn.Text = "Chest: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        statusLabel.Text = "⏸ Auto Chest paused"
        statusLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

-- TextBox RecentServer Timer
local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(0, 180, 0, 25)
timerLabel.Position = UDim2.new(0, 10, 0, 90)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.Text = "RecentServer Timeout (s):"
timerLabel.Font = Enum.Font.Gotham
timerLabel.TextScaled = true
timerLabel.Parent = frame

local timerBox = Instance.new("TextBox")
timerBox.Size = UDim2.new(0, 60, 0, 25)
timerBox.Position = UDim2.new(0, 190, 0, 90)
timerBox.Text = tostring(recentServerTimer)
timerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
timerBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
timerBox.Font = Enum.Font.Gotham
timerBox.TextScaled = true
timerBox.ClearTextOnFocus = false
timerBox.Parent = frame
Instance.new("UICorner", timerBox).CornerRadius = UDim.new(0, 6)

timerBox.FocusLost:Connect(function(enterPressed)
    local value = tonumber(timerBox.Text)
    if value and value > 0 then
        recentServerTimer = value
        statusLabel.Text = "⏱ RecentServer timeout set to " .. value .. "s"
        statusLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    else
        timerBox.Text = tostring(recentServerTimer)
        statusLabel.Text = "⚠️ Invalid value"
        statusLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- 🟢 Update status
local function updateStatus(text, color)
    statusLabel.Text = text
    statusLabel.BackgroundColor3 = color
end

-- 🟢 Get all chests
local function getAllChests()
    local chestList = {}
    local chestsFolder = workspace:FindFirstChild("Chests")
    if chestsFolder then
        for _, chest in pairs(chestsFolder:GetChildren()) do
            if chest:IsA("Model") then
                local part = chest:FindFirstChild("TreasureChestPart") or chest:FindFirstChild("HumanoidRootPart")
                if part then
                    table.insert(chestList, chest)
                end
            end
        end
    end
    return chestList
end

-- 🟢 Farm chest
local function farmChest(chest)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local part = chest:FindFirstChild("TreasureChestPart") or chest:FindFirstChild("HumanoidRootPart")
    if hrp and part then
        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
        wait(0.2)
        remainingChests = remainingChests - 1
        updateStatus("🟢 Farming chests... (" .. remainingChests .. ")", Color3.fromRGB(0, 170, 0))
        print("✅ Collected chest:", chest.Name)
    end
end

-- 🟢 Hop server ngẫu nhiên
local function hopServer()
    if #accessCodes == 0 then return end
    local attempt = 0
    local accesscode
    repeat
        attempt = attempt + 1
        accesscode = accessCodes[math.random(1, #accessCodes)]
    until not recentServers[accesscode] or attempt > 10

    recentServers[accesscode] = true
    task.delay(recentServerTimer, function()
        recentServers[accesscode] = nil
    end)

    updateStatus("🟡 No chests left → hopping...", Color3.fromRGB(200, 170, 0))
    wait(2)
    warn("👉 Hopping to server:", accesscode)
    game.RobloxReplicatedStorage.ContactListIrisInviteTeleport:FireServer(placeid, "", accesscode)
end

-- 🟢 Right Alt toggle GUI
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        frame.Visible = not frame.Visible
    end
end)

-- 🟢 Main loop
task.spawn(function()
    wait(5)
    while true do
        if chestEnabled then
            local chests = getAllChests()
            remainingChests = #chests
            if #chests > 0 then
                updateStatus("🟢 Farming chests... (" .. #chests .. ")", Color3.fromRGB(0, 170, 0))
                for _, chest in ipairs(chests) do
                    if not chestEnabled then break end
                    farmChest(chest)
                    wait(0.5)
                end
            else
                hopServer()
                updateStatus("🔵 Joined new server", Color3.fromRGB(0, 85, 255))
                wait(8)
            end
        end
        wait(1)
    end
end)
