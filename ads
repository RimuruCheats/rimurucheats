local name, version = identifyexecutor()
 
if name ~= "Codex" then print('please use codex executor') return end

-- settings
local autoparry = false;
local fastparry = false;
local autospam = false;
local autoLook = false;

-- script defaults
local parryMethod = nil;
local spamMethod = nil;
local minimumVelocity = 150;
local minimumParries = 3;
local parryCount = 0;
local timeforvelocity = 0.4;


 

-- services
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
-- variables
local Players = game:GetService("Players");
local Client = Players.LocalPlayer;
local parryButtonPress = ReplicatedStorage.Remotes.ParryButtonPress;

-- script settings
local timeforball = 0.4;
local timefordist = 40;
local mintimeball = 0.2;
local autoparryMethod = "time";

local lastPosition
local velocity

-- remote
local ParryAttempt = ReplicatedStorage.Remotes.ParryAttempt
local cframe = CFrame.new(-149.9, 10.9, -62.4, 0.9, -0, 0, 0, 0.8, 0.4, -0, -0.4, 0.8)
local vectorArgs = {
    ["5116808496"] = Vector3.new(2009.5, -26.3, -40.4),
    ["5116798298"] = Vector3.new(1806.7, 11.4, -73.2),
    ["2896054889"] = Vector3.new(640.4, 111.1, 64),
}

local intArgs = {
    [1] = 884,
    [2] = 226
}



-- library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))();
local Window = OrionLib:MakeWindow({Name = "Codex | Blade Ball | Beta", HidePremium = false, SaveConfig = true, ConfigFolder = "blade ball"});
local semiLegitTab = Window:MakeTab({Name = "Semi-Legit",Icon = "rbxassetid://4483345998",PremiumOnly = false});
local legitTab = Window:MakeTab({Name = "Legit",Icon = "rbxassetid://4483345998",PremiumOnly = false});
local clientTab = Window:MakeTab({Name = "Client",Icon = "rbxassetid://4483345998",PremiumOnly = false});
local miscTab = Window:MakeTab({Name = "Misc",Icon = "rbxassetid://4483345998",PremiumOnly = false});




local holdParry = false;
legitTab:AddBind({
	Name = "Manual Spam",
	Default = Enum.KeyCode.E,
	Hold = true,
	Callback = function(callback)
	    fastparry = callback
        holdParry = callback;
	end
})

RunService.Heartbeat:Connect(function()
    if holdParry then
        ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs)
    end
end)


local Section = legitTab:AddSection({
	Name = "Binds"
})


legitTab:AddBind({
	Name = "Parry bind 1 (to spam faster manually)",
	Default = Enum.KeyCode.Z,
	Hold = false,
	Callback = function()
		parryButtonPress:Fire();
	end    
})

legitTab:AddBind({
	Name = "Parry bind 2 (to spam faster manually)",
	Default = Enum.KeyCode.X,
	Hold = false,
	Callback = function()
		parryButtonPress:Fire();
	end    
})

legitTab:AddBind({
	Name = "Parry bind 3 (to spam faster manually)",
	Default = Enum.KeyCode.C,
	Hold = false,
	Callback = function()
		parryButtonPress:Fire();
	end    
})

legitTab:AddBind({
	Name = "Parry bind 4 (to spam faster manually)",
	Default = Enum.KeyCode.V,
	Hold = false,
	Callback = function()
		parryButtonPress:Fire();
	end    
})

legitTab:AddBind({
	Name = "Parry bind 5 (to spam faster manually)",
	Default = Enum.KeyCode.B,
	Hold = false,
	Callback = function()
		parryButtonPress:Fire();
	end    
})

semiLegitTab:AddToggle({
    Name = "Auto Parry",
    Default = true,
    Save = true,
    Flag = "autoParryToggleFlag"
})

semiLegitTab:AddDropdown({
	Name = "Choose auto parry method",
	Default = "curve",
	Options = {"button","remote","curve" },
	Callback = function(Value)
        parryMethod = Value
	end    
})


semiLegitTab:AddToggle({
    Name = "Auto Spam",
    Default = true,
    Save = true,
    Flag = "autoSpamToggleFlag"
})

--[[semiLegitTab:AddDropdown({
	Name = "Choose spam method",
	Default = "legit",
	Options = {"button", "remote", "remote + button", "legit", "all"},
	Callback = function(Value)
        spamMethod = Value
	end    
})--]]


semiLegitTab:AddToggle({
    Name = "Rage parry",
    Default = true,
    Save = true,
    Flag = "rageParryFlag"
})


miscTab:AddSlider({
	Name = "Minimum ball velocity before spam",
	Min = 50,
	Max = 350,
	Default = 150,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		minimumVelocity = Value
	end    
})

miscTab:AddSlider({
	Name = "Parries before auto spam",
	Min = 2,
	Max = 5,
	Default = 3,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "parryes",
	Callback = function(Value)
		minimumParries = Value
	end    
})

clientTab:AddSlider({
	Name = "Walk Speed Changer",
	Min = 36,
	Max = 150,
	Default = 36,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "KM/H",
	Callback = function(Value)
		Client.Character.Humanoid.WalkSpeed = Value
	end    
})

miscTab:AddToggle({
    Name = "Auto Look While Clash",
    Default = true,
    Save = true,
    Flag = "autoLookToggleFlag"
})

OrionLib:MakeNotification({
	Name = "Shyde",
	Content = "Game: Blade Ball",
	Image = "rbxassetid://4483345998",
	Time = 1.5
})



-- fps boost
local function FPSBOOST()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RimuruCheats/rimurucheats/main/fpsbooster"))();
end

miscTab:AddButton({
	Name = "Fps Boost",
	Callback = function()
        setfpscap(240);
      	FPSBOOST();
  	end    
})


-- functions

local function findTarget()
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") and ball:GetAttribute("target") == Client.Name then
            return ball;
        end
    end
end


local function getballvelocity()
    for _, ball in ipairs(workspace.Balls:GetChildren()) do
        if ball:GetAttribute("realBall") then
            local velocity = ball.Velocity
            if velocity then
                return velocity.Magnitude
            end
        end
    end
end

local function getballvelocityold()
    for _, ball in ipairs(workspace.Balls:GetChildren()) do
        if ball:GetAttribute("realBall") then
            local velocity = ball.AssemblyLinearVelocity.Magnitude
            if velocity then
                return velocity
            end
        end
    end
end



local function returnStuds()
    for _, ball in workspace.Balls:GetChildren() do
            local latestTargetName = ball:GetAttribute("target")
            
            if not latestTargetName or latestTargetName == "" then
                print("Warning: Target not set")
                return nil
            end
        
            local targetCharacter = workspace.Alive:FindFirstChild(latestTargetName)
            
            if targetCharacter and targetCharacter.Name ~= Client.Name then
                return Client:DistanceFromCharacter(targetCharacter.PrimaryPart.Position)
            else
                -- print("Warning: No character found with the name:", latestTargetName)
                return nil
            end
    end
end

local function returnNearestTargetBool()
    for _, ball in workspace.Balls:GetChildren() do
        local latestTargetName = ball:GetAttribute("target")
        
        if not latestTargetName or latestTargetName == "" then
            print("Warning: Target not set")
            return nil
        end
    
        local targetCharacter = workspace.Alive:FindFirstChild(latestTargetName)
        
        if targetCharacter and targetCharacter.Name ~= Client.Name then
            return true
        else
            return nil
        end
end
end


RunService.Heartbeat:Connect(function(deltaTime)
    local Ball = findTarget()
    if not Ball then
        return
    end
 
    local currentPosition = Ball.Position
    if not currentPosition or not lastPosition then
        lastPosition = currentPosition
        return
    end
 
    velocity = (currentPosition - lastPosition) / deltaTime
    lastPosition = currentPosition
end)


-- slow asf but obfuscators wont obfuscate if i change it
local function CheckForAlive()
    if workspace.Alive:FindFirstChild(Client.Name) then
        return true
    else
        return false
    end
end



--[[local function returnballDIST()
    local Ball = findTarget()
    if Ball then
        if Client:DistanceFromCharacter(Ball.Position) <= 50 then
            return true
        end
    end
end--]]

-- checks

local function returnPrimaryPart()
	for _,v in workspace.Alive:GetChildren() do
		local dist = Client:DistanceFromCharacter(v.PrimaryPart.Position)
		if dist <= math.huge and v.Name ~= Client.Name then
			return v.PrimaryPart	
		end
	end
end

local function spamClick()
    if not CheckForAlive() then
        return
    end

    fastparry = false;
    for _, character in workspace.Alive:GetChildren() do
        if character.Name ~= Client.Name then
            if Client:DistanceFromCharacter(character.PrimaryPart.Position) <= timefordist and character:FindFirstChild("Highlight") and parryCount >= minimumParries and getballvelocity() >= minimumVelocity then
                fastparry = true
                break;
            end
            if Client:DistanceFromCharacter(character.PrimaryPart.Position) and Client:DistanceFromCharacter(character.PrimaryPart.Position) <= timefordist and returnNearestTargetBool() and parryCount >= minimumParries and returnStuds() <= 15 then
                fastparry = true;
                break;
            end
            if Client:DistanceFromCharacter(character.PrimaryPart.Position) >= timefordist --[[returnballDIST()]] then 
                fastparry = false;
                holdParry = false;
                break;
            end
            character.Humanoid.Died:Connect(function()
                fastparry = false;
                parryCount = 0
            end)
            if findTarget() then
                if getballvelocity() <= 3 then
                    fastparry = false;
                    holdParry = false;
                    break;
                end
            end
        end
    end
end
Client.Character:FindFirstChild("Humanoid").Died:Connect(function()
    fastparry = false;
    parryCount = 0;
    return;
end)

workspace.Alive.ChildRemoved:Connect(function ()
    parryCount = 0;
    timeforball = 0.4;
    timefordist = 40;
end)


local function midCheck()
    local ball = findTarget()
    local velocity = getballvelocityold()
    if ball then
        if velocity and velocity >= 300 then
            timeforvelocity = 0.5
        elseif velocity and velocity >= 350 then
            timeforvelocity = 0.55
        elseif velocity and velocity >= 450 then
            timeforvelocity = 0.6
        end
    end
end



local function checktimefordista()
    local ball = findTarget()
    local velocity = getballvelocityold()
    if not returnStuds() then return end
    if ball then
        if velocity >= 150 and returnStuds() <= 55 then
            timefordist = 55
        elseif velocity >= 200 and returnStuds() <= 75 then
            timefordist = 75
            mintimeball = 0.10
        elseif velocity >= 300 and returnStuds() <= 85 then
            timefordist = 85
            mintimeball = 0.5
        elseif velocity >= 500 and returnStuds() <= 100 then
            timefordist = 100
            mintimeball = 0
        end  
    end

end




local rageParry = true;
-- heartbeats
RunService.Heartbeat:Connect(function(deltaTime)
    autoparry = OrionLib.Flags["autoParryToggleFlag"].Value
    autospam = OrionLib.Flags["autoSpamToggleFlag"].Value
    autoLook = OrionLib.Flags["autoLookToggleFlag"].Value
    rageParry = OrionLib.Flags["rageParryFlag"].Value
end)

local ts = game:GetService("TweenService")
local function TP(P)
    local Distance = (P.Position - Client.Character.HumanoidRootPart.Position).Magnitude;
    local Speed = 300;
    if Distance < 170 then
        Client.Character.HumanoidRootPart.CFrame = P
        Speed = 350
    elseif Distance < 1000 then
        Speed = 350
    elseif Distance >= 1000 then
        Speed = 300
    end
    for _, part in Client.Character:GetDescendants() do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    Client.Character.HumanoidRootPart.Anchored = true;
    ts:Create(Client.Character.PrimaryPart,TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),{CFrame = P}):Play()
end
local function returnball()
    for _,v in workspace.Balls:GetChildren() do
        if v:GetAttribute("realBall") then
            return v
        end
     end
end

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait();
        if rageParry then
            local ball = returnball();
            TP(ball.CFrame - Vector3.new(0,6,0));
            task.wait()
            parryButtonPress:Fire();
        end
    end
end)


RunService.Heartbeat:Connect(function(deltaTime)
    if autospam then
        spamClick()
    end
    midCheck()
end)

RunService.Heartbeat:Connect(function(deltaTime)
    if fastparry and autoLook then
        local character = Client.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local targetPart = returnPrimaryPart()

            if targetPart then
                humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, targetPart.Position - Vector3.new(0, 1.3, 0))
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if fastparry then
        ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs)
        holdParry = true;
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    if not CheckForAlive() then
        autoparryMethod = "time"
        fastparry = false;
        holdParry = false;
        timefordist = 40;
        timeforball = 0.4;
        parryCount = 0
    end
end)

local detected = {}

task.spawn(function()
    while true do
        for _,v in workspace.Alive:GetChildren() do
            if v.Name ~= Client.Name then
                if v:FindFirstChild("ParryHighlight") and not detected[v] then
                    detected[v] = true
                    task.wait(0.2)
                    if findTarget() then
                        parryCount += 1
                    end
                else
                    detected[v] = nil 
                end
            end
        end

        task.wait(0.2)
    end
end)



local function curveRight()
    local cframe = CFrame.new(-270.8353271484375, 31.929479598999023, -191.62216186523438, 0.20279856026172638, -0.25149253010749817, 0.9463742971420288, -3.725290298461914e-09, 0.9664568305015564, 0.25682932138442993, -0.9792205095291138, -0.05208462104201317, 0.19599604606628418)

    ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs)
end

local function curveLeft() 
    local cframe = CFrame.new(-294.7437744140625, 31.933059692382812, -194.2222442626953, -0.012835070490837097, 0.25709471106529236, -0.9663009643554688, 0, 0.9663806557655334, 0.2571158707141876, 0.9999176859855652, 0.0033001003321260214, -0.012403560802340508)

    ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs)
end

local function curveBack()
    local cframe = CFrame.new(-282.7514343261719, 31.954345703125, -181.9947052001953, 0.9999743700027466, 0.0018526178319007158, -0.006914064288139343, 0, 0.9659258723258972, 0.258819043636322, 0.007157965563237667, -0.25881239771842957, 0.9659011363983154);

    ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs)
end

local function curveFront()
    local cframe = CFrame.new(-282.0899353027344, 30.248661041259766, -206.46060180664062, -0.9989250898361206, -0.005672093480825424, 0.04600585252046585, 0, 0.9924852252006531, 0.12236418575048447, -0.04635419696569443, 0.12223265320062637, -0.9914183616638184)

    ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs)
    
end

local function curveUp()
    local cframe = CFrame.new(-282.7198486328125, 23.787445068359375, -194.93930053710938, -0.998009979724884, -0.06209864467382431, -0.010949705727398396, 9.31322685637781e-10, 0.17364877462387085, -0.9848076105117798, 0.06305662542581558, -0.9828478097915649, -0.17330320179462433);
    ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs)
end



--[[local function getVelocityMagnitude(are)
    return if velocity and velocity.Magnitude and Client:DistanceFromCharacter(are.Position) / velocity.Magnitude or 0 then true else false
end

local function canhitVelocity(ball)
    local ballVelocityMagnitude = getVelocityMagnitude(ball)
    return if ballVelocityMagnitude > 0.1 and ballVelocityMagnitude <= 0.4 then true else false
end

local function canhitTime(ball)
    return if ball.AssemblyLinearVelocity and ball.AssemblyLinearVelocity.Magnitude and Client:DistanceFromCharacter(ball.Position) / ball.AssemblyLinearVelocity.Magnitude <= timeforball then true else false
end--]]

local function getTimeUntilHit(ball)
    return if velocity then Client:DistanceFromCharacter(ball.Position) / velocity.Magnitude else 0
end

--[[local function ballVelocity(ball)
    return Client:DistanceFromCharacter(ball.Position) / velocity.Magnitude
end]]

local function canHitBall(ball)
    local timeUntilHit = getTimeUntilHit(ball);
    return timeUntilHit > 0.15 and timeUntilHit <= timeforvelocity;
end

local function canHitBallDist(ball)
    return Client:DistanceFromCharacter(ball.Position) >= 30 and Client:DistanceFromCharacter(ball.Position) <= 50;
end


local function getRandomCurve()
    return math.random(1, 5)
end

local curveFunctions = {
    curveRight,
    curveLeft,
    curveBack,
    curveFront,
    curveUp
}

local methodFunctions = {
    button = function() parryButtonPress:Fire() end,
    remote = function() ParryAttempt:FireServer(0, cframe, vectorArgs, intArgs) end,
    curve = function()
        local selectedCurve = curveFunctions[getRandomCurve()]
        if selectedCurve then
            selectedCurve()
        end
    end
}

local lastVelocity = 0
local threshold = 5

local function isBallCurving()
    local currentVelocity = getballvelocity()

    if type(currentVelocity) == "number" and type(lastVelocity) == "number" then
        local velocityDifference = math.abs(currentVelocity - lastVelocity)
        if velocityDifference >= threshold then
            return currentVelocity > lastVelocity
        end
    end

    return false
end

RunService.Heartbeat:Connect(function(deltaTime)
    local isCurving = isBallCurving()
    if isCurving then
        autoparryMethod = "distance"
    else
        autoparryMethod = "time"
    end

    lastVelocity = getballvelocity() or 0 -- Update lastVelocity outside the function
end)

task.spawn(function()
    while task.wait(2) do
        print(autoparryMethod)
    end
end)


task.spawn(function()
    while true do
        RunService.Heartbeat:Wait();
        if autoparry and autoparryMethod == "time" then

            local ball = findTarget();

            if ball and canHitBall(ball) then
                if parryCount <= 0 then task.wait(0.3) end
                local selectedFunction = methodFunctions[parryMethod]
                if selectedFunction then
                    selectedFunction()
                end

                if canHitBall(ball) then 
                    local selectedFunction = methodFunctions[parryMethod]
                    if selectedFunction then
                        selectedFunction()
                    end
                end

                while ball and canHitBall(ball) do
                    if parryMethod == "curve" then
                        task.wait(0.3)
                    end

                    RunService.Heartbeat:Wait();
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait();
        local ball = findTarget()

        if autoparry and autoparryMethod == "distance" then
            if parryCount <= 0 then task.wait(0.3) end
            if ball and canHitBallDist(ball) then
    
                local selectedFunction = methodFunctions[parryMethod]
                if selectedFunction then
                    selectedFunction()
                end
    
                if canHitBall(ball) then 
                    local selectedFunction = methodFunctions[parryMethod]
                    if selectedFunction then
                        selectedFunction()
                    end
                end
    
                while ball and canHitBallDist(ball) do
                    if parryMethod == "curve" then
                        task.wait(0.3)
                    end
                    RunService.Heartbeat:Wait();
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(deltaTime)
    pcall(function()
        local ball = findTarget()
        local distance = Client:DistanceFromCharacter(ball.Position)
        if ball and distance and distance <= 15 then
            parryButtonPress:Fire();
        end
    end)
end)

OrionLib:Init()
