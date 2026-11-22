/*
 * [value, letters to repeat it for ... replacements for whats left over]
*/

tick = 0

letter = 0
addingLetters = false

letterOffset = 0
lineOffset = 0

function decipher(array){
	var returnArray = []
	
	for (var index = 0; index < array_length(array); index++) {
		var value = array[index]
		
		if (index % 2 == 0 and index + 1 < array_length(array)){
			repeat (array[index + 1]) {
				array_push(returnArray, value)
			}
		}
	}
	
	repeat (string_length(text) - array_length(returnArray)) {
		array_push(returnArray, array_last(array))
	}
	
	return returnArray
}

if (!instance_exists(oPlayer)){
	exit
}

image_xscale = sign(oPlayer.x - x)