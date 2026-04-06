local services = setmetatable({}, {
    __index = function(self, key)
        local service = pcall(cloneref, game:FindService(key)) and cloneref(game:GetService(key)) or Instance.new(key)
        rawset(self, key, service)

        return rawget(self, key)
    end
})

local players = services.Players
local rservice = services.RunService

local conns = {}

local client = players.LocalPlayer
local character = client.Character

local setupplayer; do
    setupplayer = function(plr)
        client.CharacterAdded:Connect(function(Char)
            character = Char
        end)
    end
end

local punch_meter = character:WaitForChild("PunchMeter")

conns.max_power = rservice:BindToRenderStep("Max_Power", 1, function()
    if not character or not character.Parent then 
        return 
    end

    punch_meter.Value = 1
end)

setupplayer(client)
