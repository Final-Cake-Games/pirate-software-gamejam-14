extends Area2D

@export var FIX_TIME : float = 10.0

@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_time : Timer = $Progress

var fix_color : String = 'RED'
var is_getting_fixed : bool = false
var is_fixed : bool = false

func _ready():
	progress_time.wait_time = FIX_TIME
	progress_time.start()

func _process(_delta):
	print(progress_time.time_left)
	if is_getting_fixed && !is_fixed:
		get_fixed()
	else:
		if is_fixed:
			progress_time.stop()
		else:
			progress_time.paused = true
		
		idle()	
	
func get_fixed():
	print('fixing valve...')
	animation.play('closing')
	progress_time.paused = false
	
func idle():
	animation.play('default')

func _on_progress_timeout():
	is_fixed = true
