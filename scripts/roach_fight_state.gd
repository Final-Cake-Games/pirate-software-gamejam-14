class_name RoachFightState
extends State

signal player_left_fight_range

var player : CharacterBody2D
var player_has_left : bool 

func _ready():
	set_physics_process(false)
	
func _enter_state():
	player_has_left = false
	animator.play('get_triggered')
	await animator.animation_finished
	animator.play('stand_idle')
	player = vessel.fight_area.get_overlapping_bodies()[0]
	do_dmg()
	
func _exit_state():
	set_physics_process(false)

	
func do_dmg():
	if (vessel.current_direction.x < 0):
		animator.play('strike_left')
	else:
		animator.play('strike_right')
		
	player.take_dmg(10)
	
	await animator.animation_finished
	animator.play('stand_idle')
	await get_tree().create_timer(3).timeout
	if player_has_left:
		return
	else:
		do_dmg()

func _on_fight_range_body_exited(body):
	player_has_left = true
	player_left_fight_range.emit()
