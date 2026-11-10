var targetFrameRate = 60 //default 60
var deltaTimeMultiplier = (delta_time / 1000000) / (1/targetFrameRate)

image_speed = baseImageSpeed * deltaTimeMultiplier

if (image_index >= 3){
	instance_destroy()
}