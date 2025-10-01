-- ⚡ Auto Chest + Random Hop + Stylish GUI + Configurable Recent Server Timer + Chest Count + HWID Lock ⚡
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- 🟢 Whitelist UserIds (giả lập HWID)
local whitelist = {
    3779522767, -- Thay bằng UserId của bạn
    3891789316,
	2059019252,
	2058645338,
	2058763991,
	2059003331,
	2058755868,
	2058540618,
	2059323976,
	2059436645,
	2059298055,
	2058954310,
	4489612254, -- tphat
}

-- 🛑 Check HWID access
local allowed = false
for _, id in ipairs(whitelist) do
    if player.UserId == id then
        allowed = true
        break
    end
end

if not allowed then
    -- Kick the player if they do not have HWID access
    player:Kick("❌ You do not have access if you do not have the correct HWID!")
    return
end

-- 🟢 Access Codes
local accessCodes = {
    "vlRPlUJMfn0cWZ6i7U8eAn5kNSw0Q0JntvQNYGyyFYLU4IxxJH0AAA2",
    "allT3KVE92KpYi1VEMDJNqRIJG2wdEAlvFoZT1lXrUvU4IxxJH0AAA2",
    "i4BJJBJAkUC9pfeYptXE5WgUZonSA0Y2nrA_iu5UI67U4IxxJH0AAA2",
    "hrGTiE_BMnUl77NkzEb6fyqi2tWQzkC-oSZVmiOB9AfU4IxxJH0AAA2",
    "6QU4JwSZ-AredN4TTilwZlOC-boI3EAhsOQf2TI-kvXU4IxxJH0AAA2",
	"IwtP4oDtHBAB2X_JCsUshzE32dkgDkKMiCxIFiehE9TU4IxxJH0AAA2",
    "IbZV25Gnz6RTtshK9k6AVWHfe-8Ak03quqKliqoipgHU4IxxJH0AAA2",
    "BHEIBCWu76DXgxvCpHBQtDeYzkn-wEwNotnyDQ7z6mHU4IxxJH0AAA2",
    "wE0RgAVxZkC-Bwo39ASq52pPg9wui0LaghdBpsZYnYfU4IxxJH0AAA2",
    "DCUQd5rbrdIbeavv3a_v8VFElZRkq0v6k637lhR7_eDU4IxxJH0AAA2",
    "EE79tVYPrlumH-vLlye6nwBEfySDskwtnAQ4XEWdRJXU4IxxJH0AAA2",
    "QGyk7TFvJOgMzBTjyM7KF1L7-zw7okEThS1eUSQmLMPU4IxxJH0AAA2",
    "9aFz8mCzP6cRfWe8Xd6pw1gJfa9qoUdtkGo3sxCupqXU4IxxJH0AAA2",
    "fr4PIrFLJ898Bwti_hz5TDWO77ej80EIjzCYVcOblZnU4IxxJH0AAA2",
    "L8xCbxab7WSq7u9o9TQsEznxaEuiJ0Qft5lBgpBD3yDU4IxxJH0AAA2",
    "XAunLYz06sPsxDDzitCX9cenMayjLUaItXkUA7w1-JbU4IxxJH0AAA2",
    "ofphuQh4dLFHYrZq3eTWnDFBK4cdgUnHhBx9eCQSlEXU4IxxJH0AAA2",
    "02d2yinSXluVulWv1S1gyKF7z3nLbk8Bq_9ucYMqGtLU4IxxJH0AAA2",
    "QTXI-5NCaCnlcyINI__6svPSN_W7HkgnjpblOMJIARPU4IxxJH0AAA2",
    "VGjTSHMSJyn0LjAuGHCdsWKrRbtA1ESqsGG6cCe5eT7U4IxxJH0AAA2",
    "S7kE14uEAjTpkxz8BpYPewJPq0VRbEdgjGasDnPTk6nU4IxxJH0AAA2",
    "EVqLR9wt9G1xxqpa4v7k_1La_nfLjUiLsMv_pqw6ITzU4IxxJH0AAA2",
    "CD8SI0eTszJ2ujHYwz528RVd_UDxAEJInAZMzjWxZMHU4IxxJH0AAA2",
    "JXTr3cAo48_O4gYu-T7-YtKt1TxdC0eBk9ubMFV45N7U4IxxJH0AAA2",
    "8xjJB27pQbR16VatNgAcmTCfYZyAXUbPr7g38NrTvE3U4IxxJH0AAA2",
    "xbocnSXX9JkxlvVGJFjugx-CvYaYGEedrZ0k3wumDG3U4IxxJH0AAA2",
    "Aowc3axny_uD4_K3CTbjga4UmurHvk5gvwdflY-eTPjU4IxxJH0AAA2",
    "l8NVSYSicaOrftcAMCxGTOfxZDBXnkmPt7n5Hcvo9IbU4IxxJH0AAA2",
    "23CNQJ7x7F8PDdnlWPlb1RhkLQNBcE_JoSspyc7yxS_U4IxxJH0AAA2",
    "qj7tQTI6cYfvvw3QQVuVsFAKq4gVY0_hsv2mPmUYuJfU4IxxJH0AAA2",
    "WVrBN7YfvoS533Z1sr0jtluG3tWqzEbUpMNZNqBdaALU4IxxJH0AAA2",
    "Ck3AeqSLL16nhDLVO3clC9aXC-_1ZUfyh1R8I9kE-rHU4IxxJH0AAA2",
    "hOa7qg5VRoSUc2AJnldAq4X7hAcgu0-HuRP99gPV3snU4IxxJH0AAA2",
    "EnwMQnf8cE7945jbfX56io-EBOcnAE9CnR6IX_X781TU4IxxJH0AAA2",
    "2ni5_cR4bxd1fnB1GwwGfJm6fw6Z0kp9gxSErx3Bs0LU4IxxJH0AAA2",
    "vcuJ2qqQ8JmaxeHo0jQ5lVs7urggUkEChULBJ6r4PgDU4IxxJH0AAA2",
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

-- TextBox để thay đổi thời gian recentServer
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
        statusLabel.Text = "⏱ RecentServer timeout set to "..value.."s"
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

-- 🟢 Farm chest (, random 2-4s để lụm)
local function farmChest(chest)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local part = chest:FindFirstChild("TreasureChestPart") or chest:FindFirstChild("HumanoidRootPart")
    if hrp and part then
        hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 5, 0))
        local collectTime = math.random(3000, 5000) / 1000
        task.wait(collectTime)
        if chest and chest.Parent then
            remainingChests = math.max(0, remainingChests - 1)
            updateStatus("🟢 Farming chests... ("..remainingChests..")", Color3.fromRGB(0, 170, 0))
            print("✅ Collected chest:", chest.Name, "| delay:", collectTime)
        end
    end
end

-- 🟢 Hop server ngẫu nhiên + tránh trùng + xóa sau thời gian cấu hình
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
    -- random chuẩn bị hop: 8-12s
    task.wait(math.random(8, 12))
    warn("👉 Hopping to server:", accesscode)
    -- dùng FireServer (theo script bạn yêu cầu)
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
    task.wait(5)
    while true do
        if chestEnabled then
            local chests = getAllChests()
            remainingChests = #chests
            if #chests > 0 then
                updateStatus("🟢 Farming chests... ("..#chests..")", Color3.fromRGB(0, 170, 0))
                for _, chest in ipairs(chests) do
                    if not chestEnabled then break end
                    farmChest(chest)
                    task.wait(0.5)
                end
            else
                hopServer()
                updateStatus("🔵 Joined new server", Color3.fromRGB(0, 85, 255))
                task.wait(8)
            end
        end
        task.wait(1)
    end
end)
