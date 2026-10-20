--[[
	CRYSATL HUB - KEY SYSTEM
	Left button = Check Key | Right button = Copy Link
	Edit CONFIG below (keys + link) any time.
]]

local CONFIG = {
	Name    = "CRYSATL HUB",
	Tagline = "Enter your key to unlock the hub",
	Keys    = { "MY-SECRET-KEY" },              -- one or more valid keys
	Link    = "https://discord.gg/XKfaATsyD",   -- <<< CHANGE YOUR LINK HERE
	Accent  = Color3.fromRGB(124, 92, 255),
	Accent2 = Color3.fromRGB(0, 200, 255),
	Accent3 = Color3.fromRGB(255, 105, 220),
}

local function onSuccess()
	-- >>> PUT YOUR MAIN SCRIPT HERE <<<
	print("Crysatl Hub loaded!")
end

------------------------------------------------------------------
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local WHITE, GRAY = Color3.new(1, 1, 1), Color3.fromRGB(150, 150, 175)
local GREEN, RED, YELLOW = Color3.fromRGB(61, 220, 132), Color3.fromRGB(255, 93, 108), Color3.fromRGB(255, 200, 87)
local LINEAR = Enum.EasingStyle.Linear

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end

local function tween(obj, t, props, style, dir)
	local tw = TweenService:Create(obj, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local parent = (gethui and gethui()) or Players.LocalPlayer:WaitForChild("PlayerGui")
local old = parent:FindFirstChild("CrysatlKeySystem")
if old then old:Destroy() end
local oldBlur = Lighting:FindFirstChild("CrysatlBlur")
if oldBlur then oldBlur:Destroy() end

local gui = new("ScreenGui", { Name = "CrysatlKeySystem", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, parent)

-- Dim + blur backdrop
local dim = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0 }, gui)
local blur = Instance.new("BlurEffect")
blur.Name, blur.Size = "CrysatlBlur", 0
pcall(function() blur.Parent = Lighting end)
tween(dim, 0.5, { BackgroundTransparency = 0.45 })
tween(blur, 0.5, { Size = 14 })

-- Main window
local main = new("Frame", {
	Size = UDim2.fromOffset(460, 304), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = WHITE, BorderSizePixel = 0,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 18) }, main)
new("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(30, 22, 58), Color3.fromRGB(9, 9, 17)), Rotation = 90 }, main)
local stroke = new("UIStroke", { Thickness = 2.5, Color = WHITE }, main)
local strokeGrad = new("UIGradient", { Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, CONFIG.Accent), ColorSequenceKeypoint.new(0.33, CONFIG.Accent2),
	ColorSequenceKeypoint.new(0.66, CONFIG.Accent3), ColorSequenceKeypoint.new(1, CONFIG.Accent),
}) }, stroke)
TweenService:Create(strokeGrad, TweenInfo.new(4, LINEAR, Enum.EasingDirection.In, -1), { Rotation = 360 }):Play()

local scale = new("UIScale", { Scale = 0.6 }, main)
tween(scale, 0.55, { Scale = 1 }, Enum.EasingStyle.Back)

-- Floating crystal particles
local glass = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true }, main)
new("UICorner", { CornerRadius = UDim.new(0, 18) }, glass)
local alive = true
local colors = { CONFIG.Accent, CONFIG.Accent2, CONFIG.Accent3 }
for _ = 1, 16 do
	task.spawn(function()
		local p = new("Frame", { Rotation = 45, BorderSizePixel = 0, BackgroundColor3 = colors[math.random(3)], BackgroundTransparency = 1 }, glass)
		task.wait(math.random() * 5)
		while alive and p.Parent do
			local s, x, t = math.random(3, 7), math.random(), math.random(40, 80) / 10
			p.Size = UDim2.fromOffset(s, s)
			p.Position = UDim2.new(x, 0, 1, 10)
			p.BackgroundTransparency = 0.6
			tween(p, t, { Position = UDim2.new(x, 0, 0, -10), BackgroundTransparency = 1 }, LINEAR)
			task.wait(t)
		end
	end)
end

-- Header: spinning gem + animated title (drag area)
local header = new("Frame", { Size = UDim2.new(1, 0, 0, 118), BackgroundTransparency = 1 }, main)
local gem = new("Frame", { Size = UDim2.fromOffset(30, 30), Position = UDim2.new(0.5, 0, 0, 34), AnchorPoint = Vector2.new(0.5, 0.5), Rotation = 45, BackgroundColor3 = WHITE, BorderSizePixel = 0 }, header)
new("UICorner", { CornerRadius = UDim.new(0, 6) }, gem)
new("UIGradient", { Color = ColorSequence.new(CONFIG.Accent2, CONFIG.Accent3), Rotation = 45 }, gem)
local core = new("Frame", { Size = UDim2.fromOffset(14, 14), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(12, 12, 20), BorderSizePixel = 0 }, gem)
new("UICorner", { CornerRadius = UDim.new(0, 3) }, core)
TweenService:Create(gem, TweenInfo.new(6, LINEAR, Enum.EasingDirection.In, -1), { Rotation = 405 }):Play()

local title = new("TextLabel", {
	Text = CONFIG.Name, Font = Enum.Font.GothamBlack, TextSize = 28, TextColor3 = WHITE,
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Position = UDim2.fromOffset(0, 62),
}, header)
local titleGrad = new("UIGradient", { Offset = Vector2.new(-0.5, 0), Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, CONFIG.Accent2), ColorSequenceKeypoint.new(0.5, CONFIG.Accent), ColorSequenceKeypoint.new(1, CONFIG.Accent3),
}) }, title)
TweenService:Create(titleGrad, TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Offset = Vector2.new(0.5, 0) }):Play()
new("TextLabel", {
	Text = CONFIG.Tagline, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = GRAY,
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Position = UDim2.fromOffset(0, 94),
}, header)

local close = new("TextButton", {
	Text = "X", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = GRAY,
	BackgroundTransparency = 1, Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -38, 0, 8),
}, main)
close.MouseEnter:Connect(function() tween(close, 0.15, { TextColor3 = RED }) end)
close.MouseLeave:Connect(function() tween(close, 0.15, { TextColor3 = GRAY }) end)

-- Key input
local inputBox = new("Frame", {
	Size = UDim2.new(1, -48, 0, 46), Position = UDim2.new(0.5, 0, 0, 130), AnchorPoint = Vector2.new(0.5, 0),
	BackgroundColor3 = Color3.fromRGB(10, 10, 18), BorderSizePixel = 0,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, inputBox)
local inputStroke = new("UIStroke", { Color = Color3.fromRGB(44, 44, 66), Thickness = 1.5 }, inputBox)
new("TextLabel", { Text = "🔑", TextSize = 18, BackgroundTransparency = 1, Size = UDim2.fromOffset(36, 46), Position = UDim2.fromOffset(6, 0) }, inputBox)
local box = new("TextBox", {
	Text = "", PlaceholderText = "Enter key here...", PlaceholderColor3 = Color3.fromRGB(100, 100, 125),
	Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = WHITE, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1, Size = UDim2.new(1, -52, 1, 0), Position = UDim2.fromOffset(42, 0),
}, inputBox)
box.Focused:Connect(function() tween(inputStroke, 0.2, { Color = CONFIG.Accent2 }) end)
box.FocusLost:Connect(function() tween(inputStroke, 0.2, { Color = Color3.fromRGB(44, 44, 66) }) end)

-- Buttons
local row = new("Frame", { Size = UDim2.new(1, -48, 0, 46), Position = UDim2.new(0.5, 0, 0, 188), AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1 }, main)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }, row)

local function makeButton(text, order, filled)
	local btn = new("TextButton", {
		Text = "", AutoButtonColor = false, ClipsDescendants = true, BackgroundColor3 = filled and WHITE or Color3.fromRGB(24, 24, 38),
		Size = UDim2.new(0.5, -6, 1, 0), LayoutOrder = order, BorderSizePixel = 0,
	}, row)
	new("UICorner", { CornerRadius = UDim.new(0, 12) }, btn)
	if filled then
		new("UIGradient", { Color = ColorSequence.new(CONFIG.Accent, CONFIG.Accent2), Rotation = 20 }, btn)
		local shine = new("Frame", { Size = UDim2.new(0.22, 0, 2, 0), Position = UDim2.new(-0.4, 0, -0.5, 0), Rotation = 20, BackgroundColor3 = WHITE, BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 2 }, btn)
		task.spawn(function()
			while btn.Parent do
				shine.Position = UDim2.new(-0.4, 0, -0.5, 0)
				tween(shine, 0.8, { Position = UDim2.new(1.3, 0, -0.5, 0) }, Enum.EasingStyle.Sine)
				task.wait(3)
			end
		end)
	else
		new("UIStroke", { Color = CONFIG.Accent, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, btn)
	end
	-- text lives in its own label so the gradient never tints it
	new("TextLabel", { Text = text, Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = WHITE, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 3 }, btn)
	local s = new("UIScale", {}, btn)
	btn.MouseEnter:Connect(function() tween(s, 0.15, { Scale = 1.05 }) end)
	btn.MouseLeave:Connect(function() tween(s, 0.15, { Scale = 1 }) end)
	btn.MouseButton1Down:Connect(function() tween(s, 0.08, { Scale = 0.95 }) end)
	btn.MouseButton1Up:Connect(function() tween(s, 0.08, { Scale = 1.05 }) end)
	return btn
end

local checkBtn = makeButton("Check Key", 1, true)   -- LEFT
local linkBtn = makeButton("Copy Link", 2, false)   -- RIGHT

-- Status, progress bar, footer
local status = new("TextLabel", {
	Text = "", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = GRAY, TextWrapped = true,
	BackgroundTransparency = 1, Size = UDim2.new(1, -48, 0, 18), Position = UDim2.new(0.5, 0, 0, 242), AnchorPoint = Vector2.new(0.5, 0),
}, main)
local barTrack = new("Frame", { Visible = false, Size = UDim2.new(1, -48, 0, 4), Position = UDim2.new(0.5, 0, 0, 266), AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Color3.fromRGB(30, 30, 48), BorderSizePixel = 0 }, main)
new("UICorner", { CornerRadius = UDim.new(0, 2) }, barTrack)
local barFill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0 }, barTrack)
new("UICorner", { CornerRadius = UDim.new(0, 2) }, barFill)
new("UIGradient", { Color = ColorSequence.new(CONFIG.Accent, CONFIG.Accent3) }, barFill)
new("TextLabel", {
	Text = "Crysatl Hub  |  v1.0", Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Color3.fromRGB(95, 95, 120),
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), Position = UDim2.fromOffset(0, 280),
}, main)

local function setStatus(msg, color)
	status.Text = msg
	status.TextColor3 = color
	status.TextTransparency = 1
	tween(status, 0.2, { TextTransparency = 0 })
end

local function shake()
	local base = main.Position
	tween(inputStroke, 0.1, { Color = RED })
	for _, dx in ipairs({ 10, -10, 6, -6, 0 }) do
		tween(main, 0.05, { Position = UDim2.new(base.X.Scale, base.X.Offset + dx, base.Y.Scale, base.Y.Offset) })
		task.wait(0.05)
	end
	tween(inputStroke, 0.4, { Color = Color3.fromRGB(44, 44, 66) })
end

local function isValid(input)
	input = input:gsub("%s+", "")
	for _, k in ipairs(CONFIG.Keys) do
		if input == k then return true end
	end
	return false
end

local busy, dragConn = false, nil

local function closeGui()
	alive = false
	if dragConn then dragConn:Disconnect() end
	tween(scale, 0.3, { Scale = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	tween(dim, 0.3, { BackgroundTransparency = 1 })
	tween(blur, 0.3, { Size = 0 })
	task.wait(0.35)
	blur:Destroy()
	gui:Destroy()
end

local function check()
	if busy then return end
	if isValid(box.Text) then
		busy = true
		barTrack.Visible = true
		setStatus("Verifying key...", YELLOW)
		tween(barFill, 0.5, { Size = UDim2.fromScale(0.6, 1) })
		task.wait(0.5)
		setStatus("Key accepted! Loading Crysatl Hub...", GREEN)
		tween(barFill, 0.6, { Size = UDim2.fromScale(1, 1) })
		task.wait(0.8)
		closeGui()
		onSuccess()
	else
		setStatus("Invalid key. Get one with the link.", RED)
		task.spawn(shake)
	end
end

checkBtn.MouseButton1Click:Connect(check)
box.FocusLost:Connect(function(enterPressed) if enterPressed then check() end end)

linkBtn.MouseButton1Click:Connect(function()
	local copy = setclipboard or toclipboard or (Clipboard and Clipboard.set)
	if copy and pcall(copy, CONFIG.Link) then
		setStatus("Link copied to clipboard!", GREEN)
	else
		box.Text = CONFIG.Link -- fallback when clipboard access isn't available
		setStatus("Clipboard unavailable. Link placed in the box, copy it manually.", YELLOW)
	end
end)

close.MouseButton1Click:Connect(closeGui)

-- Dragging
do
	local dragging, dragStart, startPos
	header.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, startPos = true, i.Position, main.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	dragConn = UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
end
