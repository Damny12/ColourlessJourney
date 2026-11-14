#region stats
//wobble
maxWobbleAngle = 30
wobbleSpeed = 20 //higher is slower

baseMovementSpeed = 1
inAirMovementSpeedMultiplier = 1.3

baseKoyoteFrames = 10
baseBufferFrames = 6

baseJumpHeight = -10
wallJumpHeightMultiplier = 1.2
wallJumpHorizontalSpeed = 10

baseHorizontalFriction = 1.2
stoppingThreshold = 0.6

gravityStrength = 0.5

terminalverticalVelocity = 10
#endregion

horizontalVelocity = 0
verticalVelocity = 0

currentKoyoteFrames = baseKoyoteFrames
currentInputBufferFrames = 0

movementSpeed = baseMovementSpeed

wobbleProgress = 0
totalWobbles = 0

visualXScale = 1
visualYScale = 1
visualAngle = 0

savedMovementDirection = 1

wallJumped = false
wallJumpPhysics = false

var camera = view_camera[0]
var cameraWidth = camera_get_view_width(camera)
var cameraHeight = camera_get_view_height(camera)

targetCameraX = x - cameraWidth/3
targetCameraY = y - cameraHeight/2

camera_set_view_pos(camera, targetCameraX, targetCameraY)

show_debug_log(true)