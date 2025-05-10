local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- قائمة الأنشنتات المتاحةk
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

-- إنشاء واجهة مخصصة
local GhostUI = Instance.new("ScreenGui")
GhostUI.Name = "GhostEnchantUI"
GhostUI.Parent = PlayerGui

-- الإطار الرئيسي
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Parent = GhostUI

-- زوايا مستديرة
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- العنوان
local Title = Instance.new("TextLabel")
Title.Text = "نظام الأنشنت | Ghost 🥀"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- القائمة المنسدلة المخصصة
local DropdownButton = Instance.new("TextButton")
DropdownButton.Name = "DropdownButton"
DropdownButton.Text = "اختر الأنشنت المطلوب ▼"
DropdownButton.Size = UDim2.new(0.9, 0, 0, 35)
DropdownButton.Position = UDim2.new(0.05, 0, 0.15, 0)
DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownButton.Font = Enum.Font.Gotham
DropdownButton.TextSize = 14
DropdownButton.Parent = MainFrame

local DropdownFrame = Instance.new("Frame")
DropdownFrame.Name = "DropdownFrame"
DropdownFrame.Size = UDim2.new(0.9, 0, 0, 0)
DropdownFrame.Position = UDim2.new(0.05, 0, 0.15, 40)
DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
DropdownFrame.ClipsDescendants = true
DropdownFrame.Parent = MainFrame

local DropdownScroll = Instance.new("ScrollingFrame")
DropdownScroll.Size = UDim2.new(1, 0, 1, 0)
DropdownScroll.CanvasSize = UDim2.new(0, 0, 0, #availableEnchants * 35)
DropdownScroll.ScrollBarThickness = 5
DropdownScroll.Parent = DropdownFrame

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Parent = DropdownScroll

-- زر التشغيل/الإيقاف
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "إيقاف"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 45)
ToggleButton.Position = UDim2.new(0.05, 0, 0.7, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.Parent = MainFrame

-- حالة النظام
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "حالة: في انتظار التشغيل..."
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.9, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.Parent = MainFrame

-- إنشاء خيارات القائمة
for _, enchant in ipairs(availableEnchants) do
    local Option = Instance.new("TextButton")
    Option.Text = enchant
    Option.Size = UDim2.new(1, -10, 0, 35)
    Option.Position = UDim2.new(0, 5, 0, 0)
    Option.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Option.TextColor3 = Color3.fromRGB(255, 255, 255)
    Option.Font = Enum.Font.Gotham
    Option.TextSize = 14
    Option.Parent = DropdownScroll
    
    Option.MouseButton1Click:Connect(function()
        selectedEnchant = enchant
        DropdownButton.Text = enchant .. " ▼"
        DropdownFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end)
end

-- التحكم في القائمة المنسدلة
DropdownButton.MouseButton1Click:Connect(function()
    if DropdownFrame.Size.Y.Offset == 0 then
        DropdownFrame.Size = UDim2.new(0.9, 0, 0, math.min(#availableEnchants * 35, 175))
    else
        DropdownFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end
end)

-- نظام الأنشنت التلقائي
local function GetCurrentEnchant()
    local success, result = pcall(function()
        local slot = Player.PlayerGui.ScreenGui.Enchant.Content.Slots["1"]
        local textElement = slot:FindFirstChild("EnchantName") or 
                          slot:FindFirstChildOfClass("TextLabel") or
                          slot:FindFirstChildOfClass("TextButton")
        return textElement and textElement.Text or ""
    end)
    return success and result or ""
end

local function PerformEnchant()
    local remote = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Enchant")
    if remote then
        remote:FireServer(unpack(args))
        return true
    end
    return false
end

local function StartEnchantLoop()
    while isRunning do
        local current = GetCurrentEnchant()
        
        if string.find(current:lower(), selectedEnchant:lower(), 1, true) then
            StatusLabel.Text = "تم الوصول إلى: " .. selectedEnchant
            isRunning = false
            ToggleButton.Text = "إيقاف"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            break
        end
        
        StatusLabel.Text = "جاري العمل... (" .. current .. ")"
        
        if not PerformEnchant() then
            isRunning = false
            ToggleButton.Text = "إيقاف"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            break
        end
        
        task.wait(0.7)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    
    if isRunning then
        ToggleButton.Text = "تشغيل"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StatusLabel.Text = "جاري البحث عن: " .. selectedEnchant
        StartEnchantLoop()
    else
        ToggleButton.Text = "إيقاف"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "حالة: متوقف"
    end
end)

-- جعل الواجهة قابلة للسحب
local dragging, dragInput, dragStart, startPos

local function UpdateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        UpdateInput(input)
    end
end)
