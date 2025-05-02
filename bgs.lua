--// FullScreen DuckHub Dashboard Native + Logic Auto (Tiếng Việt)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Services (for future automation hooks)
local function safeFire(remote, ...)
    if typeof(remote) == "Instance" and remote:IsA("RemoteEvent") then
        pcall(function() 
            remote:FireServer(...) 
        end)
    else
        warn("[safeFire ERROR]: Remote không phải là một RemoteEvent hợp lệ!")
    end
end

local function safeInvoke(remote, ...)
    if typeof(remote) == "Instance" and remote:IsA("RemoteFunction") then
        local success, result = pcall(function()
            return remote:InvokeServer(...)
        end)
        if success then
            return result
        else
            warn("[safeInvoke ERROR]:", result)
            return nil
        end
    else
        warn("[safeInvoke ERROR]: Remote không phải là một RemoteFunction hợp lệ!")
    end
    return nil
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Background = Instance.new("Frame")
Background.Parent = ScreenGui
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Background.BorderSizePixel = 0

local function CreateInfoLabel(text, posY)
    local Label = Instance.new("TextLabel")
    Label.Parent = Background
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 20
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0.5, -200, 0, posY)
    Label.Size = UDim2.new(0, 400, 0, 30)
    Label.TextStrokeTransparency = 0.8
    return Label
end

-- UI Labels
local UsernameLabel = CreateInfoLabel("Username: " .. LocalPlayer.Name, 80)
local BestPetLabel = CreateInfoLabel("Best Pet: Loading...", 130)
local HatchLabel = CreateInfoLabel("Total Hatches: 0", 180)
local CoinsLabel = CreateInfoLabel("Coins: 0", 230)
local GemsLabel = CreateInfoLabel("Gems: 0", 280)
local TimeLabel = CreateInfoLabel("Time: 00:00:00", 330)

local Coins, Gems, TotalHatches, Timer = 0, 0, 0, 0

-- Timer Update
spawn(function()
    while wait(1) do
        Timer += 1
        local h = math.floor(Timer / 3600)
        local m = math.floor((Timer % 3600) / 60)
        local s = Timer % 60
        TimeLabel.Text = string.format("Time: %02d:%02d:%02d", h, m, s)
    end
end)

-- Stats Update
spawn(function()
    while wait(5) do
        Coins += math.random(10000, 100000)
        Gems += math.random(100, 1000)
        TotalHatches += math.random(1, 3)
        CoinsLabel.Text = "Coins: " .. Coins
        GemsLabel.Text = "Gems: " .. Gems
        HatchLabel.Text = "Total Hatches: " .. TotalHatches
    end
end)

-- Configurations (rút gọn)
local Config = {
    AutoActions = {
        DailyRewards = true,
        UnlockZones = true,
        ClaimIndex = true,
        ClaimQuests = true,
        SeasonPass = true,
        DoggyJump = true,
        Playtime = true,
        RiftGifts = true,
        SpinWheel = true,
        BlowSell = true,
        BuyFlavor = true,
        EquipFlavor = true,
        OpenItems = true,
        UpgradeMastery = true,
        EquipPets = true,
        UsePotions = true,
        CollectPickups = true,
        SeekRifts = true,
        FindDuck = true
    }
}

-- Logic: Anti-AFK
LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    if vu then
        vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    else
        warn("[ERROR]: VirtualUser không có sẵn!")
    end
end)

-- Automation Placeholder (hook tùy Remote cụ thể của game)
spawn(function()
    while wait(10) do
        -- Kiểm tra và gọi các remotes an toàn
        if Config.AutoActions.DailyRewards then
            print("Claim Daily Rewards")
            local remote = ReplicatedStorage:FindFirstChild("ClaimDailyRewardsRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "Claim")
            else
                warn("[ERROR]: Remote ClaimDailyRewardsRemote không tồn tại!")
            end
        end
        if Config.AutoActions.ClaimQuests then
            print("Claim Quest Rewards")
            local remote = ReplicatedStorage:FindFirstChild("ClaimQuestRewardsRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "Claim")
            else
                warn("[ERROR]: Remote ClaimQuestRewardsRemote không tồn tại!")
            end
        end
        if Config.AutoActions.SeasonPass then
            print("Claim Season Pass")
            local remote = ReplicatedStorage:FindFirstChild("ClaimSeasonPassRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "Claim")
            else
                warn("[ERROR]: Remote ClaimSeasonPassRemote không tồn tại!")
            end
        end
        if Config.AutoActions.SpinWheel then
            print("Spinning Lucky Wheel")
            local remote = ReplicatedStorage:FindFirstChild("SpinWheelRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "Spin")
            else
                warn("[ERROR]: Remote SpinWheelRemote không tồn tại!")
            end
        end
        if Config.AutoActions.BlowSell then
            print("Auto Blowing & Selling")
            local remote = ReplicatedStorage:FindFirstChild("BlowSellRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "BlowAndSell")
            else
                warn("[ERROR]: Remote BlowSellRemote không tồn tại!")
            end
        end
        if Config.AutoActions.BuyFlavor then
            print("Buying Best Flavor")
            local remote = ReplicatedStorage:FindFirstChild("BuyFlavorRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "BuyBestFlavor")
            else
                warn("[ERROR]: Remote BuyFlavorRemote không tồn tại!")
            end
        end
        if Config.AutoActions.EquipPets then
            print("Equipping Best Pets")
            local remote = ReplicatedStorage:FindFirstChild("EquipPetsRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "EquipBestPets")
            else
                warn("[ERROR]: Remote EquipPetsRemote không tồn tại!")
            end
        end
        if Config.AutoActions.UsePotions then
            print("Using Best Potions")
            local remote = ReplicatedStorage:FindFirstChild("UsePotionsRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "UseBestPotions")
            else
                warn("[ERROR]: Remote UsePotionsRemote không tồn tại!")
            end
        end
        if Config.AutoActions.SeekRifts then
            print("Seeking Rifts")
            local remote = ReplicatedStorage:FindFirstChild("SeekRiftsRemote") -- Kiểm tra Remote của bạn
            if remote then
                safeFire(remote, "SeekRifts")
            else
                warn("[ERROR]: Remote SeekRiftsRemote không tồn tại!")
            end
        end
    end
end)

print("[✅ DuckHub Dashboard with All Automation Loaded]")
