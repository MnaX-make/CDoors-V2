local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

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

-- Main Tab ----------
local MainB = Tabs.Main:AddLeftGroupbox("Main", "house")
local Profile = Tabs.Main:AddRightGroupbox("Profile", "user")


MainB:AddLabel({
    Text = '<font color="rgb(228, 255, 0)">CDoors</font> Is open Source script By MnaX supports Lots of Executors (<font color="rgb(0, 191, 255)">https://rscripts.net/script/cdoors-V2-open-source-NkT4</font>)',
    DoesWrap = true
})

MainB:AddLabel("LOOK AT THIS DOG")

MainB:AddImage("DOG", {
    Image = "rbxassetid://12541893596",
    Callback = function(image)
        print("Image changed!", image)
    end,
})

-- User Profile

Profile:AddImage("UserIcon", {
    Image = content,
    Callback = function(image)
        print("Image changed!", image)
    end,
})

Profile:AddLabel({
    Text = '<font color="rgb(0, 191, 255)">' .. player.Name .. '</font>',
    DoesWrap = true
})

-- Visual Tab ----------
local ESP = Tabs.Visual:AddLeftTabbox()

local Main = ESP:AddTab("ESP")
Main:AddToggle("PlayerEsp", {
    Text = "Player Esp",
    Default = false,
    Callback = function(Value)
        print("Player ESP:", Value)
    end
})

local Settings = ESP:AddTab("Settings")
Settings:AddToggle("Cool", {
    Text = "Tab",
    Default = false,
    Callback = function(Value)
        print("Cool toggle:", Value)
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