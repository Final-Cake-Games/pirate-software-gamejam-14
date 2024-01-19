extends Control

func _ready():
	hide()
	
func _set_value(progress):
	$TextureProgressBar.value = progress
	
	if progress > 0:
		show()
