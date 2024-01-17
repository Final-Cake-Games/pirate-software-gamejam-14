class_name RoachFightState
extends State

@onready var reload_timer = $"../../ReloadTimer"

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
	reload_timer.stop()

	
func do_dmg():
	if player_has_left: return
	
	reload_timer.wait_time = 3
	
	if (vessel.current_direction.x < 0):
		animator.play('strike_left')
	else:
		animator.play('strike_right')
	
	await animator.animation_finished
	
	player.take_dmg(10)
	
	animator.play('stand_idle')
	
	reload_timer.start()

func _on_fight_range_body_exited(body):
	player_has_left = true
	player_left_fight_range.emit()

func _on_reload_timer_timeout():
	if !player_has_left:
		do_dmg()
