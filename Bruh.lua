local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

-- إنشاء النافذة الرئيسية
local Window = Rayfield:CreateWindow({
    Name = "⚡ نظام الأنشنت التلقائي | By Ｇんｏｓｔ 🥀",
    LoadingTitle = "جاري التحميل...",
    LoadingSubtitle = "نظام التلقائي للأنشنت - الإصدار المحدث",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GhostEnchantPro",
        FileName = "ConfigV2"
    },
    KeySystem = false,
    KeySettings = {
        Title = "نظام المفتاح",
        Subtitle = "أدخل مفتاح الوصول",
        Note = "لا يلزم مفتاح في هذا الإصدار",
        FileName = "Key",
        SaveKey = false,
        GrabKeyFromSite = false,
        Actions = {
            [1] = {
                Text = "نسخ الرابط",
                OnPress = function()
                    setclipboard("https://github.com/yourrepo")
                end,
            }
        }
    }
})

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

-- متغيرات النظام
local isRunning = false
local selectedEnchant = availableEnchants[1]
local args = {6, 1}

-- تبويب التحكم الرئيسي
local MainTab = Window:CreateTab("التحكم", 13014546637) -- أيقونة جديدة

-- قسم الأنشنت
local EnchantSection = MainTab:CreateSection("إعدادات الأنشنت")

local EnchantDropdown = MainTab:CreateDropdown({
    Name = "الأنشنت المطلوب",
    Options = availableEnchants,
    CurrentOption = selectedEnchant,
    Flag = "EnchantTarget",
    Callback = function(Option)
        selectedEnchant = Option
        Rayfield:Notify({
            Title = "تم تحديد الهدف",
            Content = "سيتم البحث عن: " .. Option,
            Duration = 3,
            Image = 13014546637,
            Actions = {
                {
                    Name = "تم",
                    Callback = function() end
                },
            },
        })
    end,
})

-- قسم التشغيل
local ControlSection = MainTab:CreateSection("تحكم التشغيل")

local Toggle = MainTab:CreateToggle({
    Name = "التشغيل التلقائي",
    CurrentValue = false,
    Flag = "AutoEnchantToggle",
    Callback = function(Value)
        isRunning = Value
        if Value then
            StartEnchantLoop()
        end
    end,
})

-- تبويب الإعدادات المتقدمة
local SettingsTab = Window:CreateTab("الإعدادات المتقدمة", 13014546637)

local AdvancedSection = SettingsTab:CreateSection("المعلمات الفنية")

local ArgsInput = SettingsTab:CreateInput({
    Name = "وسائط الأنشنت",
    PlaceholderText = "أدخل الأرقام مفصولة بفاصلة (6,1)",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local parts = {}
        for part in Text:gmatch("[^,]+") do
            table.insert(parts, tonumber(part))
        end
        
        if #parts == 2 then
            args = parts
            Rayfield:Notify({
                Title = "تم التحديث",
                Content = "الوسائط الجديدة: " .. table.concat(args, ","),
                Duration = 3,
                Image = 13014546637,
            })
        end
    end,
})

-- تبويب المعلومات
local InfoTab = Window:CreateTab("المعلومات", 13014546637)

local InfoSection = InfoTab:CreateSection("معلومات النظام")

InfoTab:CreateLabel("الإصدار: 3.0.0")
InfoTab:CreateLabel("محرر السكريبت: Ｇんｏｓｔ 🥀")
InfoTab:CreateLabel("تاريخ البناء: " .. os.date("%Y/%m/%d"))

local Button = InfoTab:CreateButton({
    Name = "نسخ معلومات التصحيح",
    Callback = function()
        local debugInfo = string.format([[
            Auto Enchant Debug Info:
            Game: %s
            Player: %s
            Target Enchant: %s
            Args: %s,%s
            Time: %s
        ]], game.Name, game.Players.LocalPlayer.Name, selectedEnchant, args[1], args[2], os.date())
        
        setclipboard(debugInfo)
        Rayfield:Notify({
            Title = "تم النسخ",
            Content = "معلومات التصحيح جاهزة للاستخدام",
            Duration = 3,
            Image = 13014546637,
        })
    end,
})

-- متطلبات النظام
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- دالة التحقق من الأنشنت الحالي
local function GetCurrentEnchant()
    local success, result = pcall(function()
        local gui = Player.PlayerGui:FindFirstChild("ScreenGui")
        if not gui then return nil end
        
        local enchantFrame = gui:FindFirstChild("Enchant")
        if not enchantFrame then return nil end
        
        local slot = enchantFrame.Content.Slots:FindFirstChild("1")
        if not slot then return nil end
        
        local textElement = slot:FindFirstChild("EnchantName") or 
                          slot:FindFirstChildOfClass("TextLabel") or
                          slot:FindFirstChildOfClass("TextButton")
        
        return textElement and textElement.Text or nil
    end)
    
    if not success then
        warn("Error getting enchant:", result)
        return nil
    end
    
    return result
end

-- دالة تنفيذ الأنشنت
local function PerformEnchant()
    local success, result = pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return false end
        
        local enchantRemote = remotes:FindFirstChild("Enchant")
        if not enchantRemote then return false end
        
        enchantRemote:FireServer(unpack(args))
        return true
    end)
    
    if not success then
        warn("Enchant failed:", result)
        Rayfield:Notify({
            Title = "فشل التنفيذ",
            Content = tostring(result),
            Duration = 5,
            Image = 13014546637,
        })
        return false
    end
    
    return result
end

-- الحلقة الرئيسية
local function StartEnchantLoop()
    task.spawn(function()
        while isRunning do
            local current = GetCurrentEnchant()
            
            if current and string.find(current:lower(), selectedEnchant:lower(), 1, true) then
                isRunning = false
                Toggle:Set(false)
                
                Rayfield:Notify({
                    Title = "تم إنجاز المهمة",
                    Content = "تم الوصول إلى: " .. selectedEnchant,
                    Duration = 5,
                    Image = 13014546637,
                })
                break
            end
            
            if not PerformEnchant() then
                isRunning = false
                Toggle:Set(false)
                break
            end
            
            task.wait(0.7)
        end
    end)
end

-- تحميل الإعدادات
Rayfield:LoadConfiguration()

-- إشعار البدء
task.delay(2, function()
    Rayfield:Notify({
        Title = "النظام جاهز",
        Content = "يمكنك بدء استخدام نظام الأنشنت التلقائي",
        Duration = 5,
        Image = 13014546637,
    })
end)
