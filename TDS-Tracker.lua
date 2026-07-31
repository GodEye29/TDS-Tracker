--========================================================
-- TDS-Tracker (Simple)
-- Menampilkan Coins, EXP, Runtime, dan Coins per Hour.
-- Tempelkan seluruh isi file ini di bagian paling atas macro.
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local oldGui = PlayerGui:FindFirstChild("TDS_Tracker")
if oldGui then
    oldGui:Destroy()
end

local SessionCoins = 0
local SessionXP = 0
local StartTime = os.clock()
local RewardAlreadyCounted = false

local function FormatNumber(number)
    local text = tostring(math.floor(number or 0))
    while true do
        local formatted, count = text:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        text = formatted
        if count == 0 then break end
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

local function ExtractNumber(text)
    if type(text) ~= "string" then return 0 end
    local cleaned = text:gsub(",", "")
    local number = cleaned:match("%d+")
    return tonumber(number) or 0
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TDS_Tracker"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(310, 190)
MainFrame.Position = UDim2.new(0, 18, 0, 120)
MainFrame.BackgroundColor3 = Color3.fromRGB(27, 26, 39)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(76, 70, 105)
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

local Dragging = false
local DragStart
local StartPosition
local DragInput

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPosition = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Dragging and input == DragInput then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end
end)

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

task.spawn(function()
    while ScreenGui.Parent do
        task.wait(10)
        UpdateDisplay()
    end
end)

local function GetRewardsScreen()
    local reactGame = PlayerGui:FindFirstChild("ReactGameNewRewards")
    if not reactGame then return nil end

    local frame = reactGame:FindFirstChild("Frame")
    if not frame or not frame.Visible then return nil end

    local gameOver = frame:FindFirstChild("gameOver")
    if not gameOver or not gameOver.Visible then return nil end

    local rewardsScreen = gameOver:FindFirstChild("RewardsScreen")
    if not rewardsScreen or not rewardsScreen.Visible then return nil end

    return rewardsScreen
end

local function ReadRewardValues(rewardsScreen)
    local rewardsSection = rewardsScreen:FindFirstChild("RewardsSection")
    if not rewardsSection then return 0, 0 end

    local foundCoins = 0
    local foundXP = 0

    for _, object in ipairs(rewardsSection:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local text = object.Text or ""
            local lower = text:lower()
            local value = ExtractNumber(text)

            if value > 0 then
                if lower:find("coin") or lower:find("gold") then
                    foundCoins = math.max(foundCoins, value)
                elseif lower:find("xp") or lower:find("experience") or lower:find("exp") then
                    foundXP = math.max(foundXP, value)
                end
            end
        end
    end

    if foundXP == 0 then
        local containerXP = rewardsSection:FindFirstChild("1")
        local xpLabel = containerXP
            and containerXP:FindFirstChild("icon")
            and containerXP.icon:FindFirstChild("icon")
            and containerXP.icon.icon:FindFirstChild("textLabel")

        if xpLabel and xpLabel:IsA("TextLabel") then
            foundXP = ExtractNumber(xpLabel.Text)
        end
    end

    if foundCoins == 0 then
        for _, container in ipairs(rewardsSection:GetChildren()) do
            if container.Name ~= "1" then
                local label = container:FindFirstChild("icon")
                    and container.icon:FindFirstChild("icon")
                    and container.icon.icon:FindFirstChild("textLabel")

                if label and label:IsA("TextLabel") then
                    local lower = label.Text:lower()
                    if lower:find("coin") or lower:find("gold") then
                        foundCoins = math.max(foundCoins, ExtractNumber(label.Text))
                    end
                end
            end
        end
    end

    return foundCoins, foundXP
end

task.spawn(function()
    while ScreenGui.Parent do
        local rewardsScreen = GetRewardsScreen()

        if rewardsScreen then
            if not RewardAlreadyCounted then
                task.wait(1)
                rewardsScreen = GetRewardsScreen()

                if rewardsScreen then
                    local coins, xp = ReadRewardValues(rewardsScreen)
                    SessionCoins = SessionCoins + coins
                    SessionXP = SessionXP + xp
                    RewardAlreadyCounted = true
                    UpdateDisplay()
                end
            end
        else
            RewardAlreadyCounted = false
        end

        task.wait(1)
    end
end)
