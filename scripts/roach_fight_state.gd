class_name RoachFightState
extends State

@onready var reload_timer = $"../../ReloadTimer"

signal player_left_fight_range
signal roach_die

var recent_attack : bool = false

func _ready():
	set_physics_process(false)
	
func _enter_state():
	set_physics_process(true) 
	
	if recent_attack:
		reload_timer.paused = false
	else:
		do_dmg()
		reload_timer.start()
	
func _exit_state():
	set_physics_process(false)
	
	if recent_attack:
		reload_timer.paused = true
	else:
		reload_timer.stop()
	
func _physics_process(delta):
	if !animator.current_animation.begins_with('strike'):
		animator.play('stand_idle')
	print(reload_timer.time_left)

func do_dmg():
	recent_attack = true
	reload_timer.start()
	if (vessel.current_direction.x < 0):
		animator.play('strike_left')
	else:
		animator.play('strike_right')
	await animator.animation_finished
	vessel.player_target.take_dmg(10)
	#print(vessel.player_target.life)

func _on_reload_timer_timeout():
	recent_attack = false
	do_dmg()

func _on_fight_range_body_exited(body):
	if !vessel.dead:
		player_left_fight_range.emit()
