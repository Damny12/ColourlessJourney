if (!instance_exists(oText)){
	exit
}

image_alpha = oText.alpha

if (image_alpha <= 0){
	instance_destroy()
}