var letterList = string_deconstruct(text)

var speaker = self

wiggleStrengthList = decipher(textWiggleStrength)
wiggleSpeedList = decipher(textWiggleSpeed)
delayList = decipher(textDelay)
widthList = decipher(textWidth)
heightList = decipher(textHeight)

var targetFrameRate = 60 //default 60
var deltaTimeMultiplier = (delta_time / 1000000) / (1/targetFrameRate)

if (addingLetters){
	tick += deltaTimeMultiplier
}else{
	letterOffset = 0
	lineOffset = 0
}

repeat (1 + deltaTimeMultiplier) {
	image_xscale = lerp(image_xscale, sign(oPlayer.x - x), 0.1)
}


if (tick >= letterDelay and letter < array_length(letterList)){ 
	if (letterList[letter] == "\n"){
		letterOffset = 0
		lineOffset += string_height("\n") * heightList[letter]
	}
	
	instance_create_depth(110 + letterOffset, 510 + lineOffset, 0, oText, {
		text:letterList[letter],
		wiggleStrength:wiggleStrengthList[letter],
		wiggleSpeed:wiggleSpeedList[letter],
		source:speaker,
		width:widthList[letter],
		height:heightList[letter]
	})
	
	letterOffset += string_width(letterList[letter]) * widthList[letter]
	
	letterDelay = delayList[letter]
	
	tick = 0
	letter += 1
}

if (letter == array_length(letterList)){
	addingLetters = false
}

if (!instance_exists(oText) and !addingLetters){
	instance_destroy(oDialogueBox)
}

if (!addingLetters and distance_to_object(oPlayer) <= sprite_get_width(sPlayer) and keyboard_check_pressed(ord("Q")) and !instance_exists(oDialogueBox)){
	addingLetters = true
	letter = 0
	letterOffset = 0
	
	letterDelay = delayList[letter]
	
	instance_create_depth(x, y, 10, oDialogueBox, {
		source:speaker
	})
}