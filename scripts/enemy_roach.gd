extends CharacterBody2D

@onready var raycast : RayCast2D = $RayCast2D
@onready var animations : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

@export var MOVE_SPEED : float = 50

var dir : float 
var going_right : bool
var _state : String

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
	print(velocity.x)
	
	
	if !is_on_floor():
		velocity.y += 450
		
	match _state:
		'IDLE':
			velocity.x = 0
			print(_state)
			await get_tree().create_timer(5).timeout
			_state = 'MOVING'
		
		'MOVING':
			move_and_slide()
			velocity.x = dir * MOVE_SPEED
			if going_right:
				dir = 1
			else:
				dir = -1
				
			if raycast.is_colliding():
				if raycast.get_collider().name != 'Player':
					dir = update_dir()
					update_raycast_dir()
				else:
					velocity.x = 0
					_state = 'FIGHT'
			print(_state)
			
		'FIGHT':
			velocity.x = 0
			if !raycast.is_colliding():
				_state = 'IDLE'
	
			
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
	
