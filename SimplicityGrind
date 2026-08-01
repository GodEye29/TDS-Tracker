local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DynamicRewardTracker"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 225)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false 
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(55, 55, 75)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopGradient = Instance.new("UIGradient")
TopGradient.Color = ColorSequence.new(Color3.fromRGB(74, 144, 226), Color3.fromRGB(142, 68, 173))
TopGradient.Parent = TopBar

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -55, 1, 0) 
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "✨ MATCH TRACKER"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 3)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = MainFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 15)
UIPadding.PaddingLeft = UDim.new(0, 15)
UIPadding.PaddingRight = UDim.new(0, 15)
UIPadding.Parent = MainFrame

local function CreateRow(name, defaultText, layoutOrder)
    local Row = Instance.new("TextLabel")
    Row.Name = name
    Row.Size = UDim2.new(1, 0, 0, 24)
    Row.BackgroundTransparency = 1
    Row.Text = defaultText
    Row.TextColor3 = Color3.fromRGB(220, 220, 230)
    Row.Font = Enum.Font.GothamMedium
    Row.TextSize = 13
    Row.TextXAlignment = Enum.TextXAlignment.Left
    Row.RichText = true
    Row.LayoutOrder = layoutOrder
    Row.Parent = MainFrame
    return Row
end

local EarnedCoinsLabel = CreateRow("EarnedCoins", "Total Earned: <font color='#FFDF00'>0 Coins</font>", 1)
local MatchCoinsLabel  = CreateRow("MatchCoins", "Last Reward: <font color='#D4AF37'>0 Coins</font>", 2)
local EarnedXpLabel   = CreateRow("EarnedXP", "Total Exp: <font color='#2ECC71'>0 XP</font>", 3)
local MatchXpLabel    = CreateRow("MatchXP", "Last Reward: <font color='#27AE60'>0 XP</font>", 4)
local PlaytimeLabel   = CreateRow("Playtime", "Total Playtime: <font color='#5DADE2'>0:00</font>", 5)

-- Footer separator
local FooterLine = Instance.new("Frame")
FooterLine.Name = "FooterLine"
FooterLine.Size = UDim2.new(1, 0, 0, 1)
FooterLine.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
FooterLine.BorderSizePixel = 0
FooterLine.LayoutOrder = 6
FooterLine.Parent = MainFrame

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Name = "UsernameLabel"
UsernameLabel.Size = UDim2.new(1, 0, 0, 30)
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Text = "Yahahaha Emir ganteng"
UsernameLabel.TextColor3 = Color3.fromRGB(155, 155, 185)
UsernameLabel.Font = Enum.Font.GothamBold
UsernameLabel.TextSize = 12
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Center 
UsernameLabel.LayoutOrder = 7
UsernameLabel.Parent = MainFrame

local PlusButton = Instance.new("TextButton")
PlusButton.Name = "PlusButton"
PlusButton.Size = UDim2.new(0, 25, 0, 25)
PlusButton.Position = UDim2.new(1, -30, 0, 5)
PlusButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlusButton.BackgroundTransparency = 0.85
PlusButton.Text = "+"
PlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusButton.Font = Enum.Font.GothamBold
PlusButton.TextSize = 16
PlusButton.ZIndex = 5
PlusButton.Parent = TopBar

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = PlusButton

local PopupFrame = Instance.new("Frame")
PopupFrame.Name = "PopupFrame"
PopupFrame.Size = UDim2.new(0, 200, 0, 80)
PopupFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
PopupFrame.BorderSizePixel = 0
PopupFrame.ClipsDescendants = true
PopupFrame.Visible = false
PopupFrame.Parent = ScreenGui 

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(0, 8)
PopupCorner.Parent = PopupFrame

local PopupStroke = Instance.new("UIStroke")
PopupStroke.Color = Color3.fromRGB(142, 68, 173) 
PopupStroke.Thickness = 1.5
PopupStroke.Parent = PopupFrame

local PopupListLayout = Instance.new("UIListLayout")
PopupListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PopupListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
PopupListLayout.Padding = UDim.new(0, 2)
PopupListLayout.Parent = PopupFrame

local PopupPadding = Instance.new("UIPadding")
PopupPadding.PaddingTop = UDim.new(0, 10)
PopupPadding.PaddingBottom = UDim.new(0, 10)
PopupPadding.Parent = PopupFrame

local PopupTitle = Instance.new("TextLabel")
PopupTitle.Name = "PopupTitle"
PopupTitle.Size = UDim2.new(1, 0, 0, 20)
PopupTitle.BackgroundTransparency = 1
PopupTitle.Text = "= Contributors ="
PopupTitle.TextColor3 = Color3.fromRGB(180, 180, 200)
PopupTitle.Font = Enum.Font.GothamBold
PopupTitle.TextSize = 13
PopupTitle.Parent = PopupFrame

-- FIX: Gave unique variable names to popup items so all elements fade correctly
local Contributor1 = Instance.new("TextLabel")
Contributor1.Name = "PopupName"
Contributor1.Size = UDim2.new(1, 0, 0, 20)
Contributor1.BackgroundTransparency = 1
Contributor1.Text = "Yuka Jelek"
Contributor1.TextColor3 = Color3.fromRGB(240, 240, 255)
Contributor1.Font = Enum.Font.GothamBold
Contributor1.TextSize = 15
Contributor1.Parent = PopupFrame

local Contributor2 = Instance.new("TextLabel")
Contributor2.Name = "PopupName"
Contributor2.Size = UDim2.new(1, 0, 0, 20)
Contributor2.BackgroundTransparency = 1
Contributor2.Text = "Dapa juga"
Contributor2.TextColor3 = Color3.fromRGB(240, 240, 255)
Contributor2.Font = Enum.Font.GothamBold
Contributor2.TextSize = 15
Contributor2.Parent = PopupFrame

local Contributor3 = Instance.new("TextLabel")
Contributor3.Name = "PopupName"
Contributor3.Size = UDim2.new(1, 0, 0, 20)
Contributor3.BackgroundTransparency = 1
Contributor3.Text = "Apalagi Kayla"
Contributor3.TextColor3 = Color3.fromRGB(240, 240, 255)
Contributor3.Font = Enum.Font.GothamBold
Contributor3.TextSize = 15
Contributor3.Parent = PopupFrame

local function UpdatePopupPosition()
    PopupFrame.Position = UDim2.new(
        MainFrame.Position.X.Scale, 
        MainFrame.Position.X.Offset + MainFrame.AbsoluteSize.X + 15, 
        MainFrame.Position.Y.Scale, 
        MainFrame.Position.Y.Offset
    )
end

local popupOpen = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local closeTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

PlusButton.MouseButton1Click:Connect(function()
    popupOpen = not popupOpen
    
    if popupOpen then
        UpdatePopupPosition()
        PopupFrame.Visible = true
        PopupFrame.Size = UDim2.new(0, 200, 0, 0)
        PopupFrame.BackgroundTransparency = 1
        PopupTitle.TextTransparency = 1
        Contributor1.TextTransparency = 1
        Contributor2.TextTransparency = 1
        Contributor3.TextTransparency = 1
        
        TweenService:Create(PopupFrame, tweenInfo, {Size = UDim2.new(0, 200, 0, 100), BackgroundTransparency = 0}):Play()
        TweenService:Create(PopupTitle, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(Contributor1, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(Contributor2, tweenInfo, {TextTransparency = 0}):Play()
        TweenService:Create(Contributor3, tweenInfo, {TextTransparency = 0}):Play()
        PlusButton.Text = "×" 
    else
        local closeTween = TweenService:Create(PopupFrame, closeTweenInfo, {Size = UDim2.new(0, 200, 0, 0), BackgroundTransparency = 1})
        TweenService:Create(PopupTitle, closeTweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(Contributor1, closeTweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(Contributor2, closeTweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(Contributor3, closeTweenInfo, {TextTransparency = 1}):Play()
        
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not popupOpen then PopupFrame.Visible = false end
        end)
        PlusButton.Text = "+"
    end
end)

local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    UpdatePopupPosition() 
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

local SessionCoins, SessionXP, TotalSeconds = 0, 0, 0
local LastMatchState = false

task.spawn(function()
    while true do
        task.wait(1)
        TotalSeconds = TotalSeconds + 1
        local minutes = math.floor(TotalSeconds / 60)
        local seconds = TotalSeconds % 60
        PlaytimeLabel.Text = string.format("Total Playtime: <font color='#5DADE2'>%d:%02d</font>", minutes, seconds)
    end
end)

local function GetMatchStatus()
    local uiRoot = PlayerGui:FindFirstChild("ReactGameNewRewards")
    if not uiRoot then return nil end

    local mainFrame = uiRoot:FindFirstChild("Frame")
    if not mainFrame or not mainFrame.Visible then return nil end

    local gameOver = mainFrame:FindFirstChild("gameOver")
    if not gameOver or not gameOver.Visible then return nil end

    local rewardsScreen = gameOver:FindFirstChild("RewardsScreen")
    if not rewardsScreen or not rewardsScreen.Visible then return nil end

    local topBanner = rewardsScreen:FindFirstChild("RewardBanner")
    if not topBanner then return nil end

    local label = topBanner:FindFirstChild("textLabel") or topBanner:FindFirstChildOfClass("TextLabel")
    if not label then return nil end

    local txt = label.Text:upper()
    if txt == "" then return nil end

    if txt:find("TRIUMPH") or txt:find("VICTORY") or txt:find("WIN") then
        return "WIN"
    elseif txt:find("LOST") or txt:find("DEFEAT") or txt:find("FAIL") then
        return "LOSS"
    end
    return nil
end

local function ExtractNumber(text)
    if not text then return 0 end
    local cleaned = text:gsub(",", ""):match("%d+")
    return cleaned and tonumber(cleaned) or 0
end

RunService.Heartbeat:Connect(function()
    local matchStatus = GetMatchStatus()
    
    if matchStatus then
        if not LastMatchState then
            LastMatchState = true
            
            local reactGame = PlayerGui:FindFirstChild("ReactGameNewRewards")
            local mainFrame = reactGame and reactGame:FindFirstChild("Frame")
            local gameOver = mainFrame and mainFrame:FindFirstChild("gameOver")
            local rewardsScreen = gameOver and gameOver:FindFirstChild("RewardsScreen")
            local RewardsSection = rewardsScreen and rewardsScreen:FindFirstChild("RewardsSection")
            
            if not RewardsSection then return end
            
            local containerCoins = RewardsSection:FindFirstChild("5")
            local containerXP = RewardsSection:FindFirstChild("2")
            
            local coinLabelObj = containerCoins and containerCoins:FindFirstChild("icon") and containerCoins.icon:FindFirstChild("icon") and containerCoins.icon.icon:FindFirstChild("textLabel")
            local xpLabelObj = containerXP and containerXP:FindFirstChild("icon") and containerXP.icon:FindFirstChild("icon") and containerXP.icon.icon:FindFirstChild("textLabel")
            
            local parsedCoins = 0
            local parsedXP = 0
            
            -- FIX: Standardized the Coin text extraction with ExtractNumber
            if coinLabelObj then
                local text = coinLabelObj.Text:lower()
                if text:find("coins") or text:find("coin") then
                    parsedCoins = ExtractNumber(coinLabelObj.Text)
                end
            end
            
            if xpLabelObj then
                parsedXP = ExtractNumber(xpLabelObj.Text)
            end
            
            SessionCoins = SessionCoins + parsedCoins
            SessionXP = SessionXP + parsedXP
            
            MatchCoinsLabel.Text = string.format("Last Reward: <font color='#D4AF37'>%d Coins</font>", parsedCoins)
            EarnedCoinsLabel.Text = string.format("Total Earned: <font color='#FFDF00'>%d Coins</font>", SessionCoins)
            
            MatchXpLabel.Text = string.format("Last Reward: <font color='#27AE60'>%d XP</font>", parsedXP)
            EarnedXpLabel.Text = string.format("Total Exp: <font color='#2ECC71'>%d XP</font>", SessionXP)
            
            TweenService:Create(UIStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Color = Color3.fromRGB(46, 204, 113)}):Play()
            task.delay(0.6, function()
                TweenService:Create(UIStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Color = Color3.fromRGB(55, 55, 75)}):Play()
            end)
        end
    else
        LastMatchState = false
    end
end)

local TDS = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/auto-strat/refs/heads/main/Library.lua"))()

TDS:Loadout("Shotgunner", "Crook Boss", "Minigunner", "Scout", "Soldier")
TDS:Mode("Frost")
TDS:GameInfo("Simplicity", {})

TDS:Ready()
TDS:Place("Soldier", -0.3238900899887085, 0.9999970197677612, -9.232925415039062)

-- [ Wave 1 ] --
TDS:Upgrade(1)
TDS:VoteSkip(1)

-- [ Wave 2 ] --
TDS:VoteSkip(2)
TDS:Upgrade(1)

-- [ Wave 3 ] --
TDS:Place("Soldier", -3.444922924041748, 1.0000015497207642, -9.238656997680664)
TDS:Upgrade(2)
TDS:VoteSkip(3)

-- [ Wave 4 ] --
TDS:Upgrade(2)
TDS:VoteSkip(4)

-- [ Wave 5 ] --
TDS:VoteSkip(5)
TDS:Place("Shotgunner", -18.155635833740234, 1.0000003576278687, -2.012455940246582)

-- [ Wave 6 ] --
TDS:VoteSkip(6)

-- [ Wave 7 ] --
TDS:Place("Shotgunner", -18.246963500976562, 1.0000007152557373, -4.115301132202148)
TDS:Upgrade(3)
TDS:VoteSkip(7)

-- [ Wave 8 ] --
TDS:Place("Shotgunner", -18.261180877685547, 0.9999834895133972, -6.1633806228637695)
TDS:Upgrade(5)
TDS:Upgrade(3)

-- [ Wave 9 ] --
TDS:Upgrade(5)

-- [ Wave 10 ] --
TDS:Place("Shotgunner", -18.105566024780273, 0.9999868869781494, -8.216458320617676)
TDS:Upgrade(6)
TDS:VoteSkip(10)
TDS:Upgrade(6)

-- [ Wave 11 ] --
TDS:Place("Shotgunner", -12.300415992736816, 1.0000005960464478, -3.29892635345459)
TDS:VoteSkip(11)

-- [ Wave 12 ] --
TDS:Upgrade(1)
TDS:Upgrade(4)
TDS:Upgrade(7)
TDS:VoteSkip(12)

-- [ Wave 13 ] --
TDS:Upgrade(2)
TDS:Upgrade(4)
TDS:Upgrade(7)
TDS:Place("Shotgunner", -12.504732131958008, 1.000000238418579, -1.2548446655273438)

-- [ Wave 14 ] --
TDS:Place("Shotgunner", -12.602682113647461, 0.9999999403953552, 0.8419671058654785)
TDS:Upgrade(9)
TDS:Upgrade(8)
TDS:Upgrade(9)
TDS:VoteSkip(14)
TDS:Upgrade(8)

-- [ Wave 15 ] --
TDS:Place("Shotgunner", -12.659687042236328, 0.9999995827674866, 2.9495606422424316)
TDS:Upgrade(10)
TDS:Upgrade(10)
TDS:Place("Shotgunner", -10.140783309936523, 0.9999831914901733, -3.21933650970459)
TDS:VoteSkip(15)
TDS:Upgrade(11)
TDS:Upgrade(11)

-- [ Wave 16 ] --
TDS:Upgrade(2)
TDS:VoteSkip(16)

-- [ Wave 17 ] --
TDS:Upgrade(1)

-- [ Wave 18 ] --
TDS:Upgrade(5)
TDS:Upgrade(3)

-- [ Wave 19 ] --
TDS:Upgrade(6)
TDS:VoteSkip(19)

-- [ Wave 20 ] --
TDS:Upgrade(9)
TDS:Upgrade(4)
TDS:VoteSkip(20)
TDS:Upgrade(7)

-- [ Wave 21 ] --
TDS:Upgrade(8)

-- [ Wave 22 ] --
TDS:Upgrade(10)
TDS:Upgrade(11)
TDS:VoteSkip(22)
TDS:VoteSkip(22)

-- [ Wave 23 ] --
TDS:Place("Crook Boss", -5.616771697998047, 0.9999886155128479, -3.356562614440918)
TDS:Place("Crook Boss", -2.33585524559021, 0.9999926090240479, -3.3202781677246094)
TDS:Place("Soldier", -8.96315860748291, 0.9999865293502808, -9.462835311889648)
TDS:Place("Minigunner", -12.457870483398438, 0.9999949932098389, -9.610630989074707)
TDS:Place("Minigunner", 0.9374628067016602, 0.9999831914901733, -3.2857208251953125)
TDS:Place("Minigunner", 4.072118282318115, 0.9999831914901733, -3.2652158737182617)

-- [ Wave 24 ] --
TDS:Upgrade(17)
TDS:Upgrade(17)
TDS:Place("Scout", -9.047877311706543, 1.000000238418579, -0.6638870239257812)
TDS:Place("Scout", -9.651762962341309, 0.9999995827674866, 2.887223243713379)
TDS:VoteSkip(24)
TDS:Place("Scout", -13.996805191040039, 0.9999992251396179, 5.090102672576904)

-- [ Wave 25 ] --
TDS:Place("Scout", -17.83717155456543, 0.9999993443489075, 4.57708740234375)
TDS:Place("Scout", -21.710840225219727, 0.9999993443489075, 4.4232707023620605)
TDS:Place("Crook Boss", -16.316627502441406, 0.9999907612800598, -10.021587371826172)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:Upgrade(13)
TDS:VoteSkip(25)
TDS:VoteSkip(25)
