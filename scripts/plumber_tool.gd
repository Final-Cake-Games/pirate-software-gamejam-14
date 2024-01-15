extends RigidBody2D

@export var THROW_STR : float = 1500

var player : CharacterBody2D 
var picked_up : bool = false
var can_be_picked_up : bool = false
var smoothed_mouse_pos : Vector2

func _ready():
	player = get_node('../Player')

func _process(delta):
	if can_be_picked_up:
		if Input.is_action_just_pressed('pick_up'):
			picked_up = true

func _physics_process(delta):
	if picked_up == true:
		position = player.get_child(0).get_child(0).global_position
		smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), 0.3)
		look_at(smoothed_mouse_pos)
		
		linear_velocity = Vector2.ZERO
		
		if Input.is_action_just_pressed('throw'):
			picked_up = false
			var trow_dir = player.global_position.direction_to(get_global_mouse_position())
			apply_impulse(trow_dir * THROW_STR)
		
		if Input.is_action_just_pressed('drop_item'):
			picked_up = false
			apply_impulse(Vector2(0, 1))

func _on_pick_up_detect_body_entered(body):
	can_be_picked_up = true

func _on_pick_up_detect_body_exited(body):
	can_be_picked_up = false
