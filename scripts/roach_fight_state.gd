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
	
	if !vessel.is_on_floor():
		vessel.move_and_slide()
		vessel.velocity.y += vessel.GRAVITY * delta

	if !animator.current_animation.begins_with('strike'):
		animator.play('stand_idle')

func do_dmg():
	if !vessel.player_target.player_dead:
		recent_attack = true
		reload_timer.start()
		if (vessel.player_dir.x < 0):
			animator.play('strike_left')
		else:
			animator.play('strike_right')
		vessel.player_target.take_dmg(10)
		SfxHandler.play_sfx(vessel.STRIKE, vessel, -5)
		await animator.animation_finished
	
func _on_reload_timer_timeout():
	recent_attack = false
	do_dmg()

func _on_fight_range_body_exited(body):
	if !vessel.dead:
		player_left_fight_range.emit()
