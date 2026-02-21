local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ESPModule = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/MnaX-make/CDoors-V2/main/Code/ESP.lua"
))()

if not ESPModule then
    warn("ESP failed to load")
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = "CDoors",
    Footer = "Fully open Source code",
    Icon = 12497860513,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "house"),
    Visual = Window:AddTab("Visual", "eye"),
    Cheats = Window:AddTab("Cheats", "shield-alert"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}


-- MAIN TAB ----------


local MainB = Tabs.Main:AddLeftGroupbox("Main")
local Profile = Tabs.Main:AddRightGroupbox("Profile")

MainB:AddLabel({
    Text = '<font color="rgb(228, 255, 0)">CDoors</font> Open Source Script',
    DoesWrap = true
})

Profile:AddImage("UserIcon", {
    Image = content,
})

Profile:AddLabel({
    Text = '<font color="rgb(0, 191, 255)">' .. player.Name .. '</font>',
    DoesWrap = true
})


-- VISUAL TAB ----------


local VisualTab = Tabs.Visual:AddLeftGroupbox("ESP Settings")

VisualTab:AddToggle("MasterESP", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(Value)
        ESPModule:SetEnabled(Value)
    end
})

VisualTab:AddToggle("ShowBoxes", {
    Text = "Show Boxes",
    Default = true,
    Callback = function(Value)
        ESPModule:SetBoxes(Value)
    end
})

VisualTab:AddToggle("ShowNames", {
    Text = "Show Names",
    Default = true,
    Callback = function(Value)
        ESPModule:SetNames(Value)
    end
})

VisualTab:AddLabel("ESP Color")
VisualTab:AddColorPicker("ESPColor", {
    Default = Color3.fromRGB(255,255,255),
    Callback = function(Value)
        ESPModule:SetColor(Value)
    end
})
-- Cheat Tab ----------


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