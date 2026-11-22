var targetFrameRate = 60 //default 60
var deltaTimeMultiplier = (delta_time / 1000000) / (1/targetFrameRate)

y = ( sin(wigglePosition) * wiggleStrength ) + ystart

wigglePosition += wiggleSpeed * deltaTimeMultiplier

if (!source.addingLetters){
	alpha -= deltaTimeMultiplier / 120
}

if (alpha <= 0){
	instance_destroy()
}