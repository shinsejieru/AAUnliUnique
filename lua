-- Animated loading screen (Luau)
-- Shows a progress bar that fills to 100%, then fades out and calls onComplete().

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local parentGui = player:WaitForChild("PlayerGui")

-- ===== Settings =====
local TITLE = "Anime Adventures"
local SUBTITLE = "Loading..."
local LOAD_TIME = 150 -- seconds to reach 100% (2 minutes 30 seconds)
local ACCENT = Color3.fromRGB(255, 90, 160)
local BG = Color3.fromRGB(15, 15, 25)

-- Put whatever should run AFTER loading finishes in here
local function onComplete()
	print("Loading finished!")
end

-- ===== Build the GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "LoadingScreen"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = parentGui

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = BG
background.BorderSizePixel = 0
background.Parent = gui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new(BG, Color3.fromRGB(40, 20, 60))
gradient.Rotation = 90
gradient.Parent = background

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(0.6, 0.12)
title.Position = UDim2.fromScale(0.2, 0.32)
title.BackgroundTransparency = 1
title.Text = TITLE
title.Font = Enum.Font.GothamBlack
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = background

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.fromScale(0.4, 0.04)
subtitle.Position = UDim2.fromScale(0.3, 0.45)
subtitle.BackgroundTransparency = 1
subtitle.Text = SUBTITLE
subtitle.Font = Enum.Font.Gotham
subtitle.TextScaled = true
subtitle.TextColor3 = Color3.fromRGB(190, 190, 210)
subtitle.Parent = background

local barBack = Instance.new("Frame")
barBack.Size = UDim2.fromScale(0.5, 0.025)
barBack.Position = UDim2.fromScale(0.25, 0.55)
barBack.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
barBack.BorderSizePixel = 0
barBack.Parent = background
Instance.new("UICorner", barBack).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.fromScale(0, 1)
barFill.BackgroundColor3 = ACCENT
barFill.BorderSizePixel = 0
barFill.Parent = barBack
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local percent = Instance.new("TextLabel")
percent.Size = UDim2.fromScale(0.2, 0.04)
percent.Position = UDim2.fromScale(0.4, 0.59)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.Font = Enum.Font.GothamBold
percent.TextScaled = true
percent.TextColor3 = ACCENT
percent.Parent = background

-- ===== Animate the bar =====
local tips = {
	"Gathering resources...",
	"Summoning units...",
	"Preparing the battlefield...",
	"Almost there...",
}

local progress = Instance.new("NumberValue")
local tween = TweenService:Create(
	progress,
	TweenInfo.new(LOAD_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
	{ Value = 100 }
)

progress.Changed:Connect(function(value)
	local pct = math.floor(value)
	percent.Text = pct .. "%"
	barFill.Size = UDim2.fromScale(value / 100, 1)
	subtitle.Text = tips[math.clamp(math.ceil(pct / 25), 1, #tips)]
end)

tween:Play()
tween.Completed:Wait()

percent.Text = "100%"
subtitle.Text = "Done!"
task.wait(0.5)

-- ===== Fade out =====
local fade = TweenInfo.new(0.6)
for _, obj in ipairs(background:GetDescendants()) do
	if obj:IsA("TextLabel") then
		TweenService:Create(obj, fade, { TextTransparency = 1 }):Play()
	elseif obj:IsA("Frame") then
		TweenService:Create(obj, fade, { BackgroundTransparency = 1 }):Play()
	end
end
TweenService:Create(background, fade, { BackgroundTransparency = 1 }):Play()
task.wait(0.7)

gui:Destroy()
onComplete()
