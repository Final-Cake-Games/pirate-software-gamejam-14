class_name RoachDieState
extends State

func _ready():
	set_physics_process(false)

func _enter_state():
	vessel.dead = true
	vessel.velocity = Vector2.ZERO
	animator.play('die')
	await animator.animation_finished
	vessel.queue_free()

