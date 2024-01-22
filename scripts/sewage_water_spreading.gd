extends CPUParticles2D

@onready var water_fall_sfx = $water_fall_sfx

func _ready():
	water_fall_sfx.play()
	
func turn_off_water_fall():
	one_shot = true
	water_fall_sfx.stop()
