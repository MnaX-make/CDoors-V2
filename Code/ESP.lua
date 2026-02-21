-- simple ESP module used by Main.lua
-- returns a table with :Toggle(bool) and :SetText(string)

local ESP = {}

-- create a small label in the centre of the screen
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "CDoorsSimpleESP"
gui.ResetOnSpawn = false

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 300, 0, 50)
label.Position = UDim2.new(0.5, 0, 0.5, 0)
label.AnchorPoint = Vector2.new(0.5, 0.5)
label.BackgroundTransparency = 0.5
label.BackgroundColor3 = Color3.new(0, 0, 0)
label.TextColor3 = Color3.new(1, 1, 1)
label.TextScaled = true
label.Text = ""
label.Visible = false
label.Parent = gui

-- parent gui to playergui when it exists
if player and player:FindFirstChild("PlayerGui") then
    gui.Parent = player.PlayerGui
else
    Players.PlayerAdded:Connect(function(plr)
        if plr == player then
            gui.Parent = plr:WaitForChild("PlayerGui")
        end
    end)
end

function ESP:Toggle(state)
    label.Visible = state
end

function ESP:SetText(str)
    label.Text = str or ""
end

return ESP
