local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Options = Library.Options

local Window = Library:CreateWindow({
    Title = "CDoors",
    Footer = "Fully Open Source",
    Icon = 12497860513,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "house"),
    Visual = Window:AddTab("Visual", "eye"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local TabBox = Tabs.Visual:AddRightTabbox()
local PlayersTab = TabBox:AddTab("Players")

local PlayerData = {}

-- Function to create the visual ESP box
local function CreateESP(player)
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1, 1, 1)
    Box.Thickness = 1
    Box.Filled = false

    PlayerData[player] = {
        Box = Box,
        Enabled = false
    }

    local function Update()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if not PlayerData[player] or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                Box.Visible = false
                if not PlayerData[player] then Connection:Disconnect() end
                return
            end

            local RootPart = player.Character.HumanoidRootPart
            local Pos, OnScreen = Camera:WorldToViewportPoint(RootPart.Position)

            if OnScreen and PlayerData[player].Enabled then
                local Size = (Camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 2.6, 0)).Y)
                Box.Size = Vector2.new(Size * 0.7, Size)
                Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                Box.Color = Options["ESP_Color_" .. player.UserId].Value
                Box.Visible = true
            else
                Box.Visible = false
            end
        end)
    end
    coroutine.wrap(Update)()
end

local function AddPlayerUI(player)
    if PlayerData[player] then return end
    CreateESP(player)

    local toggleId = "ESP_" .. player.UserId
    local colorId = "ESP_Color_" .. player.UserId

    PlayersTab:AddToggle(toggleId, {
        Text = player.Name,
        Default = false,
        Callback = function(Value)
            PlayerData[player].Enabled = Value
        end
    })

    PlayersTab:AddColorPicker(colorId, {
        Default = Color3.new(1, 1, 0),
        Title = player.Name .. " Color",
    })
end

-- Initialize and Listeners
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then AddPlayerUI(player) end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then AddPlayerUI(player) end
end)

Players.PlayerRemoving:Connect(function(player)
    if PlayerData[player] then
        PlayerData[player].Box:Remove()
        PlayerData[player] = nil
    end
end)

-- UI Settings

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")



MenuGroup:AddToggle("KeybindMenuOpen", {

    Default = Library.KeybindFrame.Visible,

    Text = "Open Keybind Menu",

    Callback = function(value)

        Library.KeybindFrame.Visible = value

    end,

})



MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})



MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)



Library.ToggleKeybind = Options.MenuKeybind



ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("CDoorsV2")
SaveManager:SetFolder("CDoorsV2/Save")
SaveManager:SetSubFolder("CDoorsV2")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

Library:Notify({
    Title = "CDoors Loaded",
    Description = "CDoors is Fully Loaded!!!",
    BigIcon = "rbxassetid://12497860513",
    IconColor = Color3.new(0, 1, 0), -- Green
    Time = 4,
})