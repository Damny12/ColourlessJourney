draw_set_font(pixelFont)

if (!addingLetters and distance_to_object(oPlayer) <= sprite_get_width(sPlayer) and !instance_exists(oDialogueBox)){
	draw_sprite_ext(sInteractButton, 0, x, y - 48, 0.75, 0.75, 0, image_blend, 1)
}

draw_self()