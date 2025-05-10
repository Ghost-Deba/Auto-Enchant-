local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- قائمة الأنشنتات المتاحة
local availableEnchants = {
    "Magic Ores",
    "Incredible Damage",
    "Deadly Damage++",
    "Deadly Damage",
    "More Damage",
    "Light Damage",
    "Incredible Luck",
    "Mighty Luck++",
    "Mighty Luck",
    "Considerable Luck",
    "Abnormal Speed"
}

-- إشعار البداية (تم التعديل هنا)
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "By Ｇんｏｓｔ 🥀",
    Text = "on Roblox",
    Duration = 12,
    Icon = "rbxassetid://138737424813164" -- يدعم أيقونات صغيرة فقط
})

-- إنشاء واجهة المستخدم
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoEnchantUI"
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 180) -- تم زيادة الارتفاع لإضافة القائمة
frame.Position = UDim2.new(0.5, -125, 0.1, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Auto Enchanter"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Dropdown لقائمة الأنشنتات
local dropdown = Instance.new("TextButton")
dropdown.Text = "Choose Enchant ▼"
dropdown.Size = UDim2.new(0.8, 0, 0, 30)
dropdown.Position = UDim2.new(0.1, 0, 0.2, 0)
dropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
dropdown.Parent = frame

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0.8, 0, 0, 0) -- سيتم تعديل الارتفاع عند الفتح
dropdownFrame.Position = UDim2.new(0.5, 125, 0.2, 0) -- جعل القائمة تظهر بجانب الواجهة
dropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdownFrame.Visible = false
dropdownFrame.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Parent = dropdownFrame

-- زر التشغيل/الإيقاف
local toggleButton = Instance.new("TextButton")
toggleButton.Text = "OFF"
toggleButton.Size = UDim2.new(0.8, 0, 0, 40)
toggleButton.Position = UDim2.new(0.1, 0, 0.7, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "Waiting to start..."
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.9, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Parent = frame

-- متغيرات السكريبت
local isRunning = false
local selectedEnchant = availableEnchants[1] -- القيمة الافتراضية
local args = {6, 1}

-- إنشاء خيارات القائمة المنسدلة
for _, enchant in ipairs(availableEnchants) do
    local option = Instance.new("TextButton")
    option.Text = enchant
    option.Size = UDim2.new(1, 0, 0, 30)
    option.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    option.TextColor3 = Color3.fromRGB(255, 255, 255)
    option.Parent = dropdownFrame
    
    option.MouseButton1Click:Connect(function()
        selectedEnchant = enchant
        dropdown.Text = enchant .. " ▼"
        dropdownFrame.Visible = false
    end)
end

-- دالة لفتح/إغلاق القائمة المنسدلة
dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
    if dropdownFrame.Visible then
        dropdownFrame.Size = UDim2.new(0.8, 0, 0, #availableEnchants * 30)
    else
        dropdownFrame.Size = UDim2.new(0.8, 0, 0, 0)
    end
end)

-- دالة للتحقق من السحر الحالي
local function getCurrentEnchant()
    local success, result = pcall(function()
        return Player.PlayerGui.ScreenGui.Enchant.Content.Slots["1"].EnchantName.Text
    end)
    return success and result or ""
end

-- دالة تنفيذ السحر
local function performEnchant()
    local success, errorMsg = pcall(function()
        local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Enchant")
        if remote then
            remote:FireServer(unpack(args))
            return true
        end
        return false
    end)
    
    if not success then
        statusLabel.Text = "Error: "..tostring(errorMsg)
        return false
    end
    return true
end

-- الحلقة الرئيسية المعدلة
local function enchantLoop()
    while isRunning do
        local currentEnchant = getCurrentEnchant()
        
        if currentEnchant == selectedEnchant then
            statusLabel.Text = "Target reached: "..selectedEnchant
            isRunning = false
            toggleButton.Text = "OFF"
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            break
        end
        
        statusLabel.Text = "Current: "..currentEnchant.." | Target: "..selectedEnchant
        
        if not performEnchant() then
            isRunning = false
            toggleButton.Text = "OFF"
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            break
        end
        
        task.wait(0.5)
    end
end

-- زر التشغيل/الإيقاف
toggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    
    if isRunning then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        statusLabel.Text = "Running... Target: "..selectedEnchant
        task.spawn(enchantLoop)
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        statusLabel.Text = "Stopped"
    end
end)

-- جعل الواجهة قابلة للسحب (نفس الكود السابق)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
