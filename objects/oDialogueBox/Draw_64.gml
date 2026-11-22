if (instance_exists(oText)){
	draw_sprite_ext(source.sprite_index, 0, 250, 600, 10, 10, image_angle, image_blend, image_alpha)
}

matrix_set(matrix_world, matrix_build(100, 490, 0, 0, 0, 0, 2, 2, 1))

draw_sprite_ext(sDialogueBox, 0, 0, 0, (image_xscale)/2, (image_yscale)/2, image_angle, image_blend, image_alpha)

matrix_set(matrix_world, matrix_build_identity())