--[[
	KEY SYSTEM GUI
	Left button  = Check Key
	Right button = Copy Link
	Change the key(s) and the link in CONFIG below, any time.
]]

local CONFIG = {
	Keys     = { "MY-SECRET-KEY" },              -- one or more valid keys
	Link     = "https://discord.gg/XKfaATsyD",   -- <<< CHANGE YOUR LINK HERE
	Title    = "KEY SYSTEM",
	Subtitle = "Enter your key to continue",
	Accent   = Color3.fromRGB(124, 92, 255),
	Accent2  = Color3.fromRGB(0, 200, 255),
}

local function onSuccess()
	-- >>> PUT YOUR MAIN SCRIPT HERE <<<
	-- e.g. loadstring(game:HttpGet("https://example.com/main.lua"))()
	print("Key accepted!")
end

------------------------------------------------------------------
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local GREEN, RED, YELLOW = Color3.fromRGB(61, 220, 132), Color3.fromRGB(255, 93, 108), Color3.fromRGB(255, 200, 87)

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
local old = parent:FindFirstChild("KeySystemGui")
if old then old:Destroy() end

local gui = new("ScreenGui", { Name = "KeySystemGui", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, parent)

-- Main window
local main = new("Frame", {
	Size = UDim2.fromOffset(420, 256), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(16, 16, 26), BorderSizePixel = 0,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 16) }, main)
local bgGrad = new("UIGradient", { Color = ColorSequence.new(Color3.fromRGB(26, 22, 46), Color3.fromRGB(12, 12, 20)), Rotation = 90 }, main)
local stroke = new("UIStroke", { Thickness = 2, Color = Color3.new(1, 1, 1) }, main)
local strokeGrad = new("UIGradient", { Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, CONFIG.Accent), ColorSequenceKeypoint.new(0.5, CONFIG.Accent2), ColorSequenceKeypoint.new(1, CONFIG.Accent),
}) }, stroke)
TweenService:Create(strokeGrad, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Rotation = 360 }):Play()

local scale = new("UIScale", { Scale = 0.7 }, main)
tween(scale, 0.45, { Scale = 1 }, Enum.EasingStyle.Back)

-- Header (drag area)
local header = new("Frame", { Size = UDim2.new(1, 0, 0, 84), BackgroundTransparency = 1 }, main)
local title = new("TextLabel", {
	Text = CONFIG.Title, Font = Enum.Font.GothamBlack, TextSize = 26, TextColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Position = UDim2.fromOffset(0, 20),
}, header)
new("UIGradient", { Color = ColorSequence.new(CONFIG.Accent, CONFIG.Accent2) }, title)
new("TextLabel", {
	Text = CONFIG.Subtitle, Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = Color3.fromRGB(150, 150, 175),
	BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 54),
}, header)

local close = new("TextButton", {
	Text = "X", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(150, 150, 175),
	BackgroundTransparency = 1, Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -38, 0, 8),
}, main)

-- Key input
local inputBox = new("Frame", {
	Size = UDim2.new(1, -48, 0, 44), Position = UDim2.new(0.5, 0, 0, 92), AnchorPoint = Vector2.new(0.5, 0),
	BackgroundColor3 = Color3.fromRGB(10, 10, 18), BorderSizePixel = 0,
}, main)
new("UICorner", { CornerRadius = UDim.new(0, 10) }, inputBox)
local inputStroke = new("UIStroke", { Color = Color3.fromRGB(44, 44, 66), Thickness = 1.5 }, inputBox)
local box = new("TextBox", {
	Text = "", PlaceholderText = "Enter key here...", PlaceholderColor3 = Color3.fromRGB(100, 100, 125),
	Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = Color3.new(1, 1, 1), ClearTextOnFocus = false,
	BackgroundTransparency = 1, Size = UDim2.new(1, -24, 1, 0), Position = UDim2.fromOffset(12, 0),
}, inputBox)
box.Focused:Connect(function() tween(inputStroke, 0.2, { Color = CONFIG.Accent }) end)
box.FocusLost:Connect(function() tween(inputStroke, 0.2, { Color = Color3.fromRGB(44, 44, 66) }) end)

-- Buttons row
local row = new("Frame", {
	Size = UDim2.new(1, -48, 0, 44), Position = UDim2.new(0.5, 0, 0, 152), AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1,
}, main)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }, row)

local function makeButton(text, order, filled)
	local btn = new("TextButton", {
		Text = filled and "" or text, Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Color3.new(1, 1, 1), AutoButtonColor = false,
		BackgroundColor3 = filled and Color3.new(1, 1, 1) or Color3.fromRGB(26, 26, 40),
		Size = UDim2.new(0.5, -6, 1, 0), LayoutOrder = order, BorderSizePixel = 0,
	}, row)
	new("UICorner", { CornerRadius = UDim.new(0, 10) }, btn)
	if filled then
		new("UIGradient", { Color = ColorSequence.new(CONFIG.Accent, CONFIG.Accent2), Rotation = 20 }, btn)
		-- the gradient would tint the button's own text, so the text lives in a separate label
		new("TextLabel", {
			Text = text, Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2,
		}, btn)
	else
		new("UIStroke", { Color = CONFIG.Accent, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, btn)
	end
	local s = new("UIScale", {}, btn)
	btn.MouseEnter:Connect(function() tween(s, 0.15, { Scale = 1.05 }) end)
	btn.MouseLeave:Connect(function() tween(s, 0.15, { Scale = 1 }) end)
	btn.MouseButton1Down:Connect(function() tween(s, 0.08, { Scale = 0.95 }) end)
	btn.MouseButton1Up:Connect(function() tween(s, 0.08, { Scale = 1.05 }) end)
	return btn
end

local checkBtn = makeButton("Check Key", 1, true)   -- LEFT
local linkBtn = makeButton("Copy Link", 2, false)   -- RIGHT

-- Status text
local status = new("TextLabel", {
	Text = "", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = Color3.fromRGB(150, 150, 175), TextWrapped = true,
	BackgroundTransparency = 1, Size = UDim2.new(1, -48, 0, 34), Position = UDim2.new(0.5, 0, 0, 208), AnchorPoint = Vector2.new(0.5, 0),
}, main)

local function setStatus(msg, color)
	status.Text = msg
	status.TextColor3 = color
	status.TextTransparency = 1
	tween(status, 0.2, { TextTransparency = 0 })
end

local function shake()
	local base = main.Position
	for _, dx in ipairs({ 10, -10, 6, -6, 0 }) do
		tween(main, 0.05, { Position = UDim2.new(base.X.Scale, base.X.Offset + dx, base.Y.Scale, base.Y.Offset) })
		task.wait(0.05)
	end
end

local function isValid(input)
	input = input:gsub("%s+", "")
	for _, k in ipairs(CONFIG.Keys) do
		if input == k then return true end
	end
	return false
end

local busy = false
local dragConn

local function closeGui()
	if dragConn then dragConn:Disconnect() end
	tween(scale, 0.3, { Scale = 0 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.wait(0.3)
	gui:Destroy()
end

checkBtn.MouseButton1Click:Connect(function()
	if busy then return end
	if isValid(box.Text) then
		busy = true
		setStatus("Key accepted! Loading...", GREEN)
		task.wait(0.8)
		closeGui()
		onSuccess()
	else
		setStatus("Invalid key. Get one with the link.", RED)
		task.spawn(shake)
	end
end)

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
