class_name RoachFightState
extends State

signal player_left_fight_range

var player : CharacterBody2D

func _ready():
	set_physics_process(false)
	
func _enter_state():
	set_physics_process(true) 
	animator.play('get_triggered')
	player = vessel.fight_area.get_overlapping_bodies()[0]
	
func _exit_state():
	set_physics_process(false)

func _physics_process(delta):
	pass
	
func _on_fight_range_body_exited(body):
	player_left_fight_range.emit()
