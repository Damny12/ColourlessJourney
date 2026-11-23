randomise()

#region stats
//wobble
maxWobbleAngle = 30
wobbleSpeed = 20 //higher is slower

baseMovementSpeed = 1
inAirMovementSpeedMultiplier = 1.3

baseKoyoteFrames = 5
baseBufferFrames = 6

baseJumpHeight = -10
wallJumpHeightMultiplier = 1.2
wallJumpFriction = 1
wallJumpHorizontalSpeed = 10

wallJumpHeadhitMultiplier = -0.2

wallBumpHorizontalMultiplier = -0.5
wallBumpVerticalSpeed = -5

highJumpVerticalMultiplier = 1.5
highJumpHorizontalMultiplier = 1.8

baseHorizontalFriction = 1.2
stoppingThreshold = 0.6

gravityStrength = 0.5

baseTerminalVerticalVelocity = 10
terminalVerticalVelocity = baseTerminalVerticalVelocity

finishTimerScale = 20
finishTimerY = 40
finishTimerX = display_get_gui_width() / 2
finishTimerAngle = 0
finishTimerBrightness = 0

if (room == Room1){
	trophyThresholds = [7.9, 8, 15]
}

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

directionStuckInWall = NaN
savedMovementDirection = 1

wallJumped = false
wallJumpPhysics = false

timerFrames = 0
timerStarted = false

finishedLevel = false
timerStartedBefore = false

timerAngle = 0
timerScale = 2
timerX = finishTimerX
timerY = 20
timerBrightness = 255

var camera = view_camera[0]
var cameraWidth = camera_get_view_width(camera)
var cameraHeight = camera_get_view_height(camera)

targetCameraX = x - cameraWidth/3
targetCameraY = y - cameraHeight/2

defaultCameraWidth = camera_get_view_width(camera)
defaultCameraHeight = camera_get_view_height(camera)

targetCameraWidth = defaultCameraWidth
targetCameraHeight = defaultCameraHeight

camera_set_view_pos(camera, targetCameraX, targetCameraY)
camera_set_view_size(camera, targetCameraWidth, targetCameraHeight)

unpausedHorizontalVelocity = 0
unpausedVerticalVelocity = 0