local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("mm2 (melhor doq alguns ai)", "Serpent") -- for different colors, use these: "GrapeTheme" "DarkTheme" "LightTheme" "BloodTheme" "Ocean" "Midnight" "Sentinel" "Synapse" "Serpent"
 
local startergui = game:GetService("StarterGui")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local teleportDistance = 2
local radius = 20
 
-- Main
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("script ta quebrado ainda , ent saiba q tem bug pa porra")
local MainSection = Main:NewSection("1 script q pelo menos funciona")
local MainSection = Main:NewSection("silent aim e bem merda pq o solara e 1 merda tbm")
MainSection:NewButton("Infinite Yield", "admin commands", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)
 
-- Variables for hitbox size and transparency
local hitboxSize = 2
local hitboxTransparency = 0.5
 
MainSection:NewButton("Murderer/Sheriff/Innocent ESP", "shows everyone on the map", function()
    local function updateESPColor(player, highlight)
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character
        local hasGun, hasKnife = false, false
 
        if backpack then
            hasGun = backpack:FindFirstChild("Gun") ~= nil
            hasKnife = backpack:FindFirstChild("Knife") ~= nil
        end
 
        if character then
            hasGun = hasGun or (character:FindFirstChild("Gun") ~= nil)
            hasKnife = hasKnife or (character:FindFirstChild("Knife") ~= nil)
        end
 
        if hasGun then
            highlight.FillColor = Color3.new(0, 0, 1)  -- Blue
        elseif hasKnife then
            highlight.FillColor = Color3.new(1, 0, 0)  -- Red
        else
            highlight.FillColor = Color3.new(0, 1, 0)  -- Green
        end
    end
 
    local function createESP(player)
        local function updateLabel(billboardGui, textLabel, character)
            local distance = (localPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            textLabel.Text = string.format("%s\n%.0f studs", player.Name, distance)
        end
 
        local function createBillboard(character)
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "ESPBillboard"
            billboardGui.Adornee = character:FindFirstChild("HumanoidRootPart")
            billboardGui.Size = UDim2.new(0, 100, 0, 50)
            billboardGui.StudsOffset = Vector3.new(0, 4, 0)
            billboardGui.AlwaysOnTop = true
 
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.TextColor3 = Color3.new(1, 1, 1)
            textLabel.TextStrokeTransparency = 0
            textLabel.Font = Enum.Font.SourceSans
            textLabel.TextSize = 14
            textLabel.Parent = billboardGui
 
            game:GetService("RunService").Heartbeat:Connect(function()
                if character:FindFirstChild("HumanoidRootPart") then
                    updateLabel(billboardGui, textLabel, character)
                end
            end)
 
            billboardGui.Parent = character
        end
 
        local character = player.Character or player.CharacterAdded:Wait()
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP"
        highlight.Adornee = character
        highlight.FillColor = Color3.new(0, 1, 0)  -- Default Green
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.OutlineTransparency = 0
        highlight.Parent = character
 
        updateESPColor(player, highlight)
 
        local function onToolChanged()
            updateESPColor(player, highlight)
        end
 
        if player.Backpack then
            player.Backpack.ChildAdded:Connect(onToolChanged)
            player.Backpack.ChildRemoved:Connect(onToolChanged)
        end
 
        if character then
            character.ChildAdded:Connect(onToolChanged)
            character.ChildRemoved:Connect(onToolChanged)
        end
 
        createBillboard(character)
 
        -- Periodic check to ensure the distance display is present
        game:GetService("RunService").Heartbeat:Connect(function()
            if character:FindFirstChild("HumanoidRootPart") and not character:FindFirstChild("ESPBillboard") then
                createBillboard(character)
            end
        end)
    end
 
    local function onCharacterAdded(character)
        createESP(players:GetPlayerFromCharacter(character))
    end
 
    local function onPlayerAdded(player)
        if player.Character then
            onCharacterAdded(player.Character)
        end
        player.CharacterAdded:Connect(onCharacterAdded)
    end
 
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            onPlayerAdded(player)
        end
    end
 
    players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then
            onPlayerAdded(player)
        end
    end)
end)
 
 
MainSection:NewButton("Turn off ESP", "turns off the esp finally", function()
    local function removeESP(player)
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESP")
            if highlight then
                highlight:Destroy()
            end
            local billboardGui = player.Character:FindFirstChild("ESPBillboard")
            if billboardGui then
                billboardGui:Destroy()
            end
        end
    end
 
    for _, player in pairs(players:GetPlayers()) do
        if player ~= localPlayer then
            removeESP(player)
        end
    end
 
    players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then
            player.CharacterAdded:Connect(function(character)
                removeESP(player)
            end)
        end
    end)
end)
 
 
-- Sliders for Hitbox Size and Transparency
MainSection:NewSlider("Hitbox tamanho", "Adjust the hitbox size", 40, 1, function(value)
    hitboxSize = value
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            hrp.Transparency = hitboxTransparency
            hrp.CanCollide = false
        end
    end
end)
 
MainSection:NewSlider("Hitbox transparencia", "Adjust the hitbox transparency", 10, 0, function(value)
    hitboxTransparency = value / 10
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Transparency = hitboxTransparency
            hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
            hrp.CanCollide = false
        end
    end
end)
 
-- WalkSpeed and JumpPower sliders
MainSection:NewSlider("speed", "Adjust the WalkSpeed", 25, 16, function(value)
    localPlayer.Character.Humanoid.WalkSpeed = value
end)
 
MainSection:NewSlider("pulo", "Adjust the JumpPower", 100, 50, function(value)
    localPlayer.Character.Humanoid.JumpPower = value
end)
 
-- Sheriff/Innocent Section
local SheriffInnocent = Window:NewTab("Sheriff/Innocent")
local SheriffInnocentSection = SheriffInnocent:NewSection("Sheriff/Innocent")
SheriffInnocent:NewSection("e 1 botao")
SheriffInnocent:NewSection("tenha certeza que o murder nao esteja atras da parede")
 
SheriffInnocentSection:NewButton("dar tp pra arma", "grab that gun", function()
    local player = localPlayer.Character
    local part = workspace.Normal:FindFirstChild("GunDrop") 
 
    -- Save the player's original CFrame
    local originalCFrame = player.HumanoidRootPart.CFrame
 
    -- Teleport to the part
    if part then
        player.HumanoidRootPart.CFrame = part.CFrame
    end
 
    -- Wait for a short duration (e.g., 2 seconds) before teleporting back
    wait(0.3)
 
    -- Teleport back to the original CFrame
    player.HumanoidRootPart.CFrame = originalCFrame
end)
 
local function getNearestPlayer()
    local players = game.Players:GetPlayers()
    local shortestDistance = math.huge
    local nearestPlayer = nil
 
    for _, player in ipairs(players) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end
 
    return nearestPlayer
end
 
local function silentAim()
    local mouse = localPlayer:GetMouse()
    local UserInputService = game:GetService("UserInputService")
    local camera = workspace.CurrentCamera
 
    UserInputService.InputBegan:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and not processed then
            local nearestPlayer = getNearestPlayer()
            if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local head = nearestPlayer.Character:FindFirstChild("Head")
                if head then
                    mouse.Hit = head.CFrame
                    mouse.Target = head
                end
            end
        end
    end)
end
 
local silentAimEnabled = false
 
local function getNil(name, class)
    for _, v in next, getnilinstances() do
        if v.ClassName == class and v.Name == name then
            return v
        end
    end
end
 
local function invokeBeam(targetPosition)
    local args = {
        [1] = 1,
        [2] = targetPosition,
        [3] = "AH2"
    }
    local remoteFunction = localPlayer.Character:FindFirstChild("Gun"):FindFirstChild("KnifeLocal"):FindFirstChild("CreateBeam"):FindFirstChild("RemoteFunction")
    
    if remoteFunction then
        remoteFunction:InvokeServer(unpack(args))
    end
end
 
local function getMurdererPosition()
    for _, player in ipairs(players:GetPlayers()) do
        if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                return character.HumanoidRootPart.Position
            end
        end
    end
    return nil
end
 
local function silentAim()
    if silentAimEnabled then
        local targetPosition = getMurdererPosition()
        if targetPosition then
            invokeBeam(targetPosition)
        end
    end
end
 
SheriffInnocentSection:NewButton("atirar no murder (silent aim)", "Enables or disables silent aim", function()
    silentAimEnabled = not silentAimEnabled
end)
 
-- Run the silent aim function every 0.1 seconds
game:GetService("RunService").RenderStepped:Connect(function()
    silentAim()
end)
 
-- Murderer Section
local Murderer = Window:NewTab("Murderer")
local MurdererSection = Murderer:NewSection("Murderer")
 
local function hasItem(player, itemName)
    -- Check the backpack
    for _, item in ipairs(player.Backpack:GetChildren()) do
        if item.Name == itemName then
            return true
        end
    end
 
    -- Check the equipped items (character)
    for _, item in ipairs(player.Character:GetChildren()) do
        if item:IsA("Tool") and item.Name == itemName then
            return true
        end
    end
 
    return false
end
 
local function teleportToPlayerWithGun()
    for _, player in ipairs(players:GetPlayers()) do
        if hasItem(player, "Gun") then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                localPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
            end
            break
        end
    end
end
 
MurdererSection:NewButton("dar tp para oq tem a arma", "bem auto-explicativo", function()
    teleportToPlayerWithGun()
end)
 
-- Variables for the grab feature
local grabDistance = 20
local teleportDistance = 2
local keybind = Enum.KeyCode.E
local grabEnabled = false
 
-- Function to handle grabbing players
local function grabPlayers()
    while grabEnabled do
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (localPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
                if distance <= grabDistance then
                    local newCFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position + localPlayer.Character.HumanoidRootPart.CFrame.LookVector * teleportDistance)
                    player.Character:SetPrimaryPartCFrame(newCFrame)
                end
            end
        end
        wait(0.1)
    end
end
 
MurdererSection:NewKeybind("Pegar Jogadores", "keybind", keybind, function()
    grabEnabled = not grabEnabled
    if grabEnabled then
        grabPlayers()
    end
end)
 
MurdererSection:NewSlider("Distancia de pegar", "distancia", 200, 1, function(value)
    grabDistance = value
end)
 
MurdererSection:NewSlider("Distancia do tp", "tp", 15, 1, function(value)
    teleportDistance = value
end)
 
local Autofarm = Window:NewTab("Autofarm")
 
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
 
local AutofarmSection = Autofarm:NewSection("any tween speeds work, they are NOT detected.")
local tweenSpeed = 100 -- Default speed
 
AutofarmSection:NewSlider("tween speed", "deve tar quebrado sla", 25, 16, function(value)
    tweenSpeed = value
end)
 
local function getClosestCoin()
    local closestCoin = nil
    local closestDistance = math.huge
    local coins = workspace.Normal.CoinContainer:GetChildren()
 
    for _, coin in ipairs(coins) do
        if coin.Name == "Coin_Server" and coin:IsDescendantOf(workspace) then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - coin.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestCoin = coin
            end
        end
    end
 
    return closestCoin
end
 
local autofarm = false
 
AutofarmSection:NewToggle("autofarm cria", "cria", function(state)
    autofarm = state
    while autofarm do
        local closestCoin = getClosestCoin()
        if closestCoin then
            local startTime = tick()
            local tweenInfo = TweenInfo.new((LocalPlayer.Character.HumanoidRootPart.Position - closestCoin.Position).Magnitude / tweenSpeed, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(LocalPlayer.Character.HumanoidRootPart, tweenInfo, {CFrame = closestCoin.CFrame})
            tween:Play()
            tween.Completed:Wait()
            
            -- Check if the tween is still valid
            if tick() - startTime < tweenInfo.Time and closestCoin:IsDescendantOf(workspace) then
                wait(2)
            end
        else
            wait(0.5) -- Check again after a short delay if no coins are found
        end
    end
end)
local AutofarmSection = Autofarm:NewSection("farm")
 
 
 
local teleporting = false
 
-- Define the path to the CoinContainer and the target teleport position
local coinContainer = game.Workspace.Normal.CoinContainer
local lobbyFountainPosition = game.Workspace.Lobby.Map.Fountain.Nikilis.WanwoodAntlers.WanwoodAntlers.Position
 
-- Function to teleport to a specific position
local function teleportToPosition(targetPosition)
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
 
    -- Set the character's HumanoidRootPart CFrame to the target position
    character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
end
 
-- Function to find the closest coin
local function getClosestCoin()
    local character = game.Players.LocalPlayer.Character
    local closestCoin = nil
    local shortestDistance = math.huge -- Initialize to a very large number
 
    for _, coin in ipairs(coinContainer:GetChildren()) do
        if coin:IsA("Part") and coin:FindFirstChild("TouchInterest") then
            local distance = (coin.Position - character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestCoin = coin
            end
        end
    end
    
    return closestCoin
end
 
-- Function to start the teleportation loop
local function startTeleportation()
    teleporting = true
    while teleporting do
        local closestCoin = getClosestCoin()
 
        if closestCoin then
            wait(3) -- Wait for 4 seconds before teleporting to the coin
            teleportToPosition(closestCoin.Position)
            wait(0.4) -- Wait for 1 second at the coin's position
            teleportToPosition(lobbyFountainPosition)
        else
            -- No coins found, stay at the lobby fountain
            teleportToPosition(lobbyFountainPosition)
        end
 
        wait(0.5) -- Check again after a short delay
    end
end
 
-- Function to stop the teleportation loop
local function stopTeleportation()
    teleporting = false
end
 
-- Create buttons in the Autofarm section
AutofarmSection:NewButton("collect coin", "coleta moedas", function()
    startTeleportation()
end)
 
AutofarmSection:NewButton("stop collect", "parar de coletar", function()
    stopTeleportation()
end)
