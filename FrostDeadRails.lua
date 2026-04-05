-- Frost Dead Rails | Rayfield (Sirius)
-- All ESP uses Highlight instances

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = 'Frost Dead Rails',
    Icon = 0,
    LoadingTitle = 'Frost Dead Rails',
    LoadingSubtitle = 'by lovesaken',
    Theme = 'Default',
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
    },
    KeySystem = false,
})

local TabDeadRails = Window:CreateTab('Dead Rails', 4483362458)
local TabMain      = Window:CreateTab('Main', 4483362458)
local TabESP       = Window:CreateTab('ESP', 4483362458)

-- ══════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════

local function addHighlight(parent, fillColor, outlineColor, fillTransparency)
    if parent:FindFirstChild('_FrostESP') then return end
    local h = Instance.new('Highlight')
    h.Name = '_FrostESP'
    h.FillColor = fillColor or Color3.fromRGB(255, 0, 0)
    h.OutlineColor = outlineColor or Color3.fromRGB(255, 255, 255)
    h.FillTransparency = fillTransparency or 0.3
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = parent
end

local function removeHighlights(tbl)
    for k, h in pairs(tbl) do
        if h and h.Parent then h:Destroy() end
        tbl[k] = nil
    end
end

-- ══════════════════════════════════════════════
-- DEAD RAILS TAB
-- ══════════════════════════════════════════════

TabDeadRails:CreateButton({
    Name = 'TP to End',
    Callback = function()
        local cf   = CFrame.new(-428.745911, 28.0728378, -49040.9062)
        local char = game.Players.LocalPlayer.Character
        local hum  = char:WaitForChild('Humanoid')
        local hrp  = char:WaitForChild('HumanoidRootPart')
        while not hum.Sit do
            hrp.CFrame = cf
            task.wait()
        end
    end,
})

TabDeadRails:CreateToggle({
    Name = 'Gun Aura (Kill Mobs)',
    CurrentValue = false,
    Flag = 'GunAura',
    Callback = function(val)
        _G.Gun = val
        if val then
            task.spawn(function()
                while _G.Gun do
                    task.wait()
                    pcall(function()
                        local lp = game:GetService('Players').LocalPlayer
                        local closest, dist = nil, math.huge
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if v.Name == 'HumanoidRootPart' and
                               (v.Parent:GetAttribute('EntityName') or v.Parent:GetAttribute('Bounty')) then
                                local hum = v.Parent:FindFirstChild('Humanoid')
                                if hum and hum.Health > 0 then
                                    local d = lp:DistanceFromCharacter(v.Position)
                                    if d < dist then closest = v dist = d end
                                end
                            end
                        end
                        if closest then
                            game:GetService('ReplicatedStorage').Remotes.Weapon.Shoot:FireServer(
                                workspace:GetServerTimeNow(),
                                lp.Character:FindFirstChildOfClass('Tool'),
                                closest.CFrame * CFrame.Angles(-1.7947, 0.2275, 2.3609),
                                { ['4'] = closest.Parent:FindFirstChild('Humanoid'), ['2'] = closest.Parent:FindFirstChild('Humanoid') }
                            )
                            game:GetService('ReplicatedStorage').Remotes.Weapon.Reload:FireServer(
                                workspace:GetServerTimeNow(),
                                lp.Character:FindFirstChildOfClass('Tool')
                            )
                        end
                        task.wait(0.2)
                    end)
                end
            end)
        end
    end,
})

TabDeadRails:CreateToggle({
    Name = 'Collect Bond & Ammo',
    CurrentValue = false,
    Flag = 'CollectBond',
    Callback = function(val)
        _G.Collect = val
        if val then
            task.spawn(function()
                while _G.Collect do
                    pcall(function()
                        for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
                            local txt = v:GetAttribute('ActivateText')
                            if txt == 'Collect Bond' or txt == 'Collect' then
                                game:GetService('ReplicatedStorage').Shared.Network.RemotePromise.Remotes.C_ActivateObject:FireServer(v)
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

TabDeadRails:CreateButton({
    Name = 'TP to Castle',
    Callback = function()
        local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
        local t = tick()
        while tick() - t < 1 do hrp.CFrame = CFrame.new(248, 24, -9059) task.wait() end
        local seat = workspace.RuntimeItems.MaximGun.VehicleSeat
        local t2 = tick()
        while tick() - t2 < 3 do
            hrp.CFrame = CFrame.new(seat.Position)
            seat.Disabled = false
            task.wait()
        end
    end,
})

TabDeadRails:CreateButton({
    Name = 'TP to TeslaLab',
    Callback = function()
        local ok = pcall(function()
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            local gen = workspace.TeslaLab.Generator.Generator
            local t = tick()
            while tick() - t < 1 do hrp.CFrame = CFrame.new(gen.Position) task.wait() end
            local closest, dist = nil, math.huge
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA('Seat') then
                    local m = (v.Position - gen.Position).Magnitude
                    if m < dist then closest = v dist = m end
                end
            end
            local cf = closest and closest.CFrame or CFrame.new()
            local t2 = tick()
            while tick() - t2 < 3 do
                hrp.CFrame = cf
                workspace.RuntimeItems.Chair.Seat.Disabled = false
                task.wait()
            end
        end)
        if not ok then
            local lp   = game.Players.LocalPlayer
            local char = lp.Character or lp.CharacterAdded:Wait()
            local hrp  = char:WaitForChild('HumanoidRootPart')
            hrp.CFrame = CFrame.new(56, 3, 29760)
            game:GetService('TweenService'):Create(hrp,
                TweenInfo.new(50, Enum.EasingStyle.Linear),
                { CFrame = CFrame.new(-424, 30, -49041) }
            ):Play()
        end
    end,
})

TabDeadRails:CreateButton({
    Name = 'TP to Sterling',
    Callback = function()
        local lp   = game.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp  = char:WaitForChild('HumanoidRootPart')
        hrp.CFrame = CFrame.new(56, 3, 29760)
        local tween = game:GetService('TweenService'):Create(hrp,
            TweenInfo.new(40, Enum.EasingStyle.Linear),
            { CFrame = CFrame.new(-424, 30, -49041) }
        )
        tween:Play()
        task.spawn(function()
            while true do
                local s = workspace:FindFirstChild('Sterling')
                if s then
                    local town = s:FindFirstChild('Town')
                    local road = town and town:FindFirstChild('Road')
                    if road then
                        tween:Cancel()
                        local cf = road.CFrame * CFrame.new(0, 5, 0)
                        local t = tick()
                        while tick() - t < 5 do
                            hrp.CFrame = cf
                            workspace.RuntimeItems.Chair.Seat.Disabled = false
                            workspace.RuntimeItems.Chair.Seat.CFrame = hrp.CFrame * CFrame.new(0, -1, 0)
                            task.wait()
                        end
                        break
                    end
                end
                task.wait(0.2)
            end
        end)
    end,
})

TabDeadRails:CreateButton({
    Name = 'TP to Fort',
    Callback = function()
        local lp   = game.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp  = char:WaitForChild('HumanoidRootPart')
        local hum  = char:WaitForChild('Humanoid')
        hrp.CFrame = CFrame.new(56, 3, 29760)
        local tween = game:GetService('TweenService'):Create(hrp,
            TweenInfo.new(50, Enum.EasingStyle.Linear),
            { CFrame = CFrame.new(-424, 30, -49041) }
        )
        tween:Play()
        task.spawn(function()
            while true do
                local cannon = workspace.RuntimeItems:FindFirstChild('Cannon')
                if cannon and cannon:FindFirstChild('VehicleSeat') then
                    tween:Cancel()
                    local seat = cannon.VehicleSeat
                    local t = tick()
                    while tick() - t < 3 do
                        hrp.CFrame = CFrame.new(seat.Position)
                        seat.Disabled = false
                        task.wait()
                    end
                    repeat task.wait() until hum.Sit
                    break
                end
                task.wait(0.2)
            end
        end)
    end,
})

-- ══════════════════════════════════════════════
-- MAIN TAB
-- ══════════════════════════════════════════════

TabMain:CreateButton({
    Name = 'TP to Train',
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local hum  = char:WaitForChild('Humanoid')
        local hrp  = char:WaitForChild('HumanoidRootPart')
        for _, v in pairs(workspace:GetChildren()) do
            if v:IsA('Model') and v:GetAttribute('serverEntityId') then
                for _, d in pairs(v:GetDescendants()) do
                    if d.Name == 'VehicleSeat' then
                        local cf = CFrame.new(d.Position)
                        while not hum.Sit do
                            hrp.CFrame = cf
                            task.wait()
                        end
                    end
                end
            end
        end
    end,
})

TabMain:CreateButton({
    Name = 'Inf Jump',
    Callback = function()
        game:GetService('UserInputService').JumpRequest:Connect(function()
            game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Jumping')
        end)
    end,
})

TabMain:CreateToggle({
    Name = 'Walk Speed',
    CurrentValue = false,
    Flag = 'WalkSpeed',
    Callback = function(val)
        _G.Speed = val
        local char = game.Players.LocalPlayer.Character
        local hum  = char and char:FindFirstChild('Humanoid')
        if val then
            task.spawn(function()
                while _G.Speed do
                    pcall(function()
                        if hum then hum.WalkSpeed = 18.5 workspace.CurrentCamera.FieldOfView = 100 end
                    end)
                    task.wait(3)
                    pcall(function()
                        if hum then hum.WalkSpeed = 16 end
                    end)
                    task.wait(1)
                end
            end)
        else
            pcall(function()
                if hum then hum.WalkSpeed = 16 workspace.CurrentCamera.FieldOfView = 70 end
            end)
        end
    end,
})

local noclipConn = nil
TabMain:CreateToggle({
    Name = 'Noclip',
    CurrentValue = false,
    Flag = 'Noclip',
    Callback = function(val)
        if val then
            noclipConn = game:GetService('RunService').Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, v in pairs(char:GetDescendants()) do
                        if v:IsA('BasePart') and v.CanCollide then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        end
    end,
})

TabMain:CreateButton({
    Name = 'UnlockCam',
    Callback = function()
        local lp  = game.Players.LocalPlayer
        local cam = workspace.CurrentCamera
        lp.CameraMode = Enum.CameraMode.Classic
        lp.CameraMinZoomDistance = 0
        lp.CameraMaxZoomDistance = 150
        cam.CameraSubject = lp.Character.Humanoid
    end,
})

TabMain:CreateToggle({
    Name = 'FullBright',
    CurrentValue = false,
    Flag = 'FullBright',
    Callback = function(val)
        local l = game:GetService('Lighting')
        if val then
            l.Brightness = 1
            l.ClockTime = 12
            l.FogEnd = 786543
            l.GlobalShadows = false
            l.Ambient = Color3.fromRGB(178, 178, 178)
        else
            l.Brightness = 1
            l.ClockTime = 14
            l.FogEnd = 100000
            l.GlobalShadows = true
            l.Ambient = Color3.fromRGB(70, 70, 70)
        end
    end,
})

-- ══════════════════════════════════════════════
-- ESP TAB — ALL HIGHLIGHT
-- ══════════════════════════════════════════════

-- MOBS ESP
local mobHighlights = {}

local function scanMobs()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA('BasePart') and v.Name == 'HumanoidRootPart' then
            local parent = v.Parent
            if (parent:GetAttribute('EntityName') or parent:GetAttribute('Bounty')) and not mobHighlights[parent] then
                addHighlight(parent, Color3.fromRGB(255, 50, 50), Color3.fromRGB(255, 255, 255), 0.3)
                mobHighlights[parent] = parent:FindFirstChild('_FrostESP')
            end
        end
    end
end

TabESP:CreateToggle({
    Name = 'Mobs ESP',
    CurrentValue = false,
    Flag = 'MobsESP',
    Callback = function(val)
        _G.MobsESP = val
        if val then
            scanMobs()
            task.spawn(function()
                while _G.MobsESP do
                    scanMobs()
                    task.wait(1)
                end
            end)
        else
            removeHighlights(mobHighlights)
        end
    end,
})

-- ITEMS ESP
local itemHighlights = {}

local function scanItems()
    for _, v in pairs(workspace.RuntimeItems:GetChildren()) do
        local target = v:IsA('Model') and v or v.Parent
        local hasPart = v:IsA('Model') and v.PrimaryPart or v:IsA('BasePart')
        if hasPart and not itemHighlights[target] then
            addHighlight(target, Color3.fromRGB(50, 200, 255), Color3.fromRGB(255, 255, 255), 0.4)
            itemHighlights[target] = target:FindFirstChild('_FrostESP')
        end
    end
end

TabESP:CreateToggle({
    Name = 'Items ESP',
    CurrentValue = false,
    Flag = 'ItemsESP',
    Callback = function(val)
        _G.ItemsESP = val
        if val then
            scanItems()
            task.spawn(function()
                while _G.ItemsESP do
                    scanItems()
                    task.wait(1)
                end
            end)
        else
            removeHighlights(itemHighlights)
        end
    end,
})

-- UNICORN ESP
local unicornHighlights = {}

local function scanUnicorns()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == 'Unicorn' and v:IsA('Model') and v:FindFirstChild('HumanoidRootPart') then
            if not unicornHighlights[v] then
                addHighlight(v, Color3.fromRGB(200, 100, 255), Color3.fromRGB(255, 255, 255), 0.2)
                unicornHighlights[v] = v:FindFirstChild('_FrostESP')
            end
        end
    end
end

TabESP:CreateToggle({
    Name = 'Unicorn ESP',
    CurrentValue = false,
    Flag = 'UnicornESP',
    Callback = function(val)
        _G.UnicornESP = val
        if val then
            scanUnicorns()
            task.spawn(function()
                while _G.UnicornESP do
                    scanUnicorns()
                    task.wait(2)
                end
            end)
        else
            removeHighlights(unicornHighlights)
        end
    end,
})

-- PLAYERS ESP
local playerHighlights = {}

local function scanPlayers()
    for _, plr in pairs(game:GetService('Players'):GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            local char = plr.Character
            if char and not playerHighlights[char] then
                addHighlight(char, Color3.fromRGB(50, 255, 100), Color3.fromRGB(255, 255, 255), 0.3)
                playerHighlights[char] = char:FindFirstChild('_FrostESP')
            end
        end
    end
end

TabESP:CreateToggle({
    Name = 'Player ESP',
    CurrentValue = false,
    Flag = 'PlayerESP',
    Callback = function(val)
        _G.PlayerESP = val
        if val then
            scanPlayers()
            task.spawn(function()
                while _G.PlayerESP do
                    scanPlayers()
                    task.wait(1)
                end
            end)
        else
            removeHighlights(playerHighlights)
        end
    end,
})

-- ══════════════════════════════════════════════
-- METAMETHOD HOOK (Gun values)
-- ══════════════════════════════════════════════

local origIndex
origIndex = hookmetamethod(game, '__index', function(self, key)
    if not checkcaller() then
        local name = tostring(self)
        if name == 'FireDelay'      and key == 'Value' then return 0         end
        if name == 'MagazineSize'   and key == 'Value' then return math.huge end
        if name == 'ReloadDuration' and key == 'Value' then return 0         end
        if name == 'SpreadAngle'    and key == 'Value' then return 0         end
    end
    return origIndex(self, key)
end)

Rayfield:Notify({
    Title = 'Frost Dead Rails',
    Content = 'Loaded successfully!',
    Duration = 5,
    Image = 4483362458,
})
