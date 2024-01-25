class_name RoachDieState
extends State

func _ready():
	set_physics_process(false)

func _enter_state():
	set_physics_process(true)
	vessel.dead = true
	vessel.velocity = Vector2.ZERO
	SfxHandler.play_sfx(vessel.HITS.pick_random(), vessel, -1)
	SfxHandler.play_sfx(vessel.DIED, vessel, 1)
	animator.play('die')
	await animator.animation_finished
	await get_tree().create_timer(3).timeout
	vessel.queue_free()

func _physics_process(delta):
	vessel.move_and_slide()
	if !vessel.is_on_floor():
		vessel.velocity.y += vessel.GRAVITY
	

