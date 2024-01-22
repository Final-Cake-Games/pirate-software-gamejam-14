class_name RoachDieState
extends State

func _ready():
	set_physics_process(false)

func _enter_state():
	vessel.dead = true
	vessel.velocity = Vector2.ZERO
	RoachSfxHandler.play_sfx(vessel.HITS.pick_random(), vessel, 3)
	RoachSfxHandler.play_sfx(vessel.DIED, vessel, 10)
	animator.play('die')
	await animator.animation_finished
	vessel.queue_free()

