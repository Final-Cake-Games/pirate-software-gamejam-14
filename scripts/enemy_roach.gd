extends CharacterBody2D

@onready var raycast : RayCast2D = $RayCast2D
@onready var animations : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

@export var MOVE_SPEED : float = 50

var dir : float 
var going_right : bool
var _state : String
var player_in_range : bool = false
var last_known_player_dir : float 

func _ready():
	dir = randomize_dir()
	
	if dir == 0: 
		_state = 'IDLE'
	else:
		_state = 'MOVING'
		
	going_right = (dir == 1)
	
	
func _process(delta):
	update_animations()
	update_raycast_dir()

func _physics_process(delta):
	print(last_known_player_dir)
	move_and_slide()
	if !is_on_floor():
		velocity.y += 450
		
	match _state:
		'IDLE':
			velocity.x = 0
			await get_tree().create_timer(randi_range(2, 12)).timeout
			if player_in_range:	
				_state = 'FIGHT'
			else:
				_state = 'MOVING'
		
		'MOVING':
			velocity.x = dir * MOVE_SPEED
			
			if going_right:
				dir = 1
			else:
				dir = -1
			
			if player_in_range:
				_state = 'FIGHT'	
			
			if raycast.is_colliding():
				dir = update_dir()
				update_raycast_dir()
			
		'FIGHT':
			velocity.x = 0
			sprite.flip_h = (dir != last_known_player_dir)
			if dir != last_known_player_dir && last_known_player_dir != 0:
					dir = update_dir()
					update_raycast_dir()
			if !player_in_range:
				_state = 'IDLE'
			
	
func do_dmg():
	print('dmg player')
	await get_tree().create_timer(3).timeout
	
	if raycast.is_colliding() && raycast.get_collider().name == 'Player':
		do_dmg()
	else:
		_state = 'IDLE'
		return
		
func update_dir():
	if going_right == true: 
		going_right = false
		return -1
	else: 
		going_right = true
		return 1


func randomize_dir():
	return randi_range(-1, 1)
	
func update_raycast_dir():
	if going_right:
		raycast.rotation_degrees = 0
	else:
		raycast.rotation_degrees = 180
		
	
func update_animations():
	if (dir != 0):  # Flip sprite
		sprite.flip_h = (dir == -1)
		
	match _state:
		'MOVING':
			animations.play('walk')
		'IDLE':
			animations.play('idle')
		'FIGHT':
			animations.play('get_triggered')
			if sprite.frame == 10:
				animations.pause()
	
func _on_area_2d_body_entered(body):
	last_known_player_dir = round((global_position.direction_to(body.global_position)).x)
	player_in_range = true

func _on_area_2d_body_exited(body):
	player_in_range = false
