-- تحميل مكتبة Tora بشكل صحيح
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()

-- إنشاء واجهة المستخدم الرئيسية
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local screenGui = library.UI:Create("ScreenGui", {Parent = PlayerGui})

-- إنشاء الإطار الأساسي
local frame = library.UI:Create("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 250, 0, 180),
    Position = UDim2.new(0.5, -125, 0.1, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
})

-- عنوان واجهة المستخدم
local title = library.UI:Create("TextLabel", {
    Parent = frame,
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
    Text = "Auto Enchanter",
    TextColor3 = Color3.fromRGB(255, 255, 255),
})

-- إنشاء الزر المنسدل للقائمة
local dropdown = library.UI:Create("TextButton", {
    Parent = frame,
    Size = UDim2.new(0.8, 0, 0, 30),
    Position = UDim2.new(0.1, 0, 0.2, 0),
    Text = "Choose Enchant ▼",
    BackgroundColor3 = Color3.fromRGB(80, 80, 80),
    TextColor3 = Color3.fromRGB(255, 255, 255),
})

-- إنشاء قائمة الأنشنتات
local availableEnchants = {
    "Magic Ores", "Incredible Damage", "Deadly Damage++", "Deadly Damage",
    "More Damage", "Light Damage", "Incredible Luck", "Mighty Luck++",
    "Mighty Luck", "Considerable Luck", "Abnormal Speed"
}

-- إنشاء إطار القائمة المنسدلة
local dropdownFrame = library.UI:Create("Frame", {
    Parent = frame,
    Size = UDim2.new(0.8, 0, 0, 0),
    Position = UDim2.new(0.1, 0, 0.2, 30),
    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
    Visible = false,
})

-- إضافة الخيارات للقائمة المنسدلة
for _, enchant in ipairs(availableEnchants) do
    library.UI:Create("TextButton", {
        Parent = dropdownFrame,
        Size = UDim2.new(1, 0, 0, 30),
        Text = enchant,
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        MouseButton1Click = function()
            dropdown.Text = enchant .. " ▼"
            dropdownFrame.Visible = false
        end
    })
end

-- فتح وإغلاق القائمة المنسدلة عند النقر على الزر
dropdown.MouseButton1Click:Connect(function()
    dropdownFrame.Visible = not dropdownFrame.Visible
    if dropdownFrame.Visible then
        dropdownFrame.Size = UDim2.new(0.8, 0, 0, #availableEnchants * 30)
    else
        dropdownFrame.Size = UDim2.new(0.8, 0, 0, 0)
    end
end)

-- إعداد زر التشغيل والإيقاف
local toggleButton = library.UI:Create("TextButton", {
    Parent = frame,
    Size = UDim2.new(0.8, 0, 0, 40),
    Position = UDim2.new(0.1, 0, 0.7, 0),
    Text = "OFF",
    BackgroundColor3 = Color3.fromRGB(255, 60, 60),
    TextColor3 = Color3.fromRGB(255, 255, 255),
})

-- إعداد حالة الزر والواجهة
local statusLabel = library.UI:Create("TextLabel", {
    Parent = frame,
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0.9, 0),
    BackgroundTransparency = 1,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Text = "Waiting to start...",
})

-- متغيرات التشغيل
local isRunning = false
local selectedEnchant = availableEnchants[1]

-- تنفيذ الفعل عند الضغط على الزر
toggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        statusLabel.Text = "Running... Target: " .. selectedEnchant
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        statusLabel.Text = "Stopped"
    end
end)
