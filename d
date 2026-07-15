
local _iter_gc = getgc(true)
for k, v in pairs(_iter_gc) do
    if pcall(function()
        return rawget(v, "indexInstance")
    end) then
        local _indexInst = rawget(v, "indexInstance")
        if type(_indexInst) == "table" and _indexInst[1] == "kick" then
            setreadonly(v, false)
            v.tvk = {
                "kick",
                function()
                    return game.Workspace:WaitForChild("")
                end
            }
        end
    end
end

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

if not CoolDowns then
    CoolDowns = {}
end
if not CoolDowns.AutoPickUps then
    CoolDowns.AutoPickUps = {}
end
if CoolDowns.AutoPickUps.MoneyCooldown == nil then
    CoolDowns.AutoPickUps.MoneyCooldown = false
end
if not Settings then
    Settings = {}
end
if Settings.IsDead == nil then
    Settings.IsDead = false
end
if not toggle_states then
    toggle_states = {}
end
if not connection_table then
    connection_table = {}
end

local _ls_Library_url = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"
local _ls_Library_data = game:HttpGet(_ls_Library_url)
local _ls_Library = loadstring(_ls_Library_data)
local Library = _ls_Library()
local _ls_ThemeManager_url = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"
local _ls_ThemeManager_data = game:HttpGet(_ls_ThemeManager_url)
local _ls_ThemeManager = loadstring(_ls_ThemeManager_data)
local ThemeManager = _ls_ThemeManager()
local _ls_SaveManager_url = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"
local _ls_SaveManager_data = game:HttpGet(_ls_SaveManager_url)
local _ls_SaveManager = loadstring(_ls_SaveManager_data)
local SaveManager = _ls_SaveManager()

local P = {
    Fly_Speed = 65, Fly_Method = "Velocity",
    BredMakurz_Distance = 200,
    SpeedHack_Value = 16, JumpDelay_Value = 0,
    MeleeUp_Distance = 5, MeleeUp_TargetPart = "Right Arm", MeleeUp_AnimEnabled = false,
    Pepper_Distance = 15,
    Aimbot_Method = "Camera", Aimbot_Smoothness = 5,
    Aimbot_FovRadius = 100, Aimbot_UseFov = false, Aimbot_DrawFov = false,
    Aimbot_FovColor = Color3.fromRGB(255,255,255),
    Aimbot_CheckTeam = true, Aimbot_CheckDowned = true, Aimbot_WallCheck = true,
    Aimbot_Prediction = 100, Aimbot_Part = "Head", Aimbot_StickyTarget = false,
    ESP_Enabled = false, ESP_Boxes = false, ESP_Names = false, ESP_Distance = false, ESP_Health = false,
    ESP_Tracers = false, ESP_Chams = false, ESP_Skeleton = false, ESP_Tool = false,
    ESP_TracerOrigin = "Bottom", ESP_MaxDist = 500,
    ESP_BoxColor = Color3.fromRGB(255,255,255), ESP_NameColor = Color3.fromRGB(255,255,255),
    ESP_DistColor = Color3.fromRGB(180,180,180), ESP_HealthColor = Color3.fromRGB(0,255,0),
    ESP_TracerColor = Color3.fromRGB(255,255,255),
    ESP_ChamsFill = Color3.fromRGB(255,0,0), ESP_ChamsOutline = Color3.fromRGB(255,255,255),
    ESP_SkelColor = Color3.fromRGB(255,255,255), ESP_ToolColor = Color3.fromRGB(200,200,200),
    WESP_Dealers = false, WESP_Cash = false, WESP_Items = false,
    WESP_ATMs = false, WESP_Mystery = false, WESP_Piles = false, WESP_Alarms = false,
    WESP_DealerColor = Color3.fromRGB(255,200,0), WESP_CashColor = Color3.fromRGB(0,255,0),
    WESP_ItemColor = Color3.fromRGB(0,150,255), WESP_ATMColor = Color3.fromRGB(200,0,255),
    WESP_MysteryColor = Color3.fromRGB(255,100,200), WESP_PileColor = Color3.fromRGB(0,255,255),
    WESP_AlarmColor = Color3.fromRGB(255,50,50),
    Ragebot_FireRate = 50, Ragebot_FovRadius = 150, Ragebot_UseFov = true, Ragebot_DrawFov = false, Ragebot_CheckDowned = false,
    AntiAim_SpinSpeed = 100, AntiAim_JitterSpeed = 50,
    Fov_Value = 80,
}

local Window = Library:CreateWindow({
    Title = 'pidors.cc v5.0',
    Center = true,
    AutoClose = false,
    AutoShow = true,
    TabPadding = 8,
    TabMargin = 4,
})

local Tabs = {
    Player = Window:AddTab('Player'),
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    World = Window:AddTab('World'),
    Working = Window:AddTab('Working'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local function formatName(name)
    name = string.gsub(name, "([a-z])([A-Z])", "%1 %2")
    local usIdx = string.find(name, "_")
    if usIdx then
        name = string.sub(name, 1, usIdx - 1)
    end
    return name
end

local cloneref = cloneref or function(...) return ... end

local MeleeUp_Parts = {"Right Arm", "Left Arm", "Right Leg", "Left Leg", "Head", "HumanoidRootPart", "Torso"}

local Fly_Enable, Fly_Disable
local Noclip_Enable, Noclip_Disable
local InfiniteStamina_Enable, InfiniteStamina_Disable
local Shadow_Enable, Shadow_Disable
local AntiAFK_Enable, AntiAFK_Disable
local AdminCheck_Enable, AdminCheck_Disable
local MeleeAura_Enable, MeleeAura_Disable
local MeleeUp_Enable, MeleeUp_Disable
local Pepper_StartLoop, Pepper_StopSpray
local NoFailLockpick_Enable, NoFailLockpick_Disable
local OpenNearbyDoors_Enable, OpenNearbyDoors_Disable
local UnlockNearbyDoors_Enable, UnlockNearbyDoors_Disable
local AutoPickupMoney_Enable, AutoPickupMoney_Disable
local Fov_Enable, Fov_Disable
local FullBright_Enable, FullBright_Disable
local FastInteract_Enable, FastInteract_Disable
local SpeedHack_Enable, SpeedHack_Disable
local JumpDelay_Set
local NoRecoil_Enable, NoRecoil_Disable
local AutoFireMode_Enable, AutoFireMode_Disable
local NoFallDamage_Enable, NoFallDamage_Disable
local Ragebot_Enable, Ragebot_Disable
local AntiAim_Enable, AntiAim_Disable


do
    local Fly_Enabled = false
    local Fly_Connection = nil

    Fly_Enable = function()
        if Fly_Enabled then return end
        Fly_Enabled = true
        Fly_Connection = RunService.RenderStepped:Connect(function(dt)
            if not Fly_Enabled then return end
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local cam = Workspace.CurrentCamera
            local velocity = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + cam.CFrame.RightVector
            end
            hrp.Velocity = velocity * P.Fly_Speed
            if P.Fly_Method == "Ragdoll" then
                local fly_event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("__RZDONL")
                if fly_event then
                    pcall(function()
                        fly_event:FireServer("__---r", Vector3.new(0, 0, 0), hrp.CFrame, false)
                    end)
                end
            end
        end)
    end

    Fly_Disable = function()
        if not Fly_Enabled then return end
        Fly_Enabled = false
        if Fly_Connection then
            Fly_Connection:Disconnect(); Fly_Connection = nil
        end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(0, 0, 0)
            end
            local _iter_part = char:GetDescendants()
            for _, part in ipairs(_iter_part) do
                if part:IsA("BasePart") then
                    pcall(function()
                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end
        end
    end
end

do
    local BredMakurz_Enabled = false
    local bredMakurzConnection = nil

    local function ApplyBredMakurzModification()
        local bredMakurzFolder = Workspace.Map:FindFirstChild("BredMakurz")
        if not bredMakurzFolder then return end
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        local playerPosition = character.HumanoidRootPart.Position
        local _iter_v = bredMakurzFolder:GetChildren()
        for _, v in pairs(_iter_v) do
            local objectPosition = nil
            if v:IsA("Model") then
                if v.PrimaryPart and v.PrimaryPart:IsA("BasePart") then
                    objectPosition = v.PrimaryPart.Position
                else
                    local part = v:FindFirstChildOfClass("BasePart")
                    if not part then
                        -- skip
                    else
                        objectPosition = part.Position
                    end
                end
            elseif v:IsA("BasePart") then
                objectPosition = v.Position
            else
                objectPosition = nil
            end
            if objectPosition then
            local distance = (objectPosition - playerPosition).Magnitude
            local existingGui = v:FindFirstChild("Ahh")
            if distance <= P.BredMakurz_Distance then
                if not existingGui then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "Ahh"; billboard.AlwaysOnTop = true
                    billboard.Size = UDim2.new(8, 0, 4, 0); billboard.MaxDistance = P.BredMakurz_Distance
                    if v:IsA("Model") and v.PrimaryPart then
                        billboard.Adornee = v
                    elseif v:IsA("Model") then
                        local part = v:FindFirstChildOfClass("BasePart")
                        if not part then
                            -- skip
                        else
                            billboard.Adornee = part
                        end
                    else
                        billboard.Adornee = v
                    end
                    billboard.Parent = v
                    local textLabel = Instance.new("TextLabel", billboard)
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Font = Enum.Font.SourceSansBold
                    textLabel.TextScaled = false; textLabel.TextSize = 15
                    textLabel.Text = formatName(v.Name)
                    local values = v:FindFirstChild("Values")
                    local brokenValue = values and values:FindFirstChild("Broken")
                    if brokenValue then
                        if brokenValue.Value ~= false then textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                        else textLabel.TextColor3 = Color3.fromRGB(0, 255, 0) end
                        brokenValue:GetPropertyChangedSignal("Value"):Connect(function()
                            if brokenValue.Value ~= false then textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                            else textLabel.TextColor3 = Color3.fromRGB(0, 255, 0) end
                        end)
                    else
                        textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                end
            elseif existingGui then
                existingGui:Destroy()
            end
            end
        end
    end

    _G.Pidors_BredMakurz = function(v)
        BredMakurz_Enabled = v
        if v then
            if bredMakurzConnection then bredMakurzConnection:Disconnect() end
            bredMakurzConnection = RunService.Heartbeat:Connect(ApplyBredMakurzModification)
        else
            if bredMakurzConnection then
                bredMakurzConnection:Disconnect(); bredMakurzConnection = nil
            end
            local folder = Workspace.Map:FindFirstChild("BredMakurz")
            if folder then
                local _iter_obj = folder:GetChildren()
                for _, obj in pairs(_iter_obj) do
                    pcall(function() local gui = obj:FindFirstChild("Ahh"); if gui then gui:Destroy() end end)
                end
            end
        end
    end

    _G.Pidors_BredMakurz_Distance = function(v)
        P.BredMakurz_Distance = v
        if BredMakurz_Enabled then
            local folder = Workspace.Map:FindFirstChild("BredMakurz")
            if folder then
                local _iter_obj = folder:GetChildren()
                for _, obj in pairs(_iter_obj) do
                    pcall(function() local gui = obj:FindFirstChild("Ahh"); if gui then gui:Destroy() end end)
                end
            end
        end
    end
end

do
    local ESP_Drawings = {}
    local ESP_Highlights = {}
    local ESP_CharConnections = {}
    local boneR6 = {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
    local boneR15 = {{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}}

    local function ESP_Create(Player)
        if ESP_Drawings[Player] then return end
        local ok, DrawingLib = pcall(function() return Drawing end)
        if not ok then return end
        local d = {Skeleton = {}}
        d.Box = DrawingLib.new("Square"); d.Box.Thickness = 1.5; d.Box.Filled = false; d.Box.Visible = false
        d.Name = DrawingLib.new("Text"); d.Name.Size = 16; d.Name.Center = true; d.Name.Outline = true; d.Name.Visible = false
        d.Dist = DrawingLib.new("Text"); d.Dist.Size = 14; d.Dist.Center = true; d.Dist.Outline = true; d.Dist.Visible = false
        d.HpBg = DrawingLib.new("Square"); d.HpBg.Filled = true; d.HpBg.Color = Color3.new(0,0,0); d.HpBg.Visible = false
        d.Hp = DrawingLib.new("Square"); d.Hp.Filled = true; d.Hp.Color = Color3.new(0,1,0); d.Hp.Visible = false
        d.Tracer = DrawingLib.new("Line"); d.Tracer.Thickness = 1.5; d.Tracer.Visible = false
        d.Tool = DrawingLib.new("Text"); d.Tool.Size = 14; d.Tool.Center = true; d.Tool.Outline = true; d.Tool.Visible = false
        for i = 1, 15 do d.Skeleton[i] = DrawingLib.new("Line"); d.Skeleton[i].Thickness = 1.5; d.Skeleton[i].Visible = false end
        ESP_Drawings[Player] = d

        local function onCharAdded(char)
            if ESP_Highlights[Player] then
                pcall(function() ESP_Highlights[Player]:Destroy() end)
                ESP_Highlights[Player] = nil
            end
            if ESP_CharConnections[Player] then
                pcall(function() ESP_CharConnections[Player]:Disconnect() end)
                ESP_CharConnections[Player] = nil
            end
            local hum = char:WaitForChild("Humanoid", 10)
            if hum then
                ESP_CharConnections[Player] = hum.Died:Connect(function()
                    if ESP_Highlights[Player] then
                        pcall(function() ESP_Highlights[Player]:Destroy() end)
                        ESP_Highlights[Player] = nil
                    end
                end)
            end
        end

        if Player.Character then
            task.spawn(onCharAdded, Player.Character)
        end
        ESP_CharConnections["_pa_" .. Player.UserId] = Player.CharacterAdded:Connect(onCharAdded)
    end

    local function ESP_Remove(Player)
        if ESP_Drawings[Player] then
            for k, drw in pairs(ESP_Drawings[Player]) do
                if k == "Skeleton" then
                    for _, ln in ipairs(drw) do
                        pcall(function() ln:Remove() end)
                    end
                else
                    pcall(function() drw:Remove() end)
                end
            end
            ESP_Drawings[Player] = nil
        end
        if ESP_Highlights[Player] then
            pcall(function() ESP_Highlights[Player]:Destroy() end); ESP_Highlights[Player] = nil
        end
        if ESP_CharConnections[Player] then
            pcall(function() ESP_CharConnections[Player]:Disconnect() end); ESP_CharConnections[Player] = nil
        end
        local paKey = "_pa_" .. Player.UserId
        if ESP_CharConnections[paKey] then
            pcall(function() ESP_CharConnections[paKey]:Disconnect() end); ESP_CharConnections[paKey] = nil
        end
    end

    local function ESP_HideAll(d)
        for k, drw in pairs(d) do
            if k == "Skeleton" then
                for _, ln in ipairs(drw) do ln.Visible = false
            end
            else drw.Visible = false end
        end
    end

    _G.Pidors_ESP_HideAll = function()
        for Player, d in pairs(ESP_Drawings) do ESP_HideAll(d) end
        for Player, hl in pairs(ESP_Highlights) do            pcall(function() hl.Enabled = false end)        end    end

    local function ESP_Update()
        local Camera = Workspace.CurrentCamera
        local camPos = Camera.CFrame.Position
        local vpX, vpY = Camera.ViewportSize.X, Camera.ViewportSize.Y
        local anyEnabled = P.ESP_Boxes or P.ESP_Names or P.ESP_Distance or P.ESP_Health or P.ESP_Tracers or P.ESP_Skeleton or P.ESP_Tool
        local chamsOnly = P.ESP_Chams and not anyEnabled
        for Player, d in pairs(ESP_Drawings) do
            local Char = Player.Character
            if not Char or not Char.Parent then
                if not chamsOnly then ESP_HideAll(d) end
                if ESP_Highlights[Player] then
                    pcall(function() ESP_Highlights[Player]:Destroy() end); ESP_Highlights[Player] = nil
                end
            else
            local Hum = Char:FindFirstChild("Humanoid")
            local Root = Char:FindFirstChild("HumanoidRootPart")
            if not Hum or not Root then
                if not chamsOnly then ESP_HideAll(d) end
                if ESP_Highlights[Player] then
                    ESP_Highlights[Player].Enabled = false
                end
            else
            local isDead = (Hum.Health <= 0) and (not Char:FindFirstChild("BodyEffects") or not Char.BodyEffects:FindFirstChild("Knocked") or not Char.BodyEffects.Knocked.Value)
            if isDead then
                if not chamsOnly then ESP_HideAll(d) end
                if ESP_Highlights[Player] then
                    pcall(function() ESP_Highlights[Player]:Destroy() end); ESP_Highlights[Player] = nil
                end
            else
            local dist = (camPos - Root.Position).Magnitude
            if dist > P.ESP_MaxDist then
                if not chamsOnly then ESP_HideAll(d) end
                if ESP_Highlights[Player] then
                    ESP_Highlights[Player].Enabled = false
                end
            else
            local rPos, onScr = Camera:WorldToViewportPoint(Root.Position)
            if not onScr then
                if not chamsOnly then ESP_HideAll(d) end
                if ESP_Highlights[Player] then
                    ESP_Highlights[Player].Enabled = false
                end
            else
            local Head = Char:FindFirstChild("Head")
            local hPos
            if Head then
                hPos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0,0.5,0))
            else
                hPos = Camera:WorldToViewportPoint(Root.Position + Vector3.new(0,2,0))
            end
            local lPos = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0,3,0))
            local h = math.abs(hPos.Y - lPos.Y)
            local w = h / 2
            if P.ESP_Boxes then
                d.Box.Size = Vector2.new(w, h); d.Box.Position = Vector2.new(rPos.X - w/2, hPos.Y)
                d.Box.Color = P.ESP_BoxColor; d.Box.Visible = true
            else d.Box.Visible = false end
            if P.ESP_Names then
                d.Name.Text = Player.Name; d.Name.Position = Vector2.new(rPos.X, hPos.Y - 20)
                d.Name.Color = P.ESP_NameColor; d.Name.Visible = true
            else d.Name.Visible = false end
            if P.ESP_Distance then
                d.Dist.Text = "[" .. math.floor(dist) .. "m]"; d.Dist.Position = Vector2.new(rPos.X, lPos.Y + 5)
                d.Dist.Color = P.ESP_DistColor; d.Dist.Visible = true
            else d.Dist.Visible = false end
            if P.ESP_Health then
                local maxHp
                if Hum.MaxHealth > 0 then
                    maxHp = Hum.MaxHealth
                else
                    maxHp = 100
                end
                local rawHp = Hum.Health
                if rawHp <= 0 then
                    rawHp = maxHp
                end
                local hs = math.clamp(rawHp / maxHp, 0, 1)
                d.HpBg.Size = Vector2.new(4, h); d.HpBg.Position = Vector2.new(rPos.X - w/2 - 6, hPos.Y); d.HpBg.Visible = true
                d.Hp.Size = Vector2.new(2, h * hs); d.Hp.Position = Vector2.new(rPos.X - w/2 - 5, hPos.Y + h * (1 - hs))
                d.Hp.Color = Color3.new(1 - hs, hs, 0); d.Hp.Visible = true
            else d.HpBg.Visible = false; d.Hp.Visible = false end
            if P.ESP_Tracers then
                local orig = Vector2.new(vpX / 2, vpY)
                if P.ESP_TracerOrigin == "Center" then orig = Vector2.new(vpX / 2, vpY / 2)
                elseif P.ESP_TracerOrigin == "Mouse" then orig = UserInputService:GetMouseLocation() end
                d.Tracer.From = orig; d.Tracer.To = Vector2.new(rPos.X, lPos.Y)
                d.Tracer.Color = P.ESP_TracerColor; d.Tracer.Visible = true
            else d.Tracer.Visible = false end
            local ToolItem = Char:FindFirstChildOfClass("Tool")
            if P.ESP_Tool and ToolItem then
                d.Tool.Text = ToolItem.Name
                local _tool_y_offset
                if P.ESP_Distance then
                    _tool_y_offset = 20 else _tool_y_offset = 5
                end
                d.Tool.Position = Vector2.new(rPos.X, lPos.Y + _tool_y_offset)
                d.Tool.Color = P.ESP_ToolColor; d.Tool.Visible = true
            else d.Tool.Visible = false end
            if P.ESP_Skeleton then
                local bones
                if Char:FindFirstChild("UpperTorso") then
                    bones = boneR15
                else
                    bones = boneR6
                end
                local boneCount = #bones
                for i = 1, boneCount do
                    local ln = d.Skeleton[i]; local pair = bones[i]
                    if pair then
                        local p1 = Char:FindFirstChild(pair[1]); local p2 = Char:FindFirstChild(pair[2])
                        if p1 and p2 then
                            local a = Camera:WorldToViewportPoint(p1.Position); local b = Camera:WorldToViewportPoint(p2.Position)
                            ln.From = Vector2.new(a.X, a.Y); ln.To = Vector2.new(b.X, b.Y)
                            ln.Color = P.ESP_SkelColor; ln.Visible = true
                        else ln.Visible = false end
                    else ln.Visible = false end
                end
                for i = boneCount + 1, #d.Skeleton do d.Skeleton[i].Visible = false end
            else
                for _, ln in ipairs(d.Skeleton) do ln.Visible = false end
            end
            if P.ESP_Chams then
                if not ESP_Highlights[Player] or not ESP_Highlights[Player].Parent then
                    ESP_Highlights[Player] = nil
                end
                if not ESP_Highlights[Player] then
                    local hl = Instance.new("Highlight"); hl.Adornee = Char; hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
                    pcall(function() hl.Parent = game:GetService("CoreGui") end)
                    if not hl.Parent then
                        hl.Parent = LocalPlayer:WaitForChild("PlayerGui")
                    end
                    ESP_Highlights[Player] = hl
                end
                if ESP_Highlights[Player].Adornee ~= Char then
                    ESP_Highlights[Player].Adornee = Char
                end
                ESP_Highlights[Player].FillColor = P.ESP_ChamsFill
                ESP_Highlights[Player].OutlineColor = P.ESP_ChamsOutline
                ESP_Highlights[Player].Enabled = true
            else
                if ESP_Highlights[Player] then
                    ESP_Highlights[Player].Enabled = false
                end
            end
            end
            end
            end
            end
        end
    end

    local _iter_plr = Players:GetPlayers()
    for _, plr in ipairs(_iter_plr) do
        if plr ~= LocalPlayer then ESP_Create(plr) end
    end
    Players.PlayerAdded:Connect(function(plr) ESP_Create(plr) end)
    Players.PlayerRemoving:Connect(ESP_Remove)

    RunService.Heartbeat:Connect(function()
        if P.ESP_Enabled and (P.ESP_Boxes or P.ESP_Names or P.ESP_Distance or P.ESP_Health or P.ESP_Tracers or P.ESP_Chams or P.ESP_Skeleton or P.ESP_Tool) then
            ESP_Update()
        end
    end)
end

do
    local Noclip_Enabled = false
    local Noclip_Connection = nil
    local originalCollisions = {}

    Noclip_Enable = function()
        if Noclip_Enabled then return end
        Noclip_Enabled = true
        local char = LocalPlayer.Character
        if char then
            local _iter_part = char:GetDescendants()
            for _, part in pairs(_iter_part) do
                if part:IsA("BasePart") then
                    if part.CanCollide then
                        originalCollisions[part] = true; part.CanCollide = false
                    end
                end
            end
        end
        if not Noclip_Connection then
            Noclip_Connection = RunService.RenderStepped:Connect(function()
                if not Noclip_Enabled then return end
                local char = LocalPlayer.Character
                if char then
                    local _iter_part = char:GetDescendants()
                    for _, part in pairs(_iter_part) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end

    Noclip_Disable = function()
        if not Noclip_Enabled then return end
        Noclip_Enabled = false
        if Noclip_Connection then
            Noclip_Connection:Disconnect(); Noclip_Connection = nil
        end
        local char = LocalPlayer.Character
        if char then
            local _iter_part = char:GetDescendants()
            for _, part in pairs(_iter_part) do
                if part:IsA("BasePart") then
                    if originalCollisions[part] then
                        part.CanCollide = true
                    end
                end
            end
        end
        originalCollisions = {}
    end

    local SpeedHack_Enabled = false
    local SpeedHack_Connection = nil

    SpeedHack_Enable = function()
        if SpeedHack_Enabled then return end
        SpeedHack_Enabled = true
        if not SpeedHack_Connection then
            SpeedHack_Connection = RunService.Heartbeat:Connect(function()
                if not SpeedHack_Enabled then return end
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hum or not hrp then return end
                if hum.MoveDirection.Magnitude > 0 then
                    hrp.AssemblyLinearVelocity = (hum.MoveDirection * P.SpeedHack_Value) + Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
            end)
        end
    end

    SpeedHack_Disable = function()
        if not SpeedHack_Enabled then return end
        SpeedHack_Enabled = false
        if SpeedHack_Connection then
            SpeedHack_Connection:Disconnect(); SpeedHack_Connection = nil
        end
    end

    JumpDelay_Set = function(val)
        P.JumpDelay_Value = val
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.JumpCooldown = val
            end
        end)
    end
end

do
    local FastInteract_Enabled = false
    local FastInteract_Connection = nil
    local FastInteract_PPConnection = nil

    FastInteract_Enable = function()
        if FastInteract_Enabled then return end
        FastInteract_Enabled = true
        local function bypassPrompts()
            local _iter_v = Workspace:GetDescendants()
            for _, v in pairs(_iter_v) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                end
            end
        end
        bypassPrompts()
        local _ppService = game:GetService("ProximityPromptService")
        FastInteract_PPConnection = _ppService.PromptButtonHoldBegan:Connect(function(v)
            if FastInteract_Enabled then
                v.HoldDuration = 0
            end
        end)
        FastInteract_Connection = Workspace.DescendantAdded:Connect(function(v)
            if FastInteract_Enabled and v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
            end
        end)
    end

    FastInteract_Disable = function()
        if not FastInteract_Enabled then return end
        FastInteract_Enabled = false
        if FastInteract_PPConnection then
            FastInteract_PPConnection:Disconnect(); FastInteract_PPConnection = nil
        end
        if FastInteract_Connection then
            FastInteract_Connection:Disconnect(); FastInteract_Connection = nil
        end
    end

    local Fov_Enabled = false
    local Fov_Connection = nil
    local Fov_Original = 70

    Fov_Enable = function()
        if Fov_Enabled then return end
        Fov_Original = Workspace.CurrentCamera.FieldOfView
        Fov_Enabled = true
        Workspace.CurrentCamera.FieldOfView = P.Fov_Value
        if not Fov_Connection then
            Fov_Connection = RunService.RenderStepped:Connect(function()
                if Fov_Enabled then
                    Workspace.CurrentCamera.FieldOfView = P.Fov_Value
                end
            end)
        end
    end

    Fov_Disable = function()
        if not Fov_Enabled then return end
        Fov_Enabled = false
        Workspace.CurrentCamera.FieldOfView = Fov_Original
        if Fov_Connection then
            Fov_Connection:Disconnect(); Fov_Connection = nil
        end
    end

    _G.Pidors_Fov_SetValue = function(v)
        P.Fov_Value = v
        if Fov_Enabled then
            Workspace.CurrentCamera.FieldOfView = v
        end
    end

    local FullBright_Enabled = false
    local FullBright_Connection = nil
    local OriginalLighting = {
        ClockTime = Lighting.ClockTime, Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        ColorShift_Top = Lighting.ColorShift_Top, FogStart = Lighting.FogStart, FogEnd = Lighting.FogEnd,
    }

    FullBright_Enable = function()
        if FullBright_Enabled then return end
        FullBright_Enabled = true
        Lighting.Brightness = 5; Lighting.ClockTime = 14
        Lighting.Ambient = Color3.new(1, 1, 1); Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0); Lighting.FogStart = 100000; Lighting.FogEnd = 100000
        FullBright_Connection = RunService.RenderStepped:Connect(function()
            if not FullBright_Enabled then return end
            if Lighting.Brightness ~= 5 then
                Lighting.Brightness = 5
            end
            if Lighting.ClockTime ~= 14 then
                Lighting.ClockTime = 14
            end
            if Lighting.Ambient ~= Color3.new(1, 1, 1) then
                Lighting.Ambient = Color3.new(1, 1, 1)
            end
            if Lighting.OutdoorAmbient ~= Color3.new(1, 1, 1) then
                Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            end
            if Lighting.ColorShift_Top ~= Color3.new(0, 0, 0) then
                Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            end
            if Lighting.FogStart ~= 100000 then
                Lighting.FogStart = 100000
            end
            if Lighting.FogEnd ~= 100000 then
                Lighting.FogEnd = 100000
            end
        end)
    end

    FullBright_Disable = function()
        if not FullBright_Enabled then return end
        FullBright_Enabled = false
        if FullBright_Connection then
            FullBright_Connection:Disconnect(); FullBright_Connection = nil
        end
        Lighting.Brightness = OriginalLighting.Brightness; Lighting.ClockTime = OriginalLighting.ClockTime
        Lighting.Ambient = OriginalLighting.Ambient; Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.ColorShift_Top = OriginalLighting.ColorShift_Top
        Lighting.FogStart = OriginalLighting.FogStart; Lighting.FogEnd = OriginalLighting.FogEnd
    end

    local AntiAFK_Enabled = false
    local AntiAFK_Connection = nil

    AntiAFK_Enable = function()
        if AntiAFK_Enabled then return end
        AntiAFK_Enabled = true
        local VirtualUser = game:GetService("VirtualUser")
        AntiAFK_Connection = LocalPlayer.Idled:Connect(function()
            if AntiAFK_Enabled then                VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new())            end        end)
    end

    AntiAFK_Disable = function()
        if not AntiAFK_Enabled then return end
        AntiAFK_Enabled = false
        if AntiAFK_Connection then
            AntiAFK_Connection:Disconnect(); AntiAFK_Connection = nil
        end
    end
end

do
    local NoFailLockpick_Enabled = false
    local lockpickAddedConnection = nil

    NoFailLockpick_Enable = function()
        if NoFailLockpick_Enabled then return end
        NoFailLockpick_Enabled = true
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not PlayerGui then return end
        lockpickAddedConnection = PlayerGui.ChildAdded:Connect(function(Item)
            if Item.Name == "LockpickGUI" then
                local mf = Item:WaitForChild("MF", 10)
                if not mf then return end
                local lpFrame = mf:WaitForChild("LP_Frame", 10)
                if not lpFrame then return end
                local frames = lpFrame:WaitForChild("Frames", 10)
                if not frames then return end
                local b1 = frames:WaitForChild("B1", 10)
                local b2 = frames:WaitForChild("B2", 10)
                local b3 = frames:WaitForChild("B3", 10)
                if b1 and b1:FindFirstChild("Bar") and b1.Bar:FindFirstChild("UIScale") then
                    b1.Bar.UIScale.Scale = 10
                end
                if b2 and b2:FindFirstChild("Bar") and b2.Bar:FindFirstChild("UIScale") then
                    b2.Bar.UIScale.Scale = 10
                end
                if b3 and b3:FindFirstChild("Bar") and b3.Bar:FindFirstChild("UIScale") then
                    b3.Bar.UIScale.Scale = 10
                end
            end
        end)
    end

    NoFailLockpick_Disable = function()
        if not NoFailLockpick_Enabled then return end
        NoFailLockpick_Enabled = false
        if lockpickAddedConnection then
            lockpickAddedConnection:Disconnect(); lockpickAddedConnection = nil
        end
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not PlayerGui then return end
        local lockpickGui = PlayerGui:FindFirstChild("LockpickGUI")
        if lockpickGui then
            local mf = lockpickGui:FindFirstChild("MF")
            if mf then
                local lpFrame = mf:FindFirstChild("LP_Frame")
                if lpFrame then
                    local bars = lpFrame:FindFirstChild("Frames")
                    if bars then
                        if bars:FindFirstChild("B1") and bars.B1:FindFirstChild("Bar") and bars.B1.Bar:FindFirstChild("UIScale") then
                            bars.B1.Bar.UIScale.Scale = 1
                        end
                        if bars:FindFirstChild("B2") and bars.B2:FindFirstChild("Bar") and bars.B2.Bar:FindFirstChild("UIScale") then
                            bars.B2.Bar.UIScale.Scale = 1
                        end
                        if bars:FindFirstChild("B3") and bars.B3:FindFirstChild("Bar") and bars.B3.Bar:FindFirstChild("UIScale") then
                            bars.B3.Bar.UIScale.Scale = 1
                        end
                    end
                end
            end
        end
    end

    local OpenNearbyDoors_Enabled = false
    local UnlockNearbyDoors_Enabled = false
    local DoorCoroutine = nil

    local function DoorLoop()
        while (OpenNearbyDoors_Enabled or UnlockNearbyDoors_Enabled) do
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then task.wait(0.5)
            else
            local doorsFolder = Workspace.Map:FindFirstChild("Doors")
            if not doorsFolder then
                OpenNearbyDoors_Enabled = false; UnlockNearbyDoors_Enabled = false; break
            end
            local playerPos = hrp.Position
            local _iter_doorInstance = doorsFolder:GetChildren()
            for _, doorInstance in ipairs(_iter_doorInstance) do
                local doorBase = doorInstance:FindFirstChild("DoorBase")
                local valuesFolder = doorInstance:FindFirstChild("Values")
                local eventsFolder = doorInstance:FindFirstChild("Events")
                if doorBase and valuesFolder and eventsFolder then
                    if (playerPos - doorBase.Position).Magnitude <= 6 then
                        local toggleEvent = eventsFolder:FindFirstChild("Toggle")
                        if toggleEvent then
                        if UnlockNearbyDoors_Enabled then
                            local lockedValue = valuesFolder:FindFirstChild("Locked")
                            local lockArgument = doorInstance:FindFirstChild("Lock")
                            if lockedValue and lockArgument and typeof(lockedValue.Value) == "boolean" and lockedValue.Value == true then
                                pcall(function() toggleEvent:FireServer("Unlock", lockArgument) end)
                            end
                        end
                        if OpenNearbyDoors_Enabled then
                            local openValue = valuesFolder:FindFirstChild("Open")
                            local knobArgument = doorInstance:FindFirstChild("Knob2") or doorInstance:FindFirstChild("Knob")
                            if openValue and knobArgument and typeof(openValue.Value) == "boolean" and openValue.Value == false then
                                local isLocked = valuesFolder:FindFirstChild("Locked")
                                if not isLocked or isLocked.Value == false or not UnlockNearbyDoors_Enabled then
                                    pcall(function() toggleEvent:FireServer("Open", knobArgument) end)
                                end
                            end
                        end
                        end
                    end
                end
            end
            task.wait(0.25)
            end
        end
        DoorCoroutine = nil
    end

    local function StartDoorLoop()
        if (OpenNearbyDoors_Enabled or UnlockNearbyDoors_Enabled) and not DoorCoroutine then
            DoorCoroutine = task.spawn(DoorLoop)
        end
    end

    OpenNearbyDoors_Enable = function()
        if OpenNearbyDoors_Enabled then return end
        OpenNearbyDoors_Enabled = true; StartDoorLoop()
    end
    OpenNearbyDoors_Disable = function()
        if not OpenNearbyDoors_Enabled then return end
        OpenNearbyDoors_Enabled = false; StartDoorLoop()
    end
    UnlockNearbyDoors_Enable = function()
        if UnlockNearbyDoors_Enabled then return end
        UnlockNearbyDoors_Enabled = true; StartDoorLoop()
    end
    UnlockNearbyDoors_Disable = function()
        if not UnlockNearbyDoors_Enabled then return end
        UnlockNearbyDoors_Enabled = false; StartDoorLoop()
    end

    local AutoPickupMoney_Enabled = false
    local AutoPickupMoney_Connection = nil
    local AutoPickupMoney_Coroutine = nil

    local function AutoPickupMoney_Logic()
        local cashFolder = Workspace.Filter:FindFirstChild("SpawnedBread")
        local remoteEvent = ReplicatedStorage.Events:FindFirstChild("CZDPZUS")
        if not cashFolder or not remoteEvent then
            AutoPickupMoney_Enabled = false
            if AutoPickupMoney_Connection then
                AutoPickupMoney_Connection:Disconnect(); AutoPickupMoney_Connection = nil
            end
            return
        end
        AutoPickupMoney_Connection = RunService.RenderStepped:Connect(function()
            if not AutoPickupMoney_Enabled then return end
            if Settings.IsDead then return end
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if CoolDowns.AutoPickUps.MoneyCooldown then return end
            local rootPosition = hrp.Position
            local _iter_v = cashFolder:GetChildren()
            for _, v in ipairs(_iter_v) do
                if (rootPosition - v.Position).Magnitude < 5 then
                    if not CoolDowns.AutoPickUps.MoneyCooldown then
                        CoolDowns.AutoPickUps.MoneyCooldown = true
                        pcall(function() remoteEvent:FireServer(v) end)
                        task.wait(1)
                        CoolDowns.AutoPickUps.MoneyCooldown = false
                        break
                    end
                end
            end
        end)
    end

    AutoPickupMoney_Enable = function()
        if AutoPickupMoney_Enabled then return end
        AutoPickupMoney_Enabled = true
        if AutoPickupMoney_Connection then
            AutoPickupMoney_Connection:Disconnect(); AutoPickupMoney_Connection = nil
        end
        if AutoPickupMoney_Coroutine then
            pcall(coroutine.close, AutoPickupMoney_Coroutine); AutoPickupMoney_Coroutine = nil
        end
        AutoPickupMoney_Coroutine = coroutine.create(AutoPickupMoney_Logic)
        coroutine.resume(AutoPickupMoney_Coroutine)
    end

    AutoPickupMoney_Disable = function()
        if not AutoPickupMoney_Enabled then return end
        AutoPickupMoney_Enabled = false
        if AutoPickupMoney_Connection then
            AutoPickupMoney_Connection:Disconnect(); AutoPickupMoney_Connection = nil
        end
        if AutoPickupMoney_Coroutine then
            pcall(coroutine.close, AutoPickupMoney_Coroutine); AutoPickupMoney_Coroutine = nil
        end
        if CoolDowns and CoolDowns.AutoPickUps then
            CoolDowns.AutoPickUps.MoneyCooldown = false
        end
    end
end

do
    local Shadow_Active = false
    local Shadow_Usable = true
    local Shadow_HMND = nil
    local Shadow_HRP = nil
    local Shadow_Char = nil
    local Shadow_AnimTrack = nil
    local Shadow_CamoAnim = Instance.new("Animation")
    Shadow_CamoAnim.AnimationId = "rbxassetid://215384594"
    local Shadow_WarningText = nil

    do
        local HUD = Instance.new("ScreenGui")
        HUD.Name = "ShadowWarningHUD"; HUD.ResetOnSpawn = false; HUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function() HUD.Parent = cloneref(game:GetService("CoreGui")) end)
        if not HUD.Parent then
            HUD.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
        Shadow_WarningText = Instance.new("TextLabel", HUD)
        Shadow_WarningText.Text = "You are visible"
        Shadow_WarningText.Visible = false; Shadow_WarningText.Size = UDim2.new(0, 200, 0, 30)
        Shadow_WarningText.Position = UDim2.new(0.5, -100, 0.85, 0)
        Shadow_WarningText.BackgroundTransparency = 1; Shadow_WarningText.Font = Enum.Font.GothamSemibold
        Shadow_WarningText.TextSize = 24; Shadow_WarningText.TextColor3 = Color3.fromRGB(255, 255, 0)
        Shadow_WarningText.TextStrokeTransparency = 0.5; Shadow_WarningText.ZIndex = 10
    end

    local function Shadow_RefreshCharRefs()
        Shadow_Char = LocalPlayer.Character
        if Shadow_Char then Shadow_HRP = Shadow_Char:FindFirstChild("HumanoidRootPart"); Shadow_HMND = Shadow_Char:FindFirstChildOfClass("Humanoid")
        else Shadow_HRP = nil; Shadow_HMND = nil end
    end

    local function Shadow_CheckGrounded()
        return Shadow_HMND and Shadow_HMND:IsDescendantOf(Workspace) and Shadow_HMND.FloorMaterial ~= Enum.Material.Air
    end

    local function Shadow_CacheAnimTrack()
        if Shadow_AnimTrack then
            pcall(function() Shadow_AnimTrack:Stop() end); Shadow_AnimTrack = nil
        end
        if Shadow_HMND then
            local success, result = pcall(function() return Shadow_HMND:LoadAnimation(Shadow_CamoAnim) end)
            if success then Shadow_AnimTrack = result; Shadow_AnimTrack.Priority = Enum.AnimationPriority.Action4
            else Shadow_AnimTrack = nil end
        end
    end

    Shadow_Disable = function()
        if not Shadow_Active then return end
        Shadow_Active = false
        if Shadow_AnimTrack then            pcall(function() Shadow_AnimTrack:Stop() end)        end        if Shadow_HMND then
            Workspace.CurrentCamera.CameraSubject = Shadow_HMND
        end
        if Shadow_Char then
            local _iter_v = Shadow_Char:GetDescendants()
            for _, v in pairs(_iter_v) do
                if v:IsA("BasePart") and v.Transparency == 0.5 then
                    v.Transparency = 0
                end
            end
        end
        if Shadow_WarningText then
            Shadow_WarningText.Visible = false
        end
    end

    Shadow_Enable = function()
        if Shadow_Active or not Shadow_Usable then return end
        Shadow_RefreshCharRefs()
        if not Shadow_Char or not Shadow_HMND or not Shadow_HRP then return end
        if not Shadow_Char:FindFirstChild("Torso") then            Library:Notify("Invisible: R6 Avatar required!", 3); return        end        Shadow_Active = true
        Workspace.CurrentCamera.CameraSubject = Shadow_HRP
        Shadow_CacheAnimTrack()
    end

    local function ShadowStep(deltaTime)
        if not Shadow_Char or not Shadow_HMND or not Shadow_HRP or not Shadow_HMND:IsDescendantOf(Workspace) or Shadow_HMND.Health <= 0 then
            if Shadow_WarningText then Shadow_WarningText.Visible = false end; return
        end
        if Shadow_WarningText then
            Shadow_WarningText.Visible = not Shadow_CheckGrounded()
        end
        local walk_speed = 12
        if Shadow_HMND.MoveDirection.Magnitude > 0 then
            Shadow_HRP.CFrame = Shadow_HRP.CFrame + Shadow_HMND.MoveDirection * walk_speed * deltaTime
        end
        local InitialCFrame = Shadow_HRP.CFrame
        local InitialCamOffset = Shadow_HMND.CameraOffset
        local _, yaw_angle = Workspace.CurrentCamera.CFrame:ToOrientation()
        Shadow_HRP.CFrame = CFrame.new(Shadow_HRP.CFrame.Position) * CFrame.fromOrientation(0, yaw_angle, 0)
        Shadow_HRP.CFrame = Shadow_HRP.CFrame * CFrame.Angles(math.rad(90), 0, 0)
        Shadow_HMND.CameraOffset = Vector3.new(0, 1.44, 0)
        if Shadow_AnimTrack then
            pcall(function()
                if not Shadow_AnimTrack.IsPlaying then Shadow_AnimTrack:Play() end
                Shadow_AnimTrack:AdjustSpeed(0); Shadow_AnimTrack.TimePosition = 0.3
            end)
        elseif Shadow_HMND and Shadow_HMND.Health > 0 then Shadow_CacheAnimTrack() end
        RunService.RenderStepped:Wait()
        if Shadow_HMND and Shadow_HMND:IsDescendantOf(Workspace) then
            Shadow_HMND.CameraOffset = InitialCamOffset
        end
        if Shadow_HRP and Shadow_HRP:IsDescendantOf(Workspace) then
            Shadow_HRP.CFrame = InitialCFrame
        end
        if Shadow_AnimTrack then            pcall(function() Shadow_AnimTrack:Stop() end)        end        if Shadow_HRP and Shadow_HRP:IsDescendantOf(Workspace) then
            local LookVec = Workspace.CurrentCamera.CFrame.LookVector
            local FlatLook = Vector3.new(LookVec.X, 0, LookVec.Z).Unit
            if FlatLook.Magnitude > 0.1 then
                Shadow_HRP.CFrame = CFrame.new(Shadow_HRP.Position, Shadow_HRP.Position + FlatLook)
            end
        end
        if Shadow_Char then
            local _iter_v = Shadow_Char:GetDescendants()
            for _, v in pairs(_iter_v) do
                if v:IsA("BasePart") and v.Transparency ~= 1 then
                    v.Transparency = 0.5
                end
            end
        end
    end

    RunService.Heartbeat:Connect(function(deltaTime)
        if not Shadow_Active or not Shadow_Usable then
            if not Shadow_Active and Shadow_Char then
                local _iter_v = Shadow_Char:GetDescendants()
                for _, v in pairs(_iter_v) do
                    if v:IsA("BasePart") and v.Transparency == 0.5 then
                        v.Transparency = 0
                    end
                end
            end
            if Shadow_WarningText then
                Shadow_WarningText.Visible = false
            end
            return
        end
        ShadowStep(deltaTime)
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        if Shadow_Active then Shadow_Disable() end
        if Shadow_AnimTrack then
            pcall(function() Shadow_AnimTrack:Stop() end); Shadow_AnimTrack = nil
        end
        task.wait(); Shadow_RefreshCharRefs()
        if Shadow_HMND then
            if Shadow_HMND.RigType ~= Enum.HumanoidRigType.R6 then Shadow_Usable = false; Library:Notify("Invisible: Non-R6 Avatar detected!", 3)
            else Shadow_Usable = true end
        end
    end)

    LocalPlayer.CharacterRemoving:Connect(function()
        if Shadow_AnimTrack then
            pcall(function() Shadow_AnimTrack:Stop() end); Shadow_AnimTrack = nil
        end
        if Shadow_WarningText then
            Shadow_WarningText.Visible = false
        end
    end)

    Shadow_RefreshCharRefs()
    if Shadow_Char and not Shadow_Char:FindFirstChild("Torso") then
        Shadow_Usable = false
    end
end

do
    local AdminCheck_Enabled = false
    local AdminCheck_Connection = nil

    local staffPlayers = {
        groups = {
            [4165692] = { ["Tester"] = true, ["Contributor"] = true, ["Tester+"] = true, ["Developer"] = true,
                ["Developer+"] = true, ["Community Manager"] = true, ["Manager"] = true, ["Owner"] = true },
            [32406137] = { ["Junior"] = true, ["Moderator"] = true, ["Senior"] = true, ["Administrator"] = true,
                ["Manager"] = true, ["Holder"] = true },
            [8024440] = { ["zzzz"] = true, ["reshape enjoyer"] = true, ["i heart reshape"] = true, ["reshape superfan"] = true },
            [14927228] = { ["\xe2\x99\x9e"] = true },
        },
        users = {
            3294804378, 93676120, 54087314, 81275825, 140837601, 1229486091, 46567801, 418086275, 29706395,
            3717066084, 1424338327, 5046662686, 5046661126, 5046659439, 418199326, 1024216621, 1810535041,
            63238912, 111250044, 63315426, 730176906, 141193516, 194512073, 193945439, 412741116, 195538733,
            102045519, 955294, 957835150, 25689921, 366613818, 281593651, 455275714, 208929505, 96783330,
            156152502, 93281166, 959606619, 142821118, 632886139, 175931803, 122209625, 278097946, 142989311,
            1517131734, 446849296, 87189764, 67180844, 9212846, 47352513, 48058122, 155413858, 10497435,
            513615792, 55893752, 55476024, 151691292, 136584758, 16983447, 3111449, 94693025, 271400893,
            5005262660, 295331237, 64489098, 244844600, 114332275, 25048901, 69262878, 50801509, 92504899,
            42066711, 50585425, 31365111, 166406495, 2457253857, 29761878, 21831137, 948293345, 439942262,
            38578487, 1163048, 7713309208, 3659305297, 15598614, 34616594, 626833004, 198610386, 153835477,
            3923114296, 3937697838, 102146039, 119861460, 371665775, 1206543842, 93428604, 1863173316, 90814576,
            374665997, 423005063, 140172831, 42662179, 9066859, 438805620, 14855669, 727189337, 1871290386,
            608073286,
        },
    }

    local function hasTracker(player)
        if not player or not player:IsA("Player") then return false, nil end
        for i = 1, #player:GetChildren() do
            local _children = player:GetChildren()
            local child = _children[i]
            if typeof(child.Name) == "string" and string.sub(child.Name, -8) == "Tracker$" then
                local trackedPlayerName = string.sub(child.Name, 1, -9)
                if Players:FindFirstChild(trackedPlayerName) then return true, trackedPlayerName end
            end
        end
        return false, nil
    end

    local function isStaff(player)
        if not player or not player:IsA("Player") then return false end
        for groupID, roles in pairs(staffPlayers.groups) do
            local successRank, rank = pcall(function() return player:GetRankInGroup(groupID) end)
            if successRank and rank and rank > 0 then
                local successRole, roleName = pcall(function() return player:GetRoleInGroup(groupID) end)
                if successRole and roleName and roles[roleName] then return true, roleName, groupID end
            end
        end
        for i = 1, #staffPlayers.users do
            if player.UserId == staffPlayers.users[i] then return true, "UserID", player.UserId end
        end
        return false
    end

    local function onPlayerJoining(player)
        if not AdminCheck_Enabled then return end
        local isPlayerStaff, role, groupID = isStaff(player)
        local hasTrackers, trackedPlayer = hasTracker(player)
        if isPlayerStaff or hasTrackers then
            LocalPlayer:Kick("Staff detected: " .. player.Name)
        end
    end

    AdminCheck_Enable = function()
        if AdminCheck_Enabled then return end
        AdminCheck_Enabled = true
        AdminCheck_Connection = Players.PlayerAdded:Connect(onPlayerJoining)
        task.spawn(function()
            local _iter_player = Players:GetPlayers()
            for _, player in ipairs(_iter_player) do
                if player ~= LocalPlayer then
                    local isPlayerStaff = isStaff(player)
                    local hasTrackers = hasTracker(player)
                    if isPlayerStaff or hasTrackers then
                        AdminCheck_Enabled = false
                        if AdminCheck_Connection then
                            AdminCheck_Connection:Disconnect(); AdminCheck_Connection = nil
                        end
                        LocalPlayer:Kick("Staff detected: " .. player.Name)
                        return
                    end
                end
            end
        end)
    end

    AdminCheck_Disable = function()
        if not AdminCheck_Enabled then return end
        AdminCheck_Enabled = false
        if AdminCheck_Connection then
            AdminCheck_Connection:Disconnect(); AdminCheck_Connection = nil
        end
    end

    local MeleeAura_Enabled = false
    local MeleeAura_Connection = nil

    local function runAttackLoop()
        local me = LocalPlayer
        local eventsFolder = ReplicatedStorage:WaitForChild("Events", 10)
        if not eventsFolder then return nil end
        local remote1 = eventsFolder:WaitForChild("XMHH.2", 10)
        local remote2 = eventsFolder:WaitForChild("XMHH2.2", 10)
        local maxdist = 5

        local function Attack(target)
            if not (target and target:FindFirstChild("Head")) then return end
            local char = me.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not remote1 or not remote1:IsA("RemoteFunction") then return end
            if not remote2 or not remote2:IsA("RemoteEvent") then return end
            local arg1 = { [1] = "\xF0\x9F\x8D\x9E", [2] = tick(), [3] = tool, [4] = "43TRFWX", [5] = "Normal", [6] = tick(), [7] = true }
            local success1, result = pcall(function() return remote1:InvokeServer(unpack(arg1)) end)
            if not success1 then return end
            task.wait(0.1)
            local Handle
            if tool then
                Handle = tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")
            end
            if not Handle and char then
                Handle = char:FindFirstChild("Right Arm")
            end
            local head = target:FindFirstChild("Head")
            if Handle and head and hrp then
                local arg2 = { [1] = "\xF0\x9F\x8D\x9E", [2] = tick(), [3] = tool, [4] = "2389ZFX34", [5] = result, [6] = false, [7] = Handle, [8] = head, [9] = target, [10] = hrp.Position, [11] = head.Position }
                pcall(function() remote2:FireServer(unpack(arg2)) end)
            end
        end

        return RunService.RenderStepped:Connect(function()
            if not MeleeAura_Enabled then return end
            local char = me.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local _iter_plr = Players:GetPlayers()
                for _, plr in ipairs(_iter_plr) do
                    if plr ~= me then
                        local c = plr.Character
                        local hrp2 = c and c:FindFirstChild("HumanoidRootPart")
                        local hum = c and c:FindFirstChildOfClass("Humanoid")
                        if hrp2 and hum then
                            local dist = (hrp.Position - hrp2.Position).Magnitude
                            if dist < maxdist and hum.Health > 15 and not c:FindFirstChildOfClass("ForceField") then Attack(c) end
                        end
                    end
                end
            end
        end)
    end

    MeleeAura_Enable = function()
        if MeleeAura_Enabled then return end
        MeleeAura_Enabled = true
        if MeleeAura_Connection and MeleeAura_Connection.Connected then MeleeAura_Connection:Disconnect() end
        MeleeAura_Connection = runAttackLoop()
    end

    MeleeAura_Disable = function()
        if not MeleeAura_Enabled then return end
        MeleeAura_Enabled = false
        if MeleeAura_Connection and MeleeAura_Connection.Connected then
            MeleeAura_Connection:Disconnect(); MeleeAura_Connection = nil
        end
    end

    local MeleeUp_Enabled = false
    local MeleeUp_Connection = nil
    local MeleeUp_Tick = tick()
    local MeleeUp_CD = {
        ["Fists"] = 0.05, ["Knuckledusters"] = 0.05, ["Nunchucks"] = 0.05,
        ["Shiv"] = 0.05, ["Bat"] = 1, ["Metal-Bat"] = 1,
        ["Chainsaw"] = 2.5, ["Balisong"] = 0.05, ["Rambo"] = 0.3,
        ["Shovel"] = 3, ["Sledgehammer"] = 2, ["Katana"] = 0.1, ["Wrench"] = 0.1,
        ["Taiga"] = 0.25, ["Bayonet"] = 0.15,
    }

    local function MeleeUp_ProcessAura()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        local TOOL = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not TOOL then return end
        local remote1 = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("XMHH.2")
        local remote2 = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("XMHH2.2")
        if not remote1 or not remote2 then return end
        if MeleeUp_Enabled and MeleeUp_CD[TOOL.Name] then
            local attachcd = MeleeUp_CD[TOOL.Name] or 0.5
            if tick() - MeleeUp_Tick >= attachcd then
                local _iter_p = Players:GetPlayers()
                for _, p in ipairs(_iter_p) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                        if dist < P.MeleeUp_Distance and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 and not p.Character:FindFirstChildOfClass("ForceField") then
                            local targetPart = p.Character:FindFirstChild(P.MeleeUp_TargetPart) or p.Character:FindFirstChild("Right Arm")
                            if not targetPart then
                                -- skip
                            end
                            if targetPart then
                            local result = remote1:InvokeServer("\xF0\x9F\x8D\x9E", tick(), TOOL, "43TRFWX", "Normal", tick(), true)
                            if P.MeleeUp_AnimEnabled then
                                local anim = TOOL:FindFirstChild("AnimsFolder") and TOOL.AnimsFolder:FindFirstChild("Slash1")
                                if anim then
                                    local _charHumanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                                    local animator = _charHumanoid and _charHumanoid:FindFirstChild("Animator")
                                    if animator then
                                        local _animTrack = animator:LoadAnimation(anim)
                                        _animTrack:Play(0.1, 1, 1.3)
                                    end
                                end
                            end
                            local Handle = TOOL:FindFirstChild("WeaponHandle") or TOOL:FindFirstChild("Handle") or LocalPlayer.Character:FindFirstChild("Left Arm")
                            local arg2 = {"\xF0\x9F\x8D\x9E", tick(), TOOL, "2389ZFX34", result, true, Handle, targetPart, p.Character, LocalPlayer.Character.HumanoidRootPart.Position, targetPart.Position}
                            if TOOL.Name == "Chainsaw" then
                                for i = 1, 15 do                                    remote2:FireServer(unpack(arg2))                                end                            else
                                remote2:FireServer(unpack(arg2))
                            end
                            MeleeUp_Tick = tick()
                        end
                    end
                end
            end
        end
    end

    MeleeUp_Enable = function()
        if MeleeUp_Enabled then return end
        MeleeUp_Enabled = true
        MeleeUp_Tick = tick()
        if not MeleeUp_Connection then
            MeleeUp_Connection = RunService.Heartbeat:Connect(function()
                if MeleeUp_Enabled then MeleeUp_ProcessAura() end
            end)
        end
    end

    MeleeUp_Disable = function()
        if not MeleeUp_Enabled then return end
        MeleeUp_Enabled = false
        if MeleeUp_Connection then
            MeleeUp_Connection:Disconnect(); MeleeUp_Connection = nil
        end
    end
end

do
    local NoRecoil_Enabled = false
    local NoRecoil_Connections = {}
    local NoRecoil_OriginalValues = {}
    local NoRecoil_WeaponCache = {}

    local function doCache()
        NoRecoil_WeaponCache = {}
        local ok, gc = pcall(function() return getgc and getgc(true) or nil end)
        if not ok or not gc then return false end
        for _, v in pairs(gc) do
            if type(v) == "table" and rawget(v, "EquipTime") then
                table.insert(NoRecoil_WeaponCache, v)
                if not NoRecoil_OriginalValues[v] then
                    NoRecoil_OriginalValues[v] = {
                        Recoil = v.Recoil, CameraRecoilingEnabled = v.CameraRecoilingEnabled,
                        AngleX_Min = v.AngleX_Min, AngleX_Max = v.AngleX_Max,
                        AngleY_Min = v.AngleY_Min, AngleY_Max = v.AngleY_Max,
                        AngleZ_Min = v.AngleZ_Min, AngleZ_Max = v.AngleZ_Max,
                        Spread = v.Spread
                    }
                end
            end
        end
        return true
    end

    local function doApply()
        for _, weapon in ipairs(NoRecoil_WeaponCache) do
            pcall(function()
                weapon.Recoil = 0; weapon.CameraRecoilingEnabled = false
                weapon.AngleX_Min = 0; weapon.AngleX_Max = 0
                weapon.AngleY_Min = 0; weapon.AngleY_Max = 0
                weapon.AngleZ_Min = 0; weapon.AngleZ_Max = 0
                weapon.Spread = 0
            end)
        end
    end

    NoRecoil_Disable = function()
        if not NoRecoil_Enabled then return end
        NoRecoil_Enabled = false
        for weapon, values in pairs(NoRecoil_OriginalValues) do
            pcall(function()
                weapon.Recoil = values.Recoil; weapon.CameraRecoilingEnabled = values.CameraRecoilingEnabled
                weapon.AngleX_Min = values.AngleX_Min; weapon.AngleX_Max = values.AngleX_Max
                weapon.AngleY_Min = values.AngleY_Min; weapon.AngleY_Max = values.AngleY_Max
                weapon.AngleZ_Min = values.AngleZ_Min; weapon.AngleZ_Max = values.AngleZ_Max
                weapon.Spread = values.Spread
            end)
        end
        NoRecoil_OriginalValues = {}; NoRecoil_WeaponCache = {}
        for _, conn in ipairs(NoRecoil_Connections) do            if conn.Connected then conn:Disconnect() end        end        NoRecoil_Connections = {}
    end

    NoRecoil_Enable = function()
        if NoRecoil_Enabled then return end
        NoRecoil_Enabled = true
        doCache(); doApply()
        local function handleWeapon(child)
            if child:IsA("Tool") and NoRecoil_Enabled then                task.wait(0.1); doCache(); doApply()            end        end
        table.insert(NoRecoil_Connections, LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(1)
            local _iter_child = character:GetChildren()
            for _, child in ipairs(_iter_child) do
                if child:IsA("Tool") then handleWeapon(child) end            end            table.insert(NoRecoil_Connections, character.ChildAdded:Connect(handleWeapon))
        end))
        if LocalPlayer.Character then
            local _iter_child = LocalPlayer.Character:GetChildren()
            for _, child in ipairs(_iter_child) do
                if child:IsA("Tool") then handleWeapon(child) end            end            table.insert(NoRecoil_Connections, LocalPlayer.Character.ChildAdded:Connect(handleWeapon))
        end
    end

    local Pepper_InfEnabled = false
    local Pepper_AuraEnabled = false
    local Pepper_Connection = nil

    Pepper_StopSpray = function()
        pcall(function()
            local pepper = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Pepper-spray")
            if pepper and pepper:FindFirstChild("RemoteEvent") then                pepper.RemoteEvent:FireServer("Spray", false)            end        end)
    end

    Pepper_StartLoop = function()
        if Pepper_Connection then return end
        local cooldown = 0
        Pepper_Connection = RunService.RenderStepped:Connect(function()
            if not Pepper_InfEnabled and not Pepper_AuraEnabled then
                if Pepper_Connection then
                    Pepper_Connection:Disconnect(); Pepper_Connection = nil
                end
                return
            end
            if Pepper_InfEnabled then
                pcall(function()
                    local pepper = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Pepper-spray")
                    if pepper then
                        local ammo = pepper:FindFirstChild("Ammo"); if ammo then ammo.Value = 100 end
                    end
                end)
            end
            if Pepper_AuraEnabled then
                local now = tick()
                if now - cooldown < 0.3 then return end
                pcall(function()
                    local pepper = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Pepper-spray")
                    if pepper and pepper:FindFirstChild("RemoteEvent") then
                        local myChar = LocalPlayer.Character
                        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        if myHRP then
                            local anyInRange = false
                            local _iter_plr = Players:GetPlayers()
                            for _, plr in ipairs(_iter_plr) do
                                if plr ~= LocalPlayer then
                                    local c = plr.Character
                                    local hrp2 = c and c:FindFirstChild("HumanoidRootPart")
                                    local hum = c and c:FindFirstChildOfClass("Humanoid")
                                    if hrp2 and hum then
                                        if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                                        elseif c:GetAttribute("Downed") then
                                        elseif not c:FindFirstChild("Head") then
                                        else
                                            local dist = (myHRP.Position - hrp2.Position).Magnitude
                                            if dist < P.Pepper_Distance then
                                                anyInRange = true
                                                pepper.RemoteEvent:FireServer("Spray", true)
                                                pepper.RemoteEvent:FireServer("Hit", c)
                                            end
                                        end
                                    end
                                end
                            end
                            if not anyInRange then                                pepper.RemoteEvent:FireServer("Spray", false)                            end                            cooldown = now
                        end
                    end
                end)
            end
        end)
    end

    _G.Pidors_Pepper = function(inf, aura)
        Pepper_InfEnabled = inf
        Pepper_AuraEnabled = aura
        if inf or aura then Pepper_StartLoop()
        else Pepper_StopSpray() end
    end

    -- Infinite Stamina (Upt_S hook)
    local isInfiniteStaminaEnabled = false
    local staminaHook = nil

    InfiniteStamina_Enable = function()
        isInfiniteStaminaEnabled = true
        if staminaHook then return true end
        local ok = pcall(function()
            local env = getrenv()
            local stamina_function = env._G.S_Take
            local upvalue_table = getupvalue(stamina_function, 2)
            local upvalues = { pairs(getupvalues(upvalue_table)) }
            local loop_func_1 = upvalues[3]
            local loop_func_2 = upvalues[1]
            local loop_var = upvalues[2]
            while true do
                local upvalue
                loop_func_1, upvalue = loop_func_2(loop_var, loop_func_1)
                if not loop_func_1 then
                    break
                end
                if type(upvalue) == "function" then
                    local _info = debug.getinfo(upvalue)
                    if _info.name == "Upt_S" and not staminaHook then
                    staminaHook = hookfunction(upvalue, function(...)
                        if isInfiniteStaminaEnabled then
                            local _upt = getupvalue(upvalue_table, 7)
                            _upt.S = 100
                        end
                        return staminaHook(...)
                    end)
                    end
                end
            end
        end)
        if staminaHook then return true end
        return false
    end

    InfiniteStamina_Disable = function()
        isInfiniteStaminaEnabled = false
    end

    local AutoFireMode_Enabled = false
    local AutoFireMode_Connections = {}

    local function ApplyAutoFireMode()
        local ok, gc = pcall(function() return getgc and getgc(true) or nil end)
        if not ok or not gc then return end
        for _, v in pairs(gc) do
            if type(v) == "table" and rawget(v, "EquipTime") then
                pcall(function()
                    v.FireModeSettings = { FireMode = "Auto", BurstAmount = 6, BurstRate = 25, CanSwitch = true, SwitchTo = "Auto" }
                end)
            end
        end
    end

    AutoFireMode_Enable = function()
        if AutoFireMode_Enabled then return end
        AutoFireMode_Enabled = true
        ApplyAutoFireMode()
        local function handleWeapon(child)
            if child:IsA("Tool") and AutoFireMode_Enabled then                task.wait(0.1); ApplyAutoFireMode()            end        end
        table.insert(AutoFireMode_Connections, LocalPlayer.CharacterAdded:Connect(function(character)
            task.wait(1)
            local _iter_child = character:GetChildren()
            for _, child in ipairs(_iter_child) do
                if child:IsA("Tool") then handleWeapon(child) end            end            table.insert(AutoFireMode_Connections, character.ChildAdded:Connect(handleWeapon))
        end))
        if LocalPlayer.Character then
            local _iter_child = LocalPlayer.Character:GetChildren()
            for _, child in ipairs(_iter_child) do
                if child:IsA("Tool") then handleWeapon(child) end            end            table.insert(AutoFireMode_Connections, LocalPlayer.Character.ChildAdded:Connect(handleWeapon))
        end
    end

    AutoFireMode_Disable = function()
        if not AutoFireMode_Enabled then return end
        AutoFireMode_Enabled = false
        for _, conn in ipairs(AutoFireMode_Connections) do            if conn.Connected then conn:Disconnect() end        end        AutoFireMode_Connections = {}
    end

    local NoFallDamage_Enabled = false
    local NoFallDamage_Hook = nil

    NoFallDamage_Enable = function()
        if NoFallDamage_Enabled then return end
        NoFallDamage_Enabled = true
        local fall_event = ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("__RZDONL")
        if not fall_event then return end
        NoFallDamage_Hook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == fall_event and NoFallDamage_Enabled then
                local args = {...}
                if args[1] == "FlllD" or args[1] == "FllH" then return end
            end
            return NoFallDamage_Hook(self, ...)
        end))
    end

    NoFallDamage_Disable = function()
        NoFallDamage_Enabled = false
    end
end

do
    local WorldHighlights = {}

    local function handleCategoryESP(folder, toggle, color)
        if not folder then return end
        if toggle then
            local _iter_inst = folder:GetChildren()
            for _, inst in ipairs(_iter_inst) do
                if not WorldHighlights[inst] then
                    local h = Instance.new("Highlight")
                    h.Adornee = inst; h.FillColor = color; h.OutlineColor = color
                    h.FillTransparency = 0.5; h.OutlineTransparency = 0
                    h.Parent = (inst:IsA("Model") and inst.PrimaryPart or inst) or inst
                    WorldHighlights[inst] = h
                else
                    WorldHighlights[inst].FillColor = color; WorldHighlights[inst].OutlineColor = color
                end
            end
        else
            local _iter_inst = folder:GetChildren()
            for _, inst in ipairs(_iter_inst) do
                if WorldHighlights[inst] then
                    WorldHighlights[inst]:Destroy(); WorldHighlights[inst] = nil
                end
            end
        end
    end

    local WESP_Tick = 0
    RunService.Heartbeat:Connect(function()
        WESP_Tick = WESP_Tick + 1
        if WESP_Tick % 30 ~= 0 then return end
        pcall(function()
            handleCategoryESP(Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Shopz"), P.WESP_Dealers, P.WESP_DealerColor)
            handleCategoryESP(Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("SpawnedBread"), P.WESP_Cash, P.WESP_CashColor)
            handleCategoryESP(Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("SpawnedTools"), P.WESP_Items, P.WESP_ItemColor)
            handleCategoryESP(Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("ATMz"), P.WESP_ATMs, P.WESP_ATMColor)
            handleCategoryESP(Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("MysteryBoxes"), P.WESP_Mystery, P.WESP_MysteryColor)
            handleCategoryESP(Workspace:FindFirstChild("Filter") and Workspace.Filter:FindFirstChild("SpawnedPiles"), P.WESP_Piles, P.WESP_PileColor)
            handleCategoryESP(Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Alarms"), P.WESP_Alarms, P.WESP_AlarmColor)
            for inst, hl in pairs(WorldHighlights) do
                if not inst or not inst.Parent then
                    hl:Destroy(); WorldHighlights[inst] = nil
                end
            end
        end)
    end)
end

do
    local mb2Holding = false
    local stickyLocked = false
    local stickyPlayer = nil
    local stickyPart = nil

    -- FOV circle (Drawing API)
    local FovCircle = nil
    local FovCircleOk = false
    pcall(function()
        FovCircle = Drawing.new("Circle")
        if FovCircle then
            FovCircle.Thickness = 1; FovCircle.Radius = P.Aimbot_FovRadius
            FovCircle.Filled = false; FovCircle.Color = P.Aimbot_FovColor
            FovCircle.Transparency = 0.5; FovCircle.Visible = false
            FovCircleOk = true
        end
    end)

    local function getTargetPart(Char)
        local partName = P.Aimbot_Part
        if partName == "Head" then return Char:FindFirstChild("Head")
        elseif partName == "Torso" then return Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("Torso")
        elseif partName == "HumanoidRootPart" then return Char:FindFirstChild("HumanoidRootPart")
        elseif partName == "Left Arm" then return Char:FindFirstChild("LeftUpperArm") or Char:FindFirstChild("Left Arm")
        elseif partName == "Right Arm" then return Char:FindFirstChild("RightUpperArm") or Char:FindFirstChild("Right Arm")
        elseif partName == "Left Leg" then return Char:FindFirstChild("LeftUpperLeg") or Char:FindFirstChild("Left Leg")
        elseif partName == "Right Leg" then return Char:FindFirstChild("RightUpperLeg") or Char:FindFirstChild("Right Leg")
        end
        if partName == "Any Part" then
            local parts = {Char:FindFirstChild("Head"), Char:FindFirstChild("UpperTorso") or Char:FindFirstChild("Torso"), Char:FindFirstChild("HumanoidRootPart")}
            for _, p in ipairs(parts) do                if p then return p end            end        end
        return Char:FindFirstChild("Head")
    end

    local function findTarget(forcePlayer)
        local Camera = Workspace.CurrentCamera
        local myChar = LocalPlayer.Character
        local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
        if not myChar or not myHum or myHum.Health <= 0 then return nil end
        local mouseLoc = UserInputService:GetMouseLocation()
        local closest = nil
        local shortest
        if P.Aimbot_UseFov then
            shortest = P.Aimbot_FovRadius
        else
            shortest = 9e9
        end
        local playersToCheck
        if forcePlayer then
            playersToCheck = {forcePlayer}
        else
            playersToCheck = Players:GetPlayers()
        end
        for _, plr in ipairs(playersToCheck) do
            if plr ~= LocalPlayer and plr.Character then
                local skip = false
                if P.Aimbot_CheckTeam then
                    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then
                        skip = true
                    end
                end
                local eChar = plr.Character
                local eHum = eChar:FindFirstChildOfClass("Humanoid")
                local eHRP = eChar:FindFirstChild("HumanoidRootPart")
                if not skip and (not eHum or not eHRP or eHum.Health <= 0) then
                    skip = true
                end
                if not skip and eChar:FindFirstChildOfClass("ForceField") then
                    skip = true
                end
                if not skip and P.Aimbot_CheckDowned then
                    local downed = eChar:GetAttribute("Downed")
                    if downed then
                        skip = true
                    end
                    if not skip and eHum and eHum.Health < 25 then
                        skip = true
                    end
                end
                local targetPart = not skip and getTargetPart(eChar)
                if not skip and not targetPart then
                    skip = true
                end
                if not skip and P.Aimbot_WallCheck then
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        local rayOrigin = myHRP.Position
                        local rayDir = (targetPart.Position - rayOrigin)
                        local rayParams = RaycastParams.new()
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        rayParams.FilterDescendantsInstances = {myChar, eChar}
                        local result = Workspace:Raycast(rayOrigin, rayDir, rayParams)
                        if result then
                            skip = true
                        end
                    end
                end
                if not skip then
                local aimPos = targetPart.Position
                if P.Aimbot_Prediction > 0 then
                    local vel = eHRP.AssemblyLinearVelocity
                    if vel then
                        aimPos = aimPos + vel * (P.Aimbot_Prediction / 1000)
                    end
                end
                local scrPos, onScr = Camera:WorldToViewportPoint(aimPos)
                if onScr then
                local dx = scrPos.X - mouseLoc.X
                local dy = scrPos.Y - mouseLoc.Y
                local dist2D = math.sqrt(dx * dx + dy * dy)
                if dist2D < shortest then
                    shortest = dist2D
                    closest = {player = plr, part = targetPart, aimPos = aimPos}
                end
                end
                end
            end
        end
        return closest
    end

    local function aimAt(target)
        local Camera = Workspace.CurrentCamera
        if P.Aimbot_Method == "Camera" then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, target.aimPos or target.part.Position)
            local factor = P.Aimbot_Smoothness / 100
            if factor >= 1 then
                Camera.CFrame = targetCFrame
            else
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, factor)
            end
        else
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myHRP then return end
            local dir = ((target.aimPos or target.part.Position) - myHRP.Position).Unit
            local factor = P.Aimbot_Smoothness / 100
            if factor >= 1 then
                myHRP.CFrame = CFrame.new(myHRP.Position, myHRP.Position + dir)
            else
                local lookAt = myHRP.Position + (myHRP.CFrame.LookVector:lerp(dir, factor)) * 10
                myHRP.CFrame = CFrame.new(myHRP.Position, lookAt)
            end
        end
    end

    RunService.Heartbeat:Connect(function()
        if FovCircleOk and FovCircle then
            if P.Aimbot_DrawFov and P.Aimbot_Enabled then
                FovCircle.Position = UserInputService:GetMouseLocation()
                FovCircle.Radius = P.Aimbot_FovRadius
                FovCircle.Color = P.Aimbot_FovColor
                FovCircle.Visible = true
            else
                FovCircle.Visible = false
            end
        end

        if not P.Aimbot_Enabled or not mb2Holding then return end

        if P.Aimbot_StickyTarget then
            if stickyPlayer then
                -- (ignores walls, FOV, team check, everything)
                local sc = stickyPlayer.Character
                local sh = sc and sc:FindFirstChildOfClass("Humanoid")
                local eHRP = sc and sc:FindFirstChild("HumanoidRootPart")
                if sh and eHRP and sh.Health > 0 then
                    local tp = stickyPart
                    if not tp or tp.Parent ~= sc then
                        tp = sc:FindFirstChild("Head") or eHRP
                        stickyPart = tp
                    end
                    if tp then
                        local aimPos = tp.Position
                        if P.Aimbot_Prediction > 0 and eHRP.AssemblyLinearVelocity then
                            aimPos = aimPos + eHRP.AssemblyLinearVelocity * (P.Aimbot_Prediction / 1000)
                        end
                        aimAt({player = stickyPlayer, part = tp, aimPos = aimPos})
                    end
                    return -- DON'T run main aimbot
                else
                    stickyPlayer = nil
                    stickyPart = nil
                    stickyLocked = false
                end
            else
                local target = findTarget()
                if target then
                    stickyPlayer = target.player
                    stickyPart = target.part
                    stickyLocked = true
                end
                return -- Give sticky one frame to establish lock
            end
        end

        local target = findTarget()
        if target then aimAt(target) end
    end)

    -- MB2 input (shared for both sticky and main aimbot)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            mb2Holding = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            mb2Holding = false
            if stickyLocked then
                stickyPlayer = nil
                stickyPart = nil
                stickyLocked = false
            end
        end
    end)
end

do
    local AntiAim_Enabled = false
    local AntiAim_Mode = "Off"
    local AntiAim_Connection = nil
    local AntiAim_YawAngle = 0

    local function AntiAim_Update(dt)
        if not AntiAim_Enabled then return end
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        if AntiAim_Mode == "Spin" then
            AntiAim_YawAngle = AntiAim_YawAngle + (P.AntiAim_SpinSpeed / 50)
        elseif AntiAim_Mode == "Jitter" then
            local jitDir
            if (tick() * (P.AntiAim_JitterSpeed / 10) % 2 < 1) then
                jitDir = 1
            else
                jitDir = -1
            end
            AntiAim_YawAngle = jitDir * 90
        else
            return
        end
        myHRP.CFrame = CFrame.new(myHRP.Position) * CFrame.Angles(0, math.rad(AntiAim_YawAngle), 0)
    end

    AntiAim_Enable = function()
        if AntiAim_Enabled then return end
        AntiAim_Enabled = true
        AntiAim_YawAngle = 0
        if not AntiAim_Connection then
            AntiAim_Connection = RunService.Heartbeat:Connect(AntiAim_Update)
        end
    end

    AntiAim_Disable = function()
        if not AntiAim_Enabled then return end
        AntiAim_Enabled = false
        AntiAim_YawAngle = 0
        if AntiAim_Connection then
            AntiAim_Connection:Disconnect(); AntiAim_Connection = nil
        end
    end

    _G.Pidors_AntiAimMode = function(v)
        AntiAim_Mode = v
        if AntiAim_Mode ~= "Off" and not AntiAim_Enabled then
            AntiAim_Enable()
        elseif AntiAim_Mode == "Off" and AntiAim_Enabled then
            AntiAim_Disable()
        end
    end

    local Ragebot_Enabled = false
    local Ragebot_Coroutine = nil

    -- FOV circle via Frame (works on all exploits)
    local RagebotScreen = Instance.new("ScreenGui")
    RagebotScreen.Name = "pidors_ragebot"; RagebotScreen.ResetOnSpawn = false
    RagebotScreen.DisplayOrder = 999; RagebotScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() RagebotScreen.Parent = game:GetService("CoreGui") end)
    if not RagebotScreen.Parent then
        RagebotScreen.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    local RagebotFovFrame = Instance.new("Frame", RagebotScreen)
    RagebotFovFrame.Name = "RagebotFOV"
    RagebotFovFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    RagebotFovFrame.BackgroundTransparency = 0.85
    RagebotFovFrame.BorderSizePixel = 0; RagebotFovFrame.Visible = false; RagebotFovFrame.ZIndex = 998
    local _corner = Instance.new("UICorner", RagebotFovFrame)
    _corner.CornerRadius = UDim.new(1, 0)
    local fovStroke = Instance.new("UIStroke", RagebotFovFrame)
    fovStroke.Color = Color3.fromRGB(255, 50, 50); fovStroke.Thickness = 1.5; fovStroke.Transparency = 0.3

    RunService.Heartbeat:Connect(function()
        if P.Ragebot_DrawFov and Ragebot_Enabled then
            local mLoc = UserInputService:GetMouseLocation()
            local d = P.Ragebot_FovRadius * 2
            RagebotFovFrame.Size = UDim2.new(0, d, 0, d)
            RagebotFovFrame.Position = UDim2.new(0, mLoc.X, 0, mLoc.Y - 36)
            RagebotFovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
            RagebotFovFrame.Visible = true
        else
            RagebotFovFrame.Visible = false
        end
    end)

    local function RandomString(length)
        local res = ""
        for i = 1, length do res = res .. string.char(math.random(97, 122)) end
        return res
    end

    local function Ragebot_PlayHeadshotSound()
        local audio = Instance.new("Sound")
        local _coreGui = game:GetService("CoreGui")
        audio.Parent = _coreGui
        audio.SoundId = "rbxassetid://8285324545"; audio.Volume = 2; audio:Play()
        local _debris = game:GetService("Debris")
        _debris:AddItem(audio, 2)
    end

    local function Ragebot_GetClosest()
        local closest = nil; local shortest = 200
        local cam = Workspace.CurrentCamera
        local mouseLoc = UserInputService:GetMouseLocation()
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return nil end
        local _iter_plr = Players:GetPlayers()
        for _, plr in ipairs(_iter_plr) do
            if plr ~= LocalPlayer then
                local eChar = plr.Character
                local eHRP = eChar and eChar:FindFirstChild("HumanoidRootPart")
                local eHum = eChar and eChar:FindFirstChildOfClass("Humanoid")
                if eHRP and eHum and eHum.Health > 15 and not eChar:FindFirstChildOfClass("ForceField") then
                    if P.Ragebot_UseFov then
                        local scrPos, onScr = cam:WorldToViewportPoint(eHRP.Position)
                        if not onScr then
                            -- skip
                        end
                        if onScr then
                        local dx = scrPos.X - mouseLoc.X; local dy = scrPos.Y - mouseLoc.Y
                        local dist2D = math.sqrt(dx * dx + dy * dy)
                        if dist2D > P.Ragebot_FovRadius then
                            -- skip
                        end
                        if dist2D <= P.Ragebot_FovRadius and dist2D < shortest then
                            shortest = dist2D; closest = plr
                        end
                        end
                    else
                        local dist = (myHRP.Position - eHRP.Position).Magnitude
                        if dist < shortest then
                            shortest = dist; closest = plr
                        end
                    end
                end
            end
        end
        return closest
    end

    local function Ragebot_Shoot(targetPlayer)
        if not targetPlayer or not targetPlayer.Character then return end
        local head = targetPlayer.Character:FindFirstChild("Head")
        if not head then return end
        local myChar = LocalPlayer.Character
        local tool = myChar and myChar:FindFirstChildOfClass("Tool")
        if not tool then return end
        local values = tool:FindFirstChild("Values")
        local hitMarker = tool:FindFirstChild("Hitmarker")
        if not values or not hitMarker then return end
        local ammo = values:FindFirstChild("SERVER_Ammo")
        if not ammo or ammo.Value <= 0 then return end
        local cam = Workspace.CurrentCamera
        local hitPos = head.Position
        local hitDir = (hitPos - cam.CFrame.Position).Unit
        local rKey = RandomString(30) .. "0"
        local evts = ReplicatedStorage:FindFirstChild("Events")
        if not evts then return end
        local GNX_S = evts:FindFirstChild("GNX_S")
        local ZFKLF_H = evts:FindFirstChild("ZFKLF__H")
        if not GNX_S or not ZFKLF_H then return end
        pcall(function() GNX_S:FireServer(tick(), rKey, tool, "FDS9I83", cam.CFrame.Position, {hitDir}, false) end)
        pcall(function() ZFKLF_H:FireServer("\xF0\x9F\xA7\x88", tool, rKey, 1, head, hitPos, hitDir) end)
        pcall(function() ammo.Value = math.max(ammo.Value - 1, 0) end)
        pcall(function() hitMarker:Fire(head); Ragebot_PlayHeadshotSound() end)
    end

    local function Ragebot_Loop()
        while Ragebot_Enabled do
            local myChar = LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChildOfClass("Tool") then
                local target = Ragebot_GetClosest()
                if target then Ragebot_Shoot(target) end
            end
            local waitTime = 1 - (P.Ragebot_FireRate / 100)
            task.wait(math.max(waitTime * 0.15, 0.01))
        end
        Ragebot_Coroutine = nil
    end

    Ragebot_Enable = function()
        if Ragebot_Enabled then return end
        local evts = ReplicatedStorage:FindFirstChild("Events")
        if not evts or not evts:FindFirstChild("GNX_S") or not evts:FindFirstChild("ZFKLF__H") then
            Library:Notify("Ragebot: Remotes not found", 3); return
        end
        Ragebot_Enabled = true
        if not Ragebot_Coroutine then
            Ragebot_Coroutine = coroutine.create(Ragebot_Loop)
            coroutine.resume(Ragebot_Coroutine)
        end
    end

    Ragebot_Disable = function()
        if not Ragebot_Enabled then return end
        Ragebot_Enabled = false
        RagebotFovFrame.Visible = false
    end
end


do
    local PlayerGrp = Tabs.Player:AddLeftGroupbox('Player')

    PlayerGrp:AddSlider('FovValue', {
        Text = 'FOV',
        Default = 70,
        Min = 30,
        Max = 120,
        Rounding = 0,
        Callback = function(v)
            P.Fov_Value = v
            if not Fov_Enabled then Fov_Enable() end
        end
    })
    PlayerGrp:AddSlider('CameraDistance', {
        Text = 'Camera Distance',
        Default = LocalPlayer.CameraMaxZoomDistance,
        Min = 10,
        Max = 500,
        Rounding = 1,
        Callback = function(v) LocalPlayer.CameraMaxZoomDistance = v end
    })
    PlayerGrp:AddSlider('Gravity', {
        Text = 'Gravity',
        Default = math.floor(Workspace.Gravity),
        Min = 10,
        Max = 500,
        Rounding = 0,
        Callback = function(v) Workspace.Gravity = v end
    })

    PlayerGrp:AddDivider()

    PlayerGrp:AddToggle('InfStamina', {
        Text = 'Infinity Stamina',
        Default = false,
        Callback = function(v)
            if v then
                local ok = InfiniteStamina_Enable()
                if ok then Library:Notify("Inf Stamina ON", 2)
                else Library:Notify("Inf Stamina: hook failed", 3) end
            else
                InfiniteStamina_Disable(); Library:Notify("Inf Stamina OFF", 2)
            end
        end
    })

    PlayerGrp:AddToggle('NoFallDamage', {
        Text = 'No Fall Damage',
        Default = false,
        Callback = function(v)
            if v then NoFallDamage_Enable(); Library:Notify("No Fall Damage ON", 2)
            else NoFallDamage_Disable(); Library:Notify("No Fall Damage OFF", 2) end
        end
    })

    PlayerGrp:AddToggle('HideHead', {
        Text = 'Hide Head',
        Default = false,
        Tooltip = 'Hides your head (server-side)',
        Callback = function(state)
            _G.Pidors_HideHead = state
            local move_event = ReplicatedStorage.Events:FindFirstChild("MOVZREP")
            if not move_event then return end
            if not _G.Pidors_HideHeadHook then
                _G.Pidors_HideHeadHook = hookmetamethod(game, "__namecall", function(self, ...)
                    if getnamecallmethod() == "FireServer" and self == move_event then
                        local args = { ... }
                        if type(args[1]) == "table" then
                            local data_table = args[1]
                            if type(data_table[1]) == "table" and _G.Pidors_HideHead then
                                local inner_table = data_table[1]
                                inner_table[2] = Vector3.new(math.random(1000), math.random(1000), math.random(1000))
                                inner_table[3] = Vector3.new(math.random(1000), math.random(1000), math.random(1000))
                            end
                        end
                    end
                    return _G.Pidors_HideHeadHook(self, ...)
                end)
            end
        end
    })

    PlayerGrp:AddToggle('StopNeckMove', {
        Text = 'Stop Neck Move',
        Default = false,
        Callback = function(state)
            if state then
                if LocalPlayer.Character then
                    LocalPlayer.Character:SetAttribute("NoNeckMovement", true)
                end
                LocalPlayer.CharacterAdded:Connect(function(new_char)
                    if not new_char then LocalPlayer.CharacterAdded:Wait() end
                    if not new_char:FindFirstChild("Humanoid") then new_char:WaitForChild("Humanoid", 5) end
                    if _G.Pidors_StopNeck then
                        new_char:SetAttribute("NoNeckMovement", true)
                    end
                end)
                _G.Pidors_StopNeck = true
            else
                _G.Pidors_StopNeck = false
                if LocalPlayer.Character and LocalPlayer.Character:GetAttribute("NoNeckMovement") then
                    LocalPlayer.Character:SetAttribute("NoNeckMovement", nil)
                end
            end
        end
    })

    local HideBodyToggle = PlayerGrp:AddToggle('HideBody', {
        Text = 'Hide Body',
        Default = false,
        Tooltip = 'Hides your body underground',
        Callback = function(state)
            if state then
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("Humanoid") then return end
                local humanoid = char.Humanoid
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://282574440"
                _G.Pidors_HideBodyTrack = humanoid:LoadAnimation(anim)
                _G.Pidors_HideBodyTrack.Looped = true
                _G.Pidors_HideBodyTrack.Priority = Enum.AnimationPriority.Action4
                _G.Pidors_HideBodyTrack:Play(0.1, 1, 0)
                _G.Pidors_HideBodyConn = RunService.Heartbeat:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and _G.Pidors_HideBodyTrack then
                        _G.Pidors_HideBodyTrack.TimePosition = 1.755
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local origCFrame = hrp.CFrame
                        local origVel = hrp.AssemblyLinearVelocity
                        hrp.CFrame = hrp.CFrame + Vector3.new(0, -2.6, 0)
                        RunService.RenderStepped:Wait()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            hrp.CFrame = origCFrame
                            hrp.AssemblyLinearVelocity = origVel
                        end
                    end
                end)
                if humanoid then humanoid.Died:Connect(function()
                    if _G.Pidors_HideBodyTrack then
                        pcall(function() _G.Pidors_HideBodyTrack:Stop(); _G.Pidors_HideBodyTrack:Destroy() end); _G.Pidors_HideBodyTrack = nil
                    end
                    if _G.Pidors_HideBodyConn then
                        _G.Pidors_HideBodyConn:Disconnect(); _G.Pidors_HideBodyConn = nil
                    end
                end) end
            else
                if _G.Pidors_HideBodyTrack then
                    pcall(function() _G.Pidors_HideBodyTrack:Stop(); _G.Pidors_HideBodyTrack:Destroy() end); _G.Pidors_HideBodyTrack = nil
                end
                if _G.Pidors_HideBodyConn then
                    _G.Pidors_HideBodyConn:Disconnect(); _G.Pidors_HideBodyConn = nil
                end
            end
        end
    })
    HideBodyToggle:AddKeyPicker('HideBody', {
        Default = 'None',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Hide Body',
        Callback = function() end
    })

    local InvisibleToggle = PlayerGrp:AddToggle('Invisible', {
        Text = 'Invisible',
        Default = false,
        Tooltip = 'Hides your character (Shadow)',
        Callback = function(v)
            if v then Shadow_Enable(); Library:Notify("Invisible ON", 2)
            else Shadow_Disable(); Library:Notify("Invisible OFF", 2) end
        end
    })
    InvisibleToggle:AddKeyPicker('Invisible', {
        Default = 'None',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Invisible',
        Callback = function() end
    })

    local NoclipToggle = PlayerGrp:AddToggle('Noclip', {
        Text = 'Noclip',
        Default = false,
        Callback = function(v)
            if v then Noclip_Enable(); Library:Notify("Noclip ON", 2)
            else Noclip_Disable(); Library:Notify("Noclip OFF", 2) end
        end
    })
    NoclipToggle:AddKeyPicker('Noclip', {
        Default = 'None',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Noclip',
        Callback = function() end
    })

    local FlyGrp = Tabs.Player:AddRightGroupbox('Fly')

    local FlyToggle = FlyGrp:AddToggle('Fly', {
        Text = 'Fly',
        Default = false,
        Callback = function(v)
            if v then Fly_Enable(); Library:Notify("Fly ON", 2)
            else Fly_Disable(); Library:Notify("Fly OFF", 2) end
        end
    })
    FlyToggle:AddKeyPicker('Fly', {
        Default = 'None',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Fly',
        Callback = function() end
    })
    FlyGrp:AddLabel('Fly method')
    FlyGrp:AddDropdown('FlyMode', {
        Values = {'Velocity', 'Ragdoll'},
        Default = 1,
        Callback = function(v) P.Fly_Method = v end
    })
end

do
    local Aim = Tabs.Combat:AddLeftGroupbox('Aimbot')

    Aim:AddToggle('Aimbot', {
        Text = 'Enable Aimbot',
        Default = false,
        Callback = function(v)
            P.Aimbot_Enabled = v
            local _notify_msg
            if v then
                _notify_msg = "Aimbot ON (Hold MB2)" else _notify_msg = "Aimbot OFF"
            end
            Library:Notify(_notify_msg, 2)
        end
    })
    Aim:AddDropdown('AimMethod', {
        Values = {'Camera', 'Mouse'},
        Default = 1,
        Callback = function(v) P.Aimbot_Method = v end
    })
    Aim:AddSlider('AimSmooth', {
        Text = 'Smoothness',
        Default = 5,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(v) P.Aimbot_Smoothness = v end
    })
    Aim:AddSlider('AimFov', {
        Text = 'Fov Radius',
        Default = 100,
        Min = 10,
        Max = 600,
        Rounding = 0,
        Callback = function(v) P.Aimbot_FovRadius = v end
    })
    Aim:AddToggle('AimUseFov', { Text = 'Use Fov', Default = false, Callback = function(v) P.Aimbot_UseFov = v end })
    local AimDrawFovToggle = Aim:AddToggle('AimDrawFov', { Text = 'Draw Fov', Default = false, Callback = function(v) P.Aimbot_DrawFov = v end })
    AimDrawFovToggle:AddColorPicker('AimFovColor', {
        Default = Color3.fromRGB(255, 255, 255),
        Title = 'Fov Color',
        Callback = function(v) P.Aimbot_FovColor = v end
    })
    Aim:AddToggle('AimCheckTeam', { Text = 'Check Team', Default = true, Callback = function(v) P.Aimbot_CheckTeam = v end })
    Aim:AddToggle('AimCheckDowned', { Text = 'Check Downed', Default = false, Callback = function(v) P.Aimbot_CheckDowned = v end })
    Aim:AddToggle('AimWallCheck', { Text = 'Wall Check', Default = true, Callback = function(v) P.Aimbot_WallCheck = v end })
    Aim:AddToggle('StickyAim', {
        Text = 'Sticky Aim',
        Default = false,
        Tooltip = 'Locks onto target until MB2 release or death. Ignores walls & FOV.',
        Callback = function(v) P.Aimbot_StickyTarget = v end
    })
    Aim:AddSlider('AimPred', {
        Text = 'Prediction',
        Default = 100,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(v) P.Aimbot_Prediction = v end
    })
    Aim:AddDropdown('AimPart', {
        Values = {'Any Part', 'Head', 'Torso', 'HumanoidRootPart', 'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg'},
        Default = 2,
        Callback = function(v) P.Aimbot_Part = v end
    })

    local RB = Tabs.Combat:AddLeftGroupbox('Ragebot')

    local RagebotToggle = RB:AddToggle('Ragebot', {
        Text = 'Enable Ragebot',
        Default = false,
        Callback = function(v)
            if v then Ragebot_Enable(); Library:Notify("Ragebot ON", 2)
            else Ragebot_Disable(); Library:Notify("Ragebot OFF", 2) end
        end
    })
    RagebotToggle:AddKeyPicker('Ragebot', {
        Default = 'None',
        SyncToggleState = true,
        Mode = 'Toggle',
        Text = 'Ragebot',
        Callback = function() end
    })
    RB:AddSlider('RageFireRate', {
        Text = 'Fire Rate',
        Default = 50,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(v) P.Ragebot_FireRate = v end
    })
    RB:AddSlider('RageFov', {
        Text = 'Fov Radius',
        Default = 150,
        Min = 10,
        Max = 600,
        Rounding = 0,
        Callback = function(v) P.Ragebot_FovRadius = v end
    })
    RB:AddDivider()
    RB:AddToggle('RageCheckDowned', {
        Text = 'Check Downed',
        Default = false,
        Callback = function(v) P.Ragebot_CheckDowned = v end
    })
    RB:AddToggle('RageUseFov', { Text = 'Use Fov', Default = true, Callback = function(v) P.Ragebot_UseFov = v end })
    RB:AddToggle('RageDrawFov', { Text = 'Draw Fov', Default = false, Callback = function(v) P.Ragebot_DrawFov = v end })

    local MeleeGrp = Tabs.Combat:AddRightGroupbox('Melee Aura')

    MeleeGrp:AddToggle('MeleeUp', {
        Text = 'Enable Melee Aura',
        Default = false,
        Callback = function(v)
            if v then MeleeUp_Enable(); Library:Notify("Melee Aura ON", 2)
            else MeleeUp_Disable(); Library:Notify("Melee Aura OFF", 2) end
        end
    })
    MeleeGrp:AddSlider('MeleeUpDist', {
        Text = 'Distance',
        Default = 5,
        Min = 1,
        Max = 15,
        Rounding = 0,
        Callback = function(v) P.MeleeUp_Distance = v end
    })
    MeleeGrp:AddDropdown('MeleeUpPart', {
        Values = MeleeUp_Parts,
        Default = 1,
        Callback = function(v) P.MeleeUp_TargetPart = v end
    })
    MeleeGrp:AddToggle('MeleeUpAnim', {
        Text = 'Show Melee Animation',
        Default = false,
        Callback = function(v) P.MeleeUp_AnimEnabled = v end
    })

    local AA = Tabs.Combat:AddRightGroupbox('Anti-Aim')

    AA:AddDropdown('AntiAimMode', {
        Values = {'Off', 'Spin', 'Jitter'},
        Default = 1,
        Callback = function(v) _G.Pidors_AntiAimMode(v) end
    })
    AA:AddSlider('AntiAimSpin', {
        Text = 'Spin Speed',
        Default = 100,
        Min = 1,
        Max = 2000,
        Rounding = 0,
        Callback = function(v) P.AntiAim_SpinSpeed = v end
    })
    AA:AddSlider('AntiAimJitter', {
        Text = 'Jitter Speed',
        Default = 50,
        Min = 1,
        Max = 500,
        Rounding = 0,
        Callback = function(v) P.AntiAim_JitterSpeed = v end
    })

    local PepperGrp = Tabs.Combat:AddRightGroupbox('Pepper Spray')

    PepperGrp:AddToggle('PepperInf', {
        Text = 'Infinite Pepper',
        Default = false,
        Callback = function(v)
            _G.Pidors_Pepper(v, toggle_states.PepperAura or false)
            toggle_states.PepperInf = v
        end
    })
    PepperGrp:AddToggle('PepperAura', {
        Text = 'Pepper Aura',
        Default = false,
        Callback = function(v)
            _G.Pidors_Pepper(toggle_states.PepperInf or false, v)
            toggle_states.PepperAura = v
        end
    })
    PepperGrp:AddSlider('PepperDist', {
        Text = 'Distance',
        Default = 5,
        Min = 1,
        Max = 15,
        Rounding = 0,
        Callback = function(v) P.Pepper_Distance = v end
    })

    local ProjGrp = Tabs.Combat:AddRightGroupbox('Projectile Control')

    local tC4 = ProjGrp:AddToggle('C4Control', {
        Text = 'C4 Control',
        Default = false,
        Callback = function(v)
            if v then
                local _vparts = Workspace.Debris:WaitForChild("VParts")
                connection_table.C4Control = _vparts.ChildAdded:Connect(function(proj)
                    if not Toggles.C4Control or not Toggles.C4Control.Value then return end
                    if proj.Name ~= "TransIgnore" then return end
                    task.wait()
                    if not LocalPlayer.Character then return end
                    if not LocalPlayer.Character:FindFirstChild("C4") then return end
                    local cam = Workspace.CurrentCamera
                    cam.CameraSubject = proj
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Anchored = true
                    end
                    pcall(function()
                        if proj:FindFirstChild("BodyForce") then proj.BodyForce:Destroy() end
                        if proj:FindFirstChild("BodyAngularVelocity") then proj.BodyAngularVelocity:Destroy() end
                        if proj:FindFirstChild("RotPart") and proj.RotPart:FindFirstChild("BodyAngularVelocity") then
                            proj.RotPart.BodyAngularVelocity:Destroy()
                        end
                        if proj:FindFirstChild("Sound") then proj.Sound:Destroy() end
                    end)
                    local BV = Instance.new("BodyVelocity", proj)
                    BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    BV.Velocity = Vector3.new()
                    local BG = Instance.new("BodyGyro", proj)
                    BG.P = 9e4
                    BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                    task.spawn(function()
                        while proj and proj.Parent and Toggles.C4Control.Value do
                            RunService.RenderStepped:Wait()
                            local speed
                            if Options.C4Speed then
                                speed = Options.C4Speed.Value
                            else
                                speed = 200
                            end
                            local fwd = 0
                            local side = 0
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                fwd = fwd + 1
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                fwd = fwd - 1
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                side = side - 1
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                side = side + 1
                            end
                            local vel = ((cam.CFrame.LookVector * fwd) + (cam.CFrame.RightVector * side)) * speed
                            pcall(function() BV.Velocity = vel end)
                            pcall(function() BG.CFrame = cam.CoordinateFrame end)
                            pcall(function() cam.CFrame = cam.CFrame:Lerp(proj.CFrame * CFrame.new(0, 5, 1), 0.1) end)
                        end
                        if LocalPlayer.Character then
                            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                            if hum then
                                cam.CameraSubject = hum
                            end
                            if hrp then
                                hrp.Anchored = false
                            end
                        end
                        pcall(function() BV:Destroy() end)
                        pcall(function() BG:Destroy() end)
                    end)
                end)
            else
                if connection_table.C4Control then
                    connection_table.C4Control:Disconnect()
                    connection_table.C4Control = nil
                end
            end
        end
    })
    tC4:AddKeyPicker('C4Key', {
        Text = 'C4 Control Key',
        Default = 'None',
        Mode = 'Toggle',
        SyncToggleState = true,
        Callback = function() end
    })
    ProjGrp:AddSlider('C4Speed', {
        Text = 'C4 Speed',
        Default = 200,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Callback = function(v) end
    })

    local tExplosives = ProjGrp:AddToggle('ExplosivesControl', {
        Text = 'Explosives Control',
        Default = false,
        Callback = function(v)
            if v then
                local _vparts = Workspace.Debris:WaitForChild("VParts")
                connection_table.ExplosivesControl = _vparts.ChildAdded:Connect(function(proj)
                    if not Toggles.ExplosivesControl or not Toggles.ExplosivesControl.Value then return end
                    local isRPG = proj.Name == "RPG_Rocket" or proj.Name == "GrenadeLauncherGrenade"
                    if not isRPG then return end
                    task.wait()
                    if not LocalPlayer.Character then return end
                    local cam = Workspace.CurrentCamera
                    cam.CameraSubject = proj
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Anchored = true
                    end
                    pcall(function()
                        if proj:FindFirstChild("BodyForce") then proj.BodyForce:Destroy() end
                        if proj:FindFirstChild("BodyAngularVelocity") then proj.BodyAngularVelocity:Destroy() end
                        if proj:FindFirstChild("RotPart") and proj.RotPart:FindFirstChild("BodyAngularVelocity") then
                            proj.RotPart.BodyAngularVelocity:Destroy()
                        end
                        if proj:FindFirstChild("Sound") then proj.Sound:Destroy() end
                    end)
                    local BV = Instance.new("BodyVelocity", proj)
                    BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    BV.Velocity = Vector3.new()
                    local BG = Instance.new("BodyGyro", proj)
                    BG.P = 9e4
                    BG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                    task.spawn(function()
                        while proj and proj.Parent and Toggles.ExplosivesControl.Value do
                            RunService.RenderStepped:Wait()
                            local speed
                            if Options.ExplosivesSpeed then
                                speed = Options.ExplosivesSpeed.Value
                            else
                                speed = 200
                            end
                            local fwd = 0
                            local side = 0
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                fwd = fwd + 1
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                fwd = fwd - 1
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                side = side - 1
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                side = side + 1
                            end
                            local vel = ((cam.CFrame.LookVector * fwd) + (cam.CFrame.RightVector * side)) * speed
                            pcall(function() BV.Velocity = vel end)
                            pcall(function() BG.CFrame = cam.CoordinateFrame end)
                            pcall(function() cam.CFrame = cam.CFrame:Lerp(proj.CFrame * CFrame.new(0, 5, 1), 0.1) end)
                        end
                        if LocalPlayer.Character then
                            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
                            if hum then
                                cam.CameraSubject = hum
                            end
                            if hrp then
                                hrp.Anchored = false
                            end
                        end
                        pcall(function() BV:Destroy() end)
                        pcall(function() BG:Destroy() end)
                    end)
                end)
            else
                if connection_table.ExplosivesControl then
                    connection_table.ExplosivesControl:Disconnect()
                    connection_table.ExplosivesControl = nil
                end
            end
        end
    })
    tExplosives:AddKeyPicker('ExplosivesKey', {
        Text = 'Explosives Control Key',
        Default = 'None',
        Mode = 'Toggle',
        SyncToggleState = true,
        Callback = function() end
    })
    ProjGrp:AddSlider('ExplosivesSpeed', {
        Text = 'Explosives Speed',
        Default = 200,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Callback = function(v) end
    })

    local Guns = Tabs.Combat:AddLeftGroupbox('Gun Mods')

    Guns:AddToggle('NoRecoil', {
        Text = 'No Recoil',
        Default = false,
        Callback = function(v)
            if v then NoRecoil_Enable(); Library:Notify("No Recoil ON", 2)
            else NoRecoil_Disable(); Library:Notify("No Recoil OFF", 2) end
        end
    })
    Guns:AddToggle('AutoFire', {
        Text = 'Auto Fire Mode',
        Default = false,
        Callback = function(v)
            if v then AutoFireMode_Enable(); Library:Notify("Auto Fire ON", 2)
            else AutoFireMode_Disable(); Library:Notify("Auto Fire OFF", 2) end
        end
    })
    Guns:AddToggle('AutoReload', {
        Text = 'Auto Reload',
        Default = false,
        Callback = function(state)
            _G.Pidors_AutoReload = state
            local reload_event = ReplicatedStorage.Events:FindFirstChild("GNX_R")
            if not reload_event then                Library:Notify("Auto Reload: event not found", 3); return            end            if not state then return end
            local function setup_reload(tool)
                if not tool or not tool:FindFirstChild("IsGun") then return end
                local ammo = tool:FindFirstChild("Values") and tool.Values:FindFirstChild("SERVER_Ammo")
                local stored = tool:FindFirstChild("Values") and tool.Values:FindFirstChild("SERVER_StoredAmmo")
                if not ammo or not stored then return end
                stored:GetPropertyChangedSignal("Value"):Connect(function()
                    if _G.Pidors_AutoReload then
                        reload_event:FireServer(tick(), "KLWE89U0", tool)
                    end
                end)
                if stored.Value ~= 0 and _G.Pidors_AutoReload then
                    reload_event:FireServer(tick(), "KLWE89U0", tool)
                end
                ammo:GetPropertyChangedSignal("Value"):Connect(function()
                    if _G.Pidors_AutoReload and stored.Value ~= 0 then
                        reload_event:FireServer(tick(), "KLWE89U0", tool)
                    end
                end)
            end
            local char = LocalPlayer.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if not tool or not tool:FindFirstChild("IsGun") then
                    char.ChildAdded:Connect(function(child)
                        if child:IsA("Tool") and child:FindFirstChild("IsGun") then
                            setup_reload(child)
                        end
                    end)
                else
                    setup_reload(tool)
                end
                LocalPlayer.CharacterAdded:Connect(function(new_char)
                    if not new_char then return end
                    repeat task.wait() until new_char.Parent
                    new_char.ChildAdded:Connect(function(child)
                        if child:IsA("Tool") and child:FindFirstChild("IsGun") then
                            setup_reload(child)
                        end
                    end)
                end)
            end
        end
    })

end

do
    local Safe = Tabs.Visuals:AddLeftGroupbox('Safe / Register ESP')

    Safe:AddToggle('BredMakurz', {
        Text = 'Safe/Register ESP',
        Default = false,
        Callback = function(v)
            _G.Pidors_BredMakurz(v)
            local _notify_msg
            if v then
                _notify_msg = "Safe ESP ON" else _notify_msg = "Safe ESP OFF"
            end
            Library:Notify(_notify_msg, 2)
        end
    })
    Safe:AddSlider('BredMakurzDist', {
        Text = 'Distance',
        Default = 200,
        Min = 50,
        Max = 1500,
        Rounding = 0,
        Callback = function(v) _G.Pidors_BredMakurz_Distance(v) end
    })

    local PEsp = Tabs.Visuals:AddRightGroupbox('Player ESP')

    PEsp:AddToggle('ESP', {
        Text = 'Enable ESP',
        Default = false,
        Callback = function(v)
            P.ESP_Enabled = v
            if not v then _G.Pidors_ESP_HideAll() end
            local _notify_msg
            if v then
                _notify_msg = "Player ESP ON" else _notify_msg = "Player ESP OFF"
            end
            Library:Notify(_notify_msg, 2)
        end
    })
    local tBoxes = PEsp:AddToggle('ESPBoxes', { Text = 'Boxes', Default = false, Callback = function(v) P.ESP_Boxes = v end })
    tBoxes:AddColorPicker('ESPBoxColor', { Default = Color3.fromRGB(255,255,255), Callback = function(v) P.ESP_BoxColor = v end })
    local tNames = PEsp:AddToggle('ESPNaming', { Text = 'Names', Default = false, Callback = function(v) P.ESP_Names = v end })
    tNames:AddColorPicker('ESPNameColor', { Default = Color3.fromRGB(255,255,255), Callback = function(v) P.ESP_NameColor = v end })
    local tDist = PEsp:AddToggle('ESPDist', { Text = 'Distance', Default = false, Callback = function(v) P.ESP_Distance = v end })
    tDist:AddColorPicker('ESPDistColor', { Default = Color3.fromRGB(180,180,180), Callback = function(v) P.ESP_DistColor = v end })
    PEsp:AddToggle('ESPHealth', { Text = 'Health Bar', Default = false, Callback = function(v) P.ESP_Health = v end })
    local tTracers = PEsp:AddToggle('ESPTracers', { Text = 'Player Tracers', Default = false, Callback = function(v) P.ESP_Tracers = v end })
    tTracers:AddColorPicker('ESPTracerColor', { Default = Color3.fromRGB(255,255,255), Callback = function(v) P.ESP_TracerColor = v end })
    PEsp:AddDropdown('ESPTracerOrigin', {
        Values = {'Bottom', 'Center', 'Mouse'},
        Default = 1,
        Callback = function(v) P.ESP_TracerOrigin = v end
    })
    local tChams = PEsp:AddToggle('ESPChams', { Text = 'Chams (Highlight)', Default = false, Callback = function(v) P.ESP_Chams = v end })
    tChams:AddColorPicker('ESPChamsColor', { Default = Color3.fromRGB(255,0,0), Callback = function(v) P.ESP_ChamsFill = v end })
    tChams:AddColorPicker('ESPChamsOutlineColor', { Default = Color3.fromRGB(255,255,255), Callback = function(v) P.ESP_ChamsOutline = v end })
    local tSkel = PEsp:AddToggle('ESPSkeleton', { Text = 'Skeleton', Default = false, Callback = function(v) P.ESP_Skeleton = v end })
    tSkel:AddColorPicker('ESPSkelColor', { Default = Color3.fromRGB(255,255,255), Callback = function(v) P.ESP_SkelColor = v end })
    local tTool = PEsp:AddToggle('ESPTool', { Text = 'Equipped Tool', Default = false, Callback = function(v) P.ESP_Tool = v end })
    tTool:AddColorPicker('ESPToolColor', { Default = Color3.fromRGB(200,200,200), Callback = function(v) P.ESP_ToolColor = v end })
    PEsp:AddSlider('ESPMaxDist', {
        Text = 'Max Render Distance',
        Default = 500,
        Min = 100,
        Max = 5000,
        Rounding = 0,
        Callback = function(v) P.ESP_MaxDist = v end
    })
    PEsp:AddDivider()
    PEsp:AddToggle('ArmsChams', {
        Text = 'Arms Chams',
        Default = false,
        Callback = function(state)
            local viewModel = Workspace.CurrentCamera:FindFirstChild("ViewModel")
            if viewModel and viewModel:FindFirstChild("Left Arm") and viewModel:FindFirstChild("Right Arm") then
                if state then
                    viewModel["Left Arm"].Material = Enum.Material.ForceField
                    viewModel["Right Arm"].Material = Enum.Material.ForceField
                else
                    viewModel["Left Arm"].Material = Enum.Material.Plastic
                    viewModel["Right Arm"].Material = Enum.Material.Plastic
                end
            end
            _G.Pidors_ArmsChams = state
            LocalPlayer.CharacterAdded:Connect(function(new_char)
                if not new_char then return end
                repeat task.wait() until new_char.Parent
                local newView = Workspace.CurrentCamera:WaitForChild("ViewModel")
                if newView:FindFirstChild("Left Arm") and newView:FindFirstChild("Right Arm") then
                    if _G.Pidors_ArmsChams then
                        newView["Left Arm"].Material = Enum.Material.ForceField
                        newView["Right Arm"].Material = Enum.Material.ForceField
                    else
                        newView["Left Arm"].Material = Enum.Material.Plastic
                        newView["Right Arm"].Material = Enum.Material.Plastic
                    end
                end
            end)
        end
    })
    PEsp:AddToggle('Chat', {
        Text = 'Chat',
        Default = false,
        Callback = function(state)
            _G.Pidors_Chat = state
            local TCS = game:GetService("TextChatService")
            if TCS and TCS.ChatWindowConfiguration then
                TCS.ChatWindowConfiguration.Enabled = state
            end
        end
    })
end

do
    local WorldGrp = Tabs.World:AddLeftGroupbox('World')

    WorldGrp:AddToggle('Fullbright', {
        Text = 'Fullbright',
        Default = false,
        Callback = function(v)
            if v then FullBright_Enable(); Library:Notify("Fullbright ON", 2)
            else FullBright_Disable(); Library:Notify("Fullbright OFF", 2) end
        end
    })
    WorldGrp:AddToggle('AutoDoors', {
        Text = 'Auto Open/Unlock Doors',
        Default = false,
        Callback = function(v)
            if v then OpenNearbyDoors_Enable(); UnlockNearbyDoors_Enable(); Library:Notify("Auto Doors ON", 2)
            else OpenNearbyDoors_Disable(); UnlockNearbyDoors_Disable(); Library:Notify("Auto Doors OFF", 2) end
        end
    })
    WorldGrp:AddToggle('FastPickup', {
        Text = 'Fast Pickup',
        Default = false,
        Callback = function(v)
            if v then FastInteract_Enable(); Library:Notify("Fast Pickup ON", 2)
            else FastInteract_Disable(); Library:Notify("Fast Pickup OFF", 2) end
        end
    })
    WorldGrp:AddToggle('AutoMoney', {
        Text = 'Auto Pickup Money',
        Default = false,
        Callback = function(v)
            if v then AutoPickupMoney_Enable(); Library:Notify("Auto Money ON", 2)
            else AutoPickupMoney_Disable(); Library:Notify("Auto Money OFF", 2) end
        end
    })
    WorldGrp:AddToggle('SliderSpam', {
        Text = 'Slider Spam',
        Default = false,
        Tooltip = 'Spamming slide sound (server side)',
        Callback = function(state)
            toggle_states.SlideSpam = state
            task.spawn(function()
                if toggle_states.SlideSpam then
                    while toggle_states.SlideSpam do
                        pcall(function()
                            ReplicatedStorage.Events.SlideEffect:FireServer()
                        end)
                        RunService.RenderStepped:Wait()
                    end
                end
            end)
        end
    })
    WorldGrp:AddToggle('AntiBarbwire', {
        Text = 'Anti Barbwire',
        Default = false,
        Tooltip = 'Removes Barbwire',
        Callback = function(state)
            toggle_states.NoBarriers = state
            if toggle_states.NoBarriers then
                local _iter_part = Workspace.Filter.Parts.F_Parts:GetDescendants()
                for _, part in pairs(_iter_part) do
                    if part:IsA("Part") or part:IsA("MeshPart") then
                        part.CanTouch = false
                    end
                end
            else
                local _iter_part = Workspace.Filter.Parts.F_Parts:GetDescendants()
                for _, part in pairs(_iter_part) do
                    if part:IsA("Part") or part:IsA("MeshPart") then
                        part.CanTouch = true
                    end
                end
            end
        end
    })
    WorldGrp:AddToggle('AutoPickupScraps', {
        Text = 'Auto Pickup Scraps',
        Default = false,
        Callback = function(state)
            toggle_states.AutoPickupScraps = state
            local pickup_event = ReplicatedStorage.Events.PIC_PU
            local spawned_piles = Workspace.Filter.SpawnedPiles
            local can_pickup = true
            local last_pickup_time = tick()
            if not toggle_states.AutoPickupScraps then
                if connection_table.AutopickupScraps then
                    connection_table.AutopickupScraps:Disconnect()
                    connection_table.AutopickupScraps = nil
                end
            else
                connection_table.AutopickupScraps = RunService.RenderStepped:Connect(function()
                    local nearest_pile = nil
                    local min_dist = 15
                    local _iter_pile = spawned_piles:GetChildren()
                    for _, pile in pairs(_iter_pile) do
                        local is_scrap = pile.Name == "S1" or pile.Name == "S2"
                        if is_scrap and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - pile.MeshPart.Position).Magnitude
                            if distance < min_dist then
                                min_dist = distance
                                nearest_pile = pile
                            end
                        end
                    end
                    if nearest_pile and can_pickup then
                        pickup_event:FireServer(string.reverse(nearest_pile:GetAttribute("jzu")))
                        can_pickup = false
                    end
                    if can_pickup == false and tick() - last_pickup_time >= 3.5 then
                        can_pickup = true
                        last_pickup_time = tick()
                    end
                end)
            end
        end
    })
    WorldGrp:AddToggle('AutoPickupTools', {
        Text = 'Auto Pickup Tools',
        Default = false,
        Callback = function(state)
            toggle_states.AutoPickupTools = state
            local pickup_event = ReplicatedStorage.Events.PIC_TLO
            local spawned_tools = Workspace.Filter.SpawnedTools
            local can_pickup = true
            local last_pickup_time = tick()
            if not toggle_states.AutoPickupTools then
                if connection_table.AutopickupTools then
                    connection_table.AutopickupTools:Disconnect()
                    connection_table.AutopickupTools = nil
                end
            else
                connection_table.AutopickupTools = RunService.RenderStepped:Connect(function()
                    local nearest_tool = nil
                    local min_dist = 10
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local _iter_tool = spawned_tools:GetChildren()
                        for _, tool in pairs(_iter_tool) do
                            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChild("WeaponHandle")
                            if handle and (handle:IsA("Part") or handle:IsA("MeshPart")) then
                                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - handle.Position).Magnitude
                                if distance < min_dist then
                                    min_dist = distance
                                    nearest_tool = tool
                                end
                            end
                        end
                    end
                    if nearest_tool then
                        local handle = nearest_tool:FindFirstChild("Handle") or nearest_tool:FindFirstChild("WeaponHandle")
                        if handle and can_pickup then
                            task.delay(0.1, function()
                                pickup_event:FireServer(handle)
                            end)
                            can_pickup = false
                        end
                    end
                    if can_pickup == false and tick() - last_pickup_time >= 1.5 then
                        can_pickup = true
                        last_pickup_time = tick()
                    end
                end)
            end
        end
    })
    WorldGrp:AddToggle('AutoPickupCrates', {
        Text = 'Auto Pickup Crates',
        Default = false,
        Callback = function(state)
            toggle_states.AutoPickupCrates = state
            local pickup_event = ReplicatedStorage.Events.PIC_PU
            local spawned_piles = Workspace.Filter.SpawnedPiles
            local can_pickup = true
            local last_pickup_time = tick()
            if not toggle_states.AutoPickupCrates then
                if connection_table.AutopickupCrates then
                    connection_table.AutopickupCrates:Disconnect()
                    connection_table.AutopickupCrates = nil
                end
            else
                connection_table.AutopickupCrates = RunService.RenderStepped:Connect(function()
                    local nearest_crate = nil
                    local min_dist = 15
                    local _iter_pile = spawned_piles:GetChildren()
                    for _, pile in pairs(_iter_pile) do
                        local is_crate = pile.Name == "C1" or pile.Name == "C2" or pile.Name == "C3"
                        if is_crate and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - pile.MeshPart.Position).Magnitude
                            if distance < min_dist then
                                min_dist = distance
                                nearest_crate = pile
                            end
                        end
                    end
                    if nearest_crate and can_pickup then
                        pickup_event:FireServer(string.reverse(nearest_crate:GetAttribute("jzu")))
                        can_pickup = false
                    end
                    if can_pickup == false and tick() - last_pickup_time >= 4 then
                        can_pickup = true
                        last_pickup_time = tick()
                    end
                end)
            end
        end
    })

    local AmbianceGrp = Tabs.World:AddLeftGroupbox('Ambiance')

    local tAmbiance = AmbianceGrp:AddToggle('AmbianceToggle', {
        Text = 'Enable Ambiance',
        Default = false,
        Callback = function(v)
            if v then
                local cc = Lighting:FindFirstChild("CustomAmbiance") or Instance.new("ColorCorrectionEffect", Lighting)
                cc.Name = "CustomAmbiance"
                cc.Enabled = true
                connection_table.Ambiance = RunService.RenderStepped:Connect(function()
                    if not Toggles.AmbianceToggle or not Toggles.AmbianceToggle.Value then return end
                    local col = P.AmbianceColor or Color3.fromRGB(255,255,255)
                    cc.TintColor = col
                    Lighting.Ambient = col
                    Lighting.OutdoorAmbient = col
                    Lighting.ClockTime = P.AmbianceTime or 12
                    Lighting.Brightness = P.AmbianceBrightness or 2
                end)
            else
                if connection_table.Ambiance then
                    connection_table.Ambiance:Disconnect()
                    connection_table.Ambiance = nil
                end
                local cc = Lighting:FindFirstChild("CustomAmbiance")
                if cc then
                    cc.Enabled = false
                end
            end
        end
    })
    tAmbiance:AddColorPicker('AmbianceColor', { Default = Color3.fromRGB(255,255,255), Callback = function(v)
        P.AmbianceColor = v
        local cc = Lighting:FindFirstChild("CustomAmbiance")
        if cc and cc.Enabled then
            cc.TintColor = v
            Lighting.Ambient = v
            Lighting.OutdoorAmbient = v
        end
    end })
    AmbianceGrp:AddSlider('AmbianceTime', {
        Text = 'Time Of Day',
        Default = 12,
        Min = 0,
        Max = 24,
        Rounding = 0,
        Callback = function(v)
            P.AmbianceTime = v
            local cc = Lighting:FindFirstChild("CustomAmbiance")
            if cc and cc.Enabled then
                Lighting.ClockTime = v
            end
        end
    })
    AmbianceGrp:AddSlider('AmbianceBrightness', {
        Text = 'Brightness',
        Default = 2,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Callback = function(v)
            P.AmbianceBrightness = v
            local cc = Lighting:FindFirstChild("CustomAmbiance")
            if cc and cc.Enabled then
                Lighting.Brightness = v
            end
        end
    })
    AmbianceGrp:AddToggle('NoFog', {
        Text = 'No Fog',
        Default = false,
        Callback = function(v)
            if v then
                P.OldFogEnd = P.OldFogEnd or Lighting.FogEnd
                Lighting.FogEnd = 100000
            else
                if P.OldFogEnd then
                    Lighting.FogEnd = P.OldFogEnd
                end
            end
        end
    })
    local tBloom = AmbianceGrp:AddToggle('BloomToggle', {
        Text = 'Enable Bloom',
        Default = false,
        Callback = function(v)
            local b = Lighting:FindFirstChild("CustomBloom") or Instance.new("BloomEffect", Lighting)
            b.Name = "CustomBloom"
            if v then
                b.Enabled = true
                b.Intensity = P.BloomIntensity or 1
                b.Size = P.BloomSize or 23
                b.Threshold = P.BloomThreshold or 2
            else
                b.Enabled = false
            end
        end
    })
    AmbianceGrp:AddSlider('BloomIntensity', {
        Text = 'Bloom Intensity',
        Default = 1,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Callback = function(v)
            P.BloomIntensity = v
            local b = Lighting:FindFirstChild("CustomBloom")
            if b and b.Enabled then
                b.Intensity = v
            end
        end
    })
    AmbianceGrp:AddSlider('BloomSize', {
        Text = 'Bloom Size',
        Default = 23,
        Min = 0,
        Max = 56,
        Rounding = 0,
        Callback = function(v)
            P.BloomSize = v
            local b = Lighting:FindFirstChild("CustomBloom")
            if b and b.Enabled then
                b.Size = v
            end
        end
    })
    AmbianceGrp:AddSlider('BloomThreshold', {
        Text = 'Bloom Threshold',
        Default = 2,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Callback = function(v)
            P.BloomThreshold = v
            local b = Lighting:FindFirstChild("CustomBloom")
            if b and b.Enabled then
                b.Threshold = v
            end
        end
    })

    AmbianceGrp:AddDivider()
    local tPlayerRig = AmbianceGrp:AddToggle('PlayerRigToggle', {
        Text = 'Modify Player Rig',
        Default = false,
        Callback = function(v)
            if v then
                connection_table.PlayerRig = RunService.RenderStepped:Connect(function()
                    if not Toggles.PlayerRigToggle or not Toggles.PlayerRigToggle.Value then return end
                    if not LocalPlayer.Character then return end
                    local mat = Enum.Material[Options.PlayerRigMaterial.Value]
                    local col = Options.PlayerRigColor.Value
                    local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                    local _iter_p = LocalPlayer.Character:GetDescendants()
                    for _, p in pairs(_iter_p) do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                            if not tool or not p:IsDescendantOf(tool) then
                                if not p:GetAttribute("OrigMat") then
                                    p:SetAttribute("OrigMat", p.Material.Name)
                                    p:SetAttribute("OrigColor", p.Color)
                                end
                                p.Color = col
                                p.Material = mat
                            end
                        end
                    end
                end)
            else
                if connection_table.PlayerRig then
                    connection_table.PlayerRig:Disconnect()
                    connection_table.PlayerRig = nil
                end
                if LocalPlayer.Character then
                    local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                    local _iter_p = LocalPlayer.Character:GetDescendants()
                    for _, p in pairs(_iter_p) do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" and p:GetAttribute("OrigMat") then
                            if not tool or not p:IsDescendantOf(tool) then
                                p.Material = Enum.Material[p:GetAttribute("OrigMat")]
                                p.Color = p:GetAttribute("OrigColor")
                                p:SetAttribute("OrigMat", nil)
                            end
                        end
                    end
                end
            end
        end
    })
    tPlayerRig:AddColorPicker('PlayerRigColor', { Default = Color3.fromRGB(128, 0, 128), Callback = function(v) end })
    AmbianceGrp:AddLabel('Player Rig Material')
    AmbianceGrp:AddDropdown('PlayerRigMaterial', {
        Values = {'ForceField','Neon','Plastic','SmoothPlastic','Glass','Foil','Metal','Wood'},
        Default = 1,
        Callback = function(v) end
    })

    local WESP = Tabs.Visuals:AddRightGroupbox('World ESP')

    local tWDealers = WESP:AddToggle('WESPDealers', { Text = 'Dealers (Shop)', Default = false, Callback = function(v) P.WESP_Dealers = v end })
    tWDealers:AddColorPicker('WESPDealerColor', { Default = Color3.fromRGB(255,200,0), Callback = function(v) P.WESP_DealerColor = v end })
    local tWCash = WESP:AddToggle('WESPCash', { Text = 'Dropped Cash', Default = false, Callback = function(v) P.WESP_Cash = v end })
    tWCash:AddColorPicker('WESPCashColor', { Default = Color3.fromRGB(0,255,0), Callback = function(v) P.WESP_CashColor = v end })
    local tWItems = WESP:AddToggle('WESPItems', { Text = 'Dropped Items', Default = false, Callback = function(v) P.WESP_Items = v end })
    tWItems:AddColorPicker('WESPItemColor', { Default = Color3.fromRGB(0,150,255), Callback = function(v) P.WESP_ItemColor = v end })
    local tWAlarms = WESP:AddToggle('WESPAlarms', { Text = 'Alarms', Default = false, Callback = function(v) P.WESP_Alarms = v end })
    tWAlarms:AddColorPicker('WESPAlarmColor', { Default = Color3.fromRGB(255,50,50), Callback = function(v) P.WESP_AlarmColor = v end })
    local tWATMs = WESP:AddToggle('WESPATMs', { Text = 'ATMs', Default = false, Callback = function(v) P.WESP_ATMs = v end })
    tWATMs:AddColorPicker('WESPATMColor', { Default = Color3.fromRGB(200,0,255), Callback = function(v) P.WESP_ATMColor = v end })
    local tWMystery = WESP:AddToggle('WESPMystery', { Text = 'Mystery Boxes', Default = false, Callback = function(v) P.WESP_Mystery = v end })
    tWMystery:AddColorPicker('WESPMysteryColor', { Default = Color3.fromRGB(255,100,200), Callback = function(v) P.WESP_MysteryColor = v end })
    local tWPiles = WESP:AddToggle('WESPPiles', { Text = 'Lootable Piles', Default = false, Callback = function(v) P.WESP_Piles = v end })
    tWPiles:AddColorPicker('WESPPileColor', { Default = Color3.fromRGB(0,255,255), Callback = function(v) P.WESP_PileColor = v end })
end

do
    local MiscGrp = Tabs.Misc:AddLeftGroupbox('Utility')

    MiscGrp:AddToggle('AdminCheck', {
        Text = 'Admin Check',
        Default = false,
        Callback = function(v)
            if v then AdminCheck_Enable(); Library:Notify("Admin Check ON", 2)
            else AdminCheck_Disable(); Library:Notify("Admin Check OFF", 2) end
        end
    })

    local FarmGrp = Tabs.Misc:AddRightGroupbox('Farm')

    FarmGrp:AddToggle('NoFailLock', {
        Text = 'No Fail Lockpick',
        Default = false,
        Callback = function(v)
            if v then NoFailLockpick_Enable(); Library:Notify("No Fail Lockpick ON", 2)
            else NoFailLockpick_Disable(); Library:Notify("No Fail Lockpick OFF", 2) end
        end
    })
    FarmGrp:AddToggle('AutoClaimAllowance', {
        Text = 'Auto Claim Allowance',
        Default = false,
        Callback = function(state)
            toggle_states.AutoClaimAllowance = state
            if not toggle_states.AutoClaimAllowance then
                if connection_table.AutoClaimAllowance then
                    connection_table.AutoClaimAllowance:Disconnect()
                    connection_table.AutoClaimAllowance = nil
                end
            else
                local function find_nearest_atm(max_distance)
                    local closest_part = nil
                    local _iter_atm = Workspace.Map.ATMz:GetChildren()
                    for _, atm in ipairs(_iter_atm) do
                        local main = atm:FindFirstChild("MainPart")
                        if main and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - main.Position).Magnitude
                            if distance < max_distance then
                                closest_part = main
                                max_distance = distance
                            end
                        end
                    end
                    return closest_part
                end
                connection_table.AutoClaimAllowance = RunService.RenderStepped:Connect(function()
                    local pData = ReplicatedStorage:FindFirstChild("PlayerbaseData2")
                    if not pData then return end
                    local pEntry = pData:FindFirstChild(LocalPlayer.Name)
                    if not pEntry then return end
                    local nextAllowance = pEntry:FindFirstChild("NextAllowance")
                    if not nextAllowance or nextAllowance.Value ~= 0 then return end
                    local atm_part = find_nearest_atm(math.huge)
                    if atm_part then
                        ReplicatedStorage.Events.CLMZALOW:InvokeServer(atm_part)
                    end
                end)
            end
        end
    })
end

do
    local AnimGrp = Tabs.Working:AddLeftGroupbox('Animation Modifier')

    AnimGrp:AddToggle('SlowAnimToggle', {
        Text = 'Slow Equip Animations',
        Default = false,
        Callback = function(v)
            if v then
                local function hookAnimator(char)
                    local hum = char:WaitForChild("Humanoid", 10)
                    if not hum then return end
                    local animator = hum:FindFirstChildOfClass("Animator") or char:FindFirstChildOfClass("Animator")
                    if not animator then
                        animator = Instance.new("Animator")
                        animator.Parent = hum
                    end
                    connection_table.SlowAnim = animator.AnimationPlayed:Connect(function(track)
                        if Toggles.SlowAnimToggle and Toggles.SlowAnimToggle.Value then
                            local speed
                            if Options.SlowAnimSpeed then
                                speed = Options.SlowAnimSpeed.Value
                            else
                                speed = 0.2
                            end
                            track:AdjustSpeed(speed)
                        end
                    end)
                end
                if LocalPlayer.Character then
                    hookAnimator(LocalPlayer.Character)
                end
                connection_table.SlowAnimCharAdded = LocalPlayer.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    hookAnimator(char)
                end)
            else
                if connection_table.SlowAnim then
                    connection_table.SlowAnim:Disconnect()
                    connection_table.SlowAnim = nil
                end
                if connection_table.SlowAnimCharAdded then
                    connection_table.SlowAnimCharAdded:Disconnect()
                    connection_table.SlowAnimCharAdded = nil
                end
            end
        end
    })
    AnimGrp:AddSlider('SlowAnimSpeed', {
        Text = 'Animation Speed',
        Default = 0.5,
        Min = 0.10,
        Max = 0.99,
        Rounding = 2,
        Suffix = 'x',
        Callback = function(v) end
    })
end

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('pidors')
ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder('pidors')
SaveManager:BuildConfigSection(Tabs['UI Settings'])


local function onCharDied()
    if Fly_Enable then
        local FlyConn = nil
        Fly_Disable()
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    local hum = char:WaitForChild("Humanoid", 10)
    if hum then hum.Died:Connect(onCharDied) end
    if P.JumpDelay_Value > 0 then
        pcall(function() hum.JumpCooldown = P.JumpDelay_Value end)
    end
end)

if LocalPlayer.Character then
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Died:Connect(onCharDied) end
end

Library:Notify("pidors.cc v5.0 loaded!", 3)


