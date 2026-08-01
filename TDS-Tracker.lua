--========================================================
-- TDS-Tracker Universal Lite
-- Coins + Gems + EXP + Runtime + Coins/Hour + Gems/Hour
-- Ringan: event-based, tanpa Heartbeat, tanpa scan berulang.
-- Tempelkan di bagian paling atas macro Anda.
--========================================================

local Players = game:GetService("Players")
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
local SessionGems = 0
local SessionEXP = 0
local StartTime = os.clock()

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
MainFrame.Size = UDim2.fromOffset(330, 245)
MainFrame.Position = UDim2.new(0, 18, 0, 120)
MainFrame.BackgroundColor3 = Color3.fromRGB(27, 26, 39)
MainFrame.BorderSizePixel = 0
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
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = Color3.fromRGB(95, 76, 150)
Header.BorderSizePixel = 0
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
Title.TextSize = 21
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Info = Instance.new("TextLabel")
Info.Name = "Info"
Info.Position = UDim2.fromOffset(18, 58)
Info.Size = UDim2.new(1, -36, 1, -72)
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
    local gemsPerHour = 0

    if runtime > 0 then
        coinsPerHour = math.floor((SessionCoins / runtime) * 3600)
        gemsPerHour = math.floor((SessionGems / runtime) * 3600)
    end

    Info.Text = string.format(
        "<font color='#FFD65A'>Coins</font>        : %s\n" ..
        "<font color='#D38CFF'>Gems</font>         : %s\n" ..
        "<font color='#7FE39A'>EXP</font>          : %s\n\n" ..
        "<font color='#7FC8FF'>Runtime</font>      : %s\n" ..
        "<font color='#FFB86C'>Coins/Hour</font>   : %s\n" ..
        "<font color='#C79CFF'>Gems/Hour</font>    : %s",
        FormatNumber(SessionCoins),
        FormatNumber(SessionGems),
        FormatNumber(SessionEXP),
        FormatTime(runtime),
        FormatNumber(coinsPerHour),
        FormatNumber(gemsPerHour)
    )
end

UpdateDisplay()

-- Hanya memperbarui tampilan setiap 10 detik.
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(10)
        UpdateDisplay()
    end
end)

--========================================================
-- PEMBACA REWARD EVENT-BASED
--========================================================

local BoundRewardScreens = {}

local function ReadRewardValues(rewardsScreen)
    local rewardsSection = rewardsScreen:FindFirstChild("RewardsSection")
    if not rewardsSection then
        return 0, 0, 0
    end

    local foundCoins = 0
    local foundGems = 0
    local foundEXP = 0

    -- Scan hanya satu kali saat layar reward muncul.
    for _, object in ipairs(rewardsSection:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local text = tostring(object.Text or "")
            local lower = text:lower()
            local value = ExtractNumber(text)

            if value > 0 then
                if lower:find("coin", 1, true)
                    or lower:find("gold", 1, true) then

                    foundCoins = math.max(foundCoins, value)

                elseif lower:find("gem", 1, true) then
                    foundGems = math.max(foundGems, value)

                elseif lower:find("xp", 1, true)
                    or lower:find("experience", 1, true)
                    or lower:find("exp", 1, true) then

                    foundEXP = math.max(foundEXP, value)
                end
            end
        end
    end

    -- Fallback tracker asli: container "1" biasanya EXP.
    if foundEXP == 0 then
        local containerEXP = rewardsSection:FindFirstChild("1")
        local icon1 = containerEXP and containerEXP:FindFirstChild("icon")
        local icon2 = icon1 and icon1:FindFirstChild("icon")
        local label = icon2 and icon2:FindFirstChild("textLabel")

        if label and (label:IsA("TextLabel") or label:IsA("TextButton")) then
            foundEXP = ExtractNumber(label.Text)
        end
    end

    return foundCoins, foundGems, foundEXP
end

local function BindRewardScreen(rewardsScreen)
    if not rewardsScreen
        or BoundRewardScreens[rewardsScreen]
        or not rewardsScreen:IsA("GuiObject") then
        return
    end

    BoundRewardScreens[rewardsScreen] = true
    local countedThisAppearance = false

    local function TryCountReward()
        if not rewardsScreen.Parent
            or not rewardsScreen.Visible
            or countedThisAppearance then
            return
        end

        countedThisAppearance = true

        -- Beri waktu agar React selesai mengisi semua angka.
        task.delay(1.25, function()
            if not rewardsScreen.Parent or not rewardsScreen.Visible then
                countedThisAppearance = false
                return
            end

            local coins, gems, exp = ReadRewardValues(rewardsScreen)

            SessionCoins = SessionCoins + coins
            SessionGems = SessionGems + gems
            SessionEXP = SessionEXP + exp

            UpdateDisplay()
        end)
    end

    rewardsScreen:GetPropertyChangedSignal("Visible"):Connect(function()
        if rewardsScreen.Visible then
            TryCountReward()
        else
            countedThisAppearance = false
        end
    end)

    rewardsScreen.AncestryChanged:Connect(function(_, parent)
        if not parent then
            BoundRewardScreens[rewardsScreen] = nil
        end
    end)

    if rewardsScreen.Visible then
        TryCountReward()
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

    -- React bisa membangun ulang RewardsScreen.
    root.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "RewardsScreen"
            and descendant:IsA("GuiObject") then
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
