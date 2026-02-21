local ESPModule = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local enabled = false
local showBoxes = true
local showNames = true
local color = Color3.fromRGB(255,255,255)
local highlights = {}

local function createESP(player)
    if not player.Character then return end
    if highlights[player] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = showBoxes and 0.5 or 1
    highlight.OutlineTransparency = 0
    highlight.Adornee = player.Character
    highlight.Parent = player.Character

    highlights[player] = highlight
end

local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function updateAll()
    for _, player in ipairs(Players:GetPlayers()) do
        if enabled then
            createESP(player)
        else
            removeESP(player)
        end
    end
end

function ESPModule:SetEnabled(Value)
    enabled = Value
    updateAll()
end

function ESPModule:SetBoxes(Value)
    showBoxes = Value
    updateAll()
end

function ESPModule:SetNames(Value)
    showNames = Value
end

function ESPModule:SetColor(Value)
    color = Value
    for _, highlight in pairs(highlights) do
        highlight.FillColor = color
        highlight.OutlineColor = color
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if enabled then
            createESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

return ESPModule