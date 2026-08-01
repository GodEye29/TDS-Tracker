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

local EarnedGemsLabel = CreateRow("EarnedGems", "Total Earned: <font color='#FFDF00'>0 Gems</font>", 1)
local MatchGemsLabel  = CreateRow("MatchGems", "Last Reward: <font color='#D4AF37'>0 Gems</font>", 2)
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
UsernameLabel.Text = "@Amongus_ is kool"
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
Contributor1.Text = "@Tartbear"
Contributor1.TextColor3 = Color3.fromRGB(240, 240, 255)
Contributor1.Font = Enum.Font.GothamBold
Contributor1.TextSize = 15
Contributor1.Parent = PopupFrame

local Contributor2 = Instance.new("TextLabel")
Contributor2.Name = "PopupName"
Contributor2.Size = UDim2.new(1, 0, 0, 20)
Contributor2.BackgroundTransparency = 1
Contributor2.Text = "@! Jager Shakur"
Contributor2.TextColor3 = Color3.fromRGB(240, 240, 255)
Contributor2.Font = Enum.Font.GothamBold
Contributor2.TextSize = 15
Contributor2.Parent = PopupFrame

local Contributor3 = Instance.new("TextLabel")
Contributor3.Name = "PopupName"
Contributor3.Size = UDim2.new(1, 0, 0, 20)
Contributor3.BackgroundTransparency = 1
Contributor3.Text = "@Rya"
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

local SessionGems, SessionXP, TotalSeconds = 0, 0, 0
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
            
            local containerGems = RewardsSection:FindFirstChild("2")
            local containerXP = RewardsSection:FindFirstChild("1")
            
            local gemLabelObj = containerGems and containerGems:FindFirstChild("icon") and containerGems.icon:FindFirstChild("icon") and containerGems.icon.icon:FindFirstChild("textLabel")
            local xpLabelObj = containerXP and containerXP:FindFirstChild("icon") and containerXP.icon:FindFirstChild("icon") and containerXP.icon.icon:FindFirstChild("textLabel")
            
            local parsedGems = 0
            local parsedXP = 0
            
            -- FIX: Standardized the Gem text extraction with ExtractNumber
            if gemLabelObj then
                local text = gemLabelObj.Text:lower()
                if text:find("gems") or text:find("gem") then
                    parsedGems = ExtractNumber(gemLabelObj.Text)
                end
            end
            
            if xpLabelObj then
                parsedXP = ExtractNumber(xpLabelObj.Text)
            end
            
            SessionGems = SessionGems + parsedGems
            SessionXP = SessionXP + parsedXP
            
            MatchGemsLabel.Text = string.format("Last Reward: <font color='#D4AF37'>%d Gems</font>", parsedGems)
            EarnedGemsLabel.Text = string.format("Total Earned: <font color='#FFDF00'>%d Gems</font>", SessionGems)
            
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
