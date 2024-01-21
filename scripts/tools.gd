extends RigidBody2D

@export var THROW_STR : float = 1500
@export var player : CharacterBody2D
@export_enum('RED', 'BLUE', 'LIME', 'ORANGE') var tool_fix_color : String

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var collision_sfx_player : AudioStreamPlayer = $ToolCollisionSFX

var can_be_picked_up : bool = false
var smoothed_mouse_pos : Vector2
var can_kill : bool = false

func _ready():
	if !player:
		player = get_node('../../Player')

func _process(delta):
	if can_be_picked_up:
		if Input.is_action_just_pressed('pick_up') && !player.player_dead && player.equipped_tool == null:
			player.equipped_tool = self

func _physics_process(delta):
	can_kill = (linear_velocity.x > 100 || linear_velocity.y > 100 || linear_velocity.x < -100 || linear_velocity.y < -100)

	
	if player.equipped_tool != null:
		player.equipped_tool.position = player.get_child(0).get_child(0).global_position  # Place tool in hand of player
		player.equipped_tool.collision_shape.disabled = true

		smoothed_mouse_pos = lerp(smoothed_mouse_pos, get_global_mouse_position(), 0.3)
		player.equipped_tool.look_at(smoothed_mouse_pos)
		
		player.equipped_tool.linear_velocity = Vector2.ZERO
		
		if Input.is_action_just_pressed('throw'):
			throw()
		
		if Input.is_action_just_pressed('drop_item') || player.player_dead:
			drop()
	else:
		collision_shape.disabled = false

func throw():
	var trow_dir = player.global_position.direction_to(get_global_mouse_position())
	player.equipped_tool.apply_impulse(trow_dir * THROW_STR)
	player.equipped_tool = null
			
func drop():
	var random_x = randf_range(-150, 150)
	var random_y = randf_range(-500, -250)
	player.equipped_tool.apply_impulse(Vector2(random_x, random_y))
	player.equipped_tool = null
	
func _on_pick_up_detect_body_entered(body):
	can_be_picked_up = true

func _on_pick_up_detect_body_exited(body):
	can_be_picked_up = false

func _on_kill_detect_body_entered(body):
	if can_kill:
		body.die()

func _on_body_entered(body):
	if !body.name.begins_with('Enemy'):
		if linear_velocity.x > 15 or linear_velocity.x < -15 or linear_velocity.y > 15 or linear_velocity.y < -15:
			collision_sfx_player.playing = false
			collision_sfx_player.play()
