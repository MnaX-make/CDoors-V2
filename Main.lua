local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
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
local PlayerUI = {}

local function AddPlayerUI(player)

    if PlayerUI[player] then return end

    local toggleId = "ESP_" .. player.UserId
    local colorId = "ESP_Color_" .. player.UserId
    local Toggle = PlayersTab:AddToggle(toggleId, {
        Text = player.Name,
        Default = false,
    })

    Toggle:AddColorPicker(colorId, {
        Default = Color3.new(1, 1, 0),
        Title = "ESP Color",
        Transparency = 0,
    })

    Toggle:OnChanged(function(Value)
        print("ESP for", player.Name, "=", Value)
    end)

    Options[colorId]:OnChanged(function()
        local Color = Options[colorId].Value
        print("Color for", player.Name, "=", Color)
    end)

    PlayerUI[player] = true
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        AddPlayerUI(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        AddPlayerUI(player)
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