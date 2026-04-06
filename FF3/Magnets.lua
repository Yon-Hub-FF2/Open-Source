-- game place: https://www.roblox.com/games/82866880824588/Football-Fusion-3

local services = setmetatable({}, {
    __index = function(self, key)
        local service = pcall(cloneref, game:FindService(key)) and cloneref(game:GetService(key)) or Instance.new(key)
        rawset(self, key, service)

        return rawget(self, key)
    end
})

local players = services.Players
local rstorage = services.ReplicatedStorage
local rservice = services.RunService

local client = players.LocalPlayer
local character = client.Character

local catchl
local catchr

local practice_id = game.PlaceId == 81310542478972

local flags = {
    mags = false,
    radius = 20, -- // 20 is max because of the distance checks.
}

local conns = {}

local setupplayer, get_root, fireti; do
    setupplayer = function(plr)
        client.CharacterAdded:Connect(function(char)
            character = char
            catchl = practice_id and char:WaitForChild("CatchLeft") or char:WaitForChild("CatchL")
            catchr = practice_id and char:WaitForChild("CatchRight") or char:WaitForChild("CatchR")
        end)
    end

    get_root = function()
        if not character then 
            return 
        end

        return character:FindFirstChild("HumanoidRootPart")
    end

    fireti = function(part, other_part, wait_time)
        if wait_time then
            firetouchinterest(part, other_part, 0)
            task.wait(wait_time)
            firetouchinterest(part, other_part, 1)
        else
            firetouchinterest(part, other_part, 0)
            firetouchinterest(part, other_part, 1)
        end
    end
end

conns.magnets = rservice.PostSimulation:Connect(function()
    if not flags.mags then
        return
    end

    local hrp = get_root()

    if not hrp then
        return
    end

    for i,v in workspace:GetChildren() do
        if v.Name == "Football" and v:IsA("BasePart") then
            local distance = (hrp.Position - v.Position).Magnitude

            if distance < flags.radius then
                fireti(catchl, v)
                fireti(catchr, v)
            end
        end
    end
end)

setupplayer(client)
