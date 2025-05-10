local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Mining World Script | By Ｇんｏｓｔ 🥀",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Welcome",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "Mining World",
       FileName = "Config"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false
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

-- متغيرات السكريبت
local isRunning = false
local selectedEnchant = availableEnchants[1]
local args = {6, 1}

-- تبويب رئيسي
local MainTab = Window:CreateTab("Main", 4483362458)

-- Dropdown لاختيار الأنشنت
local EnchantDropdown = MainTab:CreateDropdown({
    Name = "Select Enchant",
    Options = availableEnchants,
    CurrentOption = selectedEnchant,
    Flag = "EnchantSelection",
    Callback = function(Option)
        selectedEnchant = Option
        Rayfield:Notify({
            Title = "Seleced",
            Content = "The Target : " .. Option,
            Duration = 2,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Done",
                    Callback = function()
                    end
                },
            },
        })
    end,
})

-- زر التشغيل/الإيقاف
local ToggleButton = MainTab:CreateToggle({
    Name = "Auto Enchant",
    CurrentValue = false,
    Flag = "AutoEnchantToggle",
    Callback = function(Value)
        isRunning = Value
        if Value then
            Rayfield:Notify({
                Title = "Turn On",
                Content = "Looking For: " .. selectedEnchant,
                Duration = 3,
                Image = 4483362458,
            })
            enchantLoop()
        else
            Rayfield:Notify({
                Title = "Turn Off",
                Content = "Stop Auto Enchant Done ✅",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- قسم الإعدادات
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- إعدادات الـ Enchant
SettingsTab:CreateInput({
    Name = "Edit Enchant Args",
    PlaceholderText = "Example : 6,1",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local success, err = pcall(function()
            local parts = string.split(Text, ",")
            args = {tonumber(parts[1]), tonumber(parts[2])}
        end)
        if not success then
            Rayfield:Notify({
                Title = "Error While Inserting",
                Content = "Use Right Numbers",
                Duration = 5,
                Image = 4483362458,
            })
        end
    end,
})

-- دالة محسنة للتحقق من السحر الحالي
local function getCurrentEnchant()
    local success, result = pcall(function()
        local slot = Player.PlayerGui.ScreenGui.Enchant.Content.Slots["1"]
        local textElement = slot:FindFirstChild("EnchantName") or 
                          slot:FindFirstChildOfClass("TextLabel") or
                          slot:FindFirstChildOfClass("TextButton")
        return textElement and textElement.Text or ""
    end)
    return success and result or ""
end

-- دالة ذكية للمقارنة
local function isTargetReached(current, target)
    local clean = function(text)
        return text:gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1"):lower()
    end
    return clean(current) == clean(target)
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
        Rayfield:Notify({
            Title = "Error While Process",
            Content = tostring(errorMsg),
            Duration = 5,
            Image = 4483362458,
        })
        return false
    end
    return true
end

-- الحلقة الرئيسية
local function enchantLoop()
    while isRunning and task.wait(0.7) do
        local currentEnchant = getCurrentEnchant()
        
        if isTargetReached(currentEnchant, selectedEnchant) then
            isRunning = false
            ToggleButton:Set(false)
            
            Rayfield:Notify({
                Title = "Reach Selected Enchant",
                Content = "Got : " .. selectedEnchant,
                Duration = 5,
                Image = 4483362458,
            })
            break
        end
        
        if not performEnchant() then
            isRunning = false
            ToggleButton:Set(false)
            break
        end
    end
end

-- قسم المعلومات
local InfoTab = Window:CreateTab("Information")

InfoTab:CreateLabel("Mining World Script")
InfoTab:CreateLabel("By : Ｇんｏｓｔ ")

InfoTab:CreateButton({
    Name = "Copy Source Code",
    Callback = function()
        setclipboard("Fuck Off Nigga")
        Rayfield:Notify({
            Title = "Copy",
            Content = "Copied",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- تحميل الإعدادات المحفوظة
Rayfield:LoadConfiguration()
