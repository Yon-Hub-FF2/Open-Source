local services = setmetatable({}, {
    __index = function(self, key)
        local service = pcall(cloneref, game:FindService(key)) and cloneref(game:GetService(key)) or Instance.new(key)
        rawset(self, key, service)

        return rawget(self, key)
    end
})

local players = services.Players
local rstorage = services.ReplicatedStorage

local client = players.LocalPlayer
local playergui = client:WaitForChild("PlayerGui")

local setupplayer; do
    setupplayer = function(plr)
        players.PlayerAdded:Connect(function(client)
            playergui = client:WaitForChild("PlayerGui")
        end)
    end
end

playergui.Visual.Shooting:GetPropertyChangedSignal("Visible"):Connect(function()
    if not playergui.Visual.Shooting.Visible then
        return
    end

    rstorage.Packages.Knit.Services.ControlService.RE.Shoot:FireServer(100)
end)

setupplayer(client)
