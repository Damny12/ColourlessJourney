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
var wallJumpedThisFrame = wallJumped

var currentGravity = gravityStrength

if (keyboard_check_pressed(vk_anykey)){
	currentInputBufferFrames = baseBufferFrames
	
	if (movementDirection != 0 or bufferedJump){
		timerStarted = true
		
		timerStartedBefore = true
	}
}

if (keyboard_check_pressed(ord("R"))){
	game_restart()
}

if (!instance_exists(oDialogueBox)){
	if (savedMovementDirection == 1){
		targetCameraX = x - cameraWidth/3
	}else{
		targetCameraX = x - cameraWidth/3 * 2
	}
	
	targetCameraY = y - cameraHeight/2 + verticalVelocity
	
	targetCameraWidth = defaultCameraWidth
	targetCameraHeight = defaultCameraHeight
	
	if (!timerStarted and timerStartedBefore){
		timerStarted = true
		
		horizontalVelocity = unpausedHorizontalVelocity
		verticalVelocity = unpausedVerticalVelocity
	}
}else{
	targetCameraX = oDialogueBox.source.x - cameraWidth/2
	targetCameraY = oDialogueBox.source.y - cameraHeight/2 - oDialogueBox.source.sprite_height / 2
	
	targetCameraWidth = defaultCameraWidth / 4
	targetCameraHeight = defaultCameraHeight / 4
	
	movementDirection = 0
	bufferedJump = false
	
	if (timerStarted){
		timerStarted = false
		
		unpausedHorizontalVelocity = horizontalVelocity
		unpausedVerticalVelocity = verticalVelocity
		
		horizontalVelocity = 0
		verticalVelocity = 0
	}
	
	currentGravity = 0
	
}

if (x >= 3488 and y >= 1780 and timerStarted){
	timerStarted = false
	finishedLevel = true
}

if (finishedLevel) {
	timerScale = lerp(timerScale, finishTimerScale, 0.1 * deltaTimeMultiplier)
	timerAngle = lerp(timerAngle, finishTimerAngle, 0.1 * deltaTimeMultiplier)
	timerBrightness = lerp(timerBrightness, finishTimerBrightness, 0.1 * deltaTimeMultiplier)
	timerY = lerp(timerY, finishTimerY, 0.1 * deltaTimeMultiplier)
}

timerX = lerp(timerX, finishTimerX, 0.1 * deltaTimeMultiplier)

if (wallJumpPhysics){
	horizontalFriction = wallJumpFriction
	movementDirection = 0
	terminalVerticalVelocity = baseTerminalVerticalVelocity * 3
	repeat (3) {
		instance_create_depth(x + random_range(-10, 10), y + random_range(-10, 10), 0, oSmoke)
	}
}else{
	terminalVerticalVelocity = baseTerminalVerticalVelocity
}

if (!place_meeting(x, y + 16, ground)){
	movementSpeed *= inAirMovementSpeedMultiplier
}

if (timerStarted){
	timerFrames += deltaTimeMultiplier
}

finishTimerX = display_get_gui_width() / 2

if (movementDirection != 0){
	savedMovementDirection = movementDirection
}

visualXScale = lerp(visualXScale, savedMovementDirection, 0.1 * deltaTimeMultiplier)

if (abs(visualXScale - savedMovementDirection) <= 0.1){
	visualXScale = savedMovementDirection
}

horizontalVelocity += movementSpeed * movementDirection
horizontalVelocity /= power(horizontalFriction, (delta_time / game_get_speed(gamespeed_microseconds)))

if (!place_meeting(x, y, ground)){
	verticalVelocity += currentGravity * deltaTimeMultiplier
}

if (abs(verticalVelocity) > abs(terminalVerticalVelocity)){
	verticalVelocity = lerp(verticalVelocity, terminalVerticalVelocity, 0.05 * deltaTimeMultiplier)
	instance_create_depth(x + random_range(-2, 2), y, 0, oSmoke)
}

if (abs(horizontalVelocity) <= stoppingThreshold){
	horizontalVelocity = 0
	
	if (currentGravity * deltaTimeMultiplier == verticalVelocity){
		visualAngle = lerp(visualAngle, 0, 0.1 * deltaTimeMultiplier)
		wobbleProgress = visualAngle
	}
	
} else {
	if (currentGravity * deltaTimeMultiplier == verticalVelocity){
		var newAngle = sin(wobbleProgress / wobbleSpeed) * maxWobbleAngle
		if (abs(newAngle) < abs(visualAngle)){
			totalWobbles += 1
			if (totalWobbles % 2 == 0){
				instance_create_depth(x + random_range(-5, 5), y + random_range(-15, -5), 0, oSmoke)	
			}
		}
		
		visualAngle = newAngle
	}
}

y += verticalVelocity

var savedVerticalVelocity = verticalVelocity
var precision = 0.5

for (var i = 0; i < abs(verticalVelocity); i+=precision) {
	if (place_meeting(x, y - i * sign(verticalVelocity), ground)){
		y -= verticalVelocity
		
		if (sign(verticalVelocity) == 1){
			currentKoyoteFrames = baseKoyoteFrames
		}
		
		verticalVelocity = 0
		
		if (sign(savedVerticalVelocity) == 1){
			wallJumped = false
			wallJumpPhysics = false
		}
		
		if (sign(savedVerticalVelocity) == -1){
			show_debug_message("i hit something above me")
			
			if (wallJumpPhysics){
				verticalVelocity = savedVerticalVelocity * wallJumpHeadhitMultiplier
				
				show_debug_message($"i hit the roof at {savedVerticalVelocity} and now i am going {verticalVelocity}")
			}
		}
	}
}

if (savedVerticalVelocity != verticalVelocity){
	savedVerticalVelocity *= 2
}

x += horizontalVelocity

var savedHorizontalVelocity = horizontalVelocity

for (var i = 0; i <= abs(horizontalVelocity); i+=precision) {
	if (place_meeting(x - i * sign(horizontalVelocity), y - savedVerticalVelocity, ground)){
		x -= horizontalVelocity
		
		show_debug_message($"i hit a wall while going at {horizontalVelocity}")
		
		horizontalVelocity = 0
		
		if (wallJumpPhysics){
			horizontalVelocity = savedHorizontalVelocity * wallBumpHorizontalMultiplier
			savedMovementDirection *= -1
			
			show_debug_message($"i bumped a wall at {savedHorizontalVelocity}. now im going at {horizontalVelocity}")
			
			verticalVelocity = wallBumpVerticalSpeed
			
			x += horizontalVelocity
			
			bufferedJump = false
		}
		
		if (savedHorizontalVelocity == 0){
			if (directionStuckInWall != NaN){
				directionStuckInWall = savedMovementDirection
				
				show_debug_message($"oh, no! i'm stuck in a wall while facing in the {directionStuckInWall} directon")
			}
			
			show_debug_message($"i am moving myself out of this wall.")
			while (place_meeting(x, y, ground)) {
				x -= directionStuckInWall
			}
			
			show_debug_message($"i think i am out of the wall") 
			directionStuckInWall = NaN
		}
		
		wobbleProgress = 0
		visualAngle = 0 
	}
}

if (bufferedJump and (position_meeting(x, y, ground) or currentKoyoteFrames > 0)){
	verticalVelocity = baseJumpHeight * deltaTimeMultiplier
	repeat (16) {
		instance_create_depth(x + random_range(-35, 35), y + random_range(-15, -5), 0, oSmoke)
	}
	
	if (wallJumpedThisFrame){
		verticalVelocity *= highJumpVerticalMultiplier
		horizontalVelocity *= highJumpHorizontalMultiplier
	}
	
	currentKoyoteFrames = 0
	
	keyboard_lastkey = -1
}

var notOnGround = !position_meeting(x, y + 32, ground) or verticalVelocity > 0

if (bufferedJump and place_meeting(x + 16 * savedMovementDirection, y, ground) and !wallJumped and notOnGround){
	verticalVelocity = baseJumpHeight * wallJumpHeightMultiplier * deltaTimeMultiplier
	horizontalVelocity = wallJumpHorizontalSpeed * savedMovementDirection * -baseMovementSpeed * deltaTimeMultiplier
	
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
camera_set_view_size(camera, lerp(cameraWidth, targetCameraWidth, 0.05 * deltaTimeMultiplier), lerp(cameraHeight, targetCameraHeight, 0.05 * deltaTimeMultiplier))