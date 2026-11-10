var camera = view_camera[0]
var cameraWidth = camera_get_view_width(camera)
var cameraHeight = camera_get_view_height(camera)

var ground = layer_tilemap_get_id("Ground")

var targetFrameRate = 60 //default 60
var deltaTimeMultiplier = (delta_time / 1000000) / (1/targetFrameRate)

var leftKey = keyboard_check(vk_left) or keyboard_check(ord("A"))
var rightKey = keyboard_check(vk_right) or keyboard_check(ord("D"))

var movementDirection = rightKey - leftKey
var movementSpeed = deltaTimeMultiplier * baseMovementSpeed

var horizontalFriction = baseHorizontalFriction

if (wallJumped){
	horizontalFriction = 1.01
	movementDirection = 0
}

if (!place_meeting(x, y + 16, ground)){
	movementSpeed *= inAirMovementSpeedMultiplier
}

if (savedMovementDirection == 1){
	targetCameraX = x - cameraWidth/4
}else{
	targetCameraX = x - cameraWidth/4 * 3
}

targetCameraY = y - cameraHeight/2

if (movementDirection != 0){
	savedMovementDirection = movementDirection
}

visualXScale = lerp(visualXScale, savedMovementDirection, 0.1)

if (abs(visualXScale - savedMovementDirection) <= 0.1){
	visualXScale = savedMovementDirection
}

horizontalVelocity += movementSpeed * movementDirection
horizontalVelocity /= horizontalFriction

if (!place_meeting(x, y, ground)){
	verticalVelocity += gravityStrength
}

if (abs(verticalVelocity) > abs(terminalverticalVelocity)){
	verticalVelocity = lerp(verticalVelocity, terminalverticalVelocity, 0.05)
	instance_create_depth(x + random_range(-2, 2), y, 0, oSmoke)
}

if (abs(horizontalVelocity) <= stoppingThreshold){
	horizontalVelocity = 0
	
	visualAngle = lerp(visualAngle, 0, 0.1)
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

if (place_meeting(x - horizontalVelocity, y, ground)){
	while (place_meeting(x - horizontalVelocity, y, ground)) {
		y -= 0.5 * sign(verticalVelocity)
	}
	verticalVelocity = 0
	
	wallJumped = false
}

if (place_meeting(x, y, ground)){
	while (place_meeting(x, y, ground)) {
		x -= 0.5 * savedMovementDirection
	}
	
	horizontalVelocity = 0
	
	wobbleProgress = 0
	visualAngle = 0
}

if (keyboard_check(vk_space) and position_meeting(x, y, ground)){
	verticalVelocity = baseJumpHeight
	repeat (16) {
		instance_create_depth(x + random_range(-35, 35), y + random_range(-15, -5), 0, oSmoke)
	}
}

if (keyboard_check_pressed(vk_space) and place_meeting(x + 16 * savedMovementDirection, y, ground) and !wallJumped and verticalVelocity != 0){
	verticalVelocity = baseJumpHeight
	horizontalVelocity = -8 * savedMovementDirection
	savedMovementDirection *= -1
	repeat (16) {
		instance_create_depth(x + random_range(-35, 35), y + random_range(-15, -5), 0, oSmoke)
	}
	
	wallJumped = true
}

wobbleProgress += horizontalVelocity

//camera controls
camera_set_view_pos(camera, lerp(camera_get_view_x(camera), targetCameraX, 0.1) , lerp(camera_get_view_y(camera), targetCameraY, 0.1))