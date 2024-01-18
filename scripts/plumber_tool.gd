extends RigidBody2D

@export var THROW_STR : float = 1500

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var player : CharacterBody2D 
var picked_up : bool = false
var can_be_picked_up : bool = false
var smoothed_mouse_pos : Vector2
var tool_fix_color = 'RED'
var can_kill : bool = false

func _ready():
	player = get_node('../Player')

func _process(delta):
	if can_be_picked_up:
		if Input.is_action_just_pressed('pick_up') && !player.player_dead:
			picked_up = true

func _physics_process(delta):
	can_kill = (linear_velocity.x > 100 || linear_velocity.y > 100 || linear_velocity.x < -100 || linear_velocity.y < -100)
			
	if picked_up == true:
		collision_shape.disabled = true
		player.can_fix_color = tool_fix_color
		position = player.get_child(0).get_child(0).global_position
		smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), 0.3)
		look_at(smoothed_mouse_pos)
		
		linear_velocity = Vector2.ZERO
		
		if Input.is_action_just_pressed('throw'):
			picked_up = false
			var trow_dir = player.global_position.direction_to(get_global_mouse_position())
			apply_impulse(trow_dir * THROW_STR)
		
		if Input.is_action_just_pressed('drop_item') || player.player_dead:
			picked_up = false
			apply_impulse(Vector2(0, 1))
	else:
		collision_shape.disabled = false
		player.can_fix_color = ''

func _on_pick_up_detect_body_entered(body):
	can_be_picked_up = true

func _on_pick_up_detect_body_exited(body):
	can_be_picked_up = false

func _on_kill_detect_body_entered(body):
	if can_kill:
		body.die()
