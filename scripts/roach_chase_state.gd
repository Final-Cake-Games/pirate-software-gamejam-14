class_name RoachChaseState
extends State

signal lost_player
signal fight_player
signal roach_die

@export var JUMP_FORCE : float = 200

var running_stream : AudioStreamPlayer2D

func _ready():
	set_physics_process(false)

func _enter_state() -> void:
	set_physics_process(true) 
	
	animator.play('walk')
	RoachSfxHandler.play_sfx(vessel.HISSES.pick_random(), vessel)
	running_stream = RoachSfxHandler.play_sfx(vessel.STEPS_CHASE, vessel)
	vessel.player_target = vessel.detection_area.get_overlapping_bodies()[0]

func _exit_state():
	RoachSfxHandler.stop_sfx(running_stream)
	set_physics_process(false)
	
func _physics_process(delta):
	vessel.move_and_slide()
	vessel.velocity.x = move_toward(vessel.velocity.x, vessel.player_dir.x * vessel.CHASE_SPEED, 2)
	
	if !vessel.is_on_floor():  # Temp add gravity in roam, make falling state soon
		vessel.velocity.y += vessel.GRAVITY * delta
		running_stream.stream_paused = true
	else:
		running_stream.stream_paused = false
		
	if ((vessel.is_on_wall() && vessel.is_on_floor()) || (vessel.player_dir.y == -1 && vessel.is_on_wall() && vessel.is_on_floor())):
		jump()

func jump():
	RoachSfxHandler.play_sfx(vessel.JUMP, vessel, 5)
	vessel.velocity.y = -JUMP_FORCE

func _on_detection_range_body_exited(body):
	if !vessel.dead:
		lost_player.emit()

func _on_fight_range_body_entered(body):
	if !vessel.dead:
		fight_player.emit()
