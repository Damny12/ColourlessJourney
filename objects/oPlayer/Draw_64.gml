var textColour = make_colour_rgb(timerBrightness, timerBrightness, timerBrightness)

if (finishedLevel){
	draw_rectangle_colour(0, 0, display_get_gui_width(), display_get_gui_height(), c_white, c_white, c_white, c_white, false)
	
	if (timerFrames / 60 <= trophyThresholds[0]){
		draw_sprite_ext(sBestTrophy, 0, display_get_gui_width() / 2, display_get_gui_height() - 64, 6, 6, 0, c_white, timerScale / finishTimerScale)
	} else if (timerFrames / 60 <= trophyThresholds[1]){
		draw_sprite_ext(sAmazingTrophy, 0, display_get_gui_width() / 2, display_get_gui_height() - 64, 6, 6, 0, c_white, timerScale / finishTimerScale)
	} else if (timerFrames / 60 <= trophyThresholds[2]){
		draw_sprite_ext(sNormalTrophy, 0, display_get_gui_width() / 2, display_get_gui_height() - 64, 6, 6, 0, c_white, timerScale / finishTimerScale)
	} else{
		draw_sprite_ext(sTerribleTrophy, 0, display_get_gui_width() / 2, display_get_gui_height() - 64, 6, 6, 0, c_white, timerScale / finishTimerScale)
	}
	
	draw_set_valign(fa_bottom)
	draw_set_halign(fa_center)
	
	draw_text_transformed_colour(timerX, display_get_gui_height(), "Click to try again", 4, 4, 0, textColour, textColour, textColour, textColour, 1)
	
	if (mouse_check_button_pressed(mb_any)){
		game_restart()
	}
}

draw_set_valign(fa_top)

draw_text_transformed_colour(timerX, timerY, timerFrames / 60, timerScale, timerScale, timerAngle, textColour, textColour, textColour, textColour, 1)