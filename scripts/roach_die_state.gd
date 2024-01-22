class_name RoachDieState
extends State

func _ready():
	set_physics_process(false)

func _enter_state():
	vessel.dead = true
	vessel.velocity = Vector2.ZERO
	SfxHandler.play_sfx(vessel.HITS.pick_random(), vessel, -1)
	SfxHandler.play_sfx(vessel.DIED, vessel, 1)
	animator.play('die')
	await animator.animation_finished
	vessel.queue_free()

