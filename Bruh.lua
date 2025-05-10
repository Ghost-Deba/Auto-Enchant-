-- الخدمات الأساسية
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
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
local isMinimized = false
local originalSize = UDim2.new(0, 300, 0, 460)
local minimizedSize = UDim2.new(0, 300, 0, 40)

-- بناء الواجهة
local GhostUI = Instance.new("ScreenGui")
GhostUI.Name = "GhostEnchantUI"
GhostUI.ResetOnSpawn = false
GhostUI.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = originalSize
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -230)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Parent = GhostUI

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = MainFrame

-- عنوان مع زر التصغير
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "نظام الأنشنت | Ghost"
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = TitleBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Text = "_"
MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
MinimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 20
MinimizeButton.Parent = TitleBar

-- محتوى الواجهة (سيتم إخفاؤه عند التصغير)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- زر اختيار Pickaxe
local PickaxeButton = Instance.new("TextButton")
PickaxeButton.Text = "اختر Pickaxe ▼"
PickaxeButton.Size = UDim2.new(0.9, 0, 0, 40) -- حجم أكبر للهواتف
PickaxeButton.Position = UDim2.new(0.05, 0, 0.05, 0)
PickaxeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
PickaxeButton.TextColor3 = Color3.new(1, 1, 1)
PickaxeButton.Font = Enum.Font.Gotham
PickaxeButton.TextSize = 14
PickaxeButton.Parent = ContentFrame

local PickaxeFrame = Instance.new("Frame")
PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0)
PickaxeFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
PickaxeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
PickaxeFrame.ClipsDescendants = true
PickaxeFrame.ZIndex = 2
PickaxeFrame.Parent = ContentFrame

local PickaxeScroll = Instance.new("ScrollingFrame")
PickaxeScroll.Size = UDim2.new(1, 0, 1, 0)
PickaxeScroll.CanvasSize = UDim2.new(0, 0, 0, #pickaxeArgs * 40) -- حجم أكبر للهواتف
PickaxeScroll.ScrollBarThickness = 5
PickaxeScroll.BackgroundTransparency = 1
PickaxeScroll.Parent = PickaxeFrame

local PickaxeLayout = Instance.new("UIListLayout")
PickaxeLayout.SortOrder = Enum.SortOrder.LayoutOrder
PickaxeLayout.Parent = PickaxeScroll

for name, a in pairs(pickaxeArgs) do
    local b = Instance.new("TextButton")
    b.Text = name
    b.Size = UDim2.new(1, -10, 0, 40) -- حجم أكبر للهواتف
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.LayoutOrder = 1
    b.Parent = PickaxeScroll
    
    b.MouseButton1Click:Connect(function()
        args = a
        PickaxeButton.Text = name .. " ▼"
        PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0)
        EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end)
end

PickaxeButton.MouseButton1Click:Connect(function()
    PickaxeFrame.Size = UDim2.new(0.9, 0, 0, (PickaxeFrame.Size.Y.Offset == 0) and math.min(#pickaxeArgs * 40, 200) or 0)
    EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0)
end)

-- زر اختيار Enchant
local EnchantButton = Instance.new("TextButton")
EnchantButton.Text = "اختر Enchant ▼"
EnchantButton.Size = UDim2.new(0.9, 0, 0, 40) -- حجم أكبر للهواتف
EnchantButton.Position = UDim2.new(0.05, 0, 0.35, 0)
EnchantButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
EnchantButton.TextColor3 = Color3.new(1, 1, 1)
EnchantButton.Font = Enum.Font.Gotham
EnchantButton.TextSize = 14
EnchantButton.Parent = ContentFrame

local EnchantFrame = Instance.new("Frame")
EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0)
EnchantFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
EnchantFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
EnchantFrame.ClipsDescendants = true
EnchantFrame.ZIndex = 2
EnchantFrame.Parent = ContentFrame

local EnchantScroll = Instance.new("ScrollingFrame")
EnchantScroll.Size = UDim2.new(1, 0, 1, 0)
EnchantScroll.CanvasSize = UDim2.new(0, 0, 0, #availableEnchants * 40) -- حجم أكبر للهواتف
EnchantScroll.ScrollBarThickness = 5
EnchantScroll.BackgroundTransparency = 1
EnchantScroll.Parent = EnchantFrame

local EnchantLayout = Instance.new("UIListLayout")
EnchantLayout.SortOrder = Enum.SortOrder.LayoutOrder
EnchantLayout.Parent = EnchantScroll

for _, enchant in ipairs(availableEnchants) do
    local b = Instance.new("TextButton")
    b.Text = enchant
    b.Size = UDim2.new(1, -10, 0, 40) -- حجم أكبر للهواتف
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.LayoutOrder = 1
    b.Parent = EnchantScroll
    
    b.MouseButton1Click:Connect(function()
        selectedEnchant = enchant
        EnchantButton.Text = enchant .. " ▼"
        EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0)
        PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0)
    end)
end

EnchantButton.MouseButton1Click:Connect(function()
    EnchantFrame.Size = UDim2.new(0.9, 0, 0, (EnchantFrame.Size.Y.Offset == 0) and math.min(#availableEnchants * 40, 200) or 0)
    PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0)
end)

-- زر التشغيل
local RunButton = Instance.new("TextButton")
RunButton.Text = "تشغيل"
RunButton.Size = UDim2.new(0.9, 0, 0, 50) -- حجم أكبر للهواتف
RunButton.Position = UDim2.new(0.05, 0, 0.75, 0)
RunButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
RunButton.TextColor3 = Color3.new(1, 1, 1)
RunButton.Font = Enum.Font.GothamBold
RunButton.TextSize = 16
RunButton.Parent = ContentFrame

RunButton.MouseButton1Click:Connect(function
