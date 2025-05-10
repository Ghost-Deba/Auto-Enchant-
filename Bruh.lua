-- الخدمات الأساسية 
local Players = game:GetService("Players") local ReplicatedStorage = game:GetService("ReplicatedStorage") local Player = Players.LocalPlayer local PlayerGui = Player:WaitForChild("PlayerGui")

-- جدول الـ Pickaxe والـ Args الخاصة بها 
local pickaxeArgs = { ["Iron Pickaxe"] = {1, 1}, ["Gold Pickaxe"] = {129, 1}, ["Diamond Pickaxe"] = {128, 1}, ["Gem Pickaxe"] = {4, 1}, ["God Pickaxe"] = {130, 1}, ["Grassy Pickaxe"] = {132, 1}, ["Ice Pickaxe"] = {131, 1}, ["Void Pickaxe"] = {6, 1}, ["Hellfire Pickaxe"] = {133, 1}, ["Pirate's Pickaxe"] = {8, 1}, ["Coral Pickaxe"] = {127, 1}, ["Sharkee Pick"] = {9, 1}, ["Lava Pickaxe"] = {76, 1} }

-- جدول الأنشنتات المتاحة 
local availableEnchants = { "Magic Ores", "Incredible Damage", "Deadly Damage++", "Deadly Damage", "More Damage", "Light Damage", "Incredible Luck", "Mighty Luck++", "Mighty Luck", "Considerable Luck", "Abnormal Speed" }

-- المتغيرات العامة 
local selectedEnchant = nil local args = nil local isRunning = false

-- بناء الواجهة 
local GhostUI = Instance.new("ScreenGui", PlayerGui) GhostUI.Name = "GhostEnchantUI"

local MainFrame = Instance.new("Frame", GhostUI) MainFrame.Size = UDim2.new(0, 300, 0, 460) MainFrame.Position = UDim2.new(0.5, -150, 0.5, -230) MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30) local corner = Instance.new("UICorner", MainFrame) corner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", MainFrame) Title.Text = "نظام الأنشنت | Ghost" Title.Size = UDim2.new(1, 0, 0, 40) Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45) Title.TextColor3 = Color3.new(1, 1, 1) Title.Font = Enum.Font.GothamBold Title.TextSize = 18

-- زر اختيار Pickaxe 
local PickaxeButton = Instance.new("TextButton", MainFrame) PickaxeButton.Text = "اختر Pickaxe ▼" PickaxeButton.Size = UDim2.new(0.9, 0, 0, 30) PickaxeButton.Position = UDim2.new(0.05, 0, 0.12, 0) PickaxeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55) PickaxeButton.TextColor3 = Color3.new(1, 1, 1) PickaxeButton.Font = Enum.Font.Gotham PickaxeButton.TextSize = 14

local PickaxeFrame = Instance.new("Frame", MainFrame) PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0) PickaxeFrame.Position = UDim2.new(0.05, 0, 0.21, 0) PickaxeFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45) PickaxeFrame.ClipsDescendants = true PickaxeFrame.ZIndex = 2

local PickaxeScroll = Instance.new("ScrollingFrame", PickaxeFrame) PickaxeScroll.Size = UDim2.new(1, 0, 1, 0) PickaxeScroll.CanvasSize = UDim2.new(0, 0, 0, #availableEnchants * 30) PickaxeScroll.ScrollBarThickness = 5 PickaxeScroll.BackgroundTransparency = 1 local PickaxeLayout = Instance.new("UIListLayout", PickaxeScroll) PickaxeLayout.SortOrder = Enum.SortOrder.LayoutOrder

for name, a in pairs(pickaxeArgs) do local b = Instance.new("TextButton", PickaxeScroll) b.Text = name b.Size = UDim2.new(1, -10, 0, 30) b.BackgroundColor3 = Color3.fromRGB(50, 50, 60) b.TextColor3 = Color3.new(1, 1, 1) b.Font = Enum.Font.Gotham b.TextSize = 14 b.LayoutOrder = 1 b.MouseButton1Click:Connect(function() args = a PickaxeButton.Text = name .. " ▼" PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0) end) end

PickaxeButton.MouseButton1Click:Connect(function() PickaxeFrame.Size = UDim2.new(0.9, 0, 0, (PickaxeFrame.Size.Y.Offset == 0) and 150 or 0) end)

-- زر اختيار Enchant 
local EnchantButton = Instance.new("TextButton", MainFrame) EnchantButton.Text = "اختر Enchant ▼" EnchantButton.Size = UDim2.new(0.9, 0, 0, 30) EnchantButton.Position = UDim2.new(0.05, 0, 0.36, 0) EnchantButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55) EnchantButton.TextColor3 = Color3.new(1, 1, 1) EnchantButton.Font = Enum.Font.Gotham EnchantButton.TextSize = 14

local EnchantFrame = Instance.new("Frame", MainFrame) EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0) EnchantFrame.Position = UDim2.new(0.05, 0, 0.45, 0) EnchantFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45) EnchantFrame.ClipsDescendants = true EnchantFrame.ZIndex = 2

local EnchantScroll = Instance.new("ScrollingFrame", EnchantFrame) EnchantScroll.Size = UDim2.new(1, 0, 1, 0) EnchantScroll.CanvasSize = UDim2.new(0, 0, 0, #availableEnchants * 30) EnchantScroll.ScrollBarThickness = 5 EnchantScroll.BackgroundTransparency = 1 local EnchantLayout = Instance.new("UIListLayout", EnchantScroll) EnchantLayout.SortOrder = Enum.SortOrder.LayoutOrder

for _, enchant in ipairs(availableEnchants) do local b = Instance.new("TextButton", EnchantScroll) b.Text = enchant b.Size = UDim2.new(1, -10, 0, 30) b.BackgroundColor3 = Color3.fromRGB(50, 50, 60) b.TextColor3 = Color3.new(1, 1, 1) b.Font = Enum.Font.Gotham b.TextSize = 14 b.LayoutOrder = 1 b.MouseButton1Click:Connect(function() selectedEnchant = enchant EnchantButton.Text = enchant .. " ▼" EnchantFrame.Size = UDim2.new(0.9, 0, 0, 0) end) end

EnchantButton.MouseButton1Click:Connect(function() EnchantFrame.Size = UDim2.new(0.9, 0, 0, (EnchantFrame.Size.Y.Offset == 0) and 150 or 0) PickaxeFrame.Size = UDim2.new(0.9, 0, 0, 0) end)

-- زر التشغيل 
local RunButton = Instance.new("TextButton", MainFrame) RunButton.Text = "تشغيل" RunButton.Size = UDim2.new(0.9, 0, 0, 40) RunButton.Position = UDim2.new(0.05, 0, 0.8, 0) RunButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60) RunButton.TextColor3 = Color3.new(1, 1, 1) RunButton.Font = Enum.Font.GothamBold RunButton.TextSize = 16

RunButton.MouseButton1Click:Connect(function() if not selectedEnchant or not args then return end if isRunning then return end isRunning = true local remote = ReplicatedStorage:FindFirstChild("Enchant") if remote then remote:FireServer(unpack(args), selectedEnchant) end isRunning = false end)

