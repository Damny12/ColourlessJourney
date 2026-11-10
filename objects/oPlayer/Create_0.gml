#region stats
//wobble
maxWobbleAngle = 30
wobbleSpeed = 20 //higher is slower

baseMovementSpeed = 1
inAirMovementSpeedMultiplier = 1.3

baseKoyoteFrames = 10

baseJumpHeight = -10

baseHorizontalFriction = 1.2
stoppingThreshold = 0.6

gravityStrength = 0.5

terminalverticalVelocity = 10
#endregion

horizontalVelocity = 0
verticalVelocity = 0

currentKoyoteFrames = baseKoyoteFrames

movementSpeed = baseMovementSpeed

wobbleProgress = 0
totalWobbles = 0

visualXScale = 1
visualYScale = 1
visualAngle = 0

savedMovementDirection = 1

wallJumped = false

targetCameraX = 0