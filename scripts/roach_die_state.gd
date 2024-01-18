class_name RoachDieState
extends State

func _enter_state():
	animator.play('die')
	await animator.animation_finished
	vessel.queue_free()
