extends CanvasLayer

signal next_level
signal restart_level

func set_red_left(amount):
	$ValvesRemaining/RedAmount.text = str(amount)

func set_blue_left(amount):
	$ValvesRemaining/BlueAmount.text = str(amount)
	
func set_lime_left(amount):
	$ValvesRemaining/LimeAmount.text = str(amount)
	
func set_orange_left(amount):
	$ValvesRemaining/OrangeAmount.text = str(amount)

func show_end_lvl(win):
	if win:
		$WinScreen.visible = true
	else:
		$LossScreen.visible = true

func _on_next_level_pressed():
	next_level.emit()

func _on_retry_level_pressed():
	restart_level.emit()

func _on_quit_pressed():
	pass
