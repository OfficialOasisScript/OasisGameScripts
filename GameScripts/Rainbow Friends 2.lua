local player = game.Players.LocalPlayer
local character = player.Character
local primaryPart = character and character.PrimaryPart or character:FindFirstChild("HumanoidRootPart")

local monstersFolder = workspace:FindFirstChild("Monsters")
local ignoreFolder = workspace:FindFirstChild("ignore")

local NoClipConnection = nil
local teleporting = false -- Variable to keep track of teleportation state
local infiniteJump = false

-- functions --
local function enableNoclip()
    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function disableNoclip()
    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    -- Reset the character's state so it doesn't get stuck in weird positions
    if humanoid then
        humanoid:ChangeState(5) -- The 'FallingDown' state to make character fall and resolve collisions naturally
    end
end

local monstersFolder = workspace:FindFirstChild("Monsters")

local function createLabels()
    if monstersFolder then
        for _, model in pairs(monstersFolder:GetChildren()) do
            if model:IsA("Model") and (model.Name == "Blue" or model.Name == "Cyan" or model.Name == "Purple" or model.Name == "Green") and not model:FindFirstChild("MonsterLabel") then
                local part = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart") -- Attach to "Head" if it exists, otherwise attach to any BasePart in the model

                if part then
                    local gui = Instance.new("BillboardGui")
                    gui.Name = "MonsterLabel" -- Name it so we can easily find and remove it later
                    gui.Size = UDim2.new(0, 100, 0, 50) 
                    gui.AlwaysOnTop = true
                    gui.Adornee = part

                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = model.Name
                    textLabel.TextSize = 24 
                    textLabel.TextColor3 = Color3.new(1, 1, 1)
                    textLabel.Parent = gui

                    gui.Parent = model
                end
            end
        end
    end
end

local function removeLabels()
    if monstersFolder then
        for _, model in pairs(monstersFolder:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("MonsterLabel") then
                model.MonsterLabel:Destroy()
            end
        end
    end
end

local function findModels(modelNames)
    local models = {}
    for _, name in pairs(modelNames) do
        for _, item in pairs(workspace:GetDescendants()) do
            if item:IsA("Model") and item.Name == name then
                table.insert(models, item)
            end
        end
    end
    return models
end

local function createHighlights(targetModels)
    for _, model in pairs(targetModels) do
        if not model:FindFirstChild("ModelHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ModelHighlight"
            
            highlight.Adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            highlight.Enabled = true
            highlight.FillColor = Color3.new(1, 1, 1)
            highlight.FillTransparency = 0
            highlight.OutlineColor = Color3.new(0, 0, 0)
            highlight.OutlineTransparency = 0
            
            highlight.Parent = model
        end
    end
end

local function removeHighlights(targetModels)
    for _, model in pairs(targetModels) do
        if model:FindFirstChild("ModelHighlight") then
            model.ModelHighlight:Destroy()
        end
    end
end

local function teleportModelsToChar(modelsList)
    while teleporting do
        for _, modelName in pairs(modelsList) do
            if not teleporting then
                return -- Stop if the toggle is turned off
            end

            local model = workspace:FindFirstChild(modelName)
            if model and model:IsA("Model") and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")) then
                local modelPrimaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                local offset = modelPrimaryPart.Position - model:GetPrimaryPartCFrame().p
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CFrame = primaryPart.CFrame * CFrame.new(offset)
                    end
                end
            end
            wait(0.1)
        end
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Oasis 🔹 - Rainbow Friends 2 🌈",
    LoadingTitle = "Oasis Interface 🔹",
    LoadingSubtitle = "Rainbow Friends 2 🌟",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "RainbowFriends2Configs", 
       FileName = "OasisSettings📜"
    },
    Discord = {
       Enabled = true,
       Invite = "nZ9jsNM5kq", 
       RememberJoins = false
    },
    KeySystem = false, 
    KeySettings = {
       Title = "Oasis Key System 🗝️",
       Subtitle = "Access Settings 🔓",
       Note = "Please get the key from the discord",
       FileName = "OasisKey", 
       SaveKey = false, 
       GrabKeyFromSite = false, 
       Key = {"Hello"}
    }
 })

 Rayfield:Notify({
    Title = "Join Our Discord 🌐",
    Content = "Want more scripts or updates? Copy our Discord invite!",
    Duration = 4,
    Image = nil,
    Actions = { 
       {
          Name = "Copy Invite",
          Callback = function()
            setclipboard('discord.gg/nZ9jsNM5kq')
          end
       },
       Ignore = {
          Name = "No Thanks",
          Callback = function()
             print("The user declined the invite offer.")
          end
       }
    },
 })
 
 
local PlayerTab = Window:CreateTab("👤 Player", nil)
local ESPTab = Window:CreateTab("👀 Visuals", nil)
local extraTab = Window:CreateTab("🔨 Extra", nil)

local PlayerSection = PlayerTab:CreateSection("🏃‍♂️ Movement")

local WalkspeedSlider = PlayerTab:CreateSlider({
    Name = "Walkspeed",
    Range = {0, 300},
    Increment = 1,
    Suffix = " ws",
    CurrentValue = 16,
    Flag = "SliderWS",
    Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
 })
 

 local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "JumpPower",
    Range = {0, 300},
    Increment = 1,
    Suffix = " jp",
    CurrentValue = 50,
    Flag = "SliderJP",
    Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
 })
 

 local GravitySlider = PlayerTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 300}, 
    Increment = 1,
    Suffix = " g",
    CurrentValue = 196.2,
    Flag = "SliderG",
    Callback = function(Value)
       game.Workspace.Gravity = Value
    end,
 })
 

 local FOVSlider = PlayerTab:CreateSlider({
    Name = "Field of View",
    Range = {0, 120}, 
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "SliderFOV",
    Callback = function(Value)
       game.Workspace.CurrentCamera.FieldOfView = Value
    end,
 })
 
local PlayerSection = PlayerTab:CreateSection("🔧 Player Mods")

local NoclipToggle = PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "ToggleNoclip",
    Callback = function(Value)
        local player = game.Players.LocalPlayer

        -- Disconnect existing connection if it exists
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end

        if Value then
            NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
                if player and player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if player and player.Character then
                for _, part in ipairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})
 
 -- Infinite Jump Toggle
 local InfiniteJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "ToggleInfiniteJump",
    Callback = function(Value)
       infiniteJump = Value
 
       -- Infinite Jump Logic
       game:GetService("UserInputService").JumpRequest:Connect(function()
          if infiniteJump then
             game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
          end
       end)
    end,
 })


 ------ VISUALS TAB -----
 local Section = ESPTab:CreateSection("👀 ESP")

 local Toggle = ESPTab:CreateToggle({
    Name = "Monster ESP",
    CurrentValue = false,
    Flag = "MonsterToggle",
    Callback = function(Value)
        if Value then
            createLabels()
        else
            removeLabels()
        end
    end,
})

local Toggle = ESPTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Flag = "ModelHighlightToggle",
    Callback = function(Value)
        local targetModels = findModels({"GasCanister", "LightBulb", "CakeMix"})

        if #targetModels == 0 then
            -- If no GasCanister, LightBulb, or CakeMix found, do nothing.
            return
        elseif not findModels({"GasCanister"})[1] then
            if findModels({"LightBulb"})[1] then
                -- If GasCanister isn't found but LightBulb is found, highlight LightBulb models.
                targetModels = findModels({"LightBulb"})
            else
                -- If neither GasCanister nor LightBulb is found, but CakeMix is, highlight CakeMix models.
                targetModels = findModels({"CakeMix"})
            end
        else
            -- If GasCanister is found, use them as the target models.
            targetModels = findModels({"GasCanister"})
        end

        if Value then
            createHighlights(targetModels)
        else
            removeHighlights(targetModels)
        end
    end,
})


------ EXTRA TAB ------
local Section = extraTab:CreateSection("🎭 Misc")
local Paragraph = extraTab:CreateParagraph({Title = "About Looky Item", Content = "Sorry i couldn't make it so that you can collect Looky"})
local Toggle = extraTab:CreateToggle({
    Name = "Auto Collect Items",
    CurrentValue = false,
    Flag = "ModelTeleportToggle",
    Callback = function(Value)
        teleporting = Value -- Set teleporting state based on toggle value
        if Value then
            teleportModelsToChar({"GasCanister", "LightBulb", "CakeMix", "Looky"})
        end
    end,
})

local Section = extraTab:CreateSection("⚙ Settings")

local Label = extraTab:CreateLabel("🔨Dev: vpm<3#7130")
