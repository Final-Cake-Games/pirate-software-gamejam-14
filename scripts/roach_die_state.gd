class_name RoachDieState
extends State

func _enter_state():
	vessel.dead = true
	animator.play('die')
	await animator.animation_finished
	vessel.queue_free()
