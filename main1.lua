local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("✦ Sleepef","Crimson")
local tab = Main:CreateTab("Combat")
local tab2 = Main:CreateTab("Visuals")
local tab3 = Main:CreateTab("Movement")
local tab4 = Main:CreateTab("UI")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer\

-- <<< Paste the CORRECT DIRECT RAW URL here >>>
local targetScriptURL = "https://raw.githubusercontent.com/xas14820-arch/main1.lua/main/main1.lua" -- Example of what the URL should look like

local success, response = pcall(function()
    return httpService:GetAsync(targetScriptURL)
end)

if success then
    local scriptContent = response
    local successLoad, loadedFunction = pcall(loadstring(scriptContent))
    
    if successLoad then
        loadedFunction() -- Execute the downloaded script
        print("Successfully loaded and executed script from: " .. targetScriptURL)
    else
        warn("Failed to loadstring the script. Error: " .. tostring(loadedFunction))
    end
else
    warn("Failed to download script from URL: " .. targetScriptURL .. ". Error: " .. tostring(response))
end

-- ESP Config
local espEnabled = false
local espObjects = {}
local espConfig = {
    color = Color3.fromRGB(214, 40, 57),
    textSize = 14,
    studOffset = 3,
    showName = true,
    showHealth = true,
    showDistance = true,
    showTracers = false,
    showTool = false,
    teamColor = false,
}

-- Aimlock Config
local aimlockEnabled = false
local aimlockTarget = nil
local aimlockKey = Enum.KeyCode.Q
local aimlockConnection
local aimlockConfig = {
    fov = 150,
    smoothness = 0,
    targetPart = "HumanoidRootPart",
    prediction = 0,
    autoRetarget = false,
}

-- Movement
local noclipEnabled = false
local flyEnabled = false
local infiniteJumpEnabled = false
local speedEnabled = false
local speedValue = 16
local flySpeed = 50
local noclipConnection = nil
local flyConnection = nil
local flyBody = nil

-- UI state
local watermarkEnabled = false
local watermarkGui = nil
local watermarkConnection = nil
local crosshairEnabled = false
local crosshairLines = {}
local notifsEnabled = true
local fovCircle = nil
local fovCircleEnabled = false
local clockEnabled = false
local clockGui = nil
local clockConnection = nil

-- Accent color (matches Crimson theme3)
local ACCENT = Color3.fromRGB(214, 40, 57)
local BG     = Color3.fromRGB(14, 14, 15)
local BG2    = Color3.fromRGB(22, 22, 24)

local function addCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
end

local function addStroke(p, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or ACCENT
    s.Thickness = t or 1
    s.Transparency = tr or 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
end

local function makePill(parent, w, h, x, y)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, w, 0, h)
    f.Position = UDim2.new(0, x, 0, y)
    f.BackgroundColor3 = BG
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.Parent = parent
    addCorner(f, 10)
    addStroke(f, ACCENT, 1, 0.4)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, -10)
    bar.Position = UDim2.new(0, 5, 0, 5)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    bar.ZIndex = 3
    bar.Parent = f
    addCorner(bar, 3)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -22, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Name = "Label"
    lbl.Parent = f
    return f, lbl
end

-- Notifications
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "SleepefNotifs"
notifGui.ResetOnSpawn = false
notifGui.Parent = LocalPlayer.PlayerGui

local notifList = Instance.new("Frame")
notifList.Size = UDim2.new(0, 240, 1, -20)
notifList.Position = UDim2.new(1, -252, 0, 0)
notifList.BackgroundTransparency = 1
notifList.Parent = notifGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 6)
notifLayout.Parent = notifList

local function notify(text)
    if not notifsEnabled then return end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 42)
    frame.BackgroundColor3 = BG
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Parent = notifList
    addCorner(frame, 10)
    addStroke(frame, ACCENT, 1, 0.35)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, -10)
    bar.Position = UDim2.new(0, 5, 0, 5)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    bar.ZIndex = 3
    bar.Parent = frame
    addCorner(bar, 3)

    local dot = Instance.new("TextLabel")
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = UDim2.new(0, 14, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
    dot.BorderSizePixel = 0
    dot.Text = "!"
    dot.TextColor3 = ACCENT
    dot.Font = Enum.Font.GothamBlack
    dot.TextSize = 11
    dot.ZIndex = 3
    dot.Parent = frame
    addCorner(dot, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -42, 1, 0)
    lbl.Position = UDim2.new(0, 38, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(225, 225, 225)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = frame

    task.delay(2.6, function()
        for i = 1, 12 do
            if not frame or not frame.Parent then break end
            local a = i / 12
            frame.BackgroundTransparency = a
            lbl.TextTransparency = a
            dot.TextTransparency = a
            dot.BackgroundTransparency = a
            bar.BackgroundTransparency = a
            task.wait(0.04)
        end
        if frame and frame.Parent then frame:Destroy() end
    end)
end

-- Watermark
local function createWatermark()
    if watermarkGui then watermarkGui:Destroy() end
    watermarkGui = Instance.new("ScreenGui")
    watermarkGui.Name = "SleepefWatermark"
    watermarkGui.ResetOnSpawn = false
    watermarkGui.Parent = LocalPlayer.PlayerGui

    local f, lbl = makePill(watermarkGui, 205, 34, 10, 10)
    lbl.Text = "✦ Sleepef  |  -- FPS"

    if watermarkConnection then watermarkConnection:Disconnect() end
    local lastTime = tick()
    local frameCount = 0
    watermarkConnection = RunService.Heartbeat:Connect(function()
        if not watermarkEnabled then return end
        frameCount += 1
        local now = tick()
        if now - lastTime >= 0.5 then
            local fps = math.floor(frameCount / (now - lastTime))
            lbl.Text = "✦ Sleepef  |  " .. fps .. " FPS"
            frameCount = 0
            lastTime = now
        end
    end)
end

local function removeWatermark()
    if watermarkConnection then watermarkConnection:Disconnect() watermarkConnection = nil end
    if watermarkGui then watermarkGui:Destroy() watermarkGui = nil end
end

-- Clock
local function createClock()
    if clockGui then clockGui:Destroy() end
    clockGui = Instance.new("ScreenGui")
    clockGui.Name = "SleepefClock"
    clockGui.ResetOnSpawn = false
    clockGui.Parent = LocalPlayer.PlayerGui

    local f, lbl = makePill(clockGui, 118, 34, 10, 50)

    if clockConnection then clockConnection:Disconnect() end
    clockConnection = RunService.Heartbeat:Connect(function()
        if not clockEnabled then return end
        local t = os.date("*t")
        local hour = t.hour % 12
        if hour == 0 then hour = 12 end
        local ampm = t.hour >= 12 and "PM" or "AM"
        lbl.Text = string.format("⏱ %d:%02d %s", hour, t.min, ampm)
    end)
end

local function removeClock()
    if clockConnection then clockConnection:Disconnect() clockConnection = nil end
    if clockGui then clockGui:Destroy() clockGui = nil end
end

-- Crosshair
local function createCrosshair()
    for _, l in pairs(crosshairLines) do pcall(function() l:Remove() end) end
    crosshairLines = {}

    local cam = workspace.CurrentCamera
    local cx = cam.ViewportSize.X / 2
    local cy = cam.ViewportSize.Y / 2
    local sz = 9
    local th = 1.5
    local gap = 5

    local function shadow(x1,y1,x2,y2)
        local l = Drawing.new("Line")
        l.From = Vector2.new(x1,y1)
        l.To = Vector2.new(x2,y2)
        l.Color = Color3.fromRGB(0,0,0)
        l.Thickness = th + 2
        l.Transparency = 0.55
        l.Visible = true
        return l
    end

    local function line(x1,y1,x2,y2)
        local l = Drawing.new("Line")
        l.From = Vector2.new(x1,y1)
        l.To = Vector2.new(x2,y2)
        l.Color = Color3.fromRGB(255,255,255)
        l.Thickness = th
        l.Transparency = 1
        l.Visible = true
        return l
    end

    crosshairLines = {
        shadow(cx-sz-gap, cy, cx-gap, cy),
        shadow(cx+gap, cy, cx+sz+gap, cy),
        shadow(cx, cy-sz-gap, cx, cy-gap),
        shadow(cx, cy+gap, cx, cy+sz+gap),
        line(cx-sz-gap, cy, cx-gap, cy),
        line(cx+gap, cy, cx+sz+gap, cy),
        line(cx, cy-sz-gap, cx, cy-gap),
        line(cx, cy+gap, cx, cy+sz+gap),
    }
end

local function removeCrosshair()
    for _, l in pairs(crosshairLines) do pcall(function() l:Remove() end) end
    crosshairLines = {}
end

-- FOV Circle
local function createFOVCircle()
    if fovCircle then fovCircle:Remove() end
    fovCircle = Drawing.new("Circle")
    fovCircle.Radius = aimlockConfig.fov
    fovCircle.Color = Color3.fromRGB(214, 40, 57)
    fovCircle.Thickness = 1
    fovCircle.Transparency = 0.5
    fovCircle.Filled = false
    fovCircle.Visible = true

    RunService.Heartbeat:Connect(function()
        if not fovCircleEnabled or not fovCircle then return end
        local cam = workspace.CurrentCamera
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = aimlockConfig.fov
    end)
end

local function removeFOVCircle()
    if fovCircle then fovCircle:Remove() fovCircle = nil end
end

-- Kill Notifications
Players.PlayerRemoving:Connect(function(player)
    notify(player.Name .. " left")
end)

local function watchDeaths(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                if player ~= LocalPlayer then
                    notify("☠  " .. player.Name .. " died")
                end
            end)
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do watchDeaths(p) end
Players.PlayerAdded:Connect(function(p) watchDeaths(p) end)

-- ESP
local function updateAllESP()
    for player, obj in pairs(espObjects) do
        if obj.label then
            local col = espConfig.teamColor and player.TeamColor.Color or espConfig.color
            obj.label.TextColor3 = col
            obj.label.TextSize = espConfig.textSize
            obj.label.Visible = espConfig.showName
        end
        if obj.healthLabel then
            obj.healthLabel.TextSize = espConfig.textSize
            obj.healthLabel.Visible = espConfig.showHealth
        end
        if obj.distLabel then
            obj.distLabel.TextSize = espConfig.textSize
            obj.distLabel.Visible = espConfig.showDistance
        end
        if obj.toolLabel then
            obj.toolLabel.TextSize = espConfig.textSize
            obj.toolLabel.Visible = espConfig.showTool
        end
        if obj.billboard then
            obj.billboard.StudsOffset = Vector3.new(0, espConfig.studOffset, 0)
        end
    end
end

local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].billboard and espObjects[player].billboard:IsDescendantOf(game) then
            espObjects[player].billboard:Destroy()
        end
        espObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
        or character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    removeESP(player)

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 160, 0, 130)
    billboard.StudsOffset = Vector3.new(0, espConfig.studOffset, 0)
    billboard.Adornee = rootPart
    billboard.Parent = rootPart

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 6)
    layout.Parent = billboard

    local function makeLabel(order, color)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, 22)
        l.TextColor3 = color
        l.TextStrokeTransparency = 0.3
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.Font = Enum.Font.GothamMedium
        l.TextSize = espConfig.textSize
        l.TextScaled = false
        l.TextTruncate = Enum.TextTruncate.None
        l.LayoutOrder = order
        l.Parent = billboard
        return l
    end

    local nameLabel = makeLabel(1, espConfig.color)
    nameLabel.Font = Enum.Font.GothamBlack
    nameLabel.Text = player.Name
    nameLabel.Visible = espConfig.showName

    local healthLabel = makeLabel(2, Color3.fromRGB(80, 255, 120))
    healthLabel.Text = "HP: ?"
    healthLabel.Visible = espConfig.showHealth

    local distLabel = makeLabel(3, Color3.fromRGB(180, 180, 255))
    distLabel.Text = "? studs"
    distLabel.Visible = espConfig.showDistance

    local toolLabel = makeLabel(4, Color3.fromRGB(255, 210, 60))
    toolLabel.Text = ""
    toolLabel.Visible = espConfig.showTool

    espObjects[player] = {
        billboard = billboard,
        label = nameLabel,
        healthLabel = healthLabel,
        distLabel = distLabel,
        toolLabel = toolLabel,
        rootPart = rootPart,
    }

    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.Died:Connect(function()
            removeESP(player)
            if aimlockTarget == player then aimlockTarget = nil end
            local newChar = player.CharacterAdded:Wait()
            newChar:WaitForChild("HumanoidRootPart", 5)
            task.wait(0.2)
            if espEnabled then createESP(player) end
        end)
    end
end

-- Tracers
local tracerLines = {}

local function removeTracer(player)
    if tracerLines[player] then
        tracerLines[player]:Remove()
        tracerLines[player] = nil
    end
end

local function removeAllTracers()
    for player in pairs(tracerLines) do removeTracer(player) end
end

local function enableESP()
    for _, p in pairs(Players:GetPlayers()) do
        task.spawn(function() createESP(p) end)
    end
end

local function disableESP()
    for p in pairs(espObjects) do removeESP(p) end
    removeAllTracers()
end

-- Closest player
local function getClosestPlayer()
    local closest, shortestDist = nil, math.huge
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local part = char:FindFirstChild(aimlockConfig.targetPart) or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not part or not hum or hum.Health <= 0 then continue end

        local sp, onScreen = cam:WorldToViewportPoint(part.Position)
        if onScreen then
            local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
            if dist < shortestDist and dist <= aimlockConfig.fov then
                shortestDist = dist
                closest = player
            end
        end
    end
    return closest
end

-- Aimlock
local function startAimlock()
    if aimlockConnection then aimlockConnection:Disconnect() end
    aimlockConnection = RunService.Heartbeat:Connect(function()
        if not aimlockEnabled then return end

        if aimlockTarget then
            local char = aimlockTarget.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if not char or not hum or hum.Health <= 0 then
                aimlockTarget = aimlockConfig.autoRetarget and getClosestPlayer() or nil
            end
        end

        if not aimlockTarget then return end

        local char = aimlockTarget.Character
        if not char then aimlockTarget = nil return end

        local part = char:FindFirstChild(aimlockConfig.targetPart) or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not part or not hum or hum.Health <= 0 then aimlockTarget = nil return end

        local vel = part.AssemblyLinearVelocity or Vector3.new()
        local predicted = part.Position + (vel * aimlockConfig.prediction * 0.05)
        local yOff = aimlockConfig.targetPart == "Head" and 0 or 0.5

        local targetCF = CFrame.lookAt(
            workspace.CurrentCamera.CFrame.Position,
            predicted + Vector3.new(0, yOff, 0)
        )

        if aimlockConfig.smoothness > 0 then
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(targetCF, 1 / (aimlockConfig.smoothness + 1))
        else
            workspace.CurrentCamera.CFrame = targetCF
        end
    end)
end

local function stopAimlock()
    if aimlockConnection then aimlockConnection:Disconnect() aimlockConnection = nil end
    aimlockTarget = nil
end

-- Noclip
local function startNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end

-- Speed
local function setSpeed(val)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = val end
end

-- Fly
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = true end

    flyBody = Instance.new("BodyVelocity")
    flyBody.Velocity = Vector3.new(0,0,0)
    flyBody.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBody.Parent = hrp

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        local cf = workspace.CurrentCamera.CFrame
        local vel = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += cf.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= cf.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= cf.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += cf.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel -= Vector3.new(0, flySpeed, 0) end
        flyBody.Velocity = vel
    end)
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBody then flyBody:Destroy() flyBody = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if not infiniteJumpEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Heartbeat
RunService.Heartbeat:Connect(function()
    local cam = workspace.CurrentCamera
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local screenBottom = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)

    for player, obj in pairs(espObjects) do
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hum and obj.healthLabel then
            local hp = math.floor(hum.Health)
            local maxHp = math.floor(hum.MaxHealth)
            local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            obj.healthLabel.TextColor3 = Color3.fromRGB(
                math.floor(255 * (1 - ratio)),
                math.floor(220 * ratio),
                50
            )
            obj.healthLabel.Text = "HP  " .. hp .. " / " .. maxHp
        end

        if hrp and localHRP and obj.distLabel then
            obj.distLabel.Text = math.floor((hrp.Position - localHRP.Position).Magnitude) .. " studs"
        end

        if obj.toolLabel and espConfig.showTool then
            local tool = char:FindFirstChildOfClass("Tool")
            obj.toolLabel.Text = tool and ("⚔ " .. tool.Name) or ""
        end

        if obj.label and espConfig.teamColor then
            pcall(function() obj.label.TextColor3 = player.TeamColor.Color end)
        end
    end

    if espEnabled and espConfig.showTracers then
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then removeTracer(player) continue end

            local sp, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if not onScreen then removeTracer(player) continue end

            if not tracerLines[player] then
                local l = Drawing.new("Line")
                l.Thickness = 1
                l.Color = espConfig.color
                l.Transparency = 0.6
                l.Visible = true
                tracerLines[player] = l
            end

            tracerLines[player].From = screenBottom
            tracerLines[player].To = Vector2.new(sp.X, sp.Y)
            tracerLines[player].Color = espConfig.color
        end
    else
        removeAllTracers()
    end

    if speedEnabled then setSpeed(speedValue) end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.2)
        if espEnabled then task.spawn(function() createESP(player) end) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    removeTracer(player)
    if aimlockTarget == player then aimlockTarget = nil end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then setSpeed(speedValue) end
    if noclipEnabled then startNoclip() end
    if flyEnabled then startFly() end
end)

-- Combat Tab
tab:CreateToggle("Aimlock", function(a)
    aimlockEnabled = a
    if aimlockEnabled then startAimlock() notify("Aimlock enabled")
    else stopAimlock() notify("Aimlock disabled") end
end)

tab:CreateDropdown("Aimlock Key", {"Q","E","R","F","T","Z","X","C"}, function(a)
    local keys = {Q=Enum.KeyCode.Q,E=Enum.KeyCode.E,R=Enum.KeyCode.R,F=Enum.KeyCode.F,T=Enum.KeyCode.T,Z=Enum.KeyCode.Z,X=Enum.KeyCode.X,C=Enum.KeyCode.C}
    aimlockKey = keys[a] or Enum.KeyCode.Q
    notify("Aimlock key: " .. a)
end)

tab:CreateDropdown("Target Part", {"HumanoidRootPart","Head"}, function(a)
    aimlockConfig.targetPart = a
    notify("Target: " .. a)
end)

tab:CreateToggle("Auto Retarget", function(a)
    aimlockConfig.autoRetarget = a
    notify("Auto Retarget " .. (a and "on" or "off"))
end)

tab:CreateSlider("FOV", 50, 500, function(a)
    aimlockConfig.fov = a
end)

tab:CreateSlider("Smoothness", 0, 10, function(a)
    aimlockConfig.smoothness = a
end)

tab:CreateSlider("Prediction", 0, 10, function(a)
    aimlockConfig.prediction = a
end)

-- Visuals Tab
tab2:CreateToggle("ESP", function(a)
    espEnabled = a
    if espEnabled then enableESP() notify("ESP enabled")
    else disableESP() notify("ESP disabled") end
end)

tab2:CreateCheckbox("Names", function(a)
    espConfig.showName = a
    updateAllESP()
end)

tab2:CreateCheckbox("Health", function(a)
    espConfig.showHealth = a
    updateAllESP()
end)

tab2:CreateCheckbox("Distance", function(a)
    espConfig.showDistance = a
    updateAllESP()
end)

tab2:CreateCheckbox("Tracers", function(a)
    espConfig.showTracers = a
    if not a then removeAllTracers() end
    notify("Tracers " .. (a and "on" or "off"))
end)

tab2:CreateCheckbox("Tool ESP", function(a)
    espConfig.showTool = a
    updateAllESP()
end)

tab2:CreateCheckbox("Team Colors", function(a)
    espConfig.teamColor = a
    updateAllESP()
    notify("Team Colors " .. (a and "on" or "off"))
end)

tab2:CreateDropdown("ESP Color", {"Red","Green","Blue","White","Yellow","Cyan"}, function(a)
    local colors = {
        Red=Color3.fromRGB(214,40,57), Green=Color3.fromRGB(60,220,100),
        Blue=Color3.fromRGB(60,120,255), White=Color3.fromRGB(240,240,240),
        Yellow=Color3.fromRGB(255,220,50), Cyan=Color3.fromRGB(50,220,255),
    }
    espConfig.color = colors[a] or Color3.fromRGB(214,40,57)
    updateAllESP()
    notify("Color: " .. a)
end)

tab2:CreateSlider("Text Size", 8, 24, function(a)
    espConfig.textSize = a
    updateAllESP()
end)

tab2:CreateSlider("Height", 1, 8, function(a)
    espConfig.studOffset = a
    updateAllESP()
end)

-- Movement Tab
tab3:CreateToggle("Noclip", function(a)
    noclipEnabled = a
    if noclipEnabled then startNoclip() notify("Noclip on")
    else stopNoclip() notify("Noclip off") end
end)

tab3:CreateToggle("Speed", function(a)
    speedEnabled = a
    if speedEnabled then setSpeed(speedValue) notify("Speed on")
    else setSpeed(16) notify("Speed off") end
end)

tab3:CreateSlider("Speed Value", 16, 150, function(a)
    speedValue = a
    if speedEnabled then setSpeed(speedValue) end
end)

tab3:CreateToggle("Fly", function(a)
    flyEnabled = a
    if flyEnabled then startFly() notify("Fly on")
    else stopFly() notify("Fly off") end
end)

tab3:CreateSlider("Fly Speed", 10, 200, function(a)
    flySpeed = a
end)

tab3:CreateToggle("Infinite Jump", function(a)
    infiniteJumpEnabled = a
    notify("Infinite Jump " .. (a and "on" or "off"))
end)

-- UI Tab
tab4:CreateToggle("Watermark", function(a)
    watermarkEnabled = a
    if watermarkEnabled then createWatermark() notify("Watermark on")
    else removeWatermark() notify("Watermark off") end
end)

tab4:CreateToggle("Clock", function(a)
    clockEnabled = a
    if clockEnabled then createClock() notify("Clock on")
    else removeClock() notify("Clock off") end
end)

tab4:CreateToggle("Crosshair", function(a)
    crosshairEnabled = a
    if crosshairEnabled then createCrosshair() notify("Crosshair on")
    else removeCrosshair() notify("Crosshair off") end
end)

tab4:CreateToggle("FOV Circle", function(a)
    fovCircleEnabled = a
    if fovCircleEnabled then createFOVCircle() notify("FOV Circle on")
    else removeFOVCircle() notify("FOV Circle off") end
end)
local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("✦ Sleepef","Crimson")
local tab = Main:CreateTab("Combat")
local tab2 = Main:CreateTab("Visuals")
local tab3 = Main:CreateTab("Movement")
local tab4 = Main:CreateTab("UI")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ESP Config
local espEnabled = false
local espObjects = {}
local espConfig = {
    color = Color3.fromRGB(214, 40, 57),
    textSize = 14,
    studOffset = 3,
    showName = true,
    showHealth = true,
    showDistance = true,
    showTracers = false,
    showTool = false,
    teamColor = false,
}

-- Aimlock Config
local aimlockEnabled = false
local aimlockTarget = nil
local aimlockKey = Enum.KeyCode.Q
local aimlockConnection
local aimlockConfig = {
    fov = 150,
    smoothness = 0,
    targetPart = "HumanoidRootPart",
    prediction = 0,
    autoRetarget = false,
}

-- Movement
local noclipEnabled = false
local flyEnabled = false
local infiniteJumpEnabled = false
local speedEnabled = false
local speedValue = 16
local flySpeed = 50
local noclipConnection = nil
local flyConnection = nil
local flyBody = nil

-- UI state
local watermarkEnabled = false
local watermarkGui = nil
local watermarkConnection = nil
local crosshairEnabled = false
local crosshairLines = {}
local notifsEnabled = true
local fovCircle = nil
local fovCircleEnabled = false
local clockEnabled = false
local clockGui = nil
local clockConnection = nil

-- Accent color (matches Crimson theme3)
local ACCENT = Color3.fromRGB(214, 40, 57)
local BG     = Color3.fromRGB(14, 14, 15)
local BG2    = Color3.fromRGB(22, 22, 24)

local function addCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
end

local function addStroke(p, col, t, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or ACCENT
    s.Thickness = t or 1
    s.Transparency = tr or 0.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
end

local function makePill(parent, w, h, x, y)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, w, 0, h)
    f.Position = UDim2.new(0, x, 0, y)
    f.BackgroundColor3 = BG
    f.BackgroundTransparency = 0
    f.BorderSizePixel = 0
    f.Parent = parent
    addCorner(f, 10)
    addStroke(f, ACCENT, 1, 0.4)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, -10)
    bar.Position = UDim2.new(0, 5, 0, 5)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    bar.ZIndex = 3
    bar.Parent = f
    addCorner(bar, 3)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -22, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Name = "Label"
    lbl.Parent = f
    return f, lbl
end

-- Notifications
local notifGui = Instance.new("ScreenGui")
notifGui.Name = "SleepefNotifs"
notifGui.ResetOnSpawn = false
notifGui.Parent = LocalPlayer.PlayerGui

local notifList = Instance.new("Frame")
notifList.Size = UDim2.new(0, 240, 1, -20)
notifList.Position = UDim2.new(1, -252, 0, 0)
notifList.BackgroundTransparency = 1
notifList.Parent = notifGui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.Padding = UDim.new(0, 6)
notifLayout.Parent = notifList

local function notify(text)
    if not notifsEnabled then return end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 42)
    frame.BackgroundColor3 = BG
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Parent = notifList
    addCorner(frame, 10)
    addStroke(frame, ACCENT, 1, 0.35)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 1, -10)
    bar.Position = UDim2.new(0, 5, 0, 5)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    bar.ZIndex = 3
    bar.Parent = frame
    addCorner(bar, 3)

    local dot = Instance.new("TextLabel")
    dot.Size = UDim2.new(0, 18, 0, 18)
    dot.Position = UDim2.new(0, 14, 0.5, -9)
    dot.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
    dot.BorderSizePixel = 0
    dot.Text = "!"
    dot.TextColor3 = ACCENT
    dot.Font = Enum.Font.GothamBlack
    dot.TextSize = 11
    dot.ZIndex = 3
    dot.Parent = frame
    addCorner(dot, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -42, 1, 0)
    lbl.Position = UDim2.new(0, 38, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(225, 225, 225)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = frame

    task.delay(2.6, function()
        for i = 1, 12 do
            if not frame or not frame.Parent then break end
            local a = i / 12
            frame.BackgroundTransparency = a
            lbl.TextTransparency = a
            dot.TextTransparency = a
            dot.BackgroundTransparency = a
            bar.BackgroundTransparency = a
            task.wait(0.04)
        end
        if frame and frame.Parent then frame:Destroy() end
    end)
end

-- Watermark
local function createWatermark()
    if watermarkGui then watermarkGui:Destroy() end
    watermarkGui = Instance.new("ScreenGui")
    watermarkGui.Name = "SleepefWatermark"
    watermarkGui.ResetOnSpawn = false
    watermarkGui.Parent = LocalPlayer.PlayerGui

    local f, lbl = makePill(watermarkGui, 205, 34, 10, 10)
    lbl.Text = "✦ Sleepef  |  -- FPS"

    if watermarkConnection then watermarkConnection:Disconnect() end
    local lastTime = tick()
    local frameCount = 0
    watermarkConnection = RunService.Heartbeat:Connect(function()
        if not watermarkEnabled then return end
        frameCount += 1
        local now = tick()
        if now - lastTime >= 0.5 then
            local fps = math.floor(frameCount / (now - lastTime))
            lbl.Text = "✦ Sleepef  |  " .. fps .. " FPS"
            frameCount = 0
            lastTime = now
        end
    end)
end

local function removeWatermark()
    if watermarkConnection then watermarkConnection:Disconnect() watermarkConnection = nil end
    if watermarkGui then watermarkGui:Destroy() watermarkGui = nil end
end

-- Clock
local function createClock()
    if clockGui then clockGui:Destroy() end
    clockGui = Instance.new("ScreenGui")
    clockGui.Name = "SleepefClock"
    clockGui.ResetOnSpawn = false
    clockGui.Parent = LocalPlayer.PlayerGui

    local f, lbl = makePill(clockGui, 118, 34, 10, 50)

    if clockConnection then clockConnection:Disconnect() end
    clockConnection = RunService.Heartbeat:Connect(function()
        if not clockEnabled then return end
        local t = os.date("*t")
        local hour = t.hour % 12
        if hour == 0 then hour = 12 end
        local ampm = t.hour >= 12 and "PM" or "AM"
        lbl.Text = string.format("⏱ %d:%02d %s", hour, t.min, ampm)
    end)
end

local function removeClock()
    if clockConnection then clockConnection:Disconnect() clockConnection = nil end
    if clockGui then clockGui:Destroy() clockGui = nil end
end

-- Crosshair
local function createCrosshair()
    for _, l in pairs(crosshairLines) do pcall(function() l:Remove() end) end
    crosshairLines = {}

    local cam = workspace.CurrentCamera
    local cx = cam.ViewportSize.X / 2
    local cy = cam.ViewportSize.Y / 2
    local sz = 9
    local th = 1.5
    local gap = 5

    local function shadow(x1,y1,x2,y2)
        local l = Drawing.new("Line")
        l.From = Vector2.new(x1,y1)
        l.To = Vector2.new(x2,y2)
        l.Color = Color3.fromRGB(0,0,0)
        l.Thickness = th + 2
        l.Transparency = 0.55
        l.Visible = true
        return l
    end

    local function line(x1,y1,x2,y2)
        local l = Drawing.new("Line")
        l.From = Vector2.new(x1,y1)
        l.To = Vector2.new(x2,y2)
        l.Color = Color3.fromRGB(255,255,255)
        l.Thickness = th
        l.Transparency = 1
        l.Visible = true
        return l
    end

    crosshairLines = {
        shadow(cx-sz-gap, cy, cx-gap, cy),
        shadow(cx+gap, cy, cx+sz+gap, cy),
        shadow(cx, cy-sz-gap, cx, cy-gap),
        shadow(cx, cy+gap, cx, cy+sz+gap),
        line(cx-sz-gap, cy, cx-gap, cy),
        line(cx+gap, cy, cx+sz+gap, cy),
        line(cx, cy-sz-gap, cx, cy-gap),
        line(cx, cy+gap, cx, cy+sz+gap),
    }
end

local function removeCrosshair()
    for _, l in pairs(crosshairLines) do pcall(function() l:Remove() end) end
    crosshairLines = {}
end

-- FOV Circle
local function createFOVCircle()
    if fovCircle then fovCircle:Remove() end
    fovCircle = Drawing.new("Circle")
    fovCircle.Radius = aimlockConfig.fov
    fovCircle.Color = Color3.fromRGB(214, 40, 57)
    fovCircle.Thickness = 1
    fovCircle.Transparency = 0.5
    fovCircle.Filled = false
    fovCircle.Visible = true

    RunService.Heartbeat:Connect(function()
        if not fovCircleEnabled or not fovCircle then return end
        local cam = workspace.CurrentCamera
        fovCircle.Position = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
        fovCircle.Radius = aimlockConfig.fov
    end)
end

local function removeFOVCircle()
    if fovCircle then fovCircle:Remove() fovCircle = nil end
end

-- Kill Notifications
Players.PlayerRemoving:Connect(function(player)
    notify(player.Name .. " left")
end)

local function watchDeaths(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                if player ~= LocalPlayer then
                    notify("☠  " .. player.Name .. " died")
                end
            end)
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do watchDeaths(p) end
Players.PlayerAdded:Connect(function(p) watchDeaths(p) end)

-- ESP
local function updateAllESP()
    for player, obj in pairs(espObjects) do
        if obj.label then
            local col = espConfig.teamColor and player.TeamColor.Color or espConfig.color
            obj.label.TextColor3 = col
            obj.label.TextSize = espConfig.textSize
            obj.label.Visible = espConfig.showName
        end
        if obj.healthLabel then
            obj.healthLabel.TextSize = espConfig.textSize
            obj.healthLabel.Visible = espConfig.showHealth
        end
        if obj.distLabel then
            obj.distLabel.TextSize = espConfig.textSize
            obj.distLabel.Visible = espConfig.showDistance
        end
        if obj.toolLabel then
            obj.toolLabel.TextSize = espConfig.textSize
            obj.toolLabel.Visible = espConfig.showTool
        end
        if obj.billboard then
            obj.billboard.StudsOffset = Vector3.new(0, espConfig.studOffset, 0)
        end
    end
end

local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].billboard and espObjects[player].billboard:IsDescendantOf(game) then
            espObjects[player].billboard:Destroy()
        end
        espObjects[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then return end

    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
        or character:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    removeESP(player)

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 160, 0, 130)
    billboard.StudsOffset = Vector3.new(0, espConfig.studOffset, 0)
    billboard.Adornee = rootPart
    billboard.Parent = rootPart

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 6)
    layout.Parent = billboard

    local function makeLabel(order, color)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, 22)
        l.TextColor3 = color
        l.TextStrokeTransparency = 0.3
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.Font = Enum.Font.GothamMedium
        l.TextSize = espConfig.textSize
        l.TextScaled = false
        l.TextTruncate = Enum.TextTruncate.None
        l.LayoutOrder = order
        l.Parent = billboard
        return l
    end

    local nameLabel = makeLabel(1, espConfig.color)
    nameLabel.Font = Enum.Font.GothamBlack
    nameLabel.Text = player.Name
    nameLabel.Visible = espConfig.showName

    local healthLabel = makeLabel(2, Color3.fromRGB(80, 255, 120))
    healthLabel.Text = "HP: ?"
    healthLabel.Visible = espConfig.showHealth

    local distLabel = makeLabel(3, Color3.fromRGB(180, 180, 255))
    distLabel.Text = "? studs"
    distLabel.Visible = espConfig.showDistance

    local toolLabel = makeLabel(4, Color3.fromRGB(255, 210, 60))
    toolLabel.Text = ""
    toolLabel.Visible = espConfig.showTool

    espObjects[player] = {
        billboard = billboard,
        label = nameLabel,
        healthLabel = healthLabel,
        distLabel = distLabel,
        toolLabel = toolLabel,
        rootPart = rootPart,
    }

    local humanoid = character:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.Died:Connect(function()
            removeESP(player)
            if aimlockTarget == player then aimlockTarget = nil end
            local newChar = player.CharacterAdded:Wait()
            newChar:WaitForChild("HumanoidRootPart", 5)
            task.wait(0.2)
            if espEnabled then createESP(player) end
        end)
    end
end

-- Tracers
local tracerLines = {}

local function removeTracer(player)
    if tracerLines[player] then
        tracerLines[player]:Remove()
        tracerLines[player] = nil
    end
end

local function removeAllTracers()
    for player in pairs(tracerLines) do removeTracer(player) end
end

local function enableESP()
    for _, p in pairs(Players:GetPlayers()) do
        task.spawn(function() createESP(p) end)
    end
end

local function disableESP()
    for p in pairs(espObjects) do removeESP(p) end
    removeAllTracers()
end

-- Closest player
local function getClosestPlayer()
    local closest, shortestDist = nil, math.huge
    local cam = workspace.CurrentCamera
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local part = char:FindFirstChild(aimlockConfig.targetPart) or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not part or not hum or hum.Health <= 0 then continue end

        local sp, onScreen = cam:WorldToViewportPoint(part.Position)
        if onScreen then
            local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
            if dist < shortestDist and dist <= aimlockConfig.fov then
                shortestDist = dist
                closest = player
            end
        end
    end
    return closest
end

-- Aimlock
local function startAimlock()
    if aimlockConnection then aimlockConnection:Disconnect() end
    aimlockConnection = RunService.Heartbeat:Connect(function()
        if not aimlockEnabled then return end

        if aimlockTarget then
            local char = aimlockTarget.Character
            local hum = char and char:FindFirstChild("Humanoid")
            if not char or not hum or hum.Health <= 0 then
                aimlockTarget = aimlockConfig.autoRetarget and getClosestPlayer() or nil
            end
        end

        if not aimlockTarget then return end

        local char = aimlockTarget.Character
        if not char then aimlockTarget = nil return end

        local part = char:FindFirstChild(aimlockConfig.targetPart) or char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not part or not hum or hum.Health <= 0 then aimlockTarget = nil return end

        local vel = part.AssemblyLinearVelocity or Vector3.new()
        local predicted = part.Position + (vel * aimlockConfig.prediction * 0.05)
        local yOff = aimlockConfig.targetPart == "Head" and 0 or 0.5

        local targetCF = CFrame.lookAt(
            workspace.CurrentCamera.CFrame.Position,
            predicted + Vector3.new(0, yOff, 0)
        )

        if aimlockConfig.smoothness > 0 then
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(targetCF, 1 / (aimlockConfig.smoothness + 1))
        else
            workspace.CurrentCamera.CFrame = targetCF
        end
    end)
end

local function stopAimlock()
    if aimlockConnection then aimlockConnection:Disconnect() aimlockConnection = nil end
    aimlockTarget = nil
end

-- Noclip
local function startNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true end
        end
    end
end

-- Speed
local function setSpeed(val)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = val end
end

-- Fly
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = true end

    flyBody = Instance.new("BodyVelocity")
    flyBody.Velocity = Vector3.new(0,0,0)
    flyBody.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBody.Parent = hrp

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flyEnabled then return end
        local cf = workspace.CurrentCamera.CFrame
        local vel = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then vel += cf.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then vel -= cf.LookVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then vel -= cf.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then vel += cf.RightVector * flySpeed end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vel += Vector3.new(0, flySpeed, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vel -= Vector3.new(0, flySpeed, 0) end
        flyBody.Velocity = vel
    end)
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBody then flyBody:Destroy() flyBody = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if not infiniteJumpEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Heartbeat
RunService.Heartbeat:Connect(function()
    local cam = workspace.CurrentCamera
    local localChar = LocalPlayer.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local screenBottom = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)

    for player, obj in pairs(espObjects) do
        local char = player.Character
        if not char then continue end
        local hum = char:FindFirstChild("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if hum and obj.healthLabel then
            local hp = math.floor(hum.Health)
            local maxHp = math.floor(hum.MaxHealth)
            local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            obj.healthLabel.TextColor3 = Color3.fromRGB(
                math.floor(255 * (1 - ratio)),
                math.floor(220 * ratio),
                50
            )
            obj.healthLabel.Text = "HP  " .. hp .. " / " .. maxHp
        end

        if hrp and localHRP and obj.distLabel then
            obj.distLabel.Text = math.floor((hrp.Position - localHRP.Position).Magnitude) .. " studs"
        end

        if obj.toolLabel and espConfig.showTool then
            local tool = char:FindFirstChildOfClass("Tool")
            obj.toolLabel.Text = tool and ("⚔ " .. tool.Name) or ""
        end

        if obj.label and espConfig.teamColor then
            pcall(function() obj.label.TextColor3 = player.TeamColor.Color end)
        end
    end

    if espEnabled and espConfig.showTracers then
        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then removeTracer(player) continue end

            local sp, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if not onScreen then removeTracer(player) continue end

            if not tracerLines[player] then
                local l = Drawing.new("Line")
                l.Thickness = 1
                l.Color = espConfig.color
                l.Transparency = 0.6
                l.Visible = true
                tracerLines[player] = l
            end

            tracerLines[player].From = screenBottom
            tracerLines[player].To = Vector2.new(sp.X, sp.Y)
            tracerLines[player].Color = espConfig.color
        end
    else
        removeAllTracers()
    end

    if speedEnabled then setSpeed(speedValue) end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.2)
        if espEnabled then task.spawn(function() createESP(player) end) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    removeTracer(player)
    if aimlockTarget == player then aimlockTarget = nil end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if speedEnabled then setSpeed(speedValue) end
    if noclipEnabled then startNoclip() end
    if flyEnabled then startFly() end
end)

-- Combat Tab
tab:CreateToggle("Aimlock", function(a)
    aimlockEnabled = a
    if aimlockEnabled then startAimlock() notify("Aimlock enabled")
    else stopAimlock() notify("Aimlock disabled") end
end)

tab:CreateDropdown("Aimlock Key", {"Q","E","R","F","T","Z","X","C"}, function(a)
    local keys = {Q=Enum.KeyCode.Q,E=Enum.KeyCode.E,R=Enum.KeyCode.R,F=Enum.KeyCode.F,T=Enum.KeyCode.T,Z=Enum.KeyCode.Z,X=Enum.KeyCode.X,C=Enum.KeyCode.C}
    aimlockKey = keys[a] or Enum.KeyCode.Q
    notify("Aimlock key: " .. a)
end)

tab:CreateDropdown("Target Part", {"HumanoidRootPart","Head"}, function(a)
    aimlockConfig.targetPart = a
    notify("Target: " .. a)
end)

tab:CreateToggle("Auto Retarget", function(a)
    aimlockConfig.autoRetarget = a
    notify("Auto Retarget " .. (a and "on" or "off"))
end)

tab:CreateSlider("FOV", 50, 500, function(a)
    aimlockConfig.fov = a
end)

tab:CreateSlider("Smoothness", 0, 10, function(a)
    aimlockConfig.smoothness = a
end)

tab:CreateSlider("Prediction", 0, 10, function(a)
    aimlockConfig.prediction = a
end)

-- Visuals Tab
tab2:CreateToggle("ESP", function(a)
    espEnabled = a
    if espEnabled then enableESP() notify("ESP enabled")
    else disableESP() notify("ESP disabled") end
end)

tab2:CreateCheckbox("Names", function(a)
    espConfig.showName = a
    updateAllESP()
end)

tab2:CreateCheckbox("Health", function(a)
    espConfig.showHealth = a
    updateAllESP()
end)

tab2:CreateCheckbox("Distance", function(a)
    espConfig.showDistance = a
    updateAllESP()
end)

tab2:CreateCheckbox("Tracers", function(a)
    espConfig.showTracers = a
    if not a then removeAllTracers() end
    notify("Tracers " .. (a and "on" or "off"))
end)

tab2:CreateCheckbox("Tool ESP", function(a)
    espConfig.showTool = a
    updateAllESP()
end)

tab2:CreateCheckbox("Team Colors", function(a)
    espConfig.teamColor = a
    updateAllESP()
    notify("Team Colors " .. (a and "on" or "off"))
end)

tab2:CreateDropdown("ESP Color", {"Red","Green","Blue","White","Yellow","Cyan"}, function(a)
    local colors = {
        Red=Color3.fromRGB(214,40,57), Green=Color3.fromRGB(60,220,100),
        Blue=Color3.fromRGB(60,120,255), White=Color3.fromRGB(240,240,240),
        Yellow=Color3.fromRGB(255,220,50), Cyan=Color3.fromRGB(50,220,255),
    }
    espConfig.color = colors[a] or Color3.fromRGB(214,40,57)
    updateAllESP()
    notify("Color: " .. a)
end)

tab2:CreateSlider("Text Size", 8, 24, function(a)
    espConfig.textSize = a
    updateAllESP()
end)

tab2:CreateSlider("Height", 1, 8, function(a)
    espConfig.studOffset = a
    updateAllESP()
end)

-- Movement Tab
tab3:CreateToggle("Noclip", function(a)
    noclipEnabled = a
    if noclipEnabled then startNoclip() notify("Noclip on")
    else stopNoclip() notify("Noclip off") end
end)

tab3:CreateToggle("Speed", function(a)
    speedEnabled = a
    if speedEnabled then setSpeed(speedValue) notify("Speed on")
    else setSpeed(16) notify("Speed off") end
end)

tab3:CreateSlider("Speed Value", 16, 150, function(a)
    speedValue = a
    if speedEnabled then setSpeed(speedValue) end
end)

tab3:CreateToggle("Fly", function(a)
    flyEnabled = a
    if flyEnabled then startFly() notify("Fly on")
    else stopFly() notify("Fly off") end
end)

tab3:CreateSlider("Fly Speed", 10, 200, function(a)
    flySpeed = a
end)

tab3:CreateToggle("Infinite Jump", function(a)
    infiniteJumpEnabled = a
    notify("Infinite Jump " .. (a and "on" or "off"))
end)

-- UI Tab
tab4:CreateToggle("Watermark", function(a)
    watermarkEnabled = a
    if watermarkEnabled then createWatermark() notify("Watermark on")
    else removeWatermark() notify("Watermark off") end
end)

tab4:CreateToggle("Clock", function(a)
    clockEnabled = a
    if clockEnabled then createClock() notify("Clock on")
    else removeClock() notify("Clock off") end
end)

tab4:CreateToggle("Crosshair", function(a)
    crosshairEnabled = a
    if crosshairEnabled then createCrosshair() notify("Crosshair on")
    else removeCrosshair() notify("Crosshair off") end
end)

tab4:CreateToggle("FOV Circle", function(a)
    fovCircleEnabled = a
    if fovCircleEnabled then createFOVCircle() notify("FOV Circle on")
    else removeFOVCircle() notify("FOV Circle off") end
end)

tab4:CreateToggle("Notifications", function(a)
    notifsEnabled = a
end)

tab4:CreateToggle("Kill Notifications", function(a)
    notifsEnabled = a
    notify("Kill Notifs " .. (a and "on" or "off"))
end)

-- Input
UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if aimlockEnabled and input.KeyCode == aimlockKey then
        aimlockTarget = aimlockTarget and nil or getClosestPlayer()
    end
end)

tab:Show()
tab4:CreateToggle("Notifications", function(a)
    notifsEnabled = a
end)

tab4:CreateToggle("Kill Notifications", function(a)
    notifsEnabled = a
    notify("Kill Notifs " .. (a and "on" or "off"))
end)

-- Input
UserInputService.InputBegan:Connect(function(input, gp)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if aimlockEnabled and input.KeyCode == aimlockKey then
        aimlockTarget = aimlockTarget and nil or getClosestPlayer()
    end
end)

tab:Show()
