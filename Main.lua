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

-- simple ESP module loading: the code lives in Code/ESP.lua and returns a table
-- with :Toggle(state) and :SetText(text).  if the local file cannot be read we
-- fall back to a minimal no-op implementation so the rest of the script still runs.
local ESP = nil
if isfile and readfile then
    local ok,src = pcall(readfile, "Code/ESP.lua")
    if ok and src then
        local f = loadstring(src)
        if f then
            ESP = f()
        end
    end
end
ESP = ESP or {}
ESP.Toggle = ESP.Toggle or function() end
ESP.SetText = ESP.SetText or function() end

-- configuration table in the main script maps a friendly "code" to the numeric id that
-- will be looked up in the names file.  edit the value on the right to whatever
-- asset/part id you want to track.
local ItemCodes = {
    Key = 123456789,            -- example entry, change this to the code you need
}

-- names file is read at startup and parsed into a simple id->name table.  the
-- file lives at Code/ESPName/Names.txt and should contain lines of the form
-- 123456789 = Kay
-- this lets you keep the human readable names separate from the script.
local ItemNames = {}
if isfile and readfile then
    local path = "Code/ESPName/Names.txt"
    if isfile(path) then
        for _, line in ipairs(string.split(readfile(path), "\n")) do
            local id, name = line:match("^(%d+)%s*=%s*(.+)$")
            if id and name then
                ItemNames[id] = name
            end
        end
    end
end

-- helper that builds the string shown by the ESP label when the toggle is on.
local function getDisplayText(key)
    local id = ItemCodes[key]
    if not id then
        return "(no code set)"
    end
    local name = ItemNames[tostring(id)] or "Unknown"
    return tostring(id) .. " = " .. name
end

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

MainB:AddDivider()
MainB:AddLabel("ESP configuration")
MainB:AddTextbox("CodeBox", {
    Text = tostring(ItemCodes.Key),
    Placeholder = "numeric id",
    FocusLost = function(value)
        local n = tonumber(value)
        if n then
            ItemCodes.Key = n
            if Toggles.PlayerEsp then
                ESP:SetText(getDisplayText("Key"))
            end
        end
    end,
})
MainB:AddButton("ReloadNames", function()
    -- re-read the names file and update the table
    ItemNames = {}
    if isfile and readfile then
        local path = "Code/ESPName/Names.txt"
        if isfile(path) then
            for _, line in ipairs(string.split(readfile(path), "\n")) do
                local id, name = line:match("^(%d+)%s*=%s*(.+)$")
                if id and name then
                    ItemNames[id] = name
                end
            end
        end
    end
    -- if ESP is visible update the text immediately
    if Toggles.PlayerEsp then
        ESP:SetText(getDisplayText("Key"))
    end
end)

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
local VisualTabbox = Tabs.Visual:AddLeftTabbox()

local Main = VisualTabbox:AddTab("ESP")
Main:AddToggle("PlayerEsp", {
    Text = "Player Esp",
    Default = false,
    Callback = function(Value)
        -- when the toggle is flipped we visibility of the ESP label and update
        -- its text to reflect the currently selected code/name pair
        ESP:Toggle(Value)
        if Value then
            ESP:SetText(getDisplayText("Key"))
        end
    end
})

local Settings = VisualTabbox:AddTab("Settings")
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