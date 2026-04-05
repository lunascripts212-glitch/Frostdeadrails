-- Frost Dead Rails | WindUI
-- All ESP uses Highlight instances

if game:GetService('CoreGui'):FindFirstChild('FrostDeadRails') then
    game:GetService('CoreGui').FrostDeadRails:Destroy()
end

local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua', true))()

local App = WindUI:CreateApp({
    Title = 'Frost Dead Rails',
    Icon = 'snowflake',
    Toggle = Enum.KeyCode.RightShift,
})

local TabDeadRails = App:Tab({ Title = 'Dead Rails', Icon = 'map-pin' })
local TabMain      = App:Tab({ Title = 'Main',       Icon = 'zap' })
local TabESP       = App:Tab({ Title = 'ESP',        Icon = 'eye' })

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

TabDeadRails:Button({
    Title = 'TP to End',
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

TabDeadRails:Toggle({
    Title = 'Gun Aura (Kill Mobs)',
    Default = false,
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

TabDeadRails:Toggle({
    Title = 'Collect Bond & Ammo',
    Default = false,
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

TabDeadRails:Button({
    Title = 'TP to Castle',
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

TabDeadRails:Button({
    Title = 'TP to TeslaLab',
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
            local lp  = game.Players.LocalPlayer
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

TabDeadRails:Button({
    Title = 'TP to Sterling',
    Callback = function()
        local lp   = game.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        local hrp  = char:WaitForChild('HumanoidRootPart')
        local hum  = char:WaitForChild('Humanoid')
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

TabDeadRails:Button({
    Title = 'TP to Fort',
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

TabMain:Button({
    Title = 'TP to Train',
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

TabMain:Button({
    Title = 'Inf Jump',
    Callback = function()
        game:GetService('UserInputService').JumpRequest:Connect(function()
            game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState('Jumping')
        end)
    end,
})

TabMain:Toggle({
    Title = 'Walk Speed',
    Default = false,
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
TabMain:Toggle({
    Title = 'Noclip',
    Default = false,
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

TabMain:Button({
    Title = 'UnlockCam',
    Callback = function()
        local lp  = game.Players.LocalPlayer
        local cam = workspace.CurrentCamera
        lp.CameraMode = Enum.CameraMode.Classic
        lp.CameraMinZoomDistance = 0
        lp.CameraMaxZoomDistance = 150
        cam.CameraSubject = lp.Character.Humanoid
    end,
})

TabMain:Toggle({
    Title = 'FullBright',
    Default = false,
    Callback = function(val)
        local lighting = game:GetService('Lighting')
        if val then
            lighting.Brightness = 1
            lighting.ClockTime = 12
            lighting.FogEnd = 786543
            lighting.GlobalShadows = false
            lighting.Ambient = Color3.fromRGB(178, 178, 178)
        else
            lighting.Brightness = 1
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = true
            lighting.Ambient = Color3.fromRGB(70, 70, 70)
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

TabESP:Toggle({
    Title = 'Mobs ESP',
    Default = false,
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
        local part = v:IsA('Model') and v.PrimaryPart or (v:IsA('BasePart') and v or nil)
        local target = v:IsA('Model') and v or v.Parent
        if part and not itemHighlights[target] then
            addHighlight(target, Color3.fromRGB(50, 200, 255), Color3.fromRGB(255, 255, 255), 0.4)
            itemHighlights[target] = target:FindFirstChild('_FrostESP')
        end
    end
end

TabESP:Toggle({
    Title = 'Items ESP',
    Default = false,
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

TabESP:Toggle({
    Title = 'Unicorn ESP',
    Default = false,
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

TabESP:Toggle({
    Title = 'Player ESP',
    Default = false,
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
        if name == 'FireDelay'     and key == 'Value' then return 0          end
        if name == 'MagazineSize'  and key == 'Value' then return math.huge  end
        if name == 'ReloadDuration' and key == 'Value' then return 0         end
        if name == 'SpreadAngle'   and key == 'Value' then return 0          end
    end
    return origIndex(self, key)
end)
