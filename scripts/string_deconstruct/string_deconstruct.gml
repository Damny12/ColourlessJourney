/// @desc Turns a string into an array of its letters
/// @param {string} string
/// @returns {array}
function string_deconstruct(string)  {
	var stringLength = string_length(string)
	var deconstructedString = []
	
	for  (var i = 1; i <= stringLength;  i++){
		deconstructedString[i -  1] = string_char_at(string, i);
	}
	
	return deconstructedString
}