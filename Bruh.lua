-- الخدمات الأساسية
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- جدول الـ Pickaxe والـ Args الخاصة بها
local pickaxeArgs = {
    ["Iron Pickaxe"] = {1, 1},
    ["Gold Pickaxe"] = {129, 1},
    ["Diamond Pickaxe"] = {128, 1},
    ["Gem Pickaxe"] = {4, 1},
    ["God Pickaxe"] = {130, 1},
    ["Grassy Pickaxe"] = {132, 1},
    ["Ice Pickaxe"] = {131, 1},
    ["Void Pickaxe"] = {6, 1},
    ["Hellfire Pickaxe"] = {133, 1},
    ["Pirate's Pickaxe"] = {8, 1},
    ["Coral Pickaxe"] = {127, 1},
    ["Sharkee Pick"] = {9, 1},
    ["Lava Pickaxe"] = {76, 1}
}

-- جدول الأنشنتات المتاحة
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

-- المتغيرات العامة
local selectedEnchant = nil
local args = nil
local isRunning = false

-- بناء الواجهة
local GhostUI = Instance.new("ScreenGui", PlayerGui)
GhostUI.Name = "GhostEnchantUI"

local MainFrame = Instance.new("Frame", GhostUI)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "نظام الأنشنت | Ghost"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- زر اختيار Pickaxe
local PickaxeButton = Instance.new("TextButton", MainFrame)
PickaxeButton.Text = "اختر Pickaxe ▼"
PickaxeButton.Size = UDim2.new(0.9, 0, 0, 30)
PickaxeButton.Position = UDim2.new(0.05, 0, 0.12, 0)
PickaxeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
PickaxeButton.TextColor3 = Color3.new(1, 1, 1)
PickaxeButton.Font = Enum.Font.Gotham
PickaxeButton.TextSize = 14

local PickaxeFrame = Instance.new("Frame", MainFrame)
PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0)
PickaxeFrame.Position = UDim2.new(0.05, 0, 0.12, 32)
PickaxeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PickaxeFrame.ClipsDescendants = true

local PickaxeScroll = Instance.new("ScrollingFrame", PickaxeFrame)
PickaxeScroll.Size = UDim2.new(1, 0, 1, 0)
PickaxeScroll.CanvasSize = UDim2.new(0, 0, 0, 13 * 30)
PickaxeScroll.ScrollBarThickness = 5
local PickaxeLayout = Instance.new("UIListLayout", PickaxeScroll)

for name, a in pairs(pickaxeArgs) do
    local b = Instance.new("TextButton", PickaxeScroll)
    b.Text = name
    b.Size = UDim2.new(1, -10, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.MouseButton1Click:Connect(function()
        args = a
        PickaxeButton.Text = name .. " ▼"
        PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end)
end

PickaxeButton.MouseButton1Click:Connect(function()
    if PickaxeFrame.Size.Y.Offset == 0 then
        PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 130)
    else
        PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end
end)

-- dropdown الخاصة بالأنشنتات
local EnchantButton = Instance.new("TextButton", MainFrame)
EnchantButton.Text = "اختر Enchant ▼"
EnchantButton.Size = UDim2.new(0.9, 0, 0, 30)
EnchantButton.Position = UDim2.new(0.05, 0, 0.3, 0)
EnchantButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
EnchantButton.TextColor3 = Color3.new(1, 1, 1)
EnchantButton.Font = Enum.Font.Gotham
EnchantButton.TextSize = 14

local EnchantFrame = Instance.new("Frame", MainFrame)
EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0)
EnchantFrame.Position = UDim2.new(0.05, 0, 0.3, 32)
EnchantFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
EnchantFrame.ClipsDescendants = true

local EnchantScroll = Instance.new("ScrollingFrame", EnchantFrame)
EnchantScroll.Size = UDim2.new(1, 0, 1, 0)
EnchantScroll.CanvasSize = UDim2.new(0, 0, 0, #availableEnchants * 30)
EnchantScroll.ScrollBarThickness = 5
local EnchantLayout = Instance.new("UIListLayout", EnchantScroll)

for _, enchant in ipairs(availableEnchants) do
    local Option = Instance.new("TextButton", EnchantScroll)
    Option.Text = enchant
    Option.Size = UDim2.new(1, -10, 0, 30)
    Option.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Option.TextColor3 = Color3.new(1, 1, 1)
    Option.Font = Enum.Font.Gotham
    Option.TextSize = 14
    Option.MouseButton1Click:Connect(function()
        selectedEnchant = enchant
        EnchantButton.Text = enchant .. " ▼"
        EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end)
end

EnchantButton.MouseButton1Click:Connect(function()
    if EnchantFrame.Size.Y.Offset == 0 then
        EnchantFrame.Size = UDim2.new(0.9, 0, 0, 150)
    else
        EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end
end)

-- زر التشغيل
local ToggleButton = Instance.new("TextButton", MainFrame)
ToggleButton.Text = "تشغيل"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.75, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Text = "حالة: في انتظار التشغيل..."
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0.92, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14

-- الحصول على Enchant الحالي
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
    if not args then return false end
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
            ToggleButton.Text = "تشغيل"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            break
        end
        StatusLabel.Text = "جاري العمل... (" .. current .. ")"
        if not PerformEnchant() then
            isRunning = false
            ToggleButton.Text = "تشغيل"
            ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            break
        end
        task.wait(0.7)
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleButton.Text = "إيقاف"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        StatusLabel.Text = "جاري البحث عن: " .. (selectedEnchant or "?")
        StartEnchantLoop()
    else
        ToggleButton.Text = "تشغيل"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        StatusLabel.Text = "حالة: متوقف"
    end
end)

-- سحب الواجهة
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
