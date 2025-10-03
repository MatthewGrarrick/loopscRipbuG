-- 📌 Auto Skill & Hold Skill GUI by LoopscRiptbuG
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Danh sách phím skill
local skillKeys = {"Z","X","C","V","B","N","F","G","H","J","K","L"}

-- Cấu hình mặc định
local skillDelay = 2
local holdTime = 5

-- Trạng thái skill
local skillSettings = {}
for _, key in ipairs(skillKeys) do
    skillSettings[key] = {Auto=false, Hold=false}
end

-- Hàm nhấn phím
local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

-- Hàm giữ phím
local function holdKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(holdTime)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

-- Auto loop
task.spawn(function()
    while task.wait(0.1) do
        for _, key in ipairs(skillKeys) do
            if skillSettings[key].Auto then
                pressKey(Enum.KeyCode[key])
                task.wait(skillDelay)
            elseif skillSettings[key].Hold then
                holdKey(Enum.KeyCode[key])
                task.wait(skillDelay)
            end
        end
    end
end)

-- 📌 GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "LoopscRiptbuG"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 500)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

-- Background Gradient động
local UIGradient = Instance.new("UIGradient", Frame)
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 150))
}
UIGradient.Rotation = 45

-- Animate gradient
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            UIGradient.Offset = Vector2.new(i, i)
            task.wait(0.05)
        end
    end
end)

-- Title Bar
local TopBar = Instance.new("Frame", Frame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
TopBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", TopBar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "⚡ LoopscRiptbuG - Auto Skill GUI ⚡"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút thu nhỏ
local minimizeBtn = Instance.new("TextButton", TopBar)
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,0)
minimizeBtn.TextSize = 20

-- Nút tắt
local closeBtn = Instance.new("TextButton", TopBar)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(255,0,0)
closeBtn.TextSize = 20

-- Thu nhỏ / mở rộng
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(Frame:GetChildren()) do
        if v ~= TopBar and v ~= UIGradient then
            v.Visible = not minimized
        end
    end
    Frame.Size = minimized and UDim2.new(0, 350, 0, 40) or UDim2.new(0, 350, 0, 500)
end)

-- Đóng hẳn GUI
closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Scroll cho skill list
local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(1, -10, 0, 400)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.CanvasSize = UDim2.new(0,0,0,500)
Scroll.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", Scroll)
UIListLayout.Padding = UDim.new(0, 5)

-- Tạo nút Auto/Hold cho từng skill
for _, key in ipairs(skillKeys) do
    local holder = Instance.new("Frame", Scroll)
    holder.Size = UDim2.new(1, -5, 0, 35)
    holder.BackgroundColor3 = Color3.fromRGB(50,50,50)
    holder.BackgroundTransparency = 0.2

    local UICorner = Instance.new("UICorner", holder)
    UICorner.CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Text = "Skill "..key
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14

    -- Auto Btn
    local autoBtn = Instance.new("TextButton", holder)
    autoBtn.Size = UDim2.new(0.3, -5, 1, 0)
    autoBtn.Position = UDim2.new(0.3, 0, 0, 0)
    autoBtn.Text = "Auto: OFF"
    autoBtn.BackgroundColor3 = Color3.fromRGB(200,0,0) -- đỏ khi OFF
    autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,6)

    autoBtn.MouseButton1Click:Connect(function()
        skillSettings[key].Auto = not skillSettings[key].Auto
        autoBtn.Text = "Auto: " .. (skillSettings[key].Auto and "ON" or "OFF")
        autoBtn.BackgroundColor3 = skillSettings[key].Auto and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)

    -- Hold Btn
    local holdBtn = Instance.new("TextButton", holder)
    holdBtn.Size = UDim2.new(0.3, -5, 1, 0)
    holdBtn.Position = UDim2.new(0.6, 0, 0, 0)
    holdBtn.Text = "Hold: OFF"
    holdBtn.BackgroundColor3 = Color3.fromRGB(200,0,0) -- đỏ khi OFF
    holdBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", holdBtn).CornerRadius = UDim.new(0,6)

    holdBtn.MouseButton1Click:Connect(function()
        skillSettings[key].Hold = not skillSettings[key].Hold
        holdBtn.Text = "Hold: " .. (skillSettings[key].Hold and "ON" or "OFF")
        holdBtn.BackgroundColor3 = skillSettings[key].Hold and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
    end)
end

-- Khung chỉnh Delay & Hold Time
local configFrame = Instance.new("Frame", Frame)
configFrame.Size = UDim2.new(1, -10, 0, 50)
configFrame.Position = UDim2.new(0, 5, 1, -55)
configFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
Instance.new("UICorner", configFrame).CornerRadius = UDim.new(0,6)

local delayBox = Instance.new("TextBox", configFrame)
delayBox.Size = UDim2.new(0.5, -5, 1, 0)
delayBox.Position = UDim2.new(0, 0, 0, 0)
delayBox.Text = "Delay: "..skillDelay.."s"
delayBox.TextColor3 = Color3.fromRGB(255,255,255)
delayBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0,6)

delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text:match("%d+"))
    if val then
        skillDelay = val
        delayBox.Text = "Delay: "..skillDelay.."s"
    end
end)

local holdBox = Instance.new("TextBox", configFrame)
holdBox.Size = UDim2.new(0.5, -5, 1, 0)
holdBox.Position = UDim2.new(0.5, 5, 0, 0)
holdBox.Text = "Hold: "..holdTime.."s"
holdBox.TextColor3 = Color3.fromRGB(255,255,255)
holdBox.BackgroundColor3 = Color3.fromRGB(70,70,70)
Instance.new("UICorner", holdBox).CornerRadius = UDim.new(0,6)

holdBox.FocusLost:Connect(function()
    local val = tonumber(holdBox.Text:match("%d+"))
    if val then
        holdTime = val
        holdBox.Text = "Hold: "..holdTime.."s"
    end
end)
