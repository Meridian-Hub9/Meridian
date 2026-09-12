local Players    = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player    = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- -----------------------------------------
--  CONFIG  (persisted to file)
-- -----------------------------------------
local CFG_PATH = "MeridianCodeSniper_Config.json"

-- defaults
local cfg = {
    scanEnabled  = true,
    autoCode     = false,
    captureCount = 4,
    codeSubmitDelay = 0.5,
    autoRiddle   = false,
    riddleCaptureCount = 1,
    riddleSubmitDelay = 0.5,
    keywords     = { "code is", "", "", "", "", "", "", "", "", "" },
    replaceRules = { {kw="admin war",rep="jandel"},{kw="",rep=""},{kw="",rep=""},{kw="",rep=""},
                     {kw="",rep=""},{kw="",rep=""},{kw="",rep=""},{kw="",rep=""},
                     {kw="",rep=""},{kw="",rep=""} },
    minimized    = false,
    activeTab    = 1,   -- 1 = Main, 2 = Riddle, 3 = Keyword Dropdown, 4 = Status
}

local function saveConfig()
    if not writefile then return end
    pcall(writefile, CFG_PATH, HttpService:JSONEncode(cfg))
end

local function loadConfig()
    if not (readfile and isfile and isfile(CFG_PATH)) then return end
    local ok, dec = pcall(function()
        return HttpService:JSONDecode(readfile(CFG_PATH))
    end)
    if ok and type(dec) == "table" then
        for k, v in pairs(dec) do cfg[k] = v end
    end
end

loadConfig()

-- On every fresh execute, no mode should ever start pre-armed. The saved
-- config still remembers keywords, capture counts, delays, etc., but
-- Auto Riddle and Auto Code must always come up OFF until the person
-- explicitly picks a mode from the menu this session - otherwise a
-- previously-saved "on" state would silently start solving/submitting
-- before any mode was ever clicked this run.
cfg.autoRiddle = false
cfg.autoCode = false

-- -----------------------------------------
--  COLOUR / STYLE TOKENS
-- -----------------------------------------
local C = {
    bg0       = Color3.fromRGB(12, 12, 12),
    bg1       = Color3.fromRGB(18, 18, 18),
    bg2       = Color3.fromRGB(26, 26, 26),
    bg3       = Color3.fromRGB(20, 15, 15),
    accent    = Color3.fromRGB(230, 45, 45),
    accentDim = Color3.fromRGB(110, 25, 25),
    accentSec = Color3.fromRGB(255, 70, 70),
    activeTabText = Color3.fromRGB(255, 225, 225),
    toggleOff = Color3.fromRGB(38, 26, 26),
    toggleOn  = Color3.fromRGB(200, 35, 35),
    knob      = Color3.fromRGB(255, 140, 140),
    textPri   = Color3.fromRGB(235, 170, 170),
    textMuted = Color3.fromRGB(100, 60, 60),
    inputBg   = Color3.fromRGB(14, 10, 10),
    tweenFast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    tweenMed  = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    toggleW   = 40,
    toggleH   = 20,
    knobSz    = 16,
}

-- -----------------------------------------
--  HELPERS
-- -----------------------------------------
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or UDim.new(0, 8)
    c.Parent = p
end

local function stroke(p, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or C.accent
    s.Thickness = thickness or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
end

-- Simulates a glowing neon red border using layered, low-opacity UIStrokes
-- (Roblox has no native glow property, so we fake it with soft outer layers)
-- plus a subtle pulsing transparency animation for a "living" neon look.
local function neonGlow(p, color, coreThickness)
    color = color or C.accent
    coreThickness = coreThickness or 1

    -- Core crisp line
    local core = Instance.new("UIStroke")
    core.Color = color
    core.Thickness = coreThickness
    core.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    core.Transparency = 0
    core.Parent = p

    -- Soft outer glow layers (wider + more transparent = glow falloff)
    local glow1 = Instance.new("UIStroke")
    glow1.Color = color
    glow1.Thickness = coreThickness + 2
    glow1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow1.Transparency = 0.55
    glow1.Parent = p

    local glow2 = Instance.new("UIStroke")
    glow2.Color = color
    glow2.Thickness = coreThickness + 4
    glow2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow2.Transparency = 0.75
    glow2.Parent = p

    -- Gentle pulse: breathes the glow layers' transparency in/out
    task.spawn(function()
        while glow1.Parent and glow2.Parent do
            TweenService:Create(glow1, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.25 }):Play()
            TweenService:Create(glow2, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.55 }):Play()
            task.wait(1.1)
            if not (glow1.Parent and glow2.Parent) then break end
            TweenService:Create(glow1, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.55 }):Play()
            TweenService:Create(glow2, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Transparency = 0.75 }):Play()
            task.wait(1.1)
        end
    end)

    return core, glow1, glow2
end

-- -----------------------------------------
--  SCANNER STATE  (initialised from cfg)
-- -----------------------------------------
local scanEnabled    = true  -- always enabled; toggle removed
local autoCode       = false -- no manual toggle anymore; always starts off, only Force Scan/Riddle can arm scanning
local autoRiddle     = cfg.autoRiddle == true
local filterKeywords = {}   -- runtime table; synced to cfg.keywords on every write
local replaceRules   = {}   -- runtime table; synced to cfg.replaceRules on every write
local captureCount   = cfg.captureCount
local codeSubmitDelay = tonumber(cfg.codeSubmitDelay) or 0.5
local riddleCaptureCount = cfg.riddleCaptureCount
local riddleSubmitDelay = tonumber(cfg.riddleSubmitDelay) or 0.5
local setAutoRiddle -- forward declared; defined later near Riddle UI, used earlier in dispatchRiddle

-- collection state
local collecting      = false
local collectBuf      = {}
local collectRemain   = 0
local forceScanActive = false   -- set by Force Scan + Code button
local codeCycleActive = false   -- true from first code detection until redeem/fail resolves

local riddleCollecting  = false
local riddleBuf         = {}
local riddleRemain      = 0
local riddleCycleActive = false -- true from first riddle detection until solve+redeem/fail resolves

local MAX_FILTERS = 10
local BOX_H       = 22
local BOX_GAP     = 4
local SCROLL_H    = 100

-- initialise filterKeywords from saved cfg
for i = 1, MAX_FILTERS do
    filterKeywords[i] = (type(cfg.keywords) == "table" and cfg.keywords[i]) or ""
end

-- initialise replaceRules from saved cfg
for i = 1, MAX_FILTERS do
    local saved = type(cfg.replaceRules) == "table" and cfg.replaceRules[i]
    replaceRules[i] = { kw = (saved and saved.kw) or "", rep = (saved and saved.rep) or "" }
end

-- -----------------------------------------
--  STATUS LOG
-- -----------------------------------------
local statusLog = {}
local statusScrollRef = nil   -- assigned after GUI creation

local function logStatus(msg)
    local t = os.date and os.date("%H:%M:%S") or "??"
    local entry = "[" .. t .. "] " .. msg
    table.insert(statusLog, entry)
    print("[STATUS] " .. entry)
    -- Update the scroll frame if it exists
    if statusScrollRef then
        local lbl = Instance.new("TextLabel")
        lbl.Size                   = UDim2.new(1, -8, 0, 0)
        lbl.AutomaticSize          = Enum.AutomaticSize.Y
        lbl.BackgroundTransparency = 1
        lbl.Font                   = Enum.Font.Code
        lbl.TextSize               = 10
        lbl.TextColor3             = C.textPri
        lbl.TextXAlignment         = Enum.TextXAlignment.Left
        lbl.TextWrapped            = true
        lbl.RichText               = false
        lbl.Text                   = entry
        lbl.Parent                 = statusScrollRef
        -- Auto-scroll to bottom
        task.defer(function()
            statusScrollRef.CanvasPosition = Vector2.new(0, math.huge)
        end)
    end
end



-- -----------------------------------------
--  FULL DISABLE ON DEATH / RESET
--  Any mode (Auto Code, Auto Riddle, Force Scan) is completely
--  turned off and all in-progress collection is wiped the moment
--  the character dies or respawns, so nothing keeps counting
--  silently after a kill. Real implementation is assigned further
--  down once the mode-toggle functions exist, so the UI switches
--  stay in sync too.
-- -----------------------------------------
local fullyDisableScanning -- forward-declared; assigned after setAutoCode/setAutoRiddle exist

local function hookCharacterDeath(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    humanoid.Died:Connect(function()
        if fullyDisableScanning then fullyDisableScanning() end
    end)
end

if player.Character then
    hookCharacterDeath(player.Character)
end
player.CharacterAdded:Connect(function(char)
    if fullyDisableScanning then fullyDisableScanning() end
    hookCharacterDeath(char)
end)

local seen = {}

-- forward-declared; assigned after ScreenGui creation
local meridianGui

local function isOwnedByUs(obj)
    local cur = obj
    while cur and cur ~= game do
        if cur == meridianGui then return true end
        cur = cur.Parent
    end
    return false
end

local function getText(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        return obj.Text
    end
    return nil
end

local function matchesKeyword(text)
    if not text or text == "" then return false end
    -- Keyword filtering removed: every non-empty notification is treated as a code
    return true
end

-- Attempts to redeem `notif` as a code via the in-game Codes UI.
-- Runs in a protected pcall so any missing UI never breaks the scanner.
-- Primary: firesignal (simple, no debounce-corruption risk).
-- Fallback: VirtualInputManager click simulation if firesignal is unavailable.
-- preSubmitDelay: optional buffer (seconds) between typing the code and
-- clicking submit, so the game has time to register the typed text first.
-- Finds the code TextBox anywhere under the Codes GUI, not just at a
-- fixed hardcoded path. Falls back to a broad PlayerGui scan if the
-- expected "Codes" root ever gets renamed/restructured by the game.
local function findCodeTextBox()
    local codesRoot = PlayerGui:FindFirstChild("Codes")
    if codesRoot then
        for _, obj in ipairs(codesRoot:GetDescendants()) do
            if obj:IsA("TextBox") then
                local n = obj.Name:lower()
                local pn = (obj.Parent and obj.Parent.Name or ""):lower()
                if n:find("code") or n:find("redeem") or n:find("input")
                    or pn:find("code") or pn:find("redeem") then
                    return obj
                end
            end
        end
        -- No name match under Codes root: just take the first visible TextBox
        for _, obj in ipairs(codesRoot:GetDescendants()) do
            if obj:IsA("TextBox") then return obj end
        end
    end
    -- Last resort: scan all of PlayerGui for a code-looking TextBox
    for _, obj in ipairs(PlayerGui:GetDescendants()) do
        if obj:IsA("TextBox") then
            local n = obj.Name:lower()
            local pn = (obj.Parent and obj.Parent.Name or ""):lower()
            if n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem") then
                return obj
            end
        end
    end
    return nil
end

-- Finds the submit/confirm button near the given TextBox by walking up
-- parents and scanning descendants for a button whose name/text matches
-- common submit keywords.
local function findConfirmButton(textBox)
    if not textBox then return nil end
    local searchNames = {"submit", "confirm", "redeem", "claim", "enter", "send", "apply", "ok", "use", "go", "check"}
    local parent = textBox.Parent
    for _ = 1, 6 do
        if not parent then break end
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                local name = obj.Name:lower()
                local text = ""
                pcall(function() text = obj.Text:lower() end)
                for _, kw in ipairs(searchNames) do
                    if name:find(kw, 1, true) or text:find(kw, 1, true) then
                        return obj
                    end
                end
            end
        end
        parent = parent.Parent
    end
    return nil
end

local function clickButton(button)
    if not button then return false end
    local activated = false
    if firesignal then
        pcall(function()
            firesignal(button.MouseButton1Click)
            firesignal(button.Activated)
            activated = true
        end)
    end
    if not activated then
        local ok = pcall(function()
            local vim = game:GetService("VirtualInputManager")
            local pos = button.AbsolutePosition + button.AbsoluteSize / 2
            vim:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
            vim:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
        end)
        activated = ok
    end
    return activated
end

local function redeemCode(notif, preSubmitDelay)
    local ok, err = pcall(function()
        -- Try the known fixed path first (fast path, no scanning needed)
        local textBox, confirmButton
        local fixedOk = pcall(function()
            local Codes = PlayerGui:WaitForChild("Codes", 3).Codes
            textBox = Codes.CodeRedeem.TextBox
            confirmButton = Codes.Confirm:FindFirstChildWhichIsA("TextButton") or Codes.Confirm
        end)

        -- If the fixed path failed or the box isn't actually there anymore,
        -- fall back to scanning the GUI tree for it.
        if not fixedOk or not textBox or not textBox.Parent then
            textBox = findCodeTextBox()
            if not textBox then error("Could not locate code TextBox (fixed path and scan both failed)") end
            confirmButton = findConfirmButton(textBox)
        end

        textBox.Text = notif
        -- Fire text-changed style events so the game's own validation
        -- (which may listen for GetPropertyChangedSignal("Text")) picks
        -- up the change even when Text is set directly instead of typed.
        pcall(function()
            textBox.CursorPosition = #notif + 1
        end)

        if preSubmitDelay and preSubmitDelay > 0 then
            task.wait(preSubmitDelay)
        end

        if not confirmButton then
            confirmButton = findConfirmButton(textBox)
        end
        if not confirmButton then
            -- No button found at all: try releasing focus, some UIs submit on FocusLost
            pcall(function() textBox:ReleaseFocus(true) end)
            error("Confirm button not found (tried FocusLost fallback)")
        end

        local clicked = clickButton(confirmButton)
        if not clicked then
            -- Final fallback: release focus with enterPressed=true
            pcall(function() textBox:ReleaseFocus(true) end)
        end
    end)
    return ok, err
end

-- Returns the replacement string if `text` matches any replace rule keyword,
-- otherwise returns nil (meaning: use original text).
local function applyReplace(text)
    if not text or text == "" then return nil end
    local lower = text:lower()
    for _, rule in ipairs(replaceRules) do
        if rule.kw ~= "" and lower:find(rule.kw:lower(), 1, true) then
            return rule.rep  -- could be "" meaning suppress entirely
        end
    end
    return nil
end

-- -----------------------------------------
--  RIDDLE SOLVING ENGINE
--  Source: AceRiddle_v6_lua.txt (solving logic only, GUI portion excluded)
--  Wired to: Riddle tab (Auto Riddle toggle + Submit Code After count)
-- -----------------------------------------
--  PASTE YOUR GROQ API KEY HERE (between the quotes)
--  Get one free at https://console.groq.com -> API Keys
-- -----------------------------------------
local MY_GROQ_KEY = "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"

local riddleHttpRequest = (syn and syn.request) or http_request or request or (http and http.request)
local riddleEnv = typeof(getgenv) == "function" and getgenv() or _G
local GROQ_API_KEY = (MY_GROQ_KEY ~= "" and MY_GROQ_KEY) or riddleEnv.GROQ_API_KEY or ""

local function stripRich(s)
    if type(s) ~= "string" then return tostring(s) end
    return (s:gsub("<[^>]->", ""))
end

local function trim(s)
    return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

-- - SAB Knowledge Base -
local SAB_DB = {
    ["real name"]                   = "SAMMY",
    ["sammy real name"]             = "SAMMY",
    ["sammys real name"]            = "SAMMY",
    ["my real name"]                = "SAMMY",
    ["creator real name"]           = "SAMMY",
    ["owner real name"]             = "SAMMY",
    ["creator name"]                = "SAMMY",
    ["who created sab"]             = "SAMMY",
    ["who made sab"]                = "SAMMY",
    ["who made steal a brainrot"]   = "SAMMY",
    ["who is the owner"]            = "SAMMY",
    ["who owns sab"]                = "SAMMY",
    ["owner"]                       = "SAMMY",
    ["creator"]                     = "SAMMY",
    ["roblox username"]             = "SPYDERSAMMY",
    ["my roblox username"]          = "SPYDERSAMMY",
    ["sammy username"]              = "SPYDERSAMMY",
    ["sammy roblox name"]           = "SPYDERSAMMY",
    ["roblox name"]                 = "SPYDERSAMMY",
    ["username"]                    = "SPYDERSAMMY",
    ["my username"]                 = "SPYDERSAMMY",

    ["how old am i"]                = "24",
    ["how old is sammy"]            = "24",
    ["my age"]                      = "24",
    ["sammy age"]                   = "24",
    ["age"]                         = "24",
    ["birth year"]                  = "2002",
    ["year born"]                   = "2002",
    ["year i was born"]             = "2002",
    ["born year"]                   = "2002",
    ["birth day"]                   = "FRIDAY",
    ["day i was born"]              = "FRIDAY",
    ["day born"]                    = "FRIDAY",
    ["birthday"]                    = "FRIDAY",
    ["born on"]                     = "FRIDAY",
    ["birth month"]                 = "FEBRUARY",
    ["month born"]                  = "FEBRUARY",
    ["month i was born"]            = "FEBRUARY",
    ["where was i born"]            = "ALGERIA",
    ["where was i born at"]         = "ALGERIA",
    ["birthplace"]                  = "ALGERIA",
    ["where i was born"]            = "ALGERIA",

    ["where am i from"]             = "BRAZIL",
    ["where is sammy from"]         = "BRAZIL",
    ["my country"]                  = "BRAZIL",
    ["sammy country"]               = "BRAZIL",
    ["country"]                     = "BRAZIL",
    ["where do i live"]             = "BRAZIL",
    ["where does sammy live"]       = "BRAZIL",
    ["sammy location"]              = "BRAZIL",
    ["nationality"]                 = "BRAZILIAN",
    ["sammy nationality"]           = "BRAZILIAN",
    ["my nationality"]              = "BRAZILIAN",
    ["state"]                       = "SAOPAULO",
    ["my state"]                    = "SAOPAULO",
    ["sammy state"]                 = "SAOPAULO",
    ["city"]                        = "SAOPAULO",
    ["my city"]                     = "SAOPAULO",
    ["sammy city"]                  = "SAOPAULO",

    ["favorite color"]              = "BLUE",
    ["fav color"]                   = "BLUE",
    ["my color"]                    = "BLUE",
    ["sammy color"]                 = "BLUE",
    ["color"]                       = "BLUE",
    ["favourite color"]             = "BLUE",
    ["favorite color is blue"]      = "BLUE",
    ["fav color is blue"]           = "BLUE",
    ["my color is blue"]            = "BLUE",
    ["sammy color is blue"]         = "BLUE",
    ["my favorite color is blue"]   = "BLUE",
    ["color is blue"]               = "BLUE",
    ["favorite sport"]              = "FOOTBALL",
    ["fav sport"]                   = "FOOTBALL",
    ["sport"]                       = "FOOTBALL",
    ["my sport"]                    = "FOOTBALL",
    ["favorite football player"]    = "RONALDO",
    ["fav football player"]         = "RONALDO",
    ["my favorite football player"] = "RONALDO",
    ["favourite football player"]   = "RONALDO",
    ["football player"]             = "RONALDO",
    ["favorite player"]             = "RONALDO",
    ["fav player"]                  = "RONALDO",
    ["ronaldo"]                     = "RONALDO",
    ["favorite food"]               = "PIZZA",
    ["fav food"]                    = "PIZZA",
    ["my food"]                     = "PIZZA",
    ["food"]                        = "PIZZA",
    ["favorite animal"]             = "SPIDER",
    ["fav animal"]                  = "SPIDER",
    ["my animal"]                   = "SPIDER",
    ["my pet"]                      = "SPIDER",
    ["favorite game"]               = "ROBLOX",
    ["fav game"]                    = "ROBLOX",
    ["social media"]                = "YOUTUBE",
    ["youtube channel"]             = "SPYDERSAMMY",
    ["my youtube"]                  = "SPYDERSAMMY",
    ["sammy youtube"]               = "SPYDERSAMMY",

    ["game created on"]             = "FRIDAY",
    ["created on"]                  = "FRIDAY",
    ["what day was the game created"]= "FRIDAY",
    ["what day was sab created"]    = "FRIDAY",
    ["game creation day"]           = "FRIDAY",
    ["release month"]               = "MAY",
    ["release year"]                = "2025",
    ["year sab was created"]        = "2025",
    ["what year was sab created"]   = "2025",
    ["what year was the game created"] = "2025",
    ["year the game was created"]   = "2025",
    ["year sab was made"]           = "2025",
    ["month sab was made"] = "MAY", ["month the game was made"] = "MAY",
    ["month sab was released"] = "MAY", ["what month was sab made"] = "MAY",
    ["what month was sab released"] = "MAY", ["sab release month"] = "MAY",
    ["day sab was made"] = "FRIDAY", ["day sab was released"] = "FRIDAY",
    ["what day was sab made"] = "FRIDAY", ["what day was sab released"] = "FRIDAY",
    ["sab release day"] = "FRIDAY", ["game made on"] = "FRIDAY", ["sab made on"] = "FRIDAY",
    ["year the game was made"] = "2025", ["year made"] = "2025",
    ["when was sab made"] = "MAY162025", ["when made"] = "MAY162025", ["date made"] = "MAY162025",
    ["my name twice"] = "SAMMYSAMMY", ["my name 2 times"] = "SAMMYSAMMY",
    ["my name 3 times"] = "SAMMYSAMMYSAMMY", ["name twice"] = "SAMMYSAMMY",
    ["my age twice"] = "2424", ["my age 2 times"] = "2424", ["my age 3 times"] = "242424",
    ["favorite color twice"] = "BLUEBLUE", ["favorite color 2 times"] = "BLUEBLUE",
    ["favorite color 3 times"] = "BLUEBLUEBLUE", ["favorite color three times"] = "BLUEBLUEBLUE",
    ["favorite color 5 times"] = "BLUEBLUEBLUEBLUEBLUE",
    ["my favorite color twice"] = "BLUEBLUE", ["my favorite color 2 times"] = "BLUEBLUE",
    ["my favorite color 3 times"] = "BLUEBLUEBLUE",
    ["favorite sport twice"] = "FOOTBALLFOOTBALL", ["favorite food twice"] = "PIZZAPIZZA",
    ["owner twice"] = "SAMMYSAMMY", ["creator twice"] = "SAMMYSAMMY",

    ["year created"]                = "2025",
    ["what year was sab made"]      = "2025",
    ["year of sab"]                 = "2025",
    ["when was sab created"]        = "MAY162025",
    ["release date"]                = "MAY162025",
    ["when was sab released"]       = "MAY162025",
    ["when was the game released"]  = "MAY162025",
    ["game release date"]           = "MAY162025",
    ["game release"]                = "MAY162025",
    ["sab release"]                 = "MAY162025",
    ["game released"]               = "MAY162025",
    ["sab released"]                = "MAY162025",

    ["first trait"]                 = "LIGHTNING",
    ["1st trait"]                   = "LIGHTNING",
    ["first trait created"]         = "LIGHTNING",
    ["1st trait created"]           = "LIGHTNING",

    ["trait you get when struck by lightning"] = "MATEO",
    ["struck by lightning"]         = "MATEO",
    ["lightning trait"]             = "MATEO",
    ["trait from lightning"]        = "MATEO",
    ["trait when struck by lightning"] = "MATEO",
    ["lightning"]                   = "MATEO",

    ["first mutation"]              = "GOLD",
    ["1st mutation"]                = "GOLD",
    ["second mutation"]             = "DIAMOND",
    ["2nd mutation"]                = "DIAMOND",
    ["third mutation"]              = "BLOODROT",
    ["3rd mutation"]                = "BLOODROT",
    ["fourth mutation"]             = "RAINBOW",
    ["4th mutation"]                = "RAINBOW",
    ["fifth mutation"]              = "CANDY",
    ["5th mutation"]                = "CANDY",
    ["sixth mutation"]              = "LAVA",
    ["6th mutation"]                = "LAVA",
    ["seventh mutation"]            = "GALAXY",
    ["7th mutation"]                = "GALAXY",
    ["eighth mutation"]             = "YINYANG",
    ["8th mutation"]                = "YINYANG",
    ["ninth mutation"]              = "RADIOACTIVE",
    ["9th mutation"]                = "RADIOACTIVE",
    ["tenth mutation"]              = "CURSED",
    ["10th mutation"]               = "CURSED",
    ["eleventh mutation"]           = "DIVINE",
    ["11th mutation"]               = "DIVINE",
    ["twelfth mutation"]            = "CYBER",
    ["12th mutation"]               = "CYBER",
    ["thirteenth mutation"]         = "PHANTOM",
    ["13th mutation"]               = "PHANTOM",
    ["fourteenth mutation"]         = "CRYSTAL",
    ["14th mutation"]               = "CRYSTAL",

    ["evil mutation"]               = "CURSED",
    ["evil"]                        = "CURSED",
    ["cursed mutation"]             = "CURSED",
    ["angelic mutation"]            = "DIVINE",
    ["angelic"]                     = "DIVINE",
    ["divine mutation"]             = "DIVINE",
    ["good mutation"]               = "DIVINE",
    ["best mutation"]               = "DIVINE",
    ["top mutation"]                = "DIVINE",
    ["latest mutation"]             = "CRYSTAL",
    ["most recent mutation"]        = "CRYSTAL",
    ["most recent"]                 = "CRYSTAL",
    ["newest mutation"]             = "CRYSTAL",
    ["divinecursed"]                = "DIVINECURSED",
    ["curseddivine"]                = "CURSEDDIVINE",

    ["green mutation"]              = "RADIOACTIVE",
    ["turns green"]                 = "RADIOACTIVE",
    ["green"]                       = "RADIOACTIVE",
    ["purple mutation"]             = "GALAXY",
    ["turns purple"]                = "GALAXY",
    ["purple"]                      = "GALAXY",
    ["black and white mutation"]    = "YINYANG",
    ["black mutation"]              = "YINYANG",
    ["turns black"]                 = "YINYANG",
    ["black and white"]             = "YINYANG",
    ["yellow mutation"]             = "DIVINE",
    ["turns yellow"]                = "DIVINE",
    ["yellow"]                      = "DIVINE",
    ["red mutation"]                = "CURSED",
    ["turns red"]                   = "CURSED",
    ["red"]                         = "CURSED",
    ["orange mutation"]             = "LAVA",
    ["turns orange"]                = "LAVA",
    ["orange"]                      = "LAVA",

    ["first machine"]               = "RAINBOWMACHINE",
    ["1st machine"]                 = "RAINBOWMACHINE",
    ["second machine"]              = "BUBBLEGUMMACHINE",
    ["2nd machine"]                 = "BUBBLEGUMMACHINE",
    ["third machine"]               = "FUSEMACHINE",
    ["3rd machine"]                 = "FUSEMACHINE",
    ["fourth machine"]              = "CRAFTMACHINE",
    ["4th machine"]                 = "CRAFTMACHINE",
    ["fifth machine"]               = "WITCHFUSE",
    ["5th machine"]                 = "WITCHFUSE",
    ["sixth machine"]               = "BRAINROTDEALER",
    ["6th machine"]                 = "BRAINROTDEALER",
    ["seventh machine"]             = "BRAINROTTRADER",
    ["7th machine"]                 = "BRAINROTTRADER",
    ["eighth machine"]              = "SANTASFUSE",
    ["8th machine"]                 = "SANTASFUSE",
    ["ninth machine"]               = "SANTASSHOP",
    ["9th machine"]                 = "SANTASSHOP",
    ["tenth machine"]               = "NEWYEARSMACHINE",
    ["10th machine"]                = "NEWYEARSMACHINE",
    ["eleventh machine"]            = "DUELSMACHINE",
    ["11th machine"]                = "DUELSMACHINE",
    ["twelfth machine"]             = "CUPIDSMACHINE",
    ["12th machine"]                = "CUPIDSMACHINE",
    ["thirteenth machine"]          = "TRADEMACHINE",
    ["13th machine"]                = "TRADEMACHINE",
    ["fourteenth machine"]          = "DIVINEFUSE",
    ["14th machine"]                = "DIVINEFUSE",
    ["fifteenth machine"]           = "EGGINCUBATOR",
    ["15th machine"]                = "EGGINCUBATOR",
    ["sixteenth machine"]           = "CYBERCRAFTMACHINE",
    ["16th machine"]                = "CYBERCRAFTMACHINE",
    ["seventeenth machine"]         = "SUMMERFUSE",
    ["17th machine"]                = "SUMMERFUSE",
    ["eighteenth machine"]          = "LOSTRADERS",
    ["18th machine"]                = "LOSTRADERS",

    ["og brainrot cannot be obtained"] = "HEADLESSHORSEMAN",
    ["headless horseman"]           = "HEADLESSHORSEMAN",
    ["rarest brainrot"]             = "HEADLESSHORSEMAN",
    ["rarest"]                      = "HEADLESSHORSEMAN",
    ["best brainrot"]               = "STRAWBERRYELEPHANT",
    ["unobtainable brainrot"]       = "HEADLESSHORSEMAN",
    ["unobtainable"]                = "HEADLESSHORSEMAN",

    ["first og added"]              = "STRAWBERRYELEPHANT",
    ["1st og"]                      = "STRAWBERRYELEPHANT",
    ["second og added"]             = "MEOWL",
    ["2nd og"]                      = "MEOWL",
    ["third og added"]              = "SKIBIDITOILET",
    ["3rd og"]                      = "SKIBIDITOILET",
    ["fifth og added"]              = "JOHNPORK",
    ["5th og"]                      = "JOHNPORK",

    ["highest rarity"]              = "OG",
    ["rarest rarity"]               = "OG",
    ["top rarity"]                  = "OG",
    ["lowest rarity"]               = "COMMON",
    ["common rarity"]               = "COMMON",

    ["fire represents"]             = "DRAGON",
    ["fire stands for"]             = "DRAGON",
    ["won the world cup"]           = "SPAIN",
    ["world cup winner"]            = "SPAIN",
    ["world cup"]                   = "SPAIN",
    ["worst game owner"]            = "SECRETLOKII",
    ["most boring game owner"]      = "SECRETLOKII",
    ["most boring game on roblox"]  = "KEYBOARDESCAPE",
    ["spawned during admin abuse war"] = "RACOONINIJANDELINI",
    ["who did i fight in the admin abuse war"] = "JANDEL",
    ["fought in admin abuse war"]   = "JANDEL",
    ["won the admin abuse war"]     = "GROWAGARDEN",
    ["worst secret"]                = "KARKERKARKURKUR",
    ["maximum server size"]         = "EIGHT",
    ["max server size"]             = "EIGHT",
    ["server size"]                 = "EIGHT",
    ["how many players"]            = "EIGHT",
    ["max players"]                 = "EIGHT",
    ["brother of hydra bunny"]      = "CERBERUS",
    ["hydra bunny brother"]         = "CERBERUS",

    ["game name"]                   = "STEALABRAINROT",
    ["name of the game"]            = "STEALABRAINROT",
    ["sab"]                         = "STEALABRAINROT",
    ["sab stands for"]              = "STEALABRAINROT",
    ["full name"]                   = "STEALABRAINROT",
    ["number of mutations"]         = "14",
    ["how many mutations"]          = "14",
    ["total mutations"]             = "THIRTEEN",
    ["number of machines"]          = "18",
    ["how many machines"]           = "18",
    ["total machines"]              = "18",
    ["most popular brainrot"]       = "DRAGONCANNELONNI",
    ["most common brainrot"]        = "NOOBINIPIZZANINI",

    -- Extra personal / contextual lookups
    ["favorite color twice"]        = "BLUEBLUE",
    ["fav color twice"]             = "BLUEBLUE",
    ["favorite color 2 times"]      = "BLUEBLUE",
    ["favorite color three times"]  = "BLUEBLUEBLUE",
    ["favorite color 3 times"]      = "BLUEBLUEBLUE",
    ["favorite color, favorite sport"] = "BLUEFOOTBALL",
    ["favorite color, favorite animal"] = "BLUESPIDER",
    ["favorite color, favorite food"] = "BLUEPIZZA",
    ["favorite color, favorite player"] = "BLUERONALDO",
    ["favorite color, creator"] = "BLUESAMMY",
    ["favorite color, owner"] = "BLUESAMMY",
    ["favorite color, username"] = "BLUESPYDERSAMMY",
    ["favorite color, roblox username"] = "BLUESPYDERSAMMY",
    ["favorite color, my age"] = "BLUE24",
    ["favorite color, my country"] = "BLUEBRAZIL",
    ["favorite sport, favorite player"] = "FOOTBALLRONALDO",
    ["favorite sport, favorite color"] = "FOOTBALLBLUE",
    ["favorite sport, favorite animal"] = "FOOTBALLSPIDER",
    ["favorite sport, owner"] = "FOOTBALLSAMMY",
    ["favorite sport, creator"] = "FOOTBALLSAMMY",
    ["creator, owner"] = "SAMMYSAMMY",
    ["creator, username"] = "SAMMYSPYDERSAMMY",
    ["owner, username"] = "SAMMYSPYDERSAMMY",
    ["favorite color, favorite sport, favorite animal"] = "BLUEFOOTBALLSPIDER",
    ["color, sport, animal"] = "BLUEFOOTBALLSPIDER",
    ["discord"]                     = "ACE",
    ["discord server"]              = "ACE",
    ["sammy discord"]               = "SPYDERSAMMY",
    ["twitter"]                     = "SPYDERSAMMY",
    ["sammy twitter"]               = "SPYDERSAMMY",
    ["x account"]                   = "SPYDERSAMMY",
    ["tiktok"]                      = "SPYDERSAMMY",
    ["sammy tiktok"]                = "SPYDERSAMMY",
    ["instagram"]                   = "SPYDERSAMMY",
    ["favorite number"]             = "SEVEN",
    ["fav number"]                  = "SEVEN",
    ["lucky number"]                = "SEVEN",
    ["number"]                      = "SEVEN",
    ["first update"]                = "MUTATIONS",
    ["1st update"]                  = "MUTATIONS",
    ["first brainrot added"]        = "STRAWBERRYELEPHANT",
    ["1st brainrot"]                = "STRAWBERRYELEPHANT",
    ["oldest brainrot"]             = "STRAWBERRYELEPHANT",
    ["newest mutation"]             = "CRYSTAL",
    ["last mutation"]             = "CRYSTAL",
    ["latest mutation"]             = "CRYSTAL",
    ["newest machine"]              = "LOSTRADERS",
    ["last machine"]                = "LOSTRADERS",
    ["latest machine"]              = "LOSTRADERS",
    ["type of game"]                = "SIMULATOR",
    ["game genre"]                  = "SIMULATOR",
    ["genre"]                       = "SIMULATOR",
    ["sammy pet name"]              = "SPIDER",
    ["pet name"]                    = "SPIDER",
    ["pet"]                         = "SPIDER",
    ["animal"]                      = "SPIDER",
    ["what is sab"]                 = "STEALABRAINROT",
    ["total rarities"]              = "SIX",
    ["how many rarities"]           = "SIX",
    ["number of rarities"]          = "SIX",
    ["rarities"]                    = "SIX",

    -- standalone single-word fallbacks
    ["fire"]                        = "DRAGON",
    ["dragon"]                      = "DRAGON",
    ["players"]                     = "EIGHT",
    ["player count"]                = "EIGHT",
    ["server"]                      = "EIGHT",
    ["brother"]                     = "CERBERUS",
    ["cerberus"]                    = "CERBERUS",
    ["hydra bunny"]                 = "CERBERUS",
    ["location"]                    = "BRAZIL",
    ["from"]                        = "BRAZIL",
    ["name"]                        = "SAMMY",
    ["my name"]                     = "SAMMY",
    ["roblox"]                      = "SPYDERSAMMY",
    ["youtube"]                     = "SPYDERSAMMY",
    ["food"]                        = "PIZZA",
    ["sport"]                       = "FOOTBALL",
    ["player"]                      = "RONALDO",
    ["football"]                    = "FOOTBALL",
    ["game"]                        = "ROBLOX",
    ["update"]                      = "MUTATIONS",
    ["trait"]                       = "LIGHTNING",
    ["first trait added"]           = "LIGHTNING",

    -- mutation by number (alternate phrasing)
    ["mutation 1"]  = "GOLD",      ["mutation number 1"]  = "GOLD",
    ["mutation 2"]  = "DIAMOND",   ["mutation number 2"]  = "DIAMOND",
    ["mutation 3"]  = "BLOODROT",  ["mutation number 3"]  = "BLOODROT",
    ["mutation 4"]  = "RAINBOW", ["mutation number 4"]  = "RAINBOW",
    ["mutation 5"]  = "CANDY",     ["mutation number 5"]  = "CANDY",
    ["mutation 6"]  = "LAVA",      ["mutation number 6"]  = "LAVA",
    ["mutation 7"]  = "GALAXY",    ["mutation number 7"]  = "GALAXY",
    ["mutation 8"]  = "YINYANG",   ["mutation number 8"]  = "YINYANG",
    ["mutation 9"]  = "RADIOACTIVE",["mutation number 9"] = "RADIOACTIVE",
    ["mutation 10"] = "CURSED",    ["mutation number 10"] = "CURSED",
    ["mutation 11"] = "DIVINE",   ["mutation number 11"] = "DIVINE",
    ["mutation 12"] = "CYBER",     ["mutation number 12"] = "CYBER",
    ["mutation 13"] = "PHANTOM",   ["mutation number 13"] = "PHANTOM",
    ["mutation 14"] = "CRYSTAL",   ["mutation number 14"] = "CRYSTAL",

    -- machine by number (alternate phrasing)
    ["machine 1"]  = "RAINBOWMACHINE",    ["machine number 1"]  = "RAINBOWMACHINE",
    ["machine 2"]  = "BUBBLEGUMMACHINE",  ["machine number 2"]  = "BUBBLEGUMMACHINE",
    ["machine 3"]  = "FUSEMACHINE",       ["machine number 3"]  = "FUSEMACHINE",
    ["machine 4"]  = "CRAFTMACHINE",      ["machine number 4"]  = "CRAFTMACHINE",
    ["machine 5"]  = "WITCHFUSE",         ["machine number 5"]  = "WITCHFUSE",
    ["machine 6"]  = "BRAINROTDEALER",    ["machine number 6"]  = "BRAINROTDEALER",
    ["machine 7"]  = "BRAINROTTRADER",    ["machine number 7"]  = "BRAINROTTRADER",
    ["machine 8"]  = "SANTASFUSE",        ["machine number 8"]  = "SANTASFUSE",
    ["machine 9"]  = "SANTASSHOP",        ["machine number 9"]  = "SANTASSHOP",
    ["machine 10"] = "NEWYEARSMACHINE",   ["machine number 10"] = "NEWYEARSMACHINE",
    ["machine 11"] = "DUELSMACHINE",      ["machine number 11"] = "DUELSMACHINE",
    ["machine 12"] = "CUPIDSMACHINE",     ["machine number 12"] = "CUPIDSMACHINE",
    ["machine 13"] = "TRADEMACHINE",      ["machine number 13"] = "TRADEMACHINE",
    ["machine 14"] = "DIVINEFUSE",        ["machine number 14"] = "DIVINEFUSE",
    ["machine 15"] = "EGGINCUBATOR",      ["machine number 15"] = "EGGINCUBATOR",
    ["machine 16"] = "CYBERCRAFTMACHINE", ["machine number 16"] = "CYBERCRAFTMACHINE",
    ["machine 17"] = "SUMMERFUSE",        ["machine number 17"] = "SUMMERFUSE",
    ["machine 18"] = "LOSTRADERS",        ["machine number 18"] = "LOSTRADERS",

    -- og brainrots by number
    ["og 1"]  = "STRAWBERRYELEPHANT", ["og number 1"]  = "STRAWBERRYELEPHANT",
    ["og 2"]  = "MEOWL",              ["og number 2"]  = "MEOWL",
    ["og 3"]  = "SKIBIDITOILET",      ["og number 3"]  = "SKIBIDITOILET",
    ["og 5"]  = "JOHNPORK",           ["og number 5"]  = "JOHNPORK",

    -- worst / least rare brainrot
    ["worst brainrot"]              = "NOOBINIPIZZANINI",
    ["most common brainrot"]        = "NOOBINIPIZZANINI",
    ["least rare brainrot"]         = "NOOBINIPIZZANINI",
    ["weakest brainrot"]            = "NOOBINIPIZZANINI",
    ["most popular brainrot"]       = "DRAGONCANNELONNI",
    ["common brainrot"]             = "NOOBINIPIZZANINI",

    -- mutation color lookups (reverse: "color of X mutation")
    ["color of gold mutation"]      = "YELLOW",
    ["color of diamond mutation"]   = "BLUE",
    ["color of bloodrot mutation"]  = "RED",
    ["color of rainbow mutation"]   = "RAINBOW",
    ["color of candy mutation"]     = "PINK",
    ["color of lava mutation"]      = "ORANGE",
    ["color of galaxy mutation"]    = "PURPLE",
    ["color of yinyang mutation"]   = "BLACK",
    ["color of radioactive mutation"]="GREEN",
    ["color of cursed mutation"]    = "RED",
    ["color of divine mutation"]    = "YELLOW",
    ["color of cyber mutation"]     = "BLUE",
    ["color of phantom mutation"]   = "BLACK",
    ["color of crystal mutation"]   = "BLUEPURPLE",
    ["divine color"]                = "YELLOW",
    ["cursed color"]                = "RED",
    ["radioactive color"]           = "GREEN",
    ["galaxy color"]                = "PURPLE",
    ["yinyang color"]               = "BLACK",
    ["lava color"]                  = "ORANGE",

    -- "what mutation is X color"
    ["blue mutation"]               = "DIAMOND",
    ["pink mutation"]               = "CANDY",

    -- specific mutation name lookups
    ["gold"]                        = "GOLD",
    ["diamond"]                     = "DIAMOND",
    ["bloodrot"]                    = "BLOODROT",
    ["rainbow"]                     = "RAINBOW",
    ["candy"]                       = "CANDY",
    ["lava"]                        = "LAVA",
    ["galaxy"]                      = "GALAXY",
    ["yinyang"]                     = "YINYANG",
    ["radioactive"]                 = "RADIOACTIVE",
    ["cursed"]                      = "CURSED",
    ["divine"]                      = "DIVINE",
    ["cyber"]                       = "CYBER",
    ["phantom"]                     = "PHANTOM",
    ["crystal"]                     = "CRYSTAL",
    ["cursed"]                      = "CURSED",
    ["rainbow"]                     = "RAINBOW",
    ["cyber"]                       = "CYBER",
    ["divine"]                      = "DIVINE",

    -- mutation position lookups (what number is X)
    ["what number is gold"]         = "1",
    ["what number is diamond"]      = "2",
    ["what number is bloodrot"]     = "3",
    ["what number is rainbow"]      = "4",
    ["what number is candy"]        = "5",
    ["what number is lava"]         = "6",
    ["what number is galaxy"]       = "7",
    ["what number is yinyang"]      = "8",
    ["what number is radioactive"]  = "9",
    ["what number is cursed"]       = "10",
    ["what number is divine"]       = "11",
    ["what number is cyber"]        = "12",
    ["what number is phantom"]      = "13",
    ["what number is crystal"]      = "14",

    -- machine name lookups
    ["rainbowmachine"]              = "RAINBOWMACHINE",
    ["bubblegummachine"]            = "BUBBLEGUMMACHINE",
    ["fusemachine"]                 = "FUSEMACHINE",
    ["craftmachine"]                = "CRAFTMACHINE",
    ["witchfuse"]                   = "WITCHFUSE",
    ["brainrotdealer"]              = "BRAINROTDEALER",
    ["brainrottrader"]              = "BRAINROTTRADER",
    ["santasfuse"]                  = "SANTASFUSE",
    ["santasshop"]                  = "SANTASSHOP",
    ["newyearsmachine"]             = "NEWYEARSMACHINE",
    ["duelsmachine"]                = "DUELSMACHINE",
    ["cupidsmachine"]               = "CUPIDSMACHINE",
    ["trademachine"]                = "TRADEMACHINE",
    ["divinefuse"]                  = "DIVINEFUSE",
    ["eggincubator"]                = "EGGINCUBATOR",
    ["cybercraftmachine"]           = "CYBERCRAFTMACHINE",
    ["summerfuse"]                  = "SUMMERFUSE",
    ["lostraders"]                  = "LOSTRADERS",

    -- extra rarity questions
    ["best rarity"]                 = "OG",
    ["rarest rarity"]               = "OG",
    ["highest rarity"]              = "OG",
    ["worst rarity"]                = "COMMON",
    ["lowest rarity"]               = "COMMON",
    ["6th rarity"]                  = "OG",
    ["1st rarity"]                  = "COMMON",
    ["second rarity"]               = "UNCOMMON",
    ["2nd rarity"]                  = "UNCOMMON",
    ["third rarity"]                = "RARE",
    ["3rd rarity"]                  = "RARE",
    ["fourth rarity"]               = "EPIC",
    ["4th rarity"]                  = "EPIC",
    ["fifth rarity"]                = "LEGENDARY",
    ["5th rarity"]                  = "LEGENDARY",
    ["sixth rarity"]                = "OG",
    ["uncommon"]                    = "UNCOMMON",
    ["rare"]                        = "RARE",
    ["epic"]                        = "EPIC",
    ["legendary"]                   = "LEGENDARY",
    ["og"]                          = "OG",
    ["common"]                      = "COMMON",

    -- extra owner questions
    ["sammy name"]                  = "SAMMY",
    ["game owner"]                  = "SAMMY",
    ["developer"]                   = "SAMMY",
    ["dev"]                         = "SAMMY",
    ["made by"]                     = "SAMMY",
    ["created by"]                  = "SAMMY",
    ["made this game"]              = "SAMMY",
    ["real name of sammy"]          = "SAMMY",
    ["sammys name"]                 = "SAMMY",
    ["birth country"]               = "BRAZIL",
    ["born in"]                     = "BRAZIL",
    ["lives in"]                    = "BRAZIL",
    ["comes from"]                  = "BRAZIL",
    ["channel"]                     = "SPYDERSAMMY",
    ["handle"]                      = "SPYDERSAMMY",

    -- extra game info questions
    ["game type"]                   = "SIMULATOR",
    ["what type"]                   = "SIMULATOR",
    ["sab genre"]                   = "SIMULATOR",
    ["sab type"]                    = "SIMULATOR",
    ["how many players in server"]  = "EIGHT",
    ["server capacity"]             = "EIGHT",
    ["players per server"]          = "EIGHT",
    ["max server"]                  = "EIGHT",
    ["day game released"]           = "FRIDAY",
    ["day sab released"]            = "FRIDAY",
    ["release day"]                 = "FRIDAY",
    ["day released"]                = "FRIDAY",
    ["what day was it released"]    = "FRIDAY",
    ["what day was it created"]     = "FRIDAY",
    ["sab creation year"]           = "2025",
    ["creation year"]               = "2025",
    ["when created"]                = "MAY162025",
    ["when released"]               = "MAY162025",
    ["date released"]               = "MAY162025",
    ["date created"]                = "MAY162025",

    -- trait questions
    ["trait added first"]           = "LIGHTNING",
    ["trait first added"]           = "LIGHTNING",
    ["what trait"]                  = "LIGHTNING",
    ["lightning strike trait"]      = "MATEO",
    ["get struck by lightning"]     = "MATEO",
    ["lightning gives"]             = "MATEO",
    ["struck by lightning trait"]   = "MATEO",
    ["mateo"]                       = "MATEO",

    -- trivia extras
    ["fire symbol"]                 = "DRAGON",
    ["fire meaning"]                = "DRAGON",
    ["fire brainrot"]               = "DRAGON",
    ["world cup"]                   = "SPAIN",
    ["won world cup"]               = "SPAIN",
    ["football world cup"]          = "SPAIN",
    ["worst owner"]                 = "SECRETLOKII",
    ["boring owner"]                = "SECRETLOKII",
    ["most boring owner"]           = "SECRETLOKII",
    ["boring game"]                 = "KEYBOARDESCAPE",
    ["most boring game"]            = "KEYBOARDESCAPE",
    ["boring roblox game"]          = "KEYBOARDESCAPE",
    ["admin abuse war"]             = "GROWAGARDEN",
    ["who won admin war"]           = "GROWAGARDEN",
    ["admin war winner"]            = "GROWAGARDEN",
    ["admin war"]                   = "GROWAGARDEN",
    ["who did sammy fight"]         = "JANDEL",
    ["sammy fought"]                = "JANDEL",
    ["fight in admin war"]          = "JANDEL",
    ["admin war brainrot"]          = "RACOONINIJANDELINI",
    ["spawned in admin war"]        = "RACOONINIJANDELINI",
    ["secret"]                      = "KARKERKARKURKUR",
    ["worst secret"]                = "KARKERKARKURKUR",
    ["bad secret"]                  = "KARKERKARKURKUR",
    ["hydra bunny"]                 = "CERBERUS",
    ["cerberus brother"]            = "CERBERUS",
    ["brother of hydra"]            = "CERBERUS",

    -- brainrot count / machine count
    ["brainrot count"]              = "THIRTEEN",
    ["mutation count"]              = "THIRTEEN",
    ["machine count"]               = "EIGHTEEN",
    ["rarity count"]                = "SIX",
    ["how many brainrots"]          = "THIRTEEN",
    ["number brainrots"]            = "THIRTEEN",
    ["how many og brainrots"]       = "FIVE",
    ["total og brainrots"]          = "FIVE",
    ["og count"]                    = "FIVE",

    -- sab full name
    ["steal a brainrot"]            = "STEALABRAINROT",
    ["full game name"]              = "STEALABRAINROT",
    ["game full name"]              = "STEALABRAINROT",
    ["sab full name"]               = "STEALABRAINROT",
}

-- localExactAnswer: ONLY returns something when we are 100% certain via exact key match.
-- Everything else falls through to Groq AI so the AI always gets a chance to answer.
local function localExactAnswer(text)
    if not text or text == "" then return nil end
    local l = text:lower()

    -- Exact DB lookup after stripping question filler words
    local clean = l
    clean = clean:gsub("what%s+is", ""):gsub("what%s+are", ""):gsub("what%s+was", ""):gsub("what%s+were", "")
    clean = clean:gsub("who%s+is", ""):gsub("who%s+was", ""):gsub("when%s+is", ""):gsub("when%s+was", "")
    clean = clean:gsub("where%s+is", ""):gsub("where%s+are", ""):gsub("how%s+old", ""):gsub("how%s+tall", "")
    clean = clean:gsub("how%s+many", ""):gsub("how%s+much", ""):gsub("do%s+you%s+know", ""):gsub("can%s+you%s+tell", "")
    clean = clean:gsub("tell%s+me", ""):gsub("i%s+need", ""):gsub("give%s+me", ""):gsub("what's", ""):gsub("whats", "")
    clean = clean:gsub("am%s+i", ""):gsub("do%s+i", ""):gsub("did%s+i", ""):gsub("have%s+i", "")
    clean = clean:gsub("^my%s+", ""):gsub("%s+my%s+", " "):gsub("^sammy[s]?%s+", ""):gsub("^sammys%s+", "")
    clean = clean:gsub("the%s+", ""):gsub("%f[%a]a%f[%A]", ""):gsub("%f[%a]an%f[%A]", ""):gsub("of%s+", ""):gsub("for%s+", "")
    clean = clean:gsub("[%?%.%,!]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    clean = clean:gsub("%d+", ""):gsub("%s+", " ")
    clean = trim(clean)

    if SAB_DB[clean] then return SAB_DB[clean] end
    -- Also try the raw lowercase question directly
    local raw = trim(l:gsub("[%?%.%,!]", ""):gsub("%s+", " "))
    if SAB_DB[raw] then return SAB_DB[raw] end

    -- Fuzzy: convert written ordinals to digits so "fifth mutation" also matches "5th mutation"
    local ordinals = {one=1,two=2,three=3,four=4,five=5,six=6,seven=7,eight=8,nine=9,ten=10,
                      eleven=11,twelve=12,thirteen=13,fourteen=14,fifteen=15,sixteen=16,seventeen=17,eighteen=18}
    local numwords  = {first=1,second=2,third=3,fourth=4,fifth=5,sixth=6,seventh=7,eighth=8,ninth=9,tenth=10,
                       eleventh=11,twelfth=12,thirteenth=13,fourteenth=14,fifteenth=15,sixteenth=16,seventeenth=17,eighteenth=18}
    local suffixes  = {[1]="1st",[2]="2nd",[3]="3rd"}
    local function ord(n) return suffixes[n] or (n.."th") end

    -- replace "fifth mutation" -> "5th mutation" etc.
    local conv = clean
    for word, n in pairs(numwords) do
        conv = conv:gsub("%f[%a]"..word.."%f[%A]", ord(n))
    end
    for word, n in pairs(ordinals) do
        conv = conv:gsub("%f[%a]"..word.."%f[%A]", tostring(n))
    end
    if conv ~= clean and SAB_DB[conv] then return SAB_DB[conv] end

    -- Fuzzy: "mutation 5" -> try "5th mutation" style too
    local kind, num2 = conv:match("^(.-)%s+(%d+)$")
    if kind and num2 then
        local alt = ord(tonumber(num2)).." "..trim(kind)
        if SAB_DB[alt] then return SAB_DB[alt] end
    end
    local num3, kind2 = conv:match("^(%d+)%s+(.-)$")
    if num3 and kind2 then
        local alt = ord(tonumber(num3)).." "..trim(kind2)
        if SAB_DB[alt] then return SAB_DB[alt] end
    end

    return nil
    -- NOTE: NO broad substring scan here - that caused wrong instant answers.
    -- Groq AI handles everything that isn't an exact key match.
end

-- - Groq AI (Llama 3.3 70B) -
local AI_SYSTEM = table.concat({
    "You are a riddle-answering bot for the Roblox game STEAL A BRAINROT (SAB).",
    "",
    "=== CRITICAL OUTPUT RULES - NEVER BREAK THESE ===",
    "1. Reply with ONE single word in ALL CAPS. NOTHING else. No punctuation.",
    "2. NEVER include spaces. Write HEADLESSHORSEMAN not HEADLESS HORSEMAN.",
    "3. NEVER repeat the answer. Return the BASE answer exactly once, even if the question says 'X times'. The system handles repetition.",
    "4. NEVER spell out numbers as words. If the answer is a number, write it as digits: 24 not TWENTYFOUR, 2025 not TWOTHOUSANDTWENTYFIVE.",
    "5. No explanation, no extra text, just the single answer word.",
    "",
    "=== CONTEXT - EVERY QUESTION IS ABOUT THIS GAME OR ITS OWNER ===",
    "All personal questions ('my X', 'the owner X', 'sammy X', 'how old am i') refer to the game owner SAMMY (SpyderSammy).",
    "There are NO exceptions. If the question seems personal, it is ALWAYS about SAMMY.",
    "",
    "=== OWNER: SAMMY (SpyderSammy / Sam Brakta) ===",
    "Real name: SAMMY",
    "Roblox username: SPYDERSAMMY",
    "Age: 24 | Birth year: 2001 | Born day: FRIDAY | Birth month: JANUARY",
    "Country: BRAZIL | State+City: SAOPAULO | Nationality: BRAZILIAN",
    "Favorite color: BLUE | Favorite sport: FOOTBALL | Favorite food: PIZZA",
    "Favorite football player: RONALDO | Favorite animal: SPIDER",
    "YouTube/Twitter/TikTok/Instagram: SPYDERSAMMY",
    "Favorite number: SEVEN",
    "",
    "=== GAME INFO ===",
    "Full name: STEALABRAINROT | Short: SAB | Genre: SIMULATOR",
    "Release date: MAY 16 2025 | Release day: FRIDAY | Release month: MAY | Release year: 2025",
    "Year created: 2025 | Max server size: EIGHT players",
    "First trait ever added: LIGHTNING | Trait you get from lightning strike: MATEO",
    "Total mutations: THIRTEEN | Total machines: EIGHTEEN | Total rarities: SIX",
    "",
    "=== RARITIES (lowest to highest) ===",
    "COMMON < UNCOMMON < RARE < EPIC < LEGENDARY < OG",
    "Highest/rarest rarity: OG | Lowest: COMMON",
    "Rarest/best/unobtainable brainrot: HEADLESSHORSEMAN",
    "Most popular brainrot: SKIBIDITOILET",
    "Worst brainrot: (if asked 'worst brainrot' -> HEADLESSHORSEMAN is unobtainable, common answer is SKIBIDITOILET for most common)",
    "",
    "=== OG BRAINROTS (order added) ===",
    "1st: STRAWBERRYELEPHANT | 2nd: MEOWL | 3rd: SKIBIDITOILET | 5th: JOHNPORK",
    "Unobtainable OG: HEADLESSHORSEMAN",
    "",
    "=== MUTATIONS (numbered order) ===",
    "1=GOLD 2=DIAMOND 3=BLOODROT 4=RAINBOW 5=CANDY 6=LAVA 7=GALAXY",
    "8=YINYANG 9=RADIOACTIVE 10=CURSED 11=DIVINE 12=CYBER 13=PHANTOM 14=CRYSTAL",
    "Newest/last mutation: CRYSTAL",
    "Evil mutation: CURSED | Angelic/good mutation: DIVINE",
    "Evil first combo: CURSEDDIVINE | Angelic first combo: DIVINECURSED",
    "",
    "=== MUTATION COLORS ===",
    "Green=RADIOACTIVE | Purple=GALAXY | Black or Black+White=YINYANG | Yellow=DIVINE | Red=CURSED | Orange=LAVA",
    "",
    "=== MACHINES (numbered order) ===",
    "1=RAINBOWMACHINE 2=BUBBLEGUMMACHINE 3=FUSEMACHINE 4=CRAFTMACHINE 5=WITCHFUSE",
    "6=BRAINROTDEALER 7=BRAINROTTRADER 8=SANTASFUSE 9=SANTASSHOP 10=NEWYEARSMACHINE",
    "11=DUELSMACHINE 12=CUPIDSMACHINE 13=TRADEMACHINE 14=DIVINEFUSE 15=EGGINCUBATOR",
    "16=CYBERCRAFTMACHINE 17=SUMMERFUSE 18=LOSTRADERS",
    "Newest/last machine: LOSTRADERS",
    "",
    "=== TRIVIA ===",
    "Fire represents: DRAGON | World Cup winner: ARGENTINA",
    "Worst/most boring game owner: SECRETLOKII | Most boring Roblox game: KEYBOARDESCAPE",
    "Brainrot spawned during admin abuse war: RACOONINIJANDELINI",
    "Who Sammy fought in admin abuse war: JANDEL | Who won admin abuse war: GROWAGARDEN",
    "Worst secret: KARKERKARKURKUR | Brother of Hydra Bunny: CERBERUS",
    "Brother of Hydra Bunny: CERBERUS",
    "",
    "=== EXAMPLE Q&A ===",
    "Q: what is my favorite color -> A: BLUE",
    "Q: who made this game -> A: SAMMY",
    "Q: what mutation turns you green -> A: RADIOACTIVE",
    "Q: what is the 7th machine -> A: BRAINROTTRADER",
    "Q: what year was sab created -> A: 2025",
    "Q: what is the rarest brainrot -> A: HEADLESSHORSEMAN",
    "Q: what is the worst brainrot -> A: HEADLESSHORSEMAN",
    "Q: what is the evil mutation -> A: CURSED",
    "Q: my favorite color (DO NOT repeat it, just say once) -> A: BLUE",
}, "\n")

-- queryAI: returns answer (string|nil), nil, errMsg (string|nil)
-- Uses Groq (api.groq.com).
-- statusCb(msg): optional callback to push live status lines to the console
local function queryAI(question, statusCb)
    local function stat(msg) if statusCb then statusCb(msg) end end

    if not riddleHttpRequest then
        return nil, nil, "no http executor (syn.request / http_request not found)"
    end
    if not GROQ_API_KEY or GROQ_API_KEY == "" then
        return nil, nil, "GROQ_API_KEY is empty"
    end

    stat("calling AI...")

    local body = HttpService:JSONEncode({
        model    = "openai/gpt-oss-120b",
        messages = {
            { role = "system", content = AI_SYSTEM },
            {
                role    = "user",
                content = "/no_think\n" .. tostring(question)
                    .. "\n\nRules: ONE word, ALL CAPS, NO spaces, NO repetition, NO spelling out numbers (write 2025 not TWOTHOUSANDTWENTYFIVE). Just the answer.",
            },
        },
        temperature = 0,
        max_tokens  = 64,
    })

    local ok, res = pcall(riddleHttpRequest, {
        Url     = "https://api.groq.com/openai/v1/chat/completions",
        Method  = "POST",
        Headers = {
            ["Content-Type"]  = "application/json",
            ["Authorization"] = "Bearer " .. GROQ_API_KEY,
        },
        Body = body,
    })

    if not ok then
        return nil, nil, "http_err: " .. tostring(res):sub(1, 100)
    end
    if not res or not res.Body then
        return nil, nil, "empty body (HTTP " .. tostring(res and res.StatusCode or "?") .. ")"
    end

    local sc = tonumber(res.StatusCode)
    if sc and sc ~= 200 then
        local bOk, bP = pcall(HttpService.JSONDecode, HttpService, res.Body)
        local detail = (bOk and bP and bP.error and bP.error.message)
            or res.Body:sub(1, 120)
        return nil, nil, ("HTTP %d: %s"):format(sc, tostring(detail):gsub("\n", " "))
    end

    local pOk, parsed = pcall(HttpService.JSONDecode, HttpService, res.Body)
    if not pOk or not parsed then
        return nil, nil, "JSON parse failed: " .. res.Body:sub(1, 80)
    end
    if parsed.error then
        return nil, nil, "API: " .. (parsed.error.message or "unknown error"):sub(1, 120)
    end

    local choice = parsed.choices and parsed.choices[1]
    if not choice then
        return nil, nil, "no choices in response"
    end

    local answer = (choice.message and choice.message.content) or ""
    answer = trim(answer):upper():gsub("[%s%?%.%,!\"'`\n\r]+", "")
    if answer == "" then
        return nil, nil, "empty answer from model"
    end
    -- Strip any "PREFIX:ANSWER" pattern - take only what's after the last colon
    if answer:find(":") then
        answer = answer:match(":([^:]+)$") or answer
    end
    -- Model dumps reasoning before the answer (e.g. "THEUSERISASKING...SODIVINE").
    -- Find which known SAB answer the blob ends with - longest match wins.
    if #answer > 25 then
        local best = nil
        for _, v in pairs(SAB_DB) do
            local clean = v:upper():gsub("%s+","")
            if #clean > 0 and answer:sub(-#clean) == clean then
                if not best or #clean > #best then best = clean end
            end
        end
        answer = best or answer:sub(-25)
    end
    return answer, nil, nil
end

local function extractNumber(text)
    for num in text:gmatch("%d+") do
        local n = tonumber(num)
        if n and n > 13 then return num end
    end
    return nil
end

local function splitByAnd(text)
    local parts = {}
    local clean = text:gsub("%s*%d+%s*$", "")
    -- treat "add" the same as "and" so "2nd mutation add 67" works like "2nd mutation and 67"
    clean = clean:gsub("%s+add%s+", " and ")
    for part in (clean .. " and "):gmatch("(.-)%s+and%s+") do
        part = trim(part)
        if part ~= "" then parts[#parts + 1] = part end
    end
    if #parts == 0 then parts[1] = trim(clean) end
    return parts
end

local function extractTimesMultiplier(text)
    local l = text:lower()
    if l:find("twice")  then return 2 end
    if l:find("thrice") then return 3 end
    local n = l:match("(%d+)%s*times")
    if n then
        n = tonumber(n)
        if n and n >= 2 and n <= 10 then return n end
    end
    return nil
end

-- Strip "N times / twice / thrice" text from a question before sending to Groq.
-- The CODE handles repetition - Groq must only return the base answer once.
local function stripMultiplierText(text)
    local s = text
    s = s:gsub("%s*%d+%s*[Tt]imes%s*", " ")
    s = s:gsub("%s*[Tt]wice%s*",        " ")
    s = s:gsub("%s*[Tt]hrice%s*",       " ")
    s = trim(s)
    if s == "" then s = text end   -- safety: don't send empty string
    return s
end

-- Strip trailing standalone number from a question (e.g. "favorite color 67" -> "favorite color").
-- This prevents Groq seeing a bare number it might spell out as text.
local function stripTrailingNumber(text)
    return trim(text:gsub("%s+%d+%s*$", ""))
end

-- Split on commas and "and"/"add". Strip filler like "at the end".
local function splitAllParts(text)
    local clean = text or ""
    clean = clean:gsub("%s+add%s+", " and ")
    clean = clean:gsub("%s*,%s*", " and ")
    clean = clean:gsub("%s+at%s+the%s+end", " ")
    clean = clean:gsub("%s+at%s+the%s+start", " ")
    clean = clean:gsub("%s+at%s+the%s+beginning", " ")
    local parts = {}
    for part in (clean .. " and "):gmatch("(.-)%s+and%s+") do
        part = trim(part)
        if part ~= "" then
            parts[#parts + 1] = part
        end
    end
    if #parts == 0 then
        parts[1] = trim(text or "")
    end
    return parts
end

-- DB first. AI only if not in DB. Numbers kept as-is. Never paste question text.
local function resolvePart(part, statusCb)
    local multiplier = extractTimesMultiplier(part)
    local q = stripMultiplierText(part)
    q = stripTrailingNumber(q)
    q = q:gsub("%s+at%s+the%s+end%s*$", "")
    q = q:gsub("%s+at%s+the%s+start%s*$", "")
    q = trim(q)
    if q == "" then return nil end

    -- pure number
    local onlyNum = q:match("^%d+$")
    if onlyNum then
        return multiplier and string.rep(onlyNum, multiplier) or onlyNum
    end

    local a = localExactAnswer(q)
    local qErr
    if not a then
        -- AI only when DB misses
        if statusCb then statusCb("AI: " .. q:sub(1, 40)) end
        a, _, qErr = queryAI(q, statusCb)
        if not a and qErr and statusCb then statusCb("AI error: " .. tostring(qErr)) end
    end
    if not a then return nil end

    local clean = tostring(a):upper():gsub("%s+", ""):gsub("[%?%.%,!\"'`]", "")
    -- never allow leftover instruction words in the answer
    if clean:find("ATTHEEND") or clean:find("ATTHESTART") or clean == "AND" then
        return nil
    end
    if clean == "" then return nil end
    return multiplier and string.rep(clean, multiplier) or clean
end

local function solveRiddle(text, statusCb)
    local suffix = extractNumber(text)
    local parts = splitAllParts(text)
    local answers = {}
    local failedParts = {}

    for _, part in ipairs(parts) do
        local ok, result = pcall(resolvePart, part, statusCb)
        if ok and result and result ~= "" then
            answers[#answers + 1] = result
        else
            failedParts[#failedParts + 1] = part
        end
    end

    -- If ANY part failed to resolve (and there was more than one part),
    -- do NOT submit a partial/incomplete answer. Fall back to asking the
    -- full question as one block instead of silently dropping parts.
    if #parts > 1 and #failedParts > 0 then
        if statusCb then
            statusCb("Part(s) unresolved: " .. table.concat(failedParts, " | ") .. " - falling back to full question")
        end
        if statusCb then statusCb("AI full question") end
        local a, _, qErr = queryAI(stripTrailingNumber(text), statusCb)
        if a then
            local clean = tostring(a):upper():gsub("%s+", ""):gsub("[%?%.%,!\"'`]", "")
            clean = clean:gsub("ATTHEEND", ""):gsub("ATTHESTART", "")
            if suffix and clean:sub(-#suffix) ~= suffix then
                clean = clean .. suffix
            end
            return clean, nil, nil
        end
        return nil, nil, "unresolved part(s): " .. table.concat(failedParts, " | ")
    end

    if #answers == 0 then
        -- full question to AI as last resort
        if statusCb then statusCb("AI full question") end
        local a, _, qErr = queryAI(stripTrailingNumber(text), statusCb)
        if a then
            local clean = tostring(a):upper():gsub("%s+", ""):gsub("[%?%.%,!\"'`]", "")
            clean = clean:gsub("ATTHEEND", ""):gsub("ATTHESTART", "")
            if suffix and clean:sub(-#suffix) ~= suffix then
                clean = clean .. suffix
            end
            return clean, nil, nil
        end
        return nil, nil, qErr or "no answer"
    end

    local out = table.concat(answers, "")
    if suffix and out:sub(-#suffix) ~= suffix then
        out = out .. suffix
    end
    return out, nil, nil
end

-- Returns true if `text` looks like a riddle/question rather than a code drop.
local function looksLikeRiddleText(text)
    if not text or text == "" then return false end
    -- Riddle keyword detection removed: every non-empty notification is treated as a riddle
    return true
end

-- Handles a single riddle notification: collects `riddleCaptureCount` messages,
-- concatenates them, solves via SAB_DB / Groq AI, then redeems via the same
-- Codes UI used for code notifications.
local function dispatchRiddle(text)
    if not autoRiddle then return false end
    if not looksLikeRiddleText(text) and not riddleCollecting then return false end

    if riddleCaptureCount > 0 then
        if riddleCollecting then
            local collectedNum = riddleCaptureCount - riddleRemain + 1
            table.insert(riddleBuf, text)
            riddleRemain = riddleRemain - 1
            logStatus(string.format("[%d/%d] \"%s\" - collected", collectedNum, riddleCaptureCount, text))
            if riddleRemain <= 0 then
                local fullQuestion = table.concat(riddleBuf, " ")
                riddleCollecting = false
                riddleBuf        = {}
                riddleRemain     = 0
                logStatus(string.format("[%d/%d] capture complete - solving: %s", riddleCaptureCount, riddleCaptureCount, fullQuestion))
                task.spawn(function()
                    local answer, _, err = solveRiddle(fullQuestion, function(msg) logStatus("Riddle: " .. msg) end)
                    if answer and answer ~= "" then
                        logStatus("[Answer] " .. answer)
                        logStatus("[Redeeming] pasting \"" .. answer .. "\" and submitting...")
                        local rOk, rErr = redeemCode(answer, riddleSubmitDelay)
                        if rOk then
                            logStatus("[Redeemed] Auto Riddle submit confirmed for: " .. answer)
                        else
                            logStatus("[Redeem FAILED] " .. tostring(rErr))
                        end
                    else
                        logStatus("[Failed] Riddle solve failed: " .. tostring(err or "no answer"))
                    end
                    riddleCycleActive = false
                end)
            end
        else
            riddleCollecting  = true
            riddleCycleActive = true
            riddleBuf         = { text }
            riddleRemain      = riddleCaptureCount - 1
            logStatus(string.format("[Riddle armed] Submit Code After = %d", riddleCaptureCount))
            logStatus(string.format("[1/%d] \"%s\" - collected", riddleCaptureCount, text))
            if riddleRemain <= 0 then
                local fullQuestion = table.concat(riddleBuf, " ")
                riddleCollecting = false
                riddleBuf        = {}
                riddleRemain     = 0
                logStatus(string.format("[%d/%d] capture complete - solving: %s", riddleCaptureCount, riddleCaptureCount, fullQuestion))
                task.spawn(function()
                    local answer, _, err = solveRiddle(fullQuestion, function(msg) logStatus("Riddle: " .. msg) end)
                    if answer and answer ~= "" then
                        logStatus("[Answer] " .. answer)
                        logStatus("[Redeeming] pasting \"" .. answer .. "\" and submitting...")
                        local rOk, rErr = redeemCode(answer, riddleSubmitDelay)
                        if rOk then
                            logStatus("[Redeemed] Auto Riddle submit confirmed for: " .. answer)
                        else
                            logStatus("[Redeem FAILED] " .. tostring(rErr))
                        end
                    else
                        logStatus("[Failed] Riddle solve failed: " .. tostring(err or "no answer"))
                    end
                    riddleCycleActive = false
                end)
            end
        end
        return true
    end

    -- riddleCaptureCount == 0: solve immediately on the single notification
    riddleCycleActive = true
    logStatus("[0/0] Solving riddle immediately: " .. text)
    task.spawn(function()
        local answer, _, err = solveRiddle(text, function(msg) logStatus("Riddle: " .. msg) end)
        if answer and answer ~= "" then
            logStatus("[Answer] " .. answer)
            logStatus("[Redeeming] pasting \"" .. answer .. "\" and submitting...")
            local rOk, rErr = redeemCode(answer, riddleSubmitDelay)
            if rOk then
                logStatus("[Redeemed] Auto Riddle submit confirmed for: " .. answer)
            else
                logStatus("[Redeem FAILED] " .. tostring(rErr))
            end
        else
            logStatus("[Failed] Riddle solve failed: " .. tostring(err or "no answer"))
        end
        riddleCycleActive = false
    end)
    return true
end

local function dispatch(text)
    if not scanEnabled then return end
    if not text or text == "" then return end

    -- Nothing armed: don't count/collect at all, just log that it was seen.
    if not autoCode and not autoRiddle and not forceScanActive then
        logStatus("Notification seen (no mode active - ignored): " .. text)
        return
    end

    if dispatchRiddle(text) then return end

    -- Force Scan: collecting flag already armed; bypass keyword gate entirely
    if forceScanActive and collecting then
        logStatus("Notification received (Force Scan): " .. text)
        table.insert(collectBuf, text)
        collectRemain = collectRemain - 1
        logStatus("Code tracking update: [" .. table.concat(collectBuf) .. "] (" .. collectRemain .. " remaining)")
        if collectRemain <= 0 then
            local result = table.concat(collectBuf)
            print(result)
            logStatus("Submit Code triggered -> entering: " .. result)
            redeemCode(result, codeSubmitDelay)   -- always redeem on a forced scan
            collecting      = false
            collectBuf      = {}
            collectRemain   = 0
            forceScanActive = false
            codeCycleActive = false
            logStatus("Force Scan complete")
        end
        return
    end

    -- Auto Code keyword-matching path removed: autoCode has no manual toggle
    -- anymore. Only the Force Scan button (forceScanActive) and Riddle mode
    -- (dispatchRiddle, checked above) can ever arm scanning now.
    logStatus("Notification seen (no active mode) - ignored: " .. text)
end

-- -----------------------------------------
--  WATCHER
-- -----------------------------------------
local function watchObject(obj)
    if seen[obj] then return end
    if isOwnedByUs(obj) then return end
    seen[obj] = true

    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        local dispatchToken = 0
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if isOwnedByUs(obj) or obj.Text == "" then return end
            dispatchToken = dispatchToken + 1
            local myToken = dispatchToken
            task.wait(0.15)
            if myToken ~= dispatchToken then return end -- text changed again (still typing); let the latest one win
            if isOwnedByUs(obj) or obj.Text == "" then return end
            dispatch(obj.Text)
        end)
    end

    for _, child in ipairs(obj:GetDescendants()) do
        watchObject(child)
    end

    obj.DescendantAdded:Connect(function(child)
        if isOwnedByUs(child) then return end
        local isNew = not seen[child]
        watchObject(child)
        if isNew then
            local t = getText(child)
            if t and t ~= "" then dispatch(t) end
        end
    end)
end

local function hookContainers()
    local names = { "TopNotification" }
    for _, name in ipairs(names) do
        local c = PlayerGui:FindFirstChild(name)
        if c then watchObject(c) end
    end
    PlayerGui.ChildAdded:Connect(function(child)
        for _, name in ipairs(names) do
            if child.Name == name then watchObject(child) end
        end
    end)
end
hookContainers()

-- (Spawn watcher + Discord webhook system removed - not needed)

-- title(TITLE_H) + tabBar(TABBAR_H) + page
-- page1 (Main)      = pad*2 + 3 rows * ROW_H + 2 gaps * ROW_GAP
-- Status page height (reuses the old Keywords-page height formula so the panel size stays consistent)
-- header(34) + divider(1) + gap(4) + scroll(SCROLL_H) + bpad(8)
-- -----------------------------------------
local TITLE_H  = 36
local TABBAR_H = 37
local ROW_H    = 34
local ROW_GAP  = 6
local PAGE_PAD = 10

local FILTER_SECTION_H = 34 + 1 + 4 + SCROLL_H + 8

local PAGE1_H = (ROW_H * 4 + ROW_GAP * 3) + PAGE_PAD * 2
local PAGE2_H = FILTER_SECTION_H + PAGE_PAD * 2
local PAGE_RIDDLE_H = (ROW_H * 3 + ROW_GAP * 2) + PAGE_PAD * 2

local FULL_H_MAIN   = TITLE_H + TABBAR_H + PAGE1_H
local FULL_H_KEY    = TITLE_H + TABBAR_H + PAGE2_H
local FULL_H_RIDDLE = TITLE_H + TABBAR_H + PAGE_RIDDLE_H
local MIN_H       = TITLE_H

-- -----------------------------------------
--  ROOT GUI
-- -----------------------------------------
meridianGui = Instance.new("ScreenGui")
meridianGui.Name           = "MeridianCodeSniper"
meridianGui.ResetOnSpawn   = false
meridianGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
meridianGui.Parent         = PlayerGui

-- -----------------------------------------
--  INTRO WARNING OVERLAY (full screen)
--  Informational only. Auto Riddle / Auto Code stay OFF until the
--  user manually toggles them inside the main GUI. Click anywhere
--  on the overlay (or "Please click to skip") to dismiss it.
-- -----------------------------------------
local introOverlay = Instance.new("TextButton")
introOverlay.Name                   = "IntroOverlay"
introOverlay.Size                   = UDim2.new(1, 0, 1, 0)
introOverlay.Position               = UDim2.new(0, 0, 0, 0)
introOverlay.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
introOverlay.BackgroundTransparency = 0.5
introOverlay.AutoButtonColor         = false
introOverlay.Text                   = ""
introOverlay.ZIndex                 = 1000
introOverlay.Parent                 = meridianGui

local warnLabel = Instance.new("TextLabel")
warnLabel.Size                   = UDim2.new(1, -80, 0, 40)
warnLabel.Position               = UDim2.new(0.5, 0, 0.5, -70)
warnLabel.AnchorPoint             = Vector2.new(0.5, 0.5)
warnLabel.BackgroundTransparency = 1
warnLabel.Font                   = Enum.Font.GothamBold
warnLabel.TextSize               = 22
warnLabel.TextColor3             = C.accentSec
warnLabel.Text                   = "⚠ WARNING ⚠"
warnLabel.ZIndex                 = 1001
warnLabel.Parent                 = introOverlay

local warnBody = Instance.new("TextLabel")
warnBody.Size                   = UDim2.new(1, -160, 0, 100)
warnBody.Position               = UDim2.new(0.5, 0, 0.5, 0)
warnBody.AnchorPoint             = Vector2.new(0.5, 0.5)
warnBody.BackgroundTransparency = 1
warnBody.Font                   = Enum.Font.Gotham
warnBody.TextSize               = 16
warnBody.TextColor3             = Color3.fromRGB(255, 255, 255)
warnBody.TextWrapped             = true
warnBody.TextXAlignment          = Enum.TextXAlignment.Center
warnBody.TextYAlignment          = Enum.TextYAlignment.Center
warnBody.Text = "The script is fully disabled by default. Please click which mode you want to use, Auto Riddle or Auto Code, inside the menu. You can switch modes anytime."
warnBody.ZIndex                 = 1001
warnBody.Parent                 = introOverlay

local introSkipLabel = Instance.new("TextLabel")
introSkipLabel.Size                   = UDim2.new(1, -80, 0, 20)
introSkipLabel.Position               = UDim2.new(0.5, 0, 0.5, 70)
introSkipLabel.AnchorPoint             = Vector2.new(0.5, 0.5)
introSkipLabel.BackgroundTransparency = 1
introSkipLabel.Font                   = Enum.Font.Gotham
introSkipLabel.TextSize               = 13
introSkipLabel.TextColor3             = Color3.fromRGB(200, 200, 200)
introSkipLabel.Text                   = "Please click to skip"
introSkipLabel.ZIndex                 = 1001
introSkipLabel.Parent                 = introOverlay

introOverlay.MouseButton1Click:Connect(function()
    introOverlay:Destroy()
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size                   = UDim2.new(0, 310, 0, FULL_H_MAIN)
mainFrame.Position               = UDim2.new(0.5, -120, 0.5, -120)  -- always default position on execute, never loaded from config
mainFrame.BackgroundColor3       = C.bg1
mainFrame.BackgroundTransparency = 0.04
mainFrame.Active                 = true
mainFrame.Parent                 = meridianGui
corner(mainFrame, UDim.new(0, 10))
neonGlow(mainFrame, C.accent, 1.2)

-- -- Title bar --------------------------------------------------------------
local titleBar = Instance.new("Frame")
titleBar.Size             = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = C.bg0
titleBar.BorderSizePixel  = 0
titleBar.Active           = true
titleBar.Selectable       = true
titleBar.Parent           = mainFrame
corner(titleBar, UDim.new(0, 10))

local titleLabel = Instance.new("TextLabel")
titleLabel.Size                   = UDim2.new(1, -80, 1, 0)
titleLabel.Position               = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font                   = Enum.Font.GothamBlack
titleLabel.TextSize               = 11
titleLabel.TextColor3             = C.accentSec
titleLabel.TextXAlignment         = Enum.TextXAlignment.Center
titleLabel.Text                   = "MERIDIAN CODE SNIPER"
titleLabel.Parent                 = titleBar

local accentLine = Instance.new("Frame")
accentLine.Size                   = UDim2.new(1, -20, 0, 1)
accentLine.Position               = UDim2.new(0, 10, 1, 0)
accentLine.BackgroundColor3       = C.accent
accentLine.BackgroundTransparency = 0.5
accentLine.BorderSizePixel        = 0
accentLine.Parent                 = titleBar

local guiLocked = false

local lockBtn = Instance.new("TextButton")
lockBtn.Size                   = UDim2.new(0, 28, 0, 20)
lockBtn.AnchorPoint            = Vector2.new(1, 0.5)
lockBtn.Position               = UDim2.new(1, -42, 0.5, 0)
lockBtn.BackgroundColor3       = C.accentDim
lockBtn.BorderSizePixel        = 0
lockBtn.Font                   = Enum.Font.GothamBlack
lockBtn.TextSize               = 12
lockBtn.TextColor3             = C.accentSec
lockBtn.Text                   = "[U]"
lockBtn.Parent                 = titleBar
corner(lockBtn, UDim.new(0, 5))

lockBtn.MouseButton1Click:Connect(function()
    guiLocked = not guiLocked
    lockBtn.Text = guiLocked and "[L]" or "[U]"
    titleBar.Active = not guiLocked
    logStatus(guiLocked and "[GUI Locked] Position locked - dragging disabled" or "[GUI Unlocked] Dragging enabled")
end)

local minBtn = Instance.new("TextButton")
minBtn.Size                   = UDim2.new(0, 28, 0, 20)
minBtn.AnchorPoint            = Vector2.new(1, 0.5)
minBtn.Position               = UDim2.new(1, -8, 0.5, 0)
minBtn.BackgroundColor3       = C.accentDim
minBtn.BorderSizePixel        = 0
minBtn.Font                   = Enum.Font.GothamBlack
minBtn.TextSize               = 14
minBtn.TextColor3             = C.accentSec
minBtn.Text                   = "-"
minBtn.Parent                 = titleBar
corner(minBtn, UDim.new(0, 5))

-- -- Tab bar ----------------------------------------------------------------
local tabBar = Instance.new("Frame")
tabBar.Position               = UDim2.new(0, 0, 0, TITLE_H)
tabBar.Size                   = UDim2.new(1, 0, 0, TABBAR_H)
tabBar.BackgroundTransparency = 1
tabBar.Parent                 = mainFrame

local tabPadding = Instance.new("UIPadding")
tabPadding.PaddingLeft   = UDim.new(0, 10)
tabPadding.PaddingRight  = UDim.new(0, 10)
tabPadding.PaddingTop    = UDim.new(0, 11)
tabPadding.PaddingBottom = UDim.new(0, 2)
tabPadding.Parent        = tabBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection       = Enum.FillDirection.Horizontal
tabLayout.Padding             = UDim.new(0, 6)
tabLayout.SortOrder           = Enum.SortOrder.LayoutOrder
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
tabLayout.Parent              = tabBar

local tabUnderline = Instance.new("Frame")
tabUnderline.Size                   = UDim2.new(1, -20, 0, 1)
tabUnderline.Position               = UDim2.new(0, 10, 1, 0)
tabUnderline.BackgroundColor3       = C.accentDim
tabUnderline.BackgroundTransparency = 0.3
tabUnderline.BorderSizePixel        = 0
tabUnderline.Parent                 = mainFrame

local function makeTabButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.new(0.25, -3, 1, 0)
    btn.LayoutOrder            = order
    btn.BackgroundColor3       = C.bg2
    btn.BorderSizePixel        = 0
    btn.AutoButtonColor        = false
    btn.Font                   = Enum.Font.GothamBold
    btn.TextSize               = 12
    btn.TextColor3             = C.textMuted
    btn.Text                   = text
    btn.Parent                 = tabBar
    corner(btn, UDim.new(0, 6))
    neonGlow(btn, C.accentDim, 1)

    local fit = Instance.new("UITextSizeConstraint")
    fit.MaxTextSize = 12
    fit.MinTextSize = 8
    fit.Parent      = btn
    btn.TextScaled  = true

    return btn
end

local tabMainBtn    = makeTabButton("Main", 1)
local tabRiddleBtn  = makeTabButton("Riddle", 2)
local tabStatusBtn  = makeTabButton("Status", 3)

-- -- Content frame ----------------------------------------------------------
local contentFrame = Instance.new("Frame")
contentFrame.Position               = UDim2.new(0, 0, 0, TITLE_H + TABBAR_H)
contentFrame.Size                   = UDim2.new(1, 0, 1, -(TITLE_H + TABBAR_H))
contentFrame.BackgroundTransparency = 1
contentFrame.Parent                 = mainFrame

-- Page 1: Main controls
local page1 = Instance.new("Frame")
page1.Size                   = UDim2.new(1, 0, 1, 0)
page1.BackgroundTransparency = 1
page1.Parent                 = contentFrame

local layout = Instance.new("UIListLayout")
layout.Padding             = UDim.new(0, 6)
layout.SortOrder           = Enum.SortOrder.LayoutOrder
layout.FillDirection       = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment   = Enum.VerticalAlignment.Top
layout.Parent              = page1

local padding = Instance.new("UIPadding")
padding.PaddingLeft   = UDim.new(0, 10)
padding.PaddingRight  = UDim.new(0, 10)
padding.PaddingTop    = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent        = page1

-- Page Riddle: Auto Riddle toggle + message count
local pageRiddle = Instance.new("Frame")
pageRiddle.Size                   = UDim2.new(1, 0, 1, 0)
pageRiddle.BackgroundTransparency = 1
pageRiddle.Visible                = false
pageRiddle.Parent                 = contentFrame

local pageRiddleLayout = Instance.new("UIListLayout")
pageRiddleLayout.Padding             = UDim.new(0, 6)
pageRiddleLayout.SortOrder           = Enum.SortOrder.LayoutOrder
pageRiddleLayout.FillDirection       = Enum.FillDirection.Vertical
pageRiddleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageRiddleLayout.VerticalAlignment   = Enum.VerticalAlignment.Top
pageRiddleLayout.Parent              = pageRiddle

local pageRiddlePadding = Instance.new("UIPadding")
pageRiddlePadding.PaddingLeft   = UDim.new(0, 10)
pageRiddlePadding.PaddingRight  = UDim.new(0, 10)
pageRiddlePadding.PaddingTop    = UDim.new(0, 10)
pageRiddlePadding.PaddingBottom = UDim.new(0, 10)
pageRiddlePadding.Parent        = pageRiddle

-- Page 3: Status log
local page4 = Instance.new("Frame")
page4.Size                   = UDim2.new(1, 0, 1, 0)
page4.BackgroundTransparency = 1
page4.Visible                = false
page4.Parent                 = contentFrame

local page4Padding = Instance.new("UIPadding")
page4Padding.PaddingLeft   = UDim.new(0, 10)
page4Padding.PaddingRight  = UDim.new(0, 10)
page4Padding.PaddingTop    = UDim.new(0, 10)
page4Padding.PaddingBottom = UDim.new(0, 10)
page4Padding.Parent        = page4

-- Status scroll frame
local statusScroll = Instance.new("ScrollingFrame")
statusScroll.Size                   = UDim2.new(1, 0, 1, -34)
statusScroll.Position               = UDim2.new(0, 0, 0, 0)
statusScroll.BackgroundColor3       = C.bg3
statusScroll.BackgroundTransparency = 0.2
statusScroll.BorderSizePixel        = 0
statusScroll.ScrollBarThickness     = 3
statusScroll.ScrollBarImageColor3   = C.accentDim
statusScroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
statusScroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
statusScroll.ClipsDescendants       = true
statusScroll.Parent                 = page4
corner(statusScroll, UDim.new(0, 5))
neonGlow(statusScroll, C.accentDim, 1)

local statusScrollLayout = Instance.new("UIListLayout")
statusScrollLayout.Padding             = UDim.new(0, 2)
statusScrollLayout.SortOrder           = Enum.SortOrder.LayoutOrder
statusScrollLayout.FillDirection       = Enum.FillDirection.Vertical
statusScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
statusScrollLayout.VerticalAlignment   = Enum.VerticalAlignment.Top
statusScrollLayout.Parent              = statusScroll

local statusScrollPad = Instance.new("UIPadding")
statusScrollPad.PaddingLeft   = UDim.new(0, 4)
statusScrollPad.PaddingRight  = UDim.new(0, 4)
statusScrollPad.PaddingTop    = UDim.new(0, 4)
statusScrollPad.PaddingBottom = UDim.new(0, 4)
statusScrollPad.Parent        = statusScroll

-- Clear log button
local clearLogRow = Instance.new("Frame")
clearLogRow.Size             = UDim2.new(1, 0, 0, 28)
clearLogRow.Position         = UDim2.new(0, 0, 1, -28)
clearLogRow.BackgroundColor3 = C.bg2
clearLogRow.Parent           = page4
corner(clearLogRow, UDim.new(0, 6))
neonGlow(clearLogRow, C.accentDim, 1)

local clearLogBtn = Instance.new("TextButton")
clearLogBtn.Size                   = UDim2.new(1, 0, 1, 0)
clearLogBtn.BackgroundTransparency = 1
clearLogBtn.Font                   = Enum.Font.Gotham
clearLogBtn.TextSize               = 11
clearLogBtn.TextColor3             = C.textMuted
clearLogBtn.Text                   = "Clear Log"
clearLogBtn.Parent                 = clearLogRow

clearLogBtn.MouseButton1Click:Connect(function()
    statusLog = {}
    for _, child in ipairs(statusScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    logStatus("Log cleared")
end)
clearLogBtn.MouseEnter:Connect(function()
    TweenService:Create(clearLogRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
end)
clearLogBtn.MouseLeave:Connect(function()
    TweenService:Create(clearLogRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
end)

-- Wire up the status scroll reference so logStatus can write to it
statusScrollRef = statusScroll

-- Replay any log entries that happened before the GUI was ready
for _, entry in ipairs(statusLog) do
    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, -8, 0, 0)
    lbl.AutomaticSize          = Enum.AutomaticSize.Y
    lbl.BackgroundTransparency = 1
    lbl.Font                   = Enum.Font.Code
    lbl.TextSize               = 10
    lbl.TextColor3             = C.textPri
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.TextWrapped            = true
    lbl.RichText               = false
    lbl.Text                   = entry
    lbl.Parent                 = statusScroll
end


-- -----------------------------------------
local forceRow = Instance.new("Frame")
forceRow.Size             = UDim2.new(1, 0, 0, 34)
forceRow.BackgroundColor3 = C.bg2
forceRow.LayoutOrder      = 0
forceRow.Parent           = page1
corner(forceRow, UDim.new(0, 7))
neonGlow(forceRow, C.accentDim, 1)

local forceBtn = Instance.new("TextButton")
forceBtn.Size                   = UDim2.new(1, 0, 1, 0)
forceBtn.BackgroundTransparency = 1
forceBtn.Font                   = Enum.Font.Gotham
forceBtn.TextSize               = 13
forceBtn.TextColor3             = C.textPri
forceBtn.TextXAlignment         = Enum.TextXAlignment.Center
forceBtn.Text                   = "Force Scan + Auto Submit"
forceBtn.Parent                 = forceRow

forceBtn.MouseButton1Click:Connect(function()
    -- Switching to Force Scan: make sure Riddle mode isn't still armed,
    -- otherwise dispatchRiddle() would keep intercepting notifications first.
    if autoRiddle then
        setAutoRiddle(false)
    end
    -- Use captureCount if set, otherwise capture exactly 1 notification
    local n = captureCount > 0 and captureCount or 1
    -- Immediately arm a forced collection that bypasses keyword filtering
    collecting    = true
    collectBuf    = {}
    collectRemain = n
    codeCycleActive = true
    -- Override dispatch temporarily so the NEXT n notifications are captured
    -- regardless of keywords, then auto-coded.  We do this by monkey-patching
    -- the forceScan flag read inside dispatch.
    forceScanActive = true
    logStatus("Force Scan started - collecting " .. n .. " notification(s)")
end)

forceBtn.MouseEnter:Connect(function()
    TweenService:Create(forceRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
    TweenService:Create(forceBtn, C.tweenFast, { TextColor3 = C.accent }):Play()
end)
forceBtn.MouseLeave:Connect(function()
    TweenService:Create(forceRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
    TweenService:Create(forceBtn, C.tweenFast, { TextColor3 = C.accentSec }):Play()
end)

-- (Scan Notifications toggle removed - scanning is always active)

-- -----------------------------------------
--  Auto Code mode is now controlled entirely by the Force Scan button
--  and the Riddle mode button (mutually exclusive) - no manual toggle.
-- -----------------------------------------
local function setAutoCode(on)
    autoCode        = on
    cfg.autoCode    = on
    if on and autoRiddle then
        setAutoRiddle(false)
    end
    -- Switching mode: always start fresh (back to 0/N on both sides)
    collecting       = false
    collectBuf       = {}
    collectRemain    = 0
    riddleCollecting = false
    riddleBuf        = {}
    riddleRemain     = 0
    saveConfig()
end

-- -----------------------------------------
--  ROW 3 - Capture count
-- -----------------------------------------
local captureRow = Instance.new("Frame")
captureRow.Size             = UDim2.new(1, 0, 0, 34)
captureRow.BackgroundColor3 = C.bg2
captureRow.LayoutOrder      = 3
captureRow.Parent           = page1
corner(captureRow, UDim.new(0, 7))
neonGlow(captureRow, C.accentDim, 1)

local captureLabel = Instance.new("TextLabel")
captureLabel.Size                   = UDim2.new(1, -60, 1, 0)
captureLabel.Position               = UDim2.new(0, 12, 0, 0)
captureLabel.BackgroundTransparency = 1
captureLabel.Font                   = Enum.Font.Gotham
captureLabel.TextSize               = 13
captureLabel.TextColor3             = C.textPri
captureLabel.TextXAlignment         = Enum.TextXAlignment.Left
captureLabel.Text                   = "Submit Code After"
captureLabel.Parent                 = captureRow

local captureBox = Instance.new("TextBox")
captureBox.AnchorPoint            = Vector2.new(1, 0.5)
captureBox.Position               = UDim2.new(1, -10, 0.5, 0)
captureBox.Size                   = UDim2.new(0, C.toggleW, 0, C.toggleH)
captureBox.BackgroundColor3       = C.inputBg
captureBox.BackgroundTransparency = 0
captureBox.BorderSizePixel        = 0
captureBox.Font                   = Enum.Font.GothamBold
captureBox.TextSize               = 12
captureBox.TextColor3             = C.accentSec
captureBox.PlaceholderText        = "0"
captureBox.PlaceholderColor3      = C.textMuted
captureBox.TextXAlignment         = Enum.TextXAlignment.Center
captureBox.ClearTextOnFocus       = false
captureBox.Text                   = captureCount > 0 and tostring(captureCount) or ""
captureBox.Parent                 = captureRow
corner(captureBox, UDim.new(0, 5))

local captureStroke = Instance.new("UIStroke")
captureStroke.Color     = C.accentDim
captureStroke.Thickness = 1
captureStroke.Parent    = captureBox

captureBox.Focused:Connect(function()
    TweenService:Create(captureStroke, C.tweenFast, { Color = C.accent }):Play()
end)
captureBox.FocusLost:Connect(function()
    TweenService:Create(captureStroke, C.tweenFast, { Color = C.accentDim }):Play()
    local raw = captureBox.Text:match("%d+")
    local n   = raw and tonumber(raw) or 0
    local old = captureCount
    captureCount        = n
    cfg.captureCount    = n
    captureBox.Text     = n > 0 and tostring(n) or ""
    collecting          = false
    collectBuf          = {}
    collectRemain       = 0
    saveConfig()
end)

captureRow.MouseEnter:Connect(function()
    TweenService:Create(captureRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
end)
captureRow.MouseLeave:Connect(function()
    TweenService:Create(captureRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
end)

-- -----------------------------------------
--  ROW 3.5 - Delay before submit (Main/Code)
-- -----------------------------------------
local codeDelayRow = Instance.new("Frame")
codeDelayRow.Size             = UDim2.new(1, 0, 0, 34)
codeDelayRow.BackgroundColor3 = C.bg2
codeDelayRow.LayoutOrder      = 3.5
codeDelayRow.Parent           = page1
corner(codeDelayRow, UDim.new(0, 7))
neonGlow(codeDelayRow, C.accentDim, 1)

local codeDelayLabel = Instance.new("TextLabel")
codeDelayLabel.Size                   = UDim2.new(1, -60, 1, 0)
codeDelayLabel.Position               = UDim2.new(0, 12, 0, 0)
codeDelayLabel.BackgroundTransparency = 1
codeDelayLabel.Font                   = Enum.Font.Gotham
codeDelayLabel.TextSize               = 13
codeDelayLabel.TextColor3             = C.textPri
codeDelayLabel.TextXAlignment         = Enum.TextXAlignment.Left
codeDelayLabel.Text                   = "Delay Before Submit (sec)"
codeDelayLabel.Parent                 = codeDelayRow

local codeDelayBox = Instance.new("TextBox")
codeDelayBox.AnchorPoint            = Vector2.new(1, 0.5)
codeDelayBox.Position               = UDim2.new(1, -10, 0.5, 0)
codeDelayBox.Size                   = UDim2.new(0, C.toggleW, 0, C.toggleH)
codeDelayBox.BackgroundColor3       = C.inputBg
codeDelayBox.BackgroundTransparency = 0
codeDelayBox.BorderSizePixel        = 0
codeDelayBox.Font                   = Enum.Font.GothamBold
codeDelayBox.TextSize               = 12
codeDelayBox.TextColor3             = C.accentSec
codeDelayBox.PlaceholderText        = "0.5"
codeDelayBox.PlaceholderColor3      = C.textMuted
codeDelayBox.TextXAlignment         = Enum.TextXAlignment.Center
codeDelayBox.ClearTextOnFocus       = false
codeDelayBox.Text                   = tostring(codeSubmitDelay)
codeDelayBox.Parent                 = codeDelayRow
corner(codeDelayBox, UDim.new(0, 5))

local codeDelayStroke = Instance.new("UIStroke")
codeDelayStroke.Color     = C.accentDim
codeDelayStroke.Thickness = 1
codeDelayStroke.Parent    = codeDelayBox

codeDelayBox.Focused:Connect(function()
    TweenService:Create(codeDelayStroke, C.tweenFast, { Color = C.accent }):Play()
end)
codeDelayBox.FocusLost:Connect(function()
    TweenService:Create(codeDelayStroke, C.tweenFast, { Color = C.accentDim }):Play()
    local raw = codeDelayBox.Text:match("[%d%.]+")
    local n   = raw and tonumber(raw) or 0.5
    n = math.max(0, n)
    codeSubmitDelay     = n
    cfg.codeSubmitDelay = n
    codeDelayBox.Text   = tostring(n)
    saveConfig()
end)

codeDelayRow.MouseEnter:Connect(function()
    TweenService:Create(codeDelayRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
end)
codeDelayRow.MouseLeave:Connect(function()
    TweenService:Create(codeDelayRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
end)

-- -----------------------------------------
--  ROW 4 - KILL AUTO DETECT (turns off Auto Code + Auto Riddle)
-- -----------------------------------------
local killRow = Instance.new("Frame")
killRow.Size             = UDim2.new(1, 0, 0, 34)
killRow.BackgroundColor3 = C.bg2
killRow.LayoutOrder      = 4
killRow.Parent           = page1
corner(killRow, UDim.new(0, 7))
neonGlow(killRow, C.accentDim, 1)

local killBtn = Instance.new("TextButton")
killBtn.Size                   = UDim2.new(1, 0, 1, 0)
killBtn.BackgroundTransparency = 1
killBtn.Font                   = Enum.Font.GothamBold
killBtn.TextSize               = 13
killBtn.TextColor3             = C.accentSec
killBtn.TextXAlignment         = Enum.TextXAlignment.Center
killBtn.Text                   = "KILL AUTO DETECT"
killBtn.Parent                 = killRow

killBtn.MouseButton1Click:Connect(function()
    if autoCode then setAutoCode(false) end
    if autoRiddle then setAutoRiddle(false) end
    -- Also clear any in-progress riddle collection
    riddleCollecting = false
    riddleBuf        = {}
    riddleRemain     = 0
    -- KILL Force Scan if active
    forceScanActive  = false
    collecting       = false
    collectBuf       = {}
    collectRemain    = 0
    logStatus("[KILL AUTO DETECT] All automation disabled - buffers cleared")
end)

killBtn.MouseEnter:Connect(function()
    TweenService:Create(killRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
end)
killBtn.MouseLeave:Connect(function()
    TweenService:Create(killRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
end)

-- -----------------------------------------
--  RIDDLE PAGE - ROW 1 - Auto Riddle + Submit button
-- -----------------------------------------
local riddleRow = Instance.new("Frame")
riddleRow.Size             = UDim2.new(1, 0, 0, 34)
riddleRow.BackgroundColor3 = C.bg2
riddleRow.LayoutOrder      = 1
riddleRow.Parent           = pageRiddle
corner(riddleRow, UDim.new(0, 7))
neonGlow(riddleRow, C.accentDim, 1)

local riddleBtn = Instance.new("TextButton")
riddleBtn.Size                   = UDim2.new(1, 0, 1, 0)
riddleBtn.BackgroundTransparency = 1
riddleBtn.Font                   = Enum.Font.Gotham
riddleBtn.TextSize               = 13
riddleBtn.TextColor3             = C.textPri
riddleBtn.TextXAlignment         = Enum.TextXAlignment.Center
riddleBtn.Text                   = "Auto Answer + Auto Submit"
riddleBtn.Parent                 = riddleRow

setAutoRiddle = function(on)
    autoRiddle        = on
    cfg.autoRiddle     = on
    if on and autoCode then
        setAutoCode(false)
    end
    -- Switching mode: always start fresh (back to 0/N on both sides)
    collecting       = false
    collectBuf       = {}
    collectRemain    = 0
    riddleCollecting = false
    riddleBuf        = {}
    riddleRemain     = 0
    riddleBtn.Text     = on and "Auto Answer + Auto Submit (Armed)" or "Auto Answer + Auto Submit"
    saveConfig()
end

fullyDisableScanning = function()
    if autoCode then setAutoCode(false) end
    if autoRiddle then setAutoRiddle(false) end
    forceScanActive = false
    saveConfig()
    logStatus("Character died/reset - auto code/riddle disabled")
end

riddleBtn.MouseButton1Click:Connect(function()
    if autoRiddle then
        -- Already ON: reset the collection buffer/counter, stay armed
        riddleCollecting = false
        riddleBuf        = {}
        riddleRemain     = 0
        logStatus("[Riddle reset] Collection cleared - re-armed at 0/" .. riddleCaptureCount)
    else
        setAutoRiddle(true)
    end
end)
riddleBtn.MouseEnter:Connect(function()
    TweenService:Create(riddleRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
end)
riddleBtn.MouseLeave:Connect(function()
    TweenService:Create(riddleRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
end)

-- -----------------------------------------
--  RIDDLE PAGE - ROW 2 - Message count
-- -----------------------------------------
local riddleCountRow = Instance.new("Frame")
riddleCountRow.Size             = UDim2.new(1, 0, 0, 34)
riddleCountRow.BackgroundColor3 = C.bg2
riddleCountRow.LayoutOrder      = 2
riddleCountRow.Parent           = pageRiddle
corner(riddleCountRow, UDim.new(0, 7))
neonGlow(riddleCountRow, C.accentDim, 1)

local riddleCountLabel = Instance.new("TextLabel")
riddleCountLabel.Size                   = UDim2.new(1, -60, 1, 0)
riddleCountLabel.Position               = UDim2.new(0, 12, 0, 0)
riddleCountLabel.BackgroundTransparency = 1
riddleCountLabel.Font                   = Enum.Font.Gotham
riddleCountLabel.TextSize               = 13
riddleCountLabel.TextColor3             = C.textPri
riddleCountLabel.TextXAlignment         = Enum.TextXAlignment.Left
riddleCountLabel.Text                   = "Submit Code After"
riddleCountLabel.Parent                 = riddleCountRow

local riddleCountBox = Instance.new("TextBox")
riddleCountBox.AnchorPoint            = Vector2.new(1, 0.5)
riddleCountBox.Position               = UDim2.new(1, -10, 0.5, 0)
riddleCountBox.Size                   = UDim2.new(0, C.toggleW, 0, C.toggleH)
riddleCountBox.BackgroundColor3       = C.inputBg
riddleCountBox.BackgroundTransparency = 0
riddleCountBox.BorderSizePixel        = 0
riddleCountBox.Font                   = Enum.Font.GothamBold
riddleCountBox.TextSize               = 12
riddleCountBox.TextColor3             = C.accentSec
riddleCountBox.PlaceholderText        = "0"
riddleCountBox.PlaceholderColor3      = C.textMuted
riddleCountBox.TextXAlignment         = Enum.TextXAlignment.Center
riddleCountBox.ClearTextOnFocus       = false
riddleCountBox.Text                   = riddleCaptureCount > 0 and tostring(riddleCaptureCount) or ""
riddleCountBox.Parent                 = riddleCountRow
corner(riddleCountBox, UDim.new(0, 5))

local riddleCountStroke = Instance.new("UIStroke")
riddleCountStroke.Color     = C.accentDim
riddleCountStroke.Thickness = 1
riddleCountStroke.Parent    = riddleCountBox

riddleCountBox.Focused:Connect(function()
    TweenService:Create(riddleCountStroke, C.tweenFast, { Color = C.accent }):Play()
end)
riddleCountBox.FocusLost:Connect(function()
    TweenService:Create(riddleCountStroke, C.tweenFast, { Color = C.accentDim }):Play()
    local raw = riddleCountBox.Text:match("%d+")
    local n   = raw and tonumber(raw) or 0
    riddleCaptureCount     = n
    cfg.riddleCaptureCount = n
    riddleCountBox.Text    = n > 0 and tostring(n) or ""
    saveConfig()
end)

riddleCountRow.MouseEnter:Connect(function()
    TweenService:Create(riddleCountRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
end)
riddleCountRow.MouseLeave:Connect(function()
    TweenService:Create(riddleCountRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
end)

-- -----------------------------------------
--  RIDDLE PAGE - ROW 3 - Delay before submit
-- -----------------------------------------
local riddleDelayRow = Instance.new("Frame")
riddleDelayRow.Size             = UDim2.new(1, 0, 0, 34)
riddleDelayRow.BackgroundColor3 = C.bg2
riddleDelayRow.LayoutOrder      = 3
riddleDelayRow.Parent           = pageRiddle
corner(riddleDelayRow, UDim.new(0, 7))
neonGlow(riddleDelayRow, C.accentDim, 1)

local riddleDelayLabel = Instance.new("TextLabel")
riddleDelayLabel.Size                   = UDim2.new(1, -60, 1, 0)
riddleDelayLabel.Position               = UDim2.new(0, 12, 0, 0)
riddleDelayLabel.BackgroundTransparency = 1
riddleDelayLabel.Font                   = Enum.Font.Gotham
riddleDelayLabel.TextSize               = 13
riddleDelayLabel.TextColor3             = C.textPri
riddleDelayLabel.TextXAlignment         = Enum.TextXAlignment.Left
riddleDelayLabel.Text                   = "Delay Before Submit (sec)"
riddleDelayLabel.Parent                 = riddleDelayRow

local riddleDelayBox = Instance.new("TextBox")
riddleDelayBox.AnchorPoint            = Vector2.new(1, 0.5)
riddleDelayBox.Position               = UDim2.new(1, -10, 0.5, 0)
riddleDelayBox.Size                   = UDim2.new(0, C.toggleW, 0, C.toggleH)
riddleDelayBox.BackgroundColor3       = C.inputBg
riddleDelayBox.BackgroundTransparency = 0
riddleDelayBox.BorderSizePixel        = 0
riddleDelayBox.Font                   = Enum.Font.GothamBold
riddleDelayBox.TextSize               = 12
riddleDelayBox.TextColor3             = C.accentSec
riddleDelayBox.PlaceholderText        = "0.5"
riddleDelayBox.PlaceholderColor3      = C.textMuted
riddleDelayBox.TextXAlignment         = Enum.TextXAlignment.Center
riddleDelayBox.ClearTextOnFocus       = false
riddleDelayBox.Text                   = tostring(riddleSubmitDelay)
riddleDelayBox.Parent                 = riddleDelayRow
corner(riddleDelayBox, UDim.new(0, 5))

local riddleDelayStroke = Instance.new("UIStroke")
riddleDelayStroke.Color     = C.accentDim
riddleDelayStroke.Thickness = 1
riddleDelayStroke.Parent    = riddleDelayBox

riddleDelayBox.Focused:Connect(function()
    TweenService:Create(riddleDelayStroke, C.tweenFast, { Color = C.accent }):Play()
end)
riddleDelayBox.FocusLost:Connect(function()
    TweenService:Create(riddleDelayStroke, C.tweenFast, { Color = C.accentDim }):Play()
    local raw = riddleDelayBox.Text:match("[%d%.]+")
    local n   = raw and tonumber(raw) or 0.5
    n = math.max(0, n)
    riddleSubmitDelay     = n
    cfg.riddleSubmitDelay = n
    riddleDelayBox.Text   = tostring(n)
    saveConfig()
end)

riddleDelayRow.MouseEnter:Connect(function()
    TweenService:Create(riddleDelayRow, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
end)
riddleDelayRow.MouseLeave:Connect(function()
    TweenService:Create(riddleDelayRow, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
end)



-- -----------------------------------------
--  TABS + MINIMIZE
-- -----------------------------------------
local isMinimized = cfg.minimized == true
local currentTab  = (cfg.activeTab == 2) and 2 or (cfg.activeTab == 3) and 3 or 1

local FULL_H_STATUS = TITLE_H + TABBAR_H + PAGE2_H  -- same height as old keyword page

local function currentTabHeight()
    if currentTab == 1 then return FULL_H_MAIN
    elseif currentTab == 2 then return FULL_H_RIDDLE
    else return FULL_H_STATUS
    end
end

-- Resizes the panel for the current minimized/tab state.
local function applyLayout(instant)
    local targetH = isMinimized and MIN_H or currentTabHeight()
    contentFrame.Visible = not isMinimized
    tabBar.Visible        = not isMinimized
    tabUnderline.Visible  = not isMinimized
    minBtn.Text           = isMinimized and "+" or "-"
    if instant then
        mainFrame.Size = UDim2.new(0, 310, 0, targetH)
    else
        TweenService:Create(mainFrame, C.tweenMed, { Size = UDim2.new(0, 310, 0, targetH) }):Play()
    end
end

-- Switches which page is visible and restyles the tab buttons.
local function setActiveTab(idx)
    currentTab = idx
    page1.Visible      = (idx == 1)
    pageRiddle.Visible = (idx == 2)
    page4.Visible      = (idx == 3)

    tabMainBtn.BackgroundColor3    = idx == 1 and C.toggleOn or C.bg2
    tabRiddleBtn.BackgroundColor3  = idx == 2 and C.toggleOn or C.bg2
    tabStatusBtn.BackgroundColor3  = idx == 3 and C.toggleOn or C.bg2
    tabMainBtn.TextColor3          = idx == 1 and C.activeTabText or C.textMuted
    tabRiddleBtn.TextColor3        = idx == 2 and C.activeTabText or C.textMuted
    tabStatusBtn.TextColor3        = idx == 3 and C.activeTabText or C.textMuted
end

setActiveTab(currentTab)
applyLayout(true)

tabMainBtn.MouseButton1Click:Connect(function()
    if currentTab == 1 then return end
    setActiveTab(1)
    cfg.activeTab = 1
    applyLayout(false)
    saveConfig()
end)
tabRiddleBtn.MouseButton1Click:Connect(function()
    if currentTab == 2 then return end
    setActiveTab(2)
    cfg.activeTab = 2
    applyLayout(false)
    saveConfig()
end)
tabStatusBtn.MouseButton1Click:Connect(function()
    if currentTab == 3 then return end
    setActiveTab(3)
    cfg.activeTab = 3
    applyLayout(false)
    saveConfig()
end)

tabMainBtn.MouseEnter:Connect(function()
    if currentTab ~= 1 then
        TweenService:Create(tabMainBtn, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
    end
end)
tabMainBtn.MouseLeave:Connect(function()
    if currentTab ~= 1 then
        TweenService:Create(tabMainBtn, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
    end
end)
tabRiddleBtn.MouseEnter:Connect(function()
    if currentTab ~= 2 then
        TweenService:Create(tabRiddleBtn, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
    end
end)
tabRiddleBtn.MouseLeave:Connect(function()
    if currentTab ~= 2 then
        TweenService:Create(tabRiddleBtn, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
    end
end)
tabStatusBtn.MouseEnter:Connect(function()
    if currentTab ~= 3 then
        TweenService:Create(tabStatusBtn, C.tweenFast, { BackgroundColor3 = Color3.fromRGB(34, 20, 20) }):Play()
    end
end)
tabStatusBtn.MouseLeave:Connect(function()
    if currentTab ~= 3 then
        TweenService:Create(tabStatusBtn, C.tweenFast, { BackgroundColor3 = C.bg2 }):Play()
    end
end)

minBtn.MouseButton1Click:Connect(function()
    isMinimized     = not isMinimized
    cfg.minimized   = isMinimized
    applyLayout(false)
    saveConfig()
end)
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn, C.tweenFast, { BackgroundColor3 = C.toggleOn }):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn, C.tweenFast, { BackgroundColor3 = C.accentDim }):Play()
end)

-- -----------------------------------------
--  DRAG  (saves position on release)
-- -----------------------------------------
do
    local dragging, dragStart, startPos = false, nil, nil
    titleBar.InputBegan:Connect(function(input)
        if guiLocked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and
           input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging  = true
        dragStart = input.Position
        startPos  = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging     = false
                -- Position intentionally NOT saved: always resets to default on next execute
            end
        end)
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and
           input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)
end

print("[Meridian Code Sniper] loaded")
logStatus("Meridian Code Sniper loaded and ready")