class_name RoachChaseState
extends State

signal lost_player
signal fight_player

var player : CharacterBody2D

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true) 
	animator.play('walk')
	player = vessel.detection_area.get_overlapping_bodies()[0]

func _exit_state():
	set_physics_process(false)
	
func _physics_process(delta):
	var player_dir_x = (vessel.global_position.direction_to(player.global_position)).x
	vessel.velocity.x = move_toward(vessel.velocity.x, player_dir_x * vessel.CHASE_SPEED, 2)
	vessel.move_and_slide()

func _on_detection_range_body_exited(body):
	lost_player.emit()
