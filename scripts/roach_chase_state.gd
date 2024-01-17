class_name RoachChaseState
extends State

signal lost_player
signal fight_player

var player_dir_x : float
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
	#print(player_dir_x)  # Sometimes -0 or 0 due to player being above
	player_dir_x = round((vessel.global_position.direction_to(player.global_position)).x)
	vessel.velocity.x = move_toward(vessel.velocity.x, player_dir_x * vessel.CHASE_SPEED, 2)
	vessel.move_and_slide()

func _on_detection_range_body_exited(body):
	vessel.last_known_player_location = player_dir_x
	lost_player.emit()

func _on_fight_range_body_entered(body):
	fight_player.emit()
