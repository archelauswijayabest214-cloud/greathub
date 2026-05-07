-- ================================================
--   GREATHUB v3 - KICK A LUCKY BLOCK
--   Full rewrite | Delta Executor
--   Fix: TENDANG! detection, speed, auto-tp, UI
-- ================================================

local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local VirtualUser    = game:GetService("VirtualUser")

local LP   = Players.LocalPlayer
local PGui
repeat PGui = LP:FindFirstChildOfClass("PlayerGui") task.wait(0.05) until PGui

-- Bersih instance lama
for _, n in ipairs({"GH_Key","GH_Main"}) do
    local g = PGui:FindFirstChild(n)
    if g then g:Destroy() end
end
task.wait(0.15)

-- ================================================
-- CONFIG
-- ================================================
local ADMIN_KEY  = "TEST123"
local FREE_KEYS  = {"GREAT001","LUCKY2026","BLOCK777","KICKTOP"}

local S = {
    AutoGo   = false,
    AutoKick = false,
    KickMode = "Sempurna",   -- Sempurna / Hebat / Bagus
    Speed    = 24,
    -- Timing setelah tombol TENDANG! muncul (detik)
    Timing   = { Sempurna = 0.68, Hebat = 0.42, Bagus = 0.22 },
    SpawnDelay = 0.01,   -- 10ms
    JumpChance = 0.28,
}

-- Warna: biru-hitam gradient feel
local K = {
    BG1    = Color3.fromRGB(4,  8,  20),   -- sangat gelap biru
    BG2    = Color3.fromRGB(8,  16, 38),   -- biru gelap
    Panel  = Color3.fromRGB(10, 18, 42),
    Card   = Color3.fromRGB(12, 22, 52),
    Blue1  = Color3.fromRGB(40, 120, 255), -- biru terang
    Blue2  = Color3.fromRGB(0,  200, 255), -- cyan
    Dim    = Color3.fromRGB(60, 90, 140),
    Text   = Color3.fromRGB(200,220,255),
    TextDim= Color3.fromRGB(80, 110,160),
    Green  = Color3.fromRGB(40, 220,100),
    Yellow = Color3.fromRGB(255,200, 40),
    Red    = Color3.fromRGB(255, 70, 70),
    White  = Color3.fromRGB(230,240,255),
}

-- ================================================
-- UI HELPERS
-- ================================================
local function corner(p, r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p return c end
local function stroke(p, col, th, tr) local s=Instance.new("UIStroke") s.Color=col or K.Blue1 s.Thickness=th or 1 s.Transparency=tr or 0.5 s.Parent=p return s end
local function pad(p,t,b,l,r) local u=Instance.new("UIPadding") u.PaddingTop=UDim.new(0,t or 0) u.PaddingBottom=UDim.new(0,b or 0) u.PaddingLeft=UDim.new(0,l or 0) u.PaddingRight=UDim.new(0,r or 0) u.Parent=p end

local function gradFrame(parent, c1, c2, rot)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = c1
    f.BorderSizePixel = 0
    f.Parent = parent
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c1, c2)
    g.Rotation = rot or 135
    g.Parent = f
    return f
end

local function makeBtn(parent, text, bgColor, textColor, size, pos)
    local b = Instance.new("TextButton")
    b.Size = size or UDim2.new(1,0,0,32)
    b.Position = pos or UDim2.new(0,0,0,0)
    b.BackgroundColor3 = bgColor or K.Blue1
    b.Text = text
    b.TextColor3 = textColor or K.White
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Active = true
    b.Parent = parent
    corner(b, 7)
    return b
end

local function makeTxt(parent, text, size, color, bold, xa)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = size or 12
    l.TextColor3 = color or K.Text
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.Size = UDim2.new(1,0,1,0)
    l.Parent = parent
    return l
end

-- ================================================
-- KEY SCREEN
-- ================================================
local KG = Instance.new("ScreenGui")
KG.Name = "GH_Key"
KG.ResetOnSpawn = false
KG.IgnoreGuiInset = true
KG.DisplayOrder = 1001
KG.Parent = PGui

-- Backdrop blur-like (dark overlay)
local backdrop = Instance.new("Frame")
backdrop.Size = UDim2.new(1,0,1,0)
backdrop.BackgroundColor3 = Color3.fromRGB(0,0,0)
backdrop.BackgroundTransparency = 0.4
backdrop.BorderSizePixel = 0
backdrop.Parent = KG

-- Card background gradient
local card = gradFrame(KG, K.BG1, K.BG2, 145)
card.Size = UDim2.new(0,310,0,230)
card.Position = UDim2.new(0.5,-155,0.5,-115)
corner(card, 14)
stroke(card, K.Blue1, 1.5, 0.2)

-- Top gradient bar
local topBar = gradFrame(card, K.Blue1, K.Blue2, 90)
topBar.Size = UDim2.new(1,0,0,4)
topBar.Position = UDim2.new(0,0,0,0)

-- Logo row
local logoRow = Instance.new("Frame")
logoRow.Size = UDim2.new(1,0,0,52)
logoRow.Position = UDim2.new(0,0,0,4)
logoRow.BackgroundTransparency = 1
logoRow.Parent = card

local logoIcon = Instance.new("TextLabel")
logoIcon.Size = UDim2.new(0,44,0,44)
logoIcon.Position = UDim2.new(0.5,-22,0,4)
logoIcon.BackgroundTransparency = 1
logoIcon.Text = "⚡"
logoIcon.TextSize = 28
logoIcon.Font = Enum.Font.GothamBold
logoIcon.TextXAlignment = Enum.TextXAlignment.Center
logoIcon.TextColor3 = K.Blue2
logoIcon.Parent = logoRow

local logoTxt = Instance.new("TextLabel")
logoTxt.Size = UDim2.new(1,0,0,20)
logoTxt.Position = UDim2.new(0,0,0,50)
logoTxt.BackgroundTransparency = 1
logoTxt.Text = "GREATHUB"
logoTxt.TextSize = 20
logoTxt.Font = Enum.Font.GothamBold
logoTxt.TextXAlignment = Enum.TextXAlignment.Center
logoTxt.TextColor3 = K.White
logoTxt.Parent = card

-- Gradient text effect via UIGradient
local logoG = Instance.new("UIGradient")
logoG.Color = ColorSequence.new(K.Blue1, K.Blue2)
logoG.Rotation = 90
logoG.Parent = logoTxt

local subTxt = Instance.new("TextLabel")
subTxt.Size = UDim2.new(1,-20,0,14)
subTxt.Position = UDim2.new(0,10,0,74)
subTxt.BackgroundTransparency = 1
subTxt.Text = "Kick a Lucky Block Edition"
subTxt.TextSize = 10
subTxt.Font = Enum.Font.Gotham
subTxt.TextXAlignment = Enum.TextXAlignment.Center
subTxt.TextColor3 = K.Dim
subTxt.Parent = card

-- Input wrap
local iWrap = Instance.new("Frame")
iWrap.Size = UDim2.new(1,-28,0,40)
iWrap.Position = UDim2.new(0,14,0,96)
iWrap.BackgroundColor3 = Color3.fromRGB(6,12,30)
iWrap.BorderSizePixel = 0
iWrap.Parent = card
corner(iWrap, 8)
local iStroke = stroke(iWrap, K.Dim, 1, 0.4)

local iBox = Instance.new("TextBox")
iBox.Size = UDim2.new(1,-16,1,-10)
iBox.Position = UDim2.new(0,8,0,5)
iBox.BackgroundTransparency = 1
iBox.PlaceholderText = "Masukkan key..."
iBox.PlaceholderColor3 = K.Dim
iBox.TextColor3 = K.White
iBox.Font = Enum.Font.GothamBold
iBox.TextSize = 14
iBox.TextXAlignment = Enum.TextXAlignment.Center
iBox.ClearTextOnFocus = false
iBox.Parent = iWrap

-- Verify button with gradient
local vBtn = gradFrame(card, K.Blue1, K.Blue2, 90)
vBtn.Size = UDim2.new(1,-28,0,40)
vBtn.Position = UDim2.new(0,14,0,146)
corner(vBtn, 9)

local vBtnBtn = Instance.new("TextButton")
vBtnBtn.Size = UDim2.new(1,0,1,0)
vBtnBtn.BackgroundTransparency = 1
vBtnBtn.Text = "VERIFY KEY"
vBtnBtn.TextColor3 = K.White
vBtnBtn.Font = Enum.Font.GothamBold
vBtnBtn.TextSize = 13
vBtnBtn.BorderSizePixel = 0
vBtnBtn.AutoButtonColor = false
vBtnBtn.Active = true
vBtnBtn.Parent = vBtn

local statusK = Instance.new("TextLabel")
statusK.Size = UDim2.new(1,-20,0,18)
statusK.Position = UDim2.new(0,10,0,193)
statusK.BackgroundTransparency = 1
statusK.Text = "Key gratis ganti tiap hari • Admin: TEST123"
statusK.TextSize = 9
statusK.Font = Enum.Font.Gotham
statusK.TextXAlignment = Enum.TextXAlignment.Center
statusK.TextColor3 = K.TextDim
statusK.Parent = card

-- ================================================
-- MAIN HUB BUILDER
-- ================================================
local function buildHub(ktype)
    KG:Destroy()
    task.wait(0.1)

    local MG = Instance.new("ScreenGui")
    MG.Name = "GH_Main"
    MG.ResetOnSpawn = false
    MG.IgnoreGuiInset = true
    MG.DisplayOrder = 999
    MG.Parent = PGui

    -- Main frame dengan gradient biru-hitam
    local MF = gradFrame(MG, K.BG1, K.BG2, 150)
    MF.Name = "MF"
    MF.Size = UDim2.new(0,270,0,300)
    MF.Position = UDim2.new(0,14,0,50)
    MF.ClipsDescendants = true
    MF.Active = true
    corner(MF, 12)
    stroke(MF, K.Blue1, 1.5, 0.25)

    -- Top glow bar
    local glowBar = gradFrame(MF, K.Blue1, K.Blue2, 90)
    glowBar.Size = UDim2.new(1,0,0,3)
    glowBar.ZIndex = 10

    -- Header
    local HBar = gradFrame(MF, K.Panel, Color3.fromRGB(8,14,36), 90)
    HBar.Size = UDim2.new(1,0,0,38)
    HBar.Position = UDim2.new(0,0,0,3)
    HBar.Active = true

    -- dot animasi
    local dotF = Instance.new("Frame")
    dotF.Size = UDim2.new(0,7,0,7)
    dotF.Position = UDim2.new(0,11,0.5,-3.5)
    dotF.BackgroundColor3 = K.Blue2
    dotF.BorderSizePixel = 0
    dotF.Parent = HBar
    corner(dotF, 4)

    -- pulse dot
    task.spawn(function()
        while MF.Parent do
            TweenService:Create(dotF, TweenInfo.new(0.8,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,true),
                {BackgroundColor3 = K.Blue1}):Play()
            task.wait(1.6)
        end
    end)

    local hTitle = Instance.new("TextLabel")
    hTitle.Size = UDim2.new(1,-85,1,0)
    hTitle.Position = UDim2.new(0,24,0,0)
    hTitle.BackgroundTransparency = 1
    hTitle.Text = "GREATHUB"
    hTitle.Font = Enum.Font.GothamBold
    hTitle.TextSize = 13
    hTitle.TextXAlignment = Enum.TextXAlignment.Left
    hTitle.Parent = HBar
    local hG = Instance.new("UIGradient")
    hG.Color = ColorSequence.new(K.Blue2, K.White)
    hG.Rotation = 0
    hG.Parent = hTitle

    -- Badge
    local badge = Instance.new("Frame")
    badge.Size = UDim2.new(0,50,0,20)
    badge.Position = UDim2.new(1,-78,0.5,-10)
    badge.BackgroundColor3 = ktype=="admin" and Color3.fromRGB(255,170,0) or K.Blue1
    badge.BorderSizePixel = 0
    badge.Parent = HBar
    corner(badge, 5)
    local bTxt = Instance.new("TextLabel")
    bTxt.Size = UDim2.new(1,0,1,0)
    bTxt.BackgroundTransparency = 1
    bTxt.Text = ktype=="admin" and "ADMIN" or "FREE"
    bTxt.TextColor3 = Color3.fromRGB(5,5,10)
    bTxt.Font = Enum.Font.GothamBold
    bTxt.TextSize = 10
    bTxt.TextXAlignment = Enum.TextXAlignment.Center
    bTxt.Parent = badge

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0,22,0,22)
    minBtn.Position = UDim2.new(1,-28,0.5,-11)
    minBtn.BackgroundColor3 = Color3.fromRGB(8,14,36)
    minBtn.Text = "–"
    minBtn.TextColor3 = K.Dim
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 14
    minBtn.BorderSizePixel = 0
    minBtn.AutoButtonColor = false
    minBtn.Active = true
    minBtn.Parent = HBar
    corner(minBtn, 5)

    -- Status bar
    local stBar = Instance.new("Frame")
    stBar.Size = UDim2.new(1,-12,0,24)
    stBar.Position = UDim2.new(0,6,0,44)
    stBar.BackgroundColor3 = Color3.fromRGB(4,8,22)
    stBar.BorderSizePixel = 0
    stBar.Parent = MF
    corner(stBar, 6)
    stroke(stBar, K.Blue1, 1, 0.75)

    local stTxt = Instance.new("TextLabel")
    stTxt.Size = UDim2.new(1,-10,1,0)
    stTxt.Position = UDim2.new(0,6,0,0)
    stTxt.BackgroundTransparency = 1
    stTxt.Text = "● Idle"
    stTxt.TextColor3 = K.Dim
    stTxt.Font = Enum.Font.Gotham
    stTxt.TextSize = 11
    stTxt.TextXAlignment = Enum.TextXAlignment.Left
    stTxt.Parent = stBar

    local function setStatus(t, c)
        stTxt.Text = "● "..t
        stTxt.TextColor3 = c or K.Dim
    end

    -- Section label
    local function secLbl(y, t)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1,-12,0,13)
        l.Position = UDim2.new(0,6,0,y)
        l.BackgroundTransparency = 1
        l.Text = t
        l.TextColor3 = K.Dim
        l.Font = Enum.Font.GothamBold
        l.TextSize = 9
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.LetterSpacingOffset = 1
        l.Parent = MF
    end

    -- Toggle row
    local function makeToggle(y, label, key)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,-12,0,34)
        row.Position = UDim2.new(0,6,0,y)
        row.BackgroundColor3 = K.Card
        row.BorderSizePixel = 0
        row.Parent = MF
        corner(row, 8)
        stroke(row, K.Blue1, 1, 0.85)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-52,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = K.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local tBG = Instance.new("Frame")
        tBG.Size = UDim2.new(0,36,0,18)
        tBG.Position = UDim2.new(1,-42,0.5,-9)
        tBG.BackgroundColor3 = K.Dim
        tBG.BorderSizePixel = 0
        tBG.Parent = row
        corner(tBG, 9)

        -- gradient saat on
        local tG = Instance.new("UIGradient")
        tG.Color = ColorSequence.new(K.Blue1, K.Blue2)
        tG.Rotation = 90
        tG.Enabled = false
        tG.Parent = tBG

        local tDot = Instance.new("Frame")
        tDot.Size = UDim2.new(0,13,0,13)
        tDot.Position = UDim2.new(0,2.5,0.5,-6.5)
        tDot.BackgroundColor3 = K.White
        tDot.BorderSizePixel = 0
        tDot.Parent = tBG
        corner(tDot, 7)

        local val = false
        local clickable = Instance.new("TextButton")
        clickable.Size = UDim2.new(1,0,1,0)
        clickable.BackgroundTransparency = 1
        clickable.Text = ""
        clickable.Active = true
        clickable.Parent = row

        clickable.MouseButton1Click:Connect(function()
            val = not val
            S[key] = val
            tG.Enabled = val
            TweenService:Create(tBG, TweenInfo.new(0.15),{
                BackgroundColor3 = val and K.Blue1 or K.Dim
            }):Play()
            TweenService:Create(tDot, TweenInfo.new(0.15),{
                Position = val
                    and UDim2.new(0,20.5,0.5,-6.5)
                    or  UDim2.new(0,2.5,0.5,-6.5)
            }):Play()
        end)
    end

    -- Kick mode selector
    local function makeKickSel(y)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,-12,0,34)
        row.Position = UDim2.new(0,6,0,y)
        row.BackgroundColor3 = K.Card
        row.BorderSizePixel = 0
        row.Parent = MF
        corner(row, 8)
        stroke(row, K.Blue1, 1, 0.85)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0,65,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Mode"
        lbl.TextColor3 = K.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local modes = {"Sempurna","Hebat","Bagus"}
        local btns = {}
        for i, m in ipairs(modes) do
            local bf = gradFrame(row,
                m==S.KickMode and K.Blue1 or Color3.fromRGB(8,14,32),
                m==S.KickMode and K.Blue2 or Color3.fromRGB(8,14,32),
                90)
            bf.Size = UDim2.new(0,58,0,22)
            bf.Position = UDim2.new(0,70+(i-1)*62,0.5,-11)
            corner(bf, 6)

            local mb = Instance.new("TextButton")
            mb.Size = UDim2.new(1,0,1,0)
            mb.BackgroundTransparency = 1
            mb.Text = m
            mb.TextColor3 = m==S.KickMode and K.White or K.Dim
            mb.Font = Enum.Font.GothamBold
            mb.TextSize = 10
            mb.BorderSizePixel = 0
            mb.AutoButtonColor = false
            mb.Active = true
            mb.Parent = bf
            table.insert(btns, {frame=bf, btn=mb, mode=m})

            mb.MouseButton1Click:Connect(function()
                S.KickMode = m
                for _, bd in ipairs(btns) do
                    local on = bd.mode == m
                    local g2 = bd.frame:FindFirstChildOfClass("UIGradient")
                    if g2 then
                        g2.Color = on
                            and ColorSequence.new(K.Blue1,K.Blue2)
                            or  ColorSequence.new(Color3.fromRGB(8,14,32),Color3.fromRGB(8,14,32))
                    end
                    bd.btn.TextColor3 = on and K.White or K.Dim
                end
                setStatus("Mode: "..m, K.Blue2)
            end)
        end
    end

    -- Speed row
    local function makeSpeed(y)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,-12,0,34)
        row.Position = UDim2.new(0,6,0,y)
        row.BackgroundColor3 = K.Card
        row.BorderSizePixel = 0
        row.Parent = MF
        corner(row, 8)
        stroke(row, K.Blue1, 1, 0.85)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0,120,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Speed: "..S.Speed
        lbl.TextColor3 = K.Text
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local function mkSBtn(txt, xoff)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0,24,0,22)
            b.Position = UDim2.new(1,xoff,0.5,-11)
            b.BackgroundColor3 = Color3.fromRGB(8,14,32)
            b.Text = txt
            b.TextColor3 = K.Text
            b.Font = Enum.Font.GothamBold
            b.TextSize = 14
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Active = true
            b.Parent = row
            corner(b, 5)
            stroke(b, K.Blue1, 1, 0.7)
            return b
        end
        local dn = mkSBtn("–", -58)
        local up = mkSBtn("+", -30)

        dn.MouseButton1Click:Connect(function()
            S.Speed = math.max(16, S.Speed-1)
            lbl.Text = "Speed: "..S.Speed
        end)
        up.MouseButton1Click:Connect(function()
            S.Speed = math.min(32, S.Speed+1)
            lbl.Text = "Speed: "..S.Speed
        end)
    end

    -- BUILD LAYOUT
    secLbl(71,  "  FITUR")
    makeToggle(82,  "Auto Go to Kick Zone", "AutoGo")
    makeToggle(120, "Auto Kick",            "AutoKick")
    secLbl(158, "  KICK MODE")
    makeKickSel(169)
    secLbl(207, "  WALK SPEED (anti-detect)")
    makeSpeed(218)

    -- Footer
    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1,-12,0,14)
    footer.Position = UDim2.new(0,6,1,-18)
    footer.BackgroundTransparency = 1
    footer.Text = "GreatHub • Kick a Lucky Block"
    footer.TextColor3 = Color3.fromRGB(25,40,80)
    footer.Font = Enum.Font.Gotham
    footer.TextSize = 9
    footer.TextXAlignment = Enum.TextXAlignment.Center
    footer.Parent = MF

    -- ── DRAG ──
    local drag,ds,do2 = false,nil,nil
    HBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
        or i.UserInputType==Enum.UserInputType.Touch then
            drag=true ds=i.Position do2=MF.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement
                  or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            MF.Position=UDim2.new(do2.X.Scale,do2.X.Offset+d.X,
                                   do2.Y.Scale,do2.Y.Offset+d.Y)
        end
    end)

    -- ── MINIMIZE ──
    local mini=false local origSz=MF.Size
    minBtn.MouseButton1Click:Connect(function()
        mini=not mini
        TweenService:Create(MF,TweenInfo.new(0.18,Enum.EasingStyle.Quint),{
            Size=mini and UDim2.new(0,270,0,41) or origSz
        }):Play()
        minBtn.Text=mini and "+" or "–"
    end)

    -- ================================================
    -- CORE FUNCTIONS
    -- ================================================

    -- Cari tombol TENDANG! di semua ScreenGui
    local function findTendang()
        for _, sg in ipairs(PGui:GetChildren()) do
            if sg:IsA("ScreenGui") and sg.Name~="GH_Main" and sg.Name~="GH_Key" then
                for _, v in ipairs(sg:GetDescendants()) do
                    if v:IsA("TextButton") or v:IsA("ImageButton") then
                        local txt = v:IsA("TextButton") and v.Text or ""
                        -- cek "TENDANG", "KICK", "TAP"
                        if txt:upper():find("TENDANG") or txt:upper():find("KICK") then
                            if v.Visible and v.Active then
                                return v
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    -- Klik tombol dengan simulasi input beneran
    local function clickBtn(btn)
        if not btn then return end
        -- Method 1: fire event
        pcall(function() btn.MouseButton1Down:Fire() end)
        task.wait(0.03)
        pcall(function() btn.MouseButton1Up:Fire() end)
        pcall(function() btn.MouseButton1Click:Fire() end)
        -- Method 2: VirtualUser tap (biar kena deteksi game juga)
        pcall(function()
            local ap = btn.AbsolutePosition
            local as = btn.AbsoluteSize
            local cx = ap.X + as.X/2
            local cy = ap.Y + as.Y/2
            VirtualUser:ClickButton2(Vector2.new(cx, cy))
            task.wait(0.02)
            VirtualUser:ClickButton1(Vector2.new(cx, cy))
        end)
    end

    -- Cari Lucky Block di workspace
    local function findBlock()
        local ws = game:GetService("Workspace")
        -- Cari model/part dengan kata lucky atau block
        for _, v in ipairs(ws:GetDescendants()) do
            if v:IsA("BasePart") then
                local n = v.Name:lower()
                if n:find("lucky") or n:find("block") then
                    -- Pastikan bukan terrain/floor, cek size
                    if v.Size.Y < 6 and v.Size.X < 6 then
                        return v
                    end
                end
            end
        end
        return nil
    end

    -- Set speed karakter secara langsung
    local function setSpeed(spd)
        local c = LP.Character
        if not c then return end
        local h = c:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = spd end
    end

    -- Gerak ke posisi dengan lompat-lompat anti-detect
    local function walkTo(targetPos)
        local c = LP.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        setSpeed(S.Speed)

        local maxTime = 8
        local elapsed = 0
        local arrived = false

        hum:MoveTo(targetPos)

        -- Sambil jalan, lompat random
        local jumpConn
        jumpConn = RunService.Heartbeat:Connect(function(dt)
            elapsed += dt
            if not S.AutoGo or elapsed > maxTime then
                jumpConn:Disconnect()
                arrived = true
                return
            end
            local dist = (hrp.Position - targetPos).Magnitude
            if dist < 4 then
                jumpConn:Disconnect()
                arrived = true
                return
            end
            -- Re-issue MoveTo tiap 1.5 detik biar ga berhenti
            if elapsed % 1.5 < dt then
                hum:MoveTo(targetPos)
            end
            -- Random jump
            if math.random() < S.JumpChance * dt then
                hum.Jump = true
            end
        end)

        -- Tunggu sampai sampai (max 8 detik)
        local t = 0
        while not arrived and t < maxTime do
            task.wait(0.1)
            t += 0.1
        end

        setSpeed(16) -- reset speed
    end

    -- ================================================
    -- MAIN LOOP
    -- ================================================
    local busy = false

    RunService.Heartbeat:Connect(function()
        if not (S.AutoGo or S.AutoKick) then
            busy = false
            return
        end
        if busy then return end
        busy = true

        task.spawn(function()
            -- 1. AUTO GO
            if S.AutoGo then
                setStatus("Mencari Lucky Block...", K.Yellow)
                local block = findBlock()

                if block then
                    setStatus("Block ditemukan! Menuju...", K.Blue2)
                    task.wait(S.SpawnDelay) -- 10ms delay

                    -- Target: depan block, di tanah
                    local dest = block.Position + Vector3.new(0, -block.Size.Y/2 + 1, 3.5)
                    walkTo(dest)
                    setStatus("Sampai di kick zone!", K.Green)
                else
                    setStatus("Block tidak ditemukan, scan ulang...", K.Dim)
                    task.wait(1)
                    busy = false
                    return
                end
            end

            -- 2. AUTO KICK
            if S.AutoKick then
                setStatus("Menunggu tombol TENDANG!...", K.Yellow)

                -- Poll tombol TENDANG! sampai muncul (max 6 detik)
                local btn = nil
                local waited = 0
                while waited < 6 do
                    btn = findTendang()
                    if btn then break end
                    task.wait(0.05)
                    waited += 0.05
                end

                if not btn then
                    setStatus("Tombol TENDANG! tidak muncul", K.Red)
                    task.wait(1)
                    busy = false
                    return
                end

                -- Dapat tombol → tunggu timing sesuai mode
                local delay = S.Timing[S.KickMode] or 0.68
                setStatus("Timing "..S.KickMode.."...", K.Yellow)
                task.wait(delay)

                -- KICK!
                clickBtn(btn)
                setStatus("✓ Kicked! ("..S.KickMode..")", K.Green)
                task.wait(1.5)
            end

            task.wait(0.3)
            busy = false
        end)
    end)

    -- Juga watch spawn baru (saat block respawn)
    game:GetService("Workspace").ChildAdded:Connect(function(child)
        task.wait(S.SpawnDelay)
        if S.AutoGo or S.AutoKick then
            -- Cek apakah itu block baru
            if child:IsA("BasePart") or child:IsA("Model") then
                local n = child.Name:lower()
                if n:find("lucky") or n:find("block") then
                    busy = false -- reset biar loop jalan lagi
                end
            end
        end
    end)

    setStatus("Siap! Aktifkan fitur di atas.", K.Blue2)
end

-- ================================================
-- KEY VERIFY
-- ================================================
local function verify()
    local k = iBox.Text:upper():gsub("%s","")
    if k == "" then
        statusK.TextColor3 = K.Red
        statusK.Text = "Key tidak boleh kosong!"
        return
    end
    local ok, ktype = false, "user"
    if k == ADMIN_KEY then ok=true ktype="admin" end
    for _, fk in ipairs(FREE_KEYS) do
        if k == fk then ok=true break end
    end

    if ok then
        statusK.TextColor3 = K.Green
        statusK.Text = "✓ Valid! Loading..."
        -- Glow effect pada card
        TweenService:Create(iStroke, TweenInfo.new(0.2),{
            Color=K.Green, Transparency=0
        }):Play()
        task.wait(0.7)
        buildHub(ktype)
    else
        statusK.TextColor3 = K.Red
        statusK.Text = "✗ Key salah!"
        -- Shake
        for i=1,5 do
            TweenService:Create(card,TweenInfo.new(0.04),{
                Position=UDim2.new(0.5,-155+(i%2==0 and 6 or -6),0.5,-115)
            }):Play()
            task.wait(0.04)
        end
        TweenService:Create(card,TweenInfo.new(0.05),{
            Position=UDim2.new(0.5,-155,0.5,-115)
        }):Play()
    end
end

vBtnBtn.MouseButton1Click:Connect(verify)
iBox.FocusLost:Connect(function(enter) if enter then verify() end end)

-- Hover effect tombol verify
vBtnBtn.MouseEnter:Connect(function()
    TweenService:Create(vBtn, TweenInfo.new(0.15),{BackgroundTransparency=0.15}):Play()
end)
vBtnBtn.MouseLeave:Connect(function()
    TweenService:Create(vBtn, TweenInfo.new(0.15),{BackgroundTransparency=0}):Play()
end)

print("[GreatHub v3] Ready")
