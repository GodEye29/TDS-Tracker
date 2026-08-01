--========================================================
-- TDS-Tracker Lite v2
-- Fokus: ringan, sederhana, tanpa Heartbeat/GetDescendants loop.
-- Tempelkan di bagian paling atas macro TDS Anda.
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Hapus tracker lama jika script dijalankan ulang.
local oldGui = PlayerGui:FindFirstChild("TDS_Tracker")
if oldGui then
    oldGui:Destroy()
end

--========================================================
-- DATA SESI
--========================================================

local SessionCoins = 0
local SessionXP = 0
local StartTime = os.clock()

local LastRewardSignature = nil
local RewardScreenVisible = false
local BoundRewardScreens = {}

local function ExtractNumber(text)
    if type(text) ~= "string" then
        return 0
    end

    local cleaned = text:gsub(",", "")
    local number = cleaned:match("%d+")
    return tonumber(number) or 0
end

local function FormatNumber(number)
    local text = tostring(math.floor(number or 0))

    while true do
        local formatted, count = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        text = formatted
        if count == 0 then
            break
        end
    end

    return text
end

local function FormatTime(seconds)
    seconds = math.max(0, math.floor(seconds or 0))

    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function GetNestedRewardLabel(container)
    if not container then
        return nil
    end

    local icon1 = container:FindFirstChild("icon")
    local icon2 = icon1 and icon1:FindFirstChild("icon")
    local label = icon2 and icon2:FindFirstChild("textLabel")

    if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
        return label
    end

    return nil
end

--========================================================
-- GUI SEDERHANA
--========================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TDS_Tracker"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(310, 185)
MainFrame.Position = UDim2.new(0, 18, 0, 120)
MainFrame.BackgroundColor3 = Color3.fromRGB(27, 26, 39)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(72, 67, 98)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(95, 76, 150)
Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = Header.BackgroundColor3
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "TDS TRACKER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Info = Instance.new("TextLabel")
Info.Name = "Info"
Info.Position = UDim2.fromOffset(18, 56)
Info.Size = UDim2.new(1, -36, 1, -68)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.fromRGB(238, 238, 245)
Info.Font = Enum.Font.GothamMedium
Info.TextSize = 18
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.RichText = true
Info.Parent = MainFrame

local function UpdateDisplay()
    local runtime = os.clock() - StartTime
    local coinsPerHour = 0

    if runtime > 0 then
        coinsPerHour = math.floor((SessionCoins / runtime) * 3600)
    end

    Info.Text = string.format(
        "<font color='#FFD65A'>Coins</font>       : %s\n" ..
        "<font color='#7FE39A'>EXP</font>          : %s\n\n" ..
        "<font color='#7FC8FF'>Runtime</font>      : %s\n" ..
        "<font color='#FFB86C'>Coins/Hour</font>   : %s",
        FormatNumber(SessionCoins),
        FormatNumber(SessionXP),
        FormatTime(runtime),
        FormatNumber(coinsPerHour)
    )
end

UpdateDisplay()

-- Update tampilan hanya setiap 10 detik.
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(10)
        UpdateDisplay()
    end
end)

-- Drag hanya pada header.
local dragging = false
local dragStart = nil
local startPosition = nil
local dragInput = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart

        MainFrame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

--========================================================
-- PEMBACA REWARD EVENT-BASED
-- Tidak ada Heartbeat dan tidak scan seluruh PlayerGui.
--========================================================

local function ReadRewardValues(rewardsScreen)
    local rewardsSection = rewardsScreen:FindFirstChild("RewardsSection")
    if not rewardsSection then
        return 0, 0, nil
    end

    local foundCoins = 0
    local foundXP = 0
    local signatureParts = {}

    -- RewardsSection biasanya hanya memiliki beberapa container reward.
    for _, container in ipairs(rewardsSection:GetChildren()) do
        local label = GetNestedRewardLabel(container)

        if label then
            local text = tostring(label.Text or "")
            local lower = text:lower()
            local value = ExtractNumber(text)

            table.insert(signatureParts, container.Name .. "=" .. text)

            if value > 0 then
                if lower:find("coin", 1, true) or lower:find("gold", 1, true) then
                    foundCoins = math.max(foundCoins, value)
                elseif lower:find("xp", 1, true)
                    or lower:find("experience", 1, true)
                    or lower:find("exp", 1, true) then
                    foundXP = math.max(foundXP, value)
                end
            end
        end
    end

    -- Fallback dari struktur tracker asli:
    -- container "1" biasanya XP.
    if foundXP == 0 then
        local xpLabel = GetNestedRewardLabel(rewardsSection:FindFirstChild("1"))
        if xpLabel then
            foundXP = ExtractNumber(xpLabel.Text)
        end
    end

    -- Jika container Coins tidak menyertakan kata "Coins",
    -- pilih reward numerik non-XP terbesar dari container lain.
    if foundCoins == 0 then
        for _, container in ipairs(rewardsSection:GetChildren()) do
            if container.Name ~= "1" then
                local label = GetNestedRewardLabel(container)
                if label then
                    local value = ExtractNumber(label.Text)
                    if value > foundCoins then
                        foundCoins = value
                    end
                end
            end
        end
    end

    table.sort(signatureParts)
    local signature = table.concat(signatureParts, "|")

    return foundCoins, foundXP, signature
end

local function ProcessRewardScreen(rewardsScreen)
    if not rewardsScreen
        or not rewardsScreen.Parent
        or not rewardsScreen.Visible
        or RewardScreenVisible then
        return
    end

    RewardScreenVisible = true

    -- Tunggu React selesai mengisi text reward.
    task.delay(1, function()
        if not rewardsScreen.Parent or not rewardsScreen.Visible then
            return
        end

        local coins, xp, signature = ReadRewardValues(rewardsScreen)

        -- Cegah reward yang sama dihitung dua kali.
        if signature and signature ~= "" and signature ~= LastRewardSignature then
            LastRewardSignature = signature
            SessionCoins = SessionCoins + coins
            SessionXP = SessionXP + xp
            UpdateDisplay()
        end
    end)
end

local function BindRewardScreen(rewardsScreen)
    if not rewardsScreen
        or BoundRewardScreens[rewardsScreen]
        or not rewardsScreen:IsA("GuiObject") then
        return
    end

    BoundRewardScreens[rewardsScreen] = true

    rewardsScreen:GetPropertyChangedSignal("Visible"):Connect(function()
        if rewardsScreen.Visible then
            ProcessRewardScreen(rewardsScreen)
        else
            RewardScreenVisible = false
            LastRewardSignature = nil
        end
    end)

    rewardsScreen.AncestryChanged:Connect(function(_, parent)
        if not parent then
            BoundRewardScreens[rewardsScreen] = nil
            RewardScreenVisible = false
        end
    end)

    if rewardsScreen.Visible then
        ProcessRewardScreen(rewardsScreen)
    end
end

local function InspectRewardRoot(root)
    if not root or root.Name ~= "ReactGameNewRewards" then
        return
    end

    local frame = root:FindFirstChild("Frame")
    local gameOver = frame and frame:FindFirstChild("gameOver")
    local rewardsScreen = gameOver and gameOver:FindFirstChild("RewardsScreen")

    if rewardsScreen then
        BindRewardScreen(rewardsScreen)
    end

    -- React kadang membangun ulang child-nya.
    root.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "RewardsScreen" and descendant:IsA("GuiObject") then
            BindRewardScreen(descendant)
        end
    end)
end

local existingRoot = PlayerGui:FindFirstChild("ReactGameNewRewards")
if existingRoot then
    InspectRewardRoot(existingRoot)
end

PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "ReactGameNewRewards" then
        InspectRewardRoot(child)
    end
end)
