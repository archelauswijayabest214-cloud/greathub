-- GreatHub | Kick a Lucky Block
-- Anti-detect: natural movement simulation
-- Key: TEST123

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local VR = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local VALID_KEY = "TEST123"
local autoOn = false
local busy = false
local keyOk = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "GreatHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = player.PlayerGui end

local function C(p,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r or 8) c.Parent=p end
local function F(par,s,p,col,zi,r)
    local f=Instance.new("Frame",par) f.Size=s f.Position=p
    f.BackgroundColor3=col or Color3.fromRGB(10,12,22)
    f.BorderSizePixel=0 f.ZIndex=zi or 1
    if r then C(f,r) end return f
end
local function L(par,txt,s,p,ts,fo,col,xa,zi)
    local l=Instance.new("TextLabel",par) l.Size=s l.Position=p
    l.BackgroundTransparency=1 l.Text=txt l.TextSize=ts or 12
    l.Font=fo or Enum.Font.Gotham l.TextColor3=col or Color3.fromRGB(210,220,255)
    l.TextXAlignment=xa or Enum.TextXAlignment.Center l.ZIndex=zi or 2
    return l
end
local function B(par,txt,s,p,bg,tc,ts,fo,zi)
    local b=Instance.new("TextButton",par) b.Size=s b.Position=p
    b.BackgroundColor3=bg or Color3.fromRGB(70,40,160)
    b.Text=txt b.TextColor3=tc or Color3.fromRGB(255,255,255)
    b.TextSize=ts or 12 b.Font=fo or Enum.Font.GothamBold
    b.BorderSizePixel=0 b.ZIndex=zi or 3 return b
end
local function toast(txt,col)
    local sg=Instance.new("ScreenGui") sg.ResetOnSpawn=false
    pcall(function() sg.Parent=game:GetService("CoreGui") end)
    if not sg.Parent then sg.Parent=player.PlayerGui end
    local f=F(sg,UDim2.new(0,260,0,36),UDim2.new(0.5,-130,0,10),col or Color3.fromRGB(30,80,180),50,9)
    L(f,txt,UDim2.new(1,-8,1,0),UDim2.new(0,4,0,0),11,Enum.Font.GothamBold,Color3.fromRGB(255,255,255),Enum.TextXAlignment.Center,51)
    game:GetService("Debris"):AddItem(sg,2.2)
end

-- ============================================================
-- KEY SCREEN
-- ============================================================
local kf = F(gui,UDim2.new(0,310,0,185),UDim2.new(0.5,-155,0.5,-92),Color3.fromRGB(10,12,22),20,14)
local kb = F(kf,UDim2.new(1,0,0,3),UDim2.new(0,0,0,0),Color3.fromRGB(110,55,230),21,3)
L(kf,"GreatHub",UDim2.new(1,0,0,32),UDim2.new(0,0,0,8),17,Enum.Font.GothamBlack,Color3.fromRGB(180,140,255),Enum.TextXAlignment.Center,21)
L(kf,"Kick a Lucky Block",UDim2.new(1,0,0,18),UDim2.new(0,0,0,38),10,Enum.Font.Gotham,Color3.fromRGB(90,80,140),Enum.TextXAlignment.Center,21)
L(kf,"Masukkan key:",UDim2.new(1,-30,0,16),UDim2.new(0,15,0,60),10,Enum.Font.Gotham,Color3.fromRGB(80,75,120),Enum.TextXAlignment.Left,21)
local kbox=Instance.new("TextBox",kf) kbox.Size=UDim2.new(1,-30,0,34) kbox.Position=UDim2.new(0,15,0,78)
kbox.BackgroundColor3=Color3.fromRGB(16,18,32) kbox.TextColor3=Color3.fromRGB(210,210,255)
kbox.PlaceholderText="Key..." kbox.PlaceholderColor3=Color3.fromRGB(55,55,100)
kbox.Text="" kbox.TextSize=13 kbox.Font=Enum.Font.Gotham
kbox.BorderSizePixel=0 kbox.ClearTextOnFocus=false kbox.ZIndex=21
C(kbox,8)
local kbtn=B(kf,"Verifikasi",UDim2.new(1,-30,0,32),UDim2.new(0,15,0,122),Color3.fromRGB(85,45,195),Color3.fromRGB(255,255,255),12,Enum.Font.GothamBold,21)
C(kbtn,8)
local kerr=L(kf,"",UDim2.new(1,-30,0,14),UDim2.new(0,15,0,158),9,Enum.Font.Gotham,Color3.fromRGB(255,70,70),Enum.TextXAlignment.Left,21)

-- ============================================================
-- MAIN PANEL
-- ============================================================
local mf=F(gui,UDim2.new(0,270,0,355),UDim2.new(0,14,0.5,-177),Color3.fromRGB(10,12,22),10,14)
mf.Visible=false
-- Drag
local dg,ds,dp=false,nil,nil
mf.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dg=true ds=i.Position dp=mf.Position
    end
end)
mf.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=false end
end)
UIS.InputChanged:Connect(function(i)
    if not dg then return end
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
        local d=i.Position-ds
        mf.Position=UDim2.new(dp.X.Scale,dp.X.Offset+d.X,dp.Y.Scale,dp.Y.Offset+d.Y)
    end
end)

F(mf,UDim2.new(1,0,0,3),UDim2.new(0,0,0,0),Color3.fromRGB(110,55,230),11,3)
L(mf,"GreatHub",UDim2.new(1,-60,0,26),UDim2.new(0,10,0,6),14,Enum.Font.GothamBlack,Color3.fromRGB(180,140,255),Enum.TextXAlignment.Left,11)
L(mf,"Kick a Lucky Block",UDim2.new(1,-60,0,16),UDim2.new(0,10,0,30),9,Enum.Font.Gotham,Color3.fromRGB(80,70,130),Enum.TextXAlignment.Left,11)

local minBtn=B(mf,"-",UDim2.new(0,26,0,26),UDim2.new(1,-32,0,9),Color3.fromRGB(18,20,38),Color3.fromRGB(160,150,200),16,Enum.Font.GothamBold,12)
C(minBtn,6)
local mini=false
minBtn.MouseButton1Click:Connect(function()
    mini=not mini minBtn.Text=mini and "+" or "-"
    TS:Create(mf,TweenInfo.new(0.18),{Size=mini and UDim2.new(0,270,0,48) or UDim2.new(0,270,0,355)}):Play()
end)

F(mf,UDim2.new(1,-20,0,1),UDim2.new(0,10,0,48),Color3.fromRGB(20,22,40),11)

-- STATUS BOX
local statBox=F(mf,UDim2.new(1,-20,0,52),UDim2.new(0,10,0,56),Color3.fromRGB(14,16,30),11,8)
L(statBox,"Status Saya",UDim2.new(1,-10,0,15),UDim2.new(0,6,0,3),9,Enum.Font.GothamBold,Color3.fromRGB(90,80,140),Enum.TextXAlignment.Left,12)
local myNameL=L(statBox,player.DisplayName,UDim2.new(0.65,0,0,18),UDim2.new(0,6,0,20),11,Enum.Font.GothamSemibold,Color3.fromRGB(200,195,230),Enum.TextXAlignment.Left,12)
local statusDot=F(statBox,UDim2.new(0,7,0,7),UDim2.new(1,-30,0.5,-3),Color3.fromRGB(70,70,110),12,4)
local statusL=L(statBox,"Idle",UDim2.new(0,46,0,16),UDim2.new(1,-50,0.5,-8),9,Enum.Font.GothamBold,Color3.fromRGB(100,95,150),Enum.TextXAlignment.Right,12)

local function setStat(txt,col)
    statusL.Text=txt statusL.TextColor3=col statusDot.BackgroundColor3=col
end

-- TOGGLE
local togBox=F(mf,UDim2.new(1,-20,0,50),UDim2.new(0,10,0,116),Color3.fromRGB(14,16,30),11,8)
L(togBox,"Auto Lucky Block",UDim2.new(0.7,0,0,20),UDim2.new(0,8,0.5,-22),12,Enum.Font.GothamBold,Color3.fromRGB(190,185,230),Enum.TextXAlignment.Left,12)
L(togBox,"Gerak natural + perfect kick",UDim2.new(0.7,0,0,14),UDim2.new(0,8,0.5,-4),9,Enum.Font.Gotham,Color3.fromRGB(70,65,110),Enum.TextXAlignment.Left,12)
local tbg=F(togBox,UDim2.new(0,46,0,22),UDim2.new(1,-54,0.5,-11),Color3.fromRGB(25,28,50),12,11)
local tdot=F(tbg,UDim2.new(0,16,0,16),UDim2.new(0,3,0.5,-8),Color3.fromRGB(70,70,110),13,8)
local thit=B(togBox,"",UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),Color3.fromRGB(0,0,0),Color3.fromRGB(255,255,255),1,Enum.Font.Gotham,14)
thit.BackgroundTransparency=1

local function setTog(v)
    autoOn=v
    TS:Create(tbg,TweenInfo.new(0.18),{BackgroundColor3=v and Color3.fromRGB(85,45,195) or Color3.fromRGB(25,28,50)}):Play()
    TS:Create(tdot,TweenInfo.new(0.18),{
        Position=v and UDim2.new(0,27,0.5,-8) or UDim2.new(0,3,0.5,-8),
        BackgroundColor3=v and Color3.fromRGB(220,205,255) or Color3.fromRGB(70,70,110)
    }):Play()
    if not v then
        setStat("Idle",Color3.fromRGB(80,80,120))
        pcall(function()
            local c=player.Character
            if c then
                local h=c:FindFirstChildOfClass("Humanoid")
                if h then h.WalkSpeed=16 end
            end
        end)
    end
end

thit.MouseButton1Click:Connect(function()
    setTog(not autoOn)
    toast(autoOn and "Auto ON" or "Auto OFF", autoOn and Color3.fromRGB(70,40,160) or Color3.fromRGB(50,50,80))
end)

-- SPEED SLIDER
local spBox=F(mf,UDim2.new(1,-20,0,46),UDim2.new(0,10,0,174),Color3.fromRGB(14,16,30),11,8)
local spd=40
local spL=L(spBox,"Kecepatan: 40",UDim2.new(1,-10,0,16),UDim2.new(0,6,0,4),10,Enum.Font.GothamBold,Color3.fromRGB(120,110,170),Enum.TextXAlignment.Left,12)
local slBg=F(spBox,UDim2.new(1,-16,0,5),UDim2.new(0,8,0,28),Color3.fromRGB(20,22,42),12,4)
local slFill=F(slBg,UDim2.new(0.5,0,1,0),UDim2.new(0,0,0,0),Color3.fromRGB(85,45,195),13,4)
local slKn=F(slBg,UDim2.new(0,12,0,12),UDim2.new(0.5,0,0.5,0),Color3.fromRGB(200,185,255),14,6)
slKn.AnchorPoint=Vector2.new(0.5,0.5)
local slDrag=false
slKn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then slDrag=true end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then slDrag=false end end)
UIS.InputChanged:Connect(function(i)
    if not slDrag then return end
    if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseMovement then
        local rel=math.clamp((i.Position.X-slBg.AbsolutePosition.X)/slBg.AbsoluteSize.X,0,1)
        spd=math.floor(22+rel*58) spL.Text="Kecepatan: "..spd
        slFill.Size=UDim2.new(rel,0,1,0) slKn.Position=UDim2.new(rel,0,0.5,0)
    end
end)

-- PLAYER LIST
local plBox=F(mf,UDim2.new(1,-20,0,90),UDim2.new(0,10,0,228),Color3.fromRGB(14,16,30),11,8)
L(plBox,"Player di Server",UDim2.new(1,-10,0,15),UDim2.new(0,6,0,3),9,Enum.Font.GothamBold,Color3.fromRGB(90,80,140),Enum.TextXAlignment.Left,12)
local plScroll=Instance.new("ScrollingFrame",plBox)
plScroll.Size=UDim2.new(1,-8,1,-20) plScroll.Position=UDim2.new(0,4,0,18)
plScroll.BackgroundTransparency=1 plScroll.BorderSizePixel=0
plScroll.ScrollBarThickness=2 plScroll.ZIndex=12
local plLayout=Instance.new("UIListLayout",plScroll)
plLayout.Padding=UDim.new(0,3) plLayout.SortOrder=Enum.SortOrder.LayoutOrder

local function refreshPlayers()
    for _,c in ipairs(plScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    local all=Players:GetPlayers()
    for _,p in ipairs(all) do
        local row=F(plScroll,UDim2.new(1,0,0,18),UDim2.new(0,0,0,0),Color3.fromRGB(18,20,36),13,5)
        local dot=F(row,UDim2.new(0,5,0,5),UDim2.new(0,5,0.5,-2),p==player and Color3.fromRGB(110,60,220) or Color3.fromRGB(60,180,100),14,3)
        L(row,p.DisplayName..(p==player and " (Kamu)" or ""),UDim2.new(1,-16,1,0),UDim2.new(0,14,0,0),9,Enum.Font.Gotham,p==player and Color3.fromRGB(170,140,230) or Color3.fromRGB(150,145,185),Enum.TextXAlignment.Left,14)
    end
    plScroll.CanvasSize=UDim2.new(0,0,0,#all*21)
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(function() task.wait(0.3) refreshPlayers() end)

-- CREDIT
L(mf,"GreatHub v1.0 | Key: TEST123",UDim2.new(1,0,0,14),UDim2.new(0,0,0,338),8,Enum.Font.Gotham,Color3.fromRGB(45,40,80),Enum.TextXAlignment.Center,11)

-- ============================================================
-- FIND LUCKY BLOCK
-- ============================================================
local function getPos(obj)
    if obj:IsA("Model") then
        local ok,cf=pcall(function() return obj:GetModelCFrame() end)
        return ok and cf.Position or nil
    end
    return obj.Position
end

local function findBlock()
    local best,bestDist=nil,math.huge
    local hrp=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    for _,obj in ipairs(workspace:GetDescendants()) do
        local ok=false
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local n=obj.Name:lower()
            ok=n:find("block") or n:find("lucky") or n:find("kick") or n:find("lb")
        end
        if ok then
            local pos=getPos(obj)
            if pos and pos.Y>-10 and pos.Y<50 then
                local d=(hrp.Position-pos).Magnitude
                if d<bestDist then bestDist=d best={obj=obj,pos=pos} end
            end
        end
    end
    -- Fallback: cari part yang ada ClickDetector atau ProximityPrompt
    if not best then
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                local part=obj.Parent
                if part and part:IsA("BasePart") then
                    local pos=part.Position
                    if pos.Y>-10 and pos.Y<50 then
                        local d=(hrp.Position-pos).Magnitude
                        if d<bestDist then bestDist=d best={obj=part,pos=pos} end
                    end
                end
            end
        end
    end
    return best
end

-- ============================================================
-- TRIGGER KICK - semua cara
-- ============================================================
local function doKick(targetPos)
    -- 1. ClickDetector
    for _,v in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("ClickDetector") then
                local ok,_ = pcall(fireClickDetector, v, 0)
                if not ok then
                    local p = v.Parent
                    if p and p:IsA("BasePart") then
                        local d=(p.Position-(targetPos or Vector3.zero)).Magnitude
                        if d<15 then fireClickDetector(v) end
                    end
                end
            end
        end)
    end
    -- 2. ProximityPrompt
    for _,v in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
            end
        end)
    end
    -- 3. RemoteEvent semua (broad)
    for _,v in ipairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("RemoteEvent") then
                local n=v.Name:lower()
                if n:find("kick") or n:find("tap") or n:find("hit") or n:find("touch") or n:find("action") or n:find("interact") then
                    v:FireServer()
                end
            end
        end)
    end
    -- 4. VirtualUser tap di tengah layar
    pcall(function()
        local cam=workspace.CurrentCamera
        if targetPos and cam then
            local sp,vis=cam:WorldToScreenPoint(targetPos)
            if vis then
                VR:Button1Down(Vector2.new(sp.X,sp.Y),CFrame.new())
                task.wait(0.05)
                VR:Button1Up(Vector2.new(sp.X,sp.Y),CFrame.new())
            end
        end
    end)
end

-- ============================================================
-- NATURAL MOVEMENT ENGINE
-- ============================================================
local function humanWalk(targetPos, onArrived)
    local char=player.Character
    if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    -- Set speed
    hum.WalkSpeed = spd

    -- Generate path: beberapa waypoint muter sebelum ke target
    local numWP = math.random(3,6)
    local waypoints = {}

    -- Waypoint muter mengelilingi target
    for i=1,numWP do
        local angle = (i/numWP)*math.pi*2 + math.random()*0.8
        local radius = math.random(10,22)
        waypoints[i] = targetPos + Vector3.new(
            math.cos(angle)*radius,
            0,
            math.sin(angle)*radius
        )
    end
    -- Terakhir ke target
    waypoints[numWP+1] = targetPos

    for i,wp in ipairs(waypoints) do
        if not autoOn then break end
        hum:MoveTo(wp)

        local t=0
        local arrived=false
        repeat
            task.wait(0.07)
            t=t+0.07
            -- Lompat random (lebih sering di awal)
            if math.random(1,7)==1 then hum.Jump=true end
            -- Variasi speed
            if math.random(1,10)==1 then
                hum.WalkSpeed=math.random(spd-10,spd+8)
            end
            arrived=(hrp.Position-wp).Magnitude<5
        until arrived or t>5 or not autoOn

        -- Jeda natural antar waypoint
        if i < numWP+1 then
            task.wait(math.random(1,4)*0.08)
        end
    end

    hum.WalkSpeed=16
    if autoOn and onArrived then onArrived() end
end

-- ============================================================
-- MAIN LOOP
-- ============================================================
local function mainRun()
    if busy or not autoOn then return end
    busy=true

    local char=player.Character
    if not char then busy=false return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hum then busy=false return end

    setStat("Mencari...",Color3.fromRGB(255,185,40))

    local data=findBlock()
    if not data then
        setStat("Tidak ada block",Color3.fromRGB(255,60,60))
        toast("Lucky Block tidak ketemu!",Color3.fromRGB(160,40,40))
        task.wait(4)
        busy=false return
    end

    setStat("Jalan ke block...",Color3.fromRGB(80,140,255))

    humanWalk(data.pos, function()
        if not autoOn then busy=false return end

        -- Delay natural sebelum kick
        task.wait(math.random(2,5)*0.1)

        setStat("KICK!",Color3.fromRGB(160,60,220))
        toast("Kick!",Color3.fromRGB(90,45,200))

        -- Spam kick buat penuh bar
        -- Timing: tap cepat di awal, lalu lebih cepat lagi
        for i=1,60 do
            if not autoOn then break end
            doKick(data.pos)
            -- Variasi interval biar natural
            local interval = i < 10 and 0.08 or (i < 30 and 0.05 or 0.03)
            task.wait(interval)
        end

        setStat("Cooldown...",Color3.fromRGB(60,200,100))

        -- Cooldown random
        local cd=math.random(5,12)
        for i=cd,1,-1 do
            if not autoOn then break end
            setStat("Cooldown "..i.."s",Color3.fromRGB(60,200,100))
            task.wait(1)
        end
    end)

    busy=false
end

-- Heartbeat loop
RS.Heartbeat:Connect(function()
    if keyOk and autoOn and not busy then
        task.spawn(mainRun)
    end
end)

-- Refresh players tiap 5s
task.spawn(function()
    while true do
        task.wait(5)
        if mf.Visible then refreshPlayers() end
    end
end)

-- ============================================================
-- KEY VERIFY
-- ============================================================
local function checkKey()
    if kbox.Text==VALID_KEY then
        keyOk=true
        TS:Create(kf,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
        for _,v in ipairs(kf:GetDescendants()) do
            pcall(function()
                if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                    TS:Create(v,TweenInfo.new(0.18),{TextTransparency=1,BackgroundTransparency=1}):Play()
                elseif v:IsA("Frame") then
                    TS:Create(v,TweenInfo.new(0.18),{BackgroundTransparency=1}):Play()
                end
            end)
        end
        task.wait(0.25)
        kf.Visible=false
        mf.Visible=true
        refreshPlayers()
        toast("Key valid! Selamat datang.",Color3.fromRGB(80,40,200))
    else
        kerr.Text="Key salah!"
        kbox.Text=""
        local orig=kf.Position
        for i=1,4 do
            TS:Create(kf,TweenInfo.new(0.04),{Position=UDim2.new(0.5,i%2==0 and -165 or -145,0.5,-92)}):Play()
            task.wait(0.05)
        end
        TS:Create(kf,TweenInfo.new(0.06),{Position=orig}):Play()
        task.wait(1.5) kerr.Text=""
    end
end

kbtn.MouseButton1Click:Connect(checkKey)
kbox.FocusLost:Connect(function(e) if e then checkKey() end end)
