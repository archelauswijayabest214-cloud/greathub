-- ================================================
--   GREATHUB - KICK A LUCKY BLOCK
--   Auto Kick Script | Delta Executor
--   Key: TEST123 (admin) | Daily key: cek discord
-- ================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- Tunggu PlayerGui
local PGui
repeat PGui = LP:FindFirstChildOfClass("PlayerGui") task.wait(0.1) until PGui

-- Bersihkan instance lama
for _, g in ipairs({"GreatHubGui", "GreatHubKey"}) do
    if PGui:FindFirstChild(g) then PGui[g]:Destroy() end
end
task.wait(0.1)

-- ================================================
-- KEY SYSTEM CONFIG
-- ================================================
local ADMIN_KEY   = "TEST123"
local DAILY_KEYS  = { -- Ganti tiap hari
    "GREAT001", "LUCKY2026", "BLOCK777", "KICKTOP"
}
local keyVerified = false

-- ================================================
-- SCRIPT CONFIG
-- ================================================
local CFG = {
    -- Kick timing (detik dari awal bar muncul)
    KickTiming = {
        Perfect   = 0.72,  -- timing perfect
        Excellent = 0.45,  -- timing excellent
        Great     = 0.25,  -- timing great
    },
    SelectedKick = "Perfect",  -- default

    -- Auto fitur
    AutoGo   = false,
    AutoKick = false,

    -- Speed saat lari ke kick zone
    WalkSpeed = 22,   -- sedikit lebih cepat dari normal (16)

    -- Posisi target dekat pohon (kick zone) - dari gambar
    -- Akan di-detect otomatis dari workspace, ini fallback
    KickZoneOffset = Vector3.new(0, 0, 0),

    -- Anti detect: lompat random
    JumpChance = 0.3,  -- 30% chance lompat tiap interval

    -- Delay setelah brainrot spawn (ms)
    SpawnDelay = 0.01, -- 10ms

    -- Warna UI
    BG     = Color3.fromRGB(8, 8, 14),
    Panel  = Color3.fromRGB(14, 15, 24),
    Accent = Color3.fromRGB(100, 220, 100),
    Red    = Color3.fromRGB(220, 60, 60),
    Yellow = Color3.fromRGB(255, 200, 40),
    Dim    = Color3.fromRGB(80, 85, 110),
    Text   = Color3.fromRGB(220, 225, 240),
}

-- ================================================
-- HELPER UI
-- ================================================
local function makeCorner(parent, rad)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, rad or 8)
    c.Parent = parent
    return c
end

local function makeStroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(100,100,100)
    s.Thickness = thick or 1
    s.Transparency = trans or 0.5
    s.Parent = parent
    return s
end

local function makeLbl(parent, text, size, color, font, xa)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 12
    l.TextColor3 = color or CFG.Text
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.Size = UDim2.new(1,0,1,0)
    l.Parent = parent
    return l
end

-- ================================================
-- KEY SCREEN
-- ================================================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "GreatHubKey"
KeyGui.ResetOnSpawn = false
KeyGui.IgnoreGuiInset = true
KeyGui.DisplayOrder = 1000
KeyGui.Parent = PGui

local KeyBG = Instance.new("Frame")
KeyBG.Size = UDim2.new(1,0,1,0)
KeyBG.BackgroundColor3 = Color3.fromRGB(0,0,0)
KeyBG.BackgroundTransparency = 0.35
KeyBG.BorderSizePixel = 0
KeyBG.Parent = KeyGui

local KeyCard = Instance.new("Frame")
KeyCard.Size = UDim2.new(0, 320, 0, 220)
KeyCard.Position = UDim2.new(0.5,-160, 0.5,-110)
KeyCard.BackgroundColor3 = CFG.BG
KeyCard.BorderSizePixel = 0
KeyCard.Parent = KeyGui
makeCorner(KeyCard, 12)
makeStroke(KeyCard, CFG.Accent, 1.5, 0.3)

-- Logo / Title
local logoBar = Instance.new("Frame")
logoBar.Size = UDim2.new(1,0,0,44)
logoBar.BackgroundColor3 = CFG.Panel
logoBar.BorderSizePixel = 0
logoBar.Parent = KeyCard
makeCorner(logoBar, 12)
local logoFix = Instance.new("Frame")
logoFix.Size = UDim2.new(1,0,0.5,0)
logoFix.Position = UDim2.new(0,0,0.5,0)
logoFix.BackgroundColor3 = CFG.Panel
logoFix.BorderSizePixel = 0
logoFix.Parent = logoBar

local logoTxt = Instance.new("TextLabel")
logoTxt.Size = UDim2.new(1,0,1,0)
logoTxt.BackgroundTransparency = 1
logoTxt.Text = "⚡ GREATHUB"
logoTxt.TextColor3 = CFG.Accent
logoTxt.Font = Enum.Font.GothamBold
logoTxt.TextSize = 18
logoTxt.TextXAlignment = Enum.TextXAlignment.Center
logoTxt.Parent = logoBar

local subTxt = Instance.new("TextLabel")
subTxt.Size = UDim2.new(1,-20,0,16)
subTxt.Position = UDim2.new(0,10,0,50)
subTxt.BackgroundTransparency = 1
subTxt.Text = "Kick a Lucky Block • Enter Key to Continue"
subTxt.TextColor3 = CFG.Dim
subTxt.Font = Enum.Font.Gotham
subTxt.TextSize = 11
subTxt.TextXAlignment = Enum.TextXAlignment.Center
subTxt.Parent = KeyCard

-- Key input
local keyWrap = Instance.new("Frame")
keyWrap.Size = UDim2.new(1,-30,0,38)
keyWrap.Position = UDim2.new(0,15,0,78)
keyWrap.BackgroundColor3 = Color3.fromRGB(18,20,32)
keyWrap.BorderSizePixel = 0
keyWrap.Parent = KeyCard
makeCorner(keyWrap, 8)
makeStroke(keyWrap, CFG.Dim, 1, 0.5)

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1,-16,1,-10)
keyInput.Position = UDim2.new(0,8,0,5)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Masukkan key..."
keyInput.PlaceholderColor3 = CFG.Dim
keyInput.TextColor3 = CFG.Text
keyInput.Font = Enum.Font.GothamBold
keyInput.TextSize = 14
keyInput.TextXAlignment = Enum.TextXAlignment.Center
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyWrap

-- Submit button
local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1,-30,0,38)
submitBtn.Position = UDim2.new(0,15,0,130)
submitBtn.BackgroundColor3 = CFG.Accent
submitBtn.Text = "VERIFY KEY"
submitBtn.TextColor3 = Color3.fromRGB(5,10,5)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 13
submitBtn.BorderSizePixel = 0
submitBtn.AutoButtonColor = false
submitBtn.Active = true
submitBtn.Parent = KeyCard
makeCorner(submitBtn, 8)

-- Status label
local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1,-20,0,20)
statusLbl.Position = UDim2.new(0,10,0,175)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = ""
statusLbl.TextColor3 = CFG.Red
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 11
statusLbl.TextXAlignment = Enum.TextXAlignment.Center
statusLbl.Parent = KeyCard

local infoLbl = Instance.new("TextLabel")
infoLbl.Size = UDim2.new(1,-20,0,16)
infoLbl.Position = UDim2.new(0,10,0,198)
infoLbl.BackgroundTransparency = 1
infoLbl.Text = "Admin key: TEST123 | Free key ganti tiap hari"
infoLbl.TextColor3 = Color3.fromRGB(60,65,90)
infoLbl.Font = Enum.Font.Gotham
infoLbl.TextSize = 9
infoLbl.TextXAlignment = Enum.TextXAlignment.Center
infoLbl.Parent = KeyCard

-- ================================================
-- VERIFY KEY FUNCTION
-- ================================================
local function verifyKey(key)
    key = key:upper():gsub("%s","")
    if key == ADMIN_KEY then return true, "admin" end
    for _, dk in ipairs(DAILY_KEYS) do
        if key == dk:upper() then return true, "user" end
    end
    return false, nil
end

-- ================================================
-- MAIN HUB (dibuat setelah key verified)
-- ================================================
local function buildMainHub(keyType)
    -- Hapus key screen
    KeyGui:Destroy()

    local SG = Instance.new("ScreenGui")
    SG.Name = "GreatHubGui"
    SG.ResetOnSpawn = false
    SG.IgnoreGuiInset = true
    SG.DisplayOrder = 999
    SG.Parent = PGui

    -- ── MAIN FRAME ──────────────────────────────
    local MF = Instance.new("Frame")
    MF.Size = UDim2.new(0, 280, 0, 310)
    MF.Position = UDim2.new(0, 16, 0, 55)
    MF.BackgroundColor3 = CFG.BG
    MF.BorderSizePixel = 0
    MF.ClipsDescendants = true
    MF.Active = true
    MF.Parent = SG
    makeCorner(MF, 10)
    makeStroke(MF, CFG.Accent, 1.2, 0.45)

    -- ── HEADER ──────────────────────────────────
    local HBar = Instance.new("Frame")
    HBar.Size = UDim2.new(1,0,0,36)
    HBar.BackgroundColor3 = CFG.Panel
    HBar.BorderSizePixel = 0
    HBar.Active = true
    HBar.Parent = MF
    makeCorner(HBar, 10)
    local hfix = Instance.new("Frame")
    hfix.Size = UDim2.new(1,0,0.5,0)
    hfix.Position = UDim2.new(0,0,0.5,0)
    hfix.BackgroundColor3 = CFG.Panel
    hfix.BorderSizePixel = 0
    hfix.Parent = HBar

    -- dot
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0,6,0,6)
    dot.Position = UDim2.new(0,10,0.5,-3)
    dot.BackgroundColor3 = CFG.Accent
    dot.BorderSizePixel = 0
    dot.Parent = HBar
    makeCorner(dot, 4)

    local htitle = Instance.new("TextLabel")
    htitle.Size = UDim2.new(1,-80,1,0)
    htitle.Position = UDim2.new(0,22,0,0)
    htitle.BackgroundTransparency = 1
    htitle.Text = "⚡ GREATHUB"
    htitle.TextColor3 = CFG.Accent
    htitle.Font = Enum.Font.GothamBold
    htitle.TextSize = 12
    htitle.TextXAlignment = Enum.TextXAlignment.Left
    htitle.Parent = HBar

    local keyBadge = Instance.new("TextLabel")
    keyBadge.Size = UDim2.new(0,60,0,20)
    keyBadge.Position = UDim2.new(1,-90,0.5,-10)
    keyBadge.BackgroundColor3 = keyType == "admin"
        and Color3.fromRGB(255,180,0)
        or Color3.fromRGB(40,180,80)
    keyBadge.Text = keyType == "admin" and "ADMIN" or "FREE"
    keyBadge.TextColor3 = Color3.fromRGB(5,5,5)
    keyBadge.Font = Enum.Font.GothamBold
    keyBadge.TextSize = 10
    keyBadge.BorderSizePixel = 0
    keyBadge.Parent = HBar
    makeCorner(keyBadge, 5)

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,24,0,24)
    minBtn.Position = UDim2.new(1,-30,0.5,-12)
    minBtn.BackgroundColor3 = Color3.fromRGB(18,20,32)
    minBtn.Text = "–"
    minBtn.TextColor3 = CFG.Dim
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.BorderSizePixel = 0
    minBtn.AutoButtonColor = false
    minBtn.Active = true
    minBtn.Parent = HBar
    makeCorner(minBtn, 5)

    -- divider
    local div = Instance.new("Frame")
    div.Size = UDim2.new(1,-10,0,1)
    div.Position = UDim2.new(0,5,0,37)
    div.BackgroundColor3 = CFG.Accent
    div.BackgroundTransparency = 0.8
    div.BorderSizePixel = 0
    div.Parent = MF

    -- ── STATUS BAR ──────────────────────────────
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1,-10,0,22)
    statusBar.Position = UDim2.new(0,5,0,42)
    statusBar.BackgroundColor3 = Color3.fromRGB(14,16,26)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = MF
    makeCorner(statusBar, 5)

    local statusTxt = Instance.new("TextLabel")
    statusTxt.Size = UDim2.new(1,-10,1,0)
    statusTxt.Position = UDim2.new(0,6,0,0)
    statusTxt.BackgroundTransparency = 1
    statusTxt.Text = "● Idle"
    statusTxt.TextColor3 = CFG.Dim
    statusTxt.Font = Enum.Font.Gotham
    statusTxt.TextSize = 11
    statusTxt.TextXAlignment = Enum.TextXAlignment.Left
    statusTxt.Parent = statusBar

    local function setStatus(txt, color)
        statusTxt.Text = "● " .. txt
        statusTxt.TextColor3 = color or CFG.Dim
    end

    -- ── SECTION LABEL helper ────────────────────
    local function sectionLbl(y, text)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,-10,0,14)
        l.Position = UDim2.new(0,5,0,y)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = Color3.fromRGB(60,65,90)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 9
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = MF
    end

    -- ── TOGGLE helper ───────────────────────────
    local function makeToggle(y, label, initVal, onToggle)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,-10,0,32)
        row.Position = UDim2.new(0,5,0,y)
        row.BackgroundColor3 = CFG.Panel
        row.BorderSizePixel = 0
        row.Parent = MF
        makeCorner(row, 7)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-52,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = CFG.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local toggleBG = Instance.new("Frame")
        toggleBG.Size = UDim2.new(0,38,0,20)
        toggleBG.Position = UDim2.new(1,-44,0.5,-10)
        toggleBG.BackgroundColor3 = initVal and CFG.Accent or CFG.Dim
        toggleBG.BorderSizePixel = 0
        toggleBG.Parent = row
        makeCorner(toggleBG, 10)

        local toggleDot = Instance.new("Frame")
        toggleDot.Size = UDim2.new(0,14,0,14)
        toggleDot.Position = initVal
            and UDim2.new(0,21,0.5,-7)
            or  UDim2.new(0,3,0.5,-7)
        toggleDot.BackgroundColor3 = Color3.fromRGB(240,240,240)
        toggleDot.BorderSizePixel = 0
        toggleDot.Parent = toggleBG
        makeCorner(toggleDot, 7)

        local val = initVal
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Active = true
        btn.Parent = row

        btn.MouseButton1Click:Connect(function()
            val = not val
            TweenService:Create(toggleBG, TweenInfo.new(0.15), {
                BackgroundColor3 = val and CFG.Accent or CFG.Dim
            }):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.15), {
                Position = val and UDim2.new(0,21,0.5,-7) or UDim2.new(0,3,0.5,-7)
            }):Play()
            onToggle(val)
        end)

        return row
    end

    -- ── KICK MODE SELECTOR ──────────────────────
    local function makeKickSelector(y)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,-10,0,32)
        frame.Position = UDim2.new(0,5,0,y)
        frame.BackgroundColor3 = CFG.Panel
        frame.BorderSizePixel = 0
        frame.Parent = MF
        makeCorner(frame, 7)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0,80,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Kick Mode"
        lbl.TextColor3 = CFG.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local modes = {"Perfect", "Excellent", "Great"}
        local btns = {}
        local btnW = 60
        local startX = 90

        for i, mode in ipairs(modes) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, btnW, 0, 22)
            b.Position = UDim2.new(0, startX + (i-1)*(btnW+4), 0.5, -11)
            b.Text = mode
            b.Font = Enum.Font.GothamBold
            b.TextSize = 10
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Active = true
            b.Parent = frame
            makeCorner(b, 5)

            local function refresh()
                for _, bb in ipairs(btns) do
                    bb.BackgroundColor3 = Color3.fromRGB(22,24,38)
                    bb.TextColor3 = CFG.Dim
                end
                b.BackgroundColor3 = (mode == "Perfect") and CFG.Accent
                    or (mode == "Excellent") and CFG.Yellow
                    or CFG.Red
                b.TextColor3 = Color3.fromRGB(5,5,5)
            end

            b.MouseButton1Click:Connect(function()
                CFG.SelectedKick = mode
                for _, bb in ipairs(btns) do
                    bb.BackgroundColor3 = Color3.fromRGB(22,24,38)
                    bb.TextColor3 = CFG.Dim
                end
                b.BackgroundColor3 = (mode == "Perfect") and CFG.Accent
                    or (mode == "Excellent") and CFG.Yellow
                    or CFG.Red
                b.TextColor3 = Color3.fromRGB(5,5,5)
                setStatus("Kick mode: " .. mode, CFG.Accent)
            end)

            table.insert(btns, b)

            -- Set default visual
            if mode == CFG.SelectedKick then
                b.BackgroundColor3 = CFG.Accent
                b.TextColor3 = Color3.fromRGB(5,5,5)
            else
                b.BackgroundColor3 = Color3.fromRGB(22,24,38)
                b.TextColor3 = CFG.Dim
            end
        end
    end

    -- ── BUILD LAYOUT ────────────────────────────
    sectionLbl(70, "  FITUR")
    makeToggle(82, "Auto Go to Kick Zone", false, function(v)
        CFG.AutoGo = v
        setStatus(v and "Auto Go aktif" or "Auto Go mati",
                  v and CFG.Accent or CFG.Dim)
    end)
    makeToggle(118, "Auto Kick", false, function(v)
        CFG.AutoKick = v
        setStatus(v and "Auto Kick aktif" or "Auto Kick mati",
                  v and CFG.Accent or CFG.Dim)
    end)

    sectionLbl(158, "  KICK MODE")
    makeKickSelector(170)

    -- Speed slider label
    sectionLbl(210, "  WALK SPEED (anti-detect)")

    local speedRow = Instance.new("Frame")
    speedRow.Size = UDim2.new(1,-10,0,32)
    speedRow.Position = UDim2.new(0,5,0,222)
    speedRow.BackgroundColor3 = CFG.Panel
    speedRow.BorderSizePixel = 0
    speedRow.Parent = MF
    makeCorner(speedRow, 7)

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(0,120,1,0)
    speedLbl.Position = UDim2.new(0,10,0,0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: " .. CFG.WalkSpeed
    speedLbl.TextColor3 = CFG.Text
    speedLbl.Font = Enum.Font.Gotham
    speedLbl.TextSize = 12
    speedLbl.TextXAlignment = Enum.TextXAlignment.Left
    speedLbl.Parent = speedRow

    local speedDown = Instance.new("TextButton")
    speedDown.Size = UDim2.new(0,24,0,22)
    speedDown.Position = UDim2.new(1,-60,0.5,-11)
    speedDown.Text = "–"
    speedDown.BackgroundColor3 = Color3.fromRGB(22,24,38)
    speedDown.TextColor3 = CFG.Text
    speedDown.Font = Enum.Font.GothamBold
    speedDown.TextSize = 14
    speedDown.BorderSizePixel = 0
    speedDown.AutoButtonColor = false
    speedDown.Parent = speedRow
    makeCorner(speedDown, 5)

    local speedUp = Instance.new("TextButton")
    speedUp.Size = UDim2.new(0,24,0,22)
    speedUp.Position = UDim2.new(1,-32,0.5,-11)
    speedUp.Text = "+"
    speedUp.BackgroundColor3 = Color3.fromRGB(22,24,38)
    speedUp.TextColor3 = CFG.Text
    speedUp.Font = Enum.Font.GothamBold
    speedUp.TextSize = 14
    speedUp.BorderSizePixel = 0
    speedUp.AutoButtonColor = false
    speedUp.Parent = speedRow
    makeCorner(speedUp, 5)

    speedDown.MouseButton1Click:Connect(function()
        CFG.WalkSpeed = math.max(16, CFG.WalkSpeed - 1)
        speedLbl.Text = "Speed: " .. CFG.WalkSpeed
    end)
    speedUp.MouseButton1Click:Connect(function()
        CFG.WalkSpeed = math.min(30, CFG.WalkSpeed + 1)
        speedLbl.Text = "Speed: " .. CFG.WalkSpeed
    end)

    -- Info bar bawah
    local infoRow = Instance.new("Frame")
    infoRow.Size = UDim2.new(1,-10,0,20)
    infoRow.Position = UDim2.new(0,5,0,266)
    infoRow.BackgroundColor3 = Color3.fromRGB(12,14,22)
    infoRow.BorderSizePixel = 0
    infoRow.Parent = MF
    makeCorner(infoRow, 5)

    local infoTxt = Instance.new("TextLabel")
    infoTxt.Size = UDim2.new(1,-10,1,0)
    infoTxt.Position = UDim2.new(0,6,0,0)
    infoTxt.BackgroundTransparency = 1
    infoTxt.Text = "GreatHub • Kick a Lucky Block Edition"
    infoTxt.TextColor3 = Color3.fromRGB(40,45,65)
    infoTxt.Font = Enum.Font.Gotham
    infoTxt.TextSize = 9
    infoTxt.TextXAlignment = Enum.TextXAlignment.Center
    infoTxt.Parent = infoRow

    -- ── DRAG ────────────────────────────────────
    local dragging, dStart, dOrig = false,nil,nil
    HBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dStart = i.Position; dOrig = MF.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging=false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement
                      or i.UserInputType==Enum.UserInputType.Touch) then
            local d = i.Position-dStart
            MF.Position = UDim2.new(dOrig.X.Scale,dOrig.X.Offset+d.X,
                                     dOrig.Y.Scale,dOrig.Y.Offset+d.Y)
        end
    end)

    -- ── MINIMIZE ────────────────────────────────
    local mini = false
    local origSz = MF.Size
    minBtn.MouseButton1Click:Connect(function()
        mini = not mini
        TweenService:Create(MF, TweenInfo.new(0.18,Enum.EasingStyle.Quint),{
            Size = mini and UDim2.new(0,280,0,36) or origSz
        }):Play()
        minBtn.Text = mini and "+" or "–"
    end)

    -- ================================================
    -- AUTO GO TO KICK ZONE
    -- Gerak ke area dekat pohon (kick zone) dengan
    -- lari + lompat random biar natural
    -- ================================================
    local function findKickZone()
        -- Cari Part yang namanya mengandung "Kick", "SafeZone", "KickZone"
        local workspace = game:GetService("Workspace")
        local keywords = {"KickZone","Kick_Zone","SafeZone","Safe_Zone","KickArea","KickPlace"}
        for _, kw in ipairs(keywords) do
            local found = workspace:FindFirstChild(kw, true)
            if found then
                if found:IsA("BasePart") then
                    return found.Position
                elseif found:IsA("Model") and found.PrimaryPart then
                    return found.PrimaryPart.Position
                end
            end
        end
        -- Fallback: cari Part yang ada "Kick" di namanya
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("kick") then
                return v.Position
            end
        end
        return nil
    end

    local function findLuckyBlock()
        local workspace = game:GetService("Workspace")
        local keywords = {"LuckyBlock","Lucky_Block","Block","LuckyBrick"}
        for _, kw in ipairs(keywords) do
            local found = workspace:FindFirstChild(kw, true)
            if found then
                if found:IsA("BasePart") then return found end
                if found:IsA("Model") and found.PrimaryPart then return found.PrimaryPart end
            end
        end
        -- Fallback: cari Part warna kuning (lucky block biasanya kuning)
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("lucky") then
                return v
            end
        end
        return nil
    end

    local function getChar()
        return LP.Character
    end

    local function getHRP()
        local c = getChar()
        return c and c:FindFirstChild("HumanoidRootPart")
    end

    local function getHuman()
        local c = getChar()
        return c and c:FindFirstChildOfClass("Humanoid")
    end

    -- Teleport halus (bukan fly, tapi walkspeed tinggi + tween posisi)
    -- Lompat random biar anti-detect
    local function walkTo(targetPos)
        local hrp = getHRP()
        local hum = getHuman()
        if not hrp or not hum then return end

        local origSpeed = hum.WalkSpeed
        hum.WalkSpeed = CFG.WalkSpeed

        -- Paksa MoveToFinished dengan MoveTo + lompat random
        local dist = (hrp.Position - targetPos).Magnitude
        local steps = math.ceil(dist / 8)

        for i = 1, steps do
            if not CFG.AutoGo then break end
            local hrp2 = getHRP()
            local hum2 = getHuman()
            if not hrp2 or not hum2 then break end

            local alpha = i / steps
            local intermediate = hrp2.Position:Lerp(targetPos, 1/steps * 1.1)
            hum2:MoveTo(intermediate)

            -- Random jump (anti detect)
            if math.random() < CFG.JumpChance then
                hum2.Jump = true
            end

            task.wait(0.12)
        end

        -- Final moveto
        local hum3 = getHuman()
        if hum3 then
            hum3:MoveTo(targetPos)
            hum3.WalkSpeed = origSpeed
        end
    end

    -- ================================================
    -- FIND KICK BUTTON IN GAME UI
    -- Cari tombol "KICK!" di PlayerGui / ScreenGui game
    -- ================================================
    local function findKickButton()
        for _, sg in ipairs(PGui:GetChildren()) do
            if sg:IsA("ScreenGui") and sg.Name ~= "GreatHubGui" then
                for _, v in ipairs(sg:GetDescendants()) do
                    if (v:IsA("TextButton") or v:IsA("ImageButton")) then
                        local txt = v:IsA("TextButton") and v.Text:upper() or ""
                        if txt:find("KICK") then
                            return v
                        end
                    end
                end
            end
        end
        return nil
    end

    -- Simulasi klik tombol
    local function clickKickButton(btn)
        if not btn then return false end
        -- Simulasi MouseButton1Click
        local ok = pcall(function()
            btn.MouseButton1Click:Fire()
        end)
        if not ok then
            -- fallback: fire via VirtualInputManager jika ada
            pcall(function()
                local pos = btn.AbsolutePosition + btn.AbsoluteSize/2
                -- Simulate via input
                local uis = game:GetService("UserInputService")
                -- Trigger via remote jika ada
            end)
        end
        return ok
    end

    -- ================================================
    -- PERFECT KICK TIMING
    -- Bar muncul → tunggu sesuai timing → klik
    -- ================================================
    local function waitForBarAndKick()
        local timing = CFG.KickTiming[CFG.SelectedKick]
        setStatus("Menunggu bar kick...", CFG.Yellow)

        -- Deteksi bar: cari elemen GUI yang muncul tiba-tiba
        -- (bar biasanya Frame dengan size yang grow)
        local barFound = false
        local timeout = 0
        local kickBtn = nil

        -- Poll sampai tombol KICK muncul
        while timeout < 8 do
            kickBtn = findKickButton()
            if kickBtn and kickBtn.Visible then
                barFound = true
                break
            end
            task.wait(0.05)
            timeout += 0.05
        end

        if not barFound then
            setStatus("Kick button tidak ditemukan", CFG.Red)
            return
        end

        -- Tunggu sesuai timing tendangan
        setStatus("Timing " .. CFG.SelectedKick .. "...", CFG.Yellow)
        task.wait(timing)

        -- Klik!
        clickKickButton(kickBtn)
        setStatus("Kicked! (" .. CFG.SelectedKick .. ")", CFG.Accent)
    end

    -- ================================================
    -- MAIN LOOP
    -- ================================================
    local running = false

    RunService.Heartbeat:Connect(function()
        if not CFG.AutoGo and not CFG.AutoKick then
            running = false
            return
        end
        if running then return end
        running = true

        task.spawn(function()
            -- AUTO GO
            if CFG.AutoGo then
                setStatus("Mencari kick zone...", CFG.Yellow)

                -- Cari lucky block dulu
                local block = findLuckyBlock()
                local targetPos

                if block then
                    -- Pergi ke dekat block (offset supaya pas di depannya)
                    targetPos = block.Position + Vector3.new(0, 0, 4)
                    setStatus("Lucky Block ditemukan! Menuju...", CFG.Accent)
                else
                    -- Cari kick zone manual
                    targetPos = findKickZone()
                    if not targetPos then
                        setStatus("Kick zone tidak ditemukan", CFG.Red)
                        running = false
                        return
                    end
                    setStatus("Menuju kick zone...", CFG.Accent)
                end

                -- Delay 10ms setelah spawn (sesuai request)
                task.wait(CFG.SpawnDelay)

                -- Jalan ke target (anti-detect: lari + lompat)
                walkTo(targetPos)
                setStatus("Sampai! Siap kick.", CFG.Accent)
            end

            -- AUTO KICK
            if CFG.AutoKick then
                task.wait(0.3) -- jeda dikit biar natural
                waitForBarAndKick()
            end

            task.wait(0.5)
            running = false
        end)
    end)

    -- Welcome notif
    setStatus("Key verified! Selamat datang.", CFG.Accent)
    task.wait(2)
    setStatus("Idle — aktifkan fitur di atas", CFG.Dim)
end

-- ================================================
-- KEY VERIFY HANDLER
-- ================================================
submitBtn.MouseButton1Click:Connect(function()
    local key = keyInput.Text
    if key == "" then
        statusLbl.Text = "Key tidak boleh kosong!"
        return
    end

    local ok, ktype = verifyKey(key)
    if ok then
        statusLbl.TextColor3 = Color3.fromRGB(60,220,100)
        statusLbl.Text = "✓ Key valid! Loading..."
        task.wait(0.8)
        buildMainHub(ktype)
    else
        -- Shake effect
        statusLbl.TextColor3 = CFG.Red
        statusLbl.Text = "✗ Key salah! Coba lagi."
        for i = 1, 4 do
            TweenService:Create(KeyCard, TweenInfo.new(0.05), {
                Position = UDim2.new(0.5, -160 + (i%2==0 and 5 or -5), 0.5, -110)
            }):Play()
            task.wait(0.05)
        end
        TweenService:Create(KeyCard, TweenInfo.new(0.05), {
            Position = UDim2.new(0.5,-160,0.5,-110)
        }):Play()
    end
end)

-- Enter di input box
keyInput.FocusLost:Connect(function(enter)
    if enter then
        submitBtn.MouseButton1Click:Fire()
    end
end)

print("[GreatHub] Loaded - Kick a Lucky Block Edition")
