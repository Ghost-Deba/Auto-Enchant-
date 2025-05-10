-- Roblox Lua Script - Mobile-Friendly Auto Enchant UI 
local Players = game:GetService("Players") local ReplicatedStorage = game:GetService("ReplicatedStorage") local Player = Players.LocalPlayer local PlayerGui = Player:WaitForChild("PlayerGui")

-- Enchant options 
local availableEnchants = { "Magic Ores", "Incredible Damage", "Deadly Damage++", "Deadly Damage", "More Damage", "Light Damage", "Incredible Luck", "Mighty Luck++", "Mighty Luck", "Considerable Luck", "Abnormal Speed" }

-- UI local 
screenGui = Instance.new("ScreenGui") screenGui.Name = "AutoEnchantUI" screenGui.Parent = PlayerGui

local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 250, 0, 200) frame.Position = UDim2.new(1, -260, 0.3, 0) frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) frame.BorderSizePixel = 0 frame.Parent = screenGui

local titleBar = Instance.new("Frame") titleBar.Size = UDim2.new(1, 0, 0, 30) titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60) titleBar.Parent = frame

local title = Instance.new("TextLabel") title.Text = "Auto Enchanter" title.Size = UDim2.new(1, -30, 1, 0) title.Position = UDim2.new(0, 5, 0, 0) title.TextColor3 = Color3.new(1, 1, 1) title.BackgroundTransparency = 1 title.TextXAlignment = Enum.TextXAlignment.Left title.Font = Enum.Font.SourceSansBold title.TextSize = 18 title.Parent = titleBar

local minimizeButton = Instance.new("TextButton") minimizeButton.Text = "–" minimizeButton.Size = UDim2.new(0, 30, 1, 0) minimizeButton.Position = UDim2.new(1, -30, 0, 0) minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) minimizeButton.TextColor3 = Color3.new(1, 1, 1) minimizeButton.Parent = titleBar

local dropdown = Instance.new("TextButton") dropdown.Text = "Choose Enchant ▼" dropdown.Size = UDim2.new(0.9, 0, 0, 30) dropdown.Position = UDim2.new(0.05, 0, 0, 40) dropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80) dropdown.TextColor3 = Color3.new(1, 1, 1) dropdown.Parent = frame

local dropdownFrame = Instance.new("Frame") dropdownFrame.Size = UDim2.new(0.9, 0, 0, 0) dropdownFrame.Position = UDim2.new(0.05, 0, 0, 70) dropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) dropdownFrame.Visible = false dropdownFrame.Parent = frame

local layout = Instance.new("UIListLayout") layout.Parent = dropdownFrame

local toggleButton = Instance.new("TextButton") toggleButton.Text = "OFF" toggleButton.Size = UDim2.new(0.9, 0, 0, 40) toggleButton.Position = UDim2.new(0.05, 0, 1, -50) toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60) toggleButton.TextColor3 = Color3.new(1, 1, 1) toggleButton.Parent = frame

local statusLabel = Instance.new("TextLabel") statusLabel.Text = "Waiting..." statusLabel.Size = UDim2.new(1, 0, 0, 20) statusLabel.Position = UDim2.new(0, 0, 1, -20) statusLabel.BackgroundTransparency = 1 statusLabel.TextColor3 = Color3.new(1, 1, 1) statusLabel.TextScaled = true statusLabel.Parent = frame

-- State variables 
local isRunning = false local selectedEnchant = availableEnchants[1] local args = {6, 1}

-- Dropdown setup 
for _, enchant in ipairs(availableEnchants) do local option = Instance.new("TextButton") option.Text = enchant option.Size = UDim2.new(1, 0, 0, 30) option.BackgroundColor3 = Color3.fromRGB(70, 70, 70) option.TextColor3 = Color3.fromRGB(255, 255, 255) option.Parent = dropdownFrame

option.MouseButton1Click:Connect(function()
    selectedEnchant = enchant
    dropdown.Text = enchant .. " ▼"
    dropdownFrame.Visible = false
    dropdownFrame.Size = UDim2.new(0.9, 0, 0, 0)
end)

end

dropdown.MouseButton1Click:Connect(function() dropdownFrame.Visible = not dropdownFrame.Visible if dropdownFrame.Visible then dropdownFrame.Size = UDim2.new(0.9, 0, 0, #availableEnchants * 30) else dropdownFrame.Size = UDim2.new(0.9, 0, 0, 0) end end)

-- Enchant logic 
local function getCurrentEnchant() local success, result = pcall(function() return Player.PlayerGui.ScreenGui.Enchant.Content.Slots["1"].EnchantName.Text end) return success and result or "" end

local function performEnchant() local success, errorMsg = pcall(function() local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Enchant") if remote then remote:FireServer(unpack(args)) return true end return false end) if not success then statusLabel.Text = "Error: " .. tostring(errorMsg) return false end return true end

local function enchantLoop() while isRunning do local currentEnchant = getCurrentEnchant() if currentEnchant == selectedEnchant then statusLabel.Text = "Reached: " .. selectedEnchant isRunning = false toggleButton.Text = "OFF" toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60) break end

statusLabel.Text = "Current: " .. currentEnchant

    if not performEnchant() then
        isRunning = false
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        break
    end
    task.wait(0.5)
end

end

toggleButton.MouseButton1Click:Connect(function() isRunning = not isRunning if isRunning then toggleButton.Text = "ON" toggleButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60) statusLabel.Text = "Running..." task.spawn(enchantLoop) else toggleButton.Text = "OFF" toggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60) statusLabel.Text = "Stopped" end end)

-- Dragging support 
local dragging, dragStart, startPos local function update(input) local delta = input.Position - dragStart frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end

titleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = frame.Position

input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then dragging = false end
    end)
end

end)

titleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then if dragging then update(input) end end end)

game:GetService("UserInputService").InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)

-- Minimize toggle 
local isMinimized = false minimizeButton.MouseButton1Click:Connect(function() isMinimized = not isMinimized for _, child in ipairs(frame:GetChildren()) do if child ~= titleBar then child.Visible = not isMinimized end end end)
