extends Control

@onready var level_1 = preload("res://scenes/levels/level_1.tscn")
@onready var animation_player = $AnimationPlayer

var engine_loop = preload("res://assets/sfx/truck/motor_loop.mp3")
var engine_accel = preload("res://assets/sfx/truck/motor_accelerate.mp3")
var engine_stream : AudioStreamPlayer2D

func _ready():
	engine_stream = SfxHandler.play_sfx(engine_loop, $Truck, 0)

func _on_play_pressed():
	SfxHandler.stop_sfx(engine_stream)
	SfxHandler.play_sfx(engine_accel, $Truck, 0)
	animation_player.play('start_game')
	await animation_player.animation_finished
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_packed(level_1)
	
func _on_quit_pressed():
	get_tree().quit() 
