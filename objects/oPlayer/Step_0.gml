var camera = view_camera[0]
var cameraWidth = camera_get_view_width(camera)
var cameraHeight = camera_get_view_height(camera)

var ground = layer_tilemap_get_id("Ground")

var targetFrameRate = 60 //default 60
var deltaTimeMultiplier = (delta_time / 1000000) / (1/targetFrameRate)

var leftKey = keyboard_check(vk_left) or keyboard_check(ord("A"))
var rightKey = keyboard_check(vk_right) or keyboard_check(ord("D"))

var movementDirection = rightKey - leftKey
var movementSpeed = baseMovementSpeed * deltaTimeMultiplier

var horizontalFriction = baseHorizontalFriction

var bufferedJump = (keyboard_check_pressed(vk_space) or (keyboard_lastkey == vk_space and currentInputBufferFrames > 0)) or (keyboard_check_pressed(vk_up) or (keyboard_lastkey == vk_up and currentInputBufferFrames > 0))

if (keyboard_check_pressed(vk_anykey)){
	currentInputBufferFrames = baseBufferFrames
}

if (wallJumpPhysics){
	horizontalFriction = 1.01
	movementDirection = 0
	repeat (3) {
		instance_create_depth(x + random_range(-10, 10), y + random_range(-10, 10), 0, oSmoke)
	}
}

if (!place_meeting(x, y + 16, ground)){
	movementSpeed *= inAirMovementSpeedMultiplier
}

if (savedMovementDirection == 1){
	targetCameraX = x - cameraWidth/3
}else{
	targetCameraX = x - cameraWidth/3 * 2
}

targetCameraY = y - cameraHeight/2

if (movementDirection != 0){
	savedMovementDirection = movementDirection
}

visualXScale = lerp(visualXScale, savedMovementDirection, 0.1 * deltaTimeMultiplier)

if (abs(visualXScale - savedMovementDirection) <= 0.1){
	visualXScale = savedMovementDirection
}

horizontalVelocity += movementSpeed * movementDirection
horizontalVelocity /= horizontalFriction * deltaTimeMultiplier

if (!place_meeting(x, y, ground)){
	verticalVelocity += gravityStrength * deltaTimeMultiplier
}

if (abs(verticalVelocity) > abs(terminalverticalVelocity)){
	verticalVelocity = lerp(verticalVelocity, terminalverticalVelocity, 0.05 * deltaTimeMultiplier)
	instance_create_depth(x + random_range(-2, 2), y, 0, oSmoke)
}

if (abs(horizontalVelocity) <= stoppingThreshold){
	horizontalVelocity = 0
	
	visualAngle = lerp(visualAngle, 0, 0.1 * deltaTimeMultiplier)
	wobbleProgress = visualAngle
} else {
	var newAngle = sin(wobbleProgress / wobbleSpeed) * maxWobbleAngle
	if (abs(newAngle) < abs(visualAngle)){
		totalWobbles += 1
		if (totalWobbles % 2 == 0){
			instance_create_depth(x + random_range(-5, 5), y + random_range(-15, -5), 0, oSmoke)	
		}
	}
	
	visualAngle = newAngle
}

x += horizontalVelocity
y += verticalVelocity

for (var i = 0; i < abs(verticalVelocity); i++) {
	if (place_meeting(x, y - i * sign(verticalVelocity), ground)){
		if (sign(verticalVelocity) == 1){
			currentKoyoteFrames = baseKoyoteFrames
		}
		
		y -= verticalVelocity + 0.01
		
		verticalVelocity = 0
		
		wallJumped = false
		wallJumpPhysics = false
	}
}

for (var i = 0; i < abs(horizontalVelocity); i++) {
	if (place_meeting(x - i * sign(horizontalVelocity), y, ground)){
		x -= horizontalVelocity
		
		horizontalVelocity = 0
		
		wallJumped = false
		wobbleProgress = 0
		visualAngle = 0
		
		show_debug_message("was in wall. pushed out")
		
	}
}

if (bufferedJump and (position_meeting(x, y, ground) or currentKoyoteFrames > 0)){
	verticalVelocity = baseJumpHeight * deltaTimeMultiplier
	repeat (16) {
		instance_create_depth(x + random_range(-35, 35), y + random_range(-15, -5), 0, oSmoke)
	}
	
	currentKoyoteFrames = 0
	
	keyboard_lastkey = -1
}

var notOnGround = !place_meeting(x, y + 32, ground) or verticalVelocity > 0

if (bufferedJump and place_meeting(x + 16 * savedMovementDirection, y, ground) and !wallJumped and notOnGround){
	verticalVelocity = baseJumpHeight * wallJumpHeightMultiplier * deltaTimeMultiplier
	horizontalVelocity = wallJumpHorizontalSpeed * savedMovementDirection * -baseMovementSpeed
	savedMovementDirection *= -1
	repeat (16) {
		instance_create_depth(x + random_range(-35, 35), y + random_range(-15, -5), 0, oSmoke)
	}
	
	wallJumped = true
	wallJumpPhysics = true
	
	keyboard_lastkey = -1
}

wobbleProgress += horizontalVelocity

currentKoyoteFrames -= deltaTimeMultiplier
currentInputBufferFrames -= deltaTimeMultiplier

//camera controls
camera_set_view_pos(camera, lerp(camera_get_view_x(camera), targetCameraX, 0.05 * deltaTimeMultiplier) , lerp(camera_get_view_y(camera), targetCameraY, 0.1 * deltaTimeMultiplier))