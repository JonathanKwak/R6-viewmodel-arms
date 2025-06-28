local player = game.Players.LocalPlayer
local character = player.Character
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

if humanoid.RigType ~= Enum.HumanoidRigType.R6 then
	return
end

local head = character:WaitForChild("Head")
local torso = character:WaitForChild("Torso")
local leftArm = character:WaitForChild("Left Arm")
local rightArm = character:WaitForChild("Right Arm")

local neck = torso:WaitForChild("Neck")
local leftShoulder = torso:WaitForChild("Left Shoulder")
local rightShoulder = torso:WaitForChild("Right Shoulder")

local defaultHeadC1 = neck.C1
local defaultLeftArmC1 = leftShoulder.C1
local defaultRightArmC1 = rightShoulder.C1

local defaultHeadC0 = neck.C0
local defaultLeftArmC0 = leftShoulder.C0
local defaultRightArmC0 = rightShoulder.C0

local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local spring = require(script.spring)

local mouseDeltaDivision = 400

local swayOffset = CFrame.new()
local movementOffset = CFrame.new()

local swaySpring = spring.create()
local movementSpring = spring.create()

-- not particularly efficient but it doesn't matter all that much, performance impact is minimal
local function setTransparency(part)
	if part and part:IsA("BasePart") and (part.Name == "Left Arm" or part.Name == "Right Arm") then
		part.LocalTransparencyModifier = 0
		part.Changed:Connect(function(property)    
			part.LocalTransparencyModifier = part.Transparency
		end)
	end
end

local function inFirstPerson()
	local dist = (camera.CFrame.Position - (root.Position + Vector3.new(0,1.5,0))).Magnitude
	return dist < 1
end

-- utilizes sinewaves for procedural walk animation cycles
local function getBobbing(addition,speed,modifier)
	return math.sin(tick()*addition*speed)*modifier
end

local function renderStepped(dt)
	local speed = 1.5
	local modifier = 2
	
	local mouseDelta = userInputService:GetMouseDelta()
	local walkCycle = Vector3.new(getBobbing(10,speed,modifier),getBobbing(5,speed,modifier), 0) * dt
	
	swaySpring:shove(Vector3.new(mouseDelta.x / mouseDeltaDivision,mouseDelta.y / mouseDeltaDivision))	
	
	movementOffset = movementSpring:update(dt)
	swayOffset = swaySpring:update(dt)
	
	local movementCF = CFrame.new()
	movementCF = CFrame.new(movementOffset.y, movementOffset.x, movementOffset.z)

	if humanoid.MoveDirection.Magnitude > 0 then
		movementSpring:shove(walkCycle)
	else
		movementSpring:shove(Vector3.new())
	end
	
	if inFirstPerson() then
		--[[
		local cf = CFrame.Angles(math.pi/2, 0, 0)
		local x, y, z = cf:ToEulerAnglesYXZ()
		local newCF = CFrame.Angles(x, y, z) 
		--]]
		
		local torsoX,torsoY,torsoZ = torso.CFrame:ToEulerAnglesYXZ()
		local _, cameraY, _ = camera.CFrame:ToEulerAnglesYXZ()
		
		local torsoRot = CFrame.Angles(torsoX,torsoY,torsoZ)
		local cameraRot = CFrame.Angles(0, -cameraY, 0)
		local swayCF = CFrame.Angles(swayOffset.y, swayOffset.x, -swayOffset.x/2)
		
		local camCF = camera.CFrame * cameraRot * torsoRot * swayCF * movementCF
		
		rightShoulder.C0 = torso.CFrame:inverse() * (camCF * CFrame.Angles(0,math.rad(90),0) * CFrame.new(0,-1,1))
		leftShoulder.C0 = torso.CFrame:inverse() * (camCF * CFrame.Angles(0,math.rad(-90),0) * CFrame.new(0,-1,1))
	else
		neck.C1 = defaultHeadC1
		leftShoulder.C1 = defaultLeftArmC1
		rightShoulder.C1 = defaultRightArmC1
		
		neck.C0 = defaultHeadC0
		leftShoulder.C0 = defaultLeftArmC0
		rightShoulder.C0 = defaultRightArmC0
	end
end

for _, v in pairs(character:GetChildren()) do
	setTransparency(v)
end
runService.RenderStepped:Connect(renderStepped)
