extends RigidBody2D

var picked_up = false
var can_be_picked_up = false

func _process(delta):
	if can_be_picked_up:
		if Input.is_action_just_pressed('pick_up'):
			picked_up = true

func _physics_process(delta):
	if picked_up == true:
		position = get_node('../Player/WeaponPos').global_position
		
		linear_velocity = Vector2.ZERO
		
		if Input.is_action_just_pressed('drop_item'):
			picked_up = false
			apply_impulse(Vector2(0, 1))

func _on_pick_up_detect_body_entered(body):
	can_be_picked_up = true

func _on_pick_up_detect_body_exited(body):
	can_be_picked_up = false
