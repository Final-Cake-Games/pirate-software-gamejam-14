extends Area2D

@export var FIX_TIME : float = 10.0
@export_enum('RED', 'BLUE', 'ORANGE', 'LIME') var fix_color : String
@export var associated_sewage : CPUParticles2D = null

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_time : Timer = $Progress

var is_getting_fixed : bool = false
var is_fixed : bool = false

func _ready():
	progress_time.wait_time = FIX_TIME
	progress_time.start()

func _process(_delta):
	if is_getting_fixed && !is_fixed:	
		get_fixed()
	else:
		if is_fixed:
			progress_time.stop()
		else:
			progress_time.paused = true
		
		idle()	
	
func get_fixed():
	animation.play('closing')
	progress_time.paused = false
	$ValveProgress._set_value((1 - (progress_time.time_left / FIX_TIME)) * 100)
	
func idle():
	animation.play('default')

func _on_progress_timeout():
	is_fixed = true
	if associated_sewage:
		associated_sewage.turn_off_water_fall()

