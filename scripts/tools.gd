extends RigidBody2D

@export var THROW_STR : float = 1500
@export var player : CharacterBody2D
@export_enum('RED', 'BLUE') var tool_fix_color : String

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var picked_up : bool = false
var can_be_picked_up : bool = false
var smoothed_mouse_pos : Vector2
var can_kill : bool = false

func _ready():
	if !player:
		player = get_node('../../Player')

func _process(delta):
	if can_be_picked_up:
		if Input.is_action_just_pressed('pick_up') && !player.player_dead && player.can_fix_color == '':
			picked_up = true
			player.tool_count += 1

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
			player.tool_count -= 1
			picked_up = false
			player.can_fix_color = ''
			var trow_dir = player.global_position.direction_to(get_global_mouse_position())
			apply_impulse(trow_dir * THROW_STR)
		
		if Input.is_action_just_pressed('drop_item') || player.player_dead:
			player.tool_count -= 1
			picked_up = false
			player.can_fix_color = ''
			apply_impulse(Vector2(0, 1))
	else:
		collision_shape.disabled = false
	
	if player.tool_count < 0 || player.tool_count > 1:
		apply_impulse(Vector2(0, 1))
		player.tool_count = 0
		picked_up = false

func _on_pick_up_detect_body_entered(body):
	can_be_picked_up = true

func _on_pick_up_detect_body_exited(body):
	can_be_picked_up = false

func _on_kill_detect_body_entered(body):
	if can_kill:
		body.die()