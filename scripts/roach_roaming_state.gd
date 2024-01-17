class_name RoachRoamingState
extends State  # inherits all of State class propreties and methods

var roam_direction : float

signal saw_player

func _ready():
	roam_direction = randi_range(-1, 1)  # Randomize start direction
	
	if roam_direction == 0: #  Temporarily disalow 0
		roam_direction = 1
		
	set_physics_process(false)  # Disable physics process by default

func _enter_state() -> void:
	set_physics_process(true)  # Only enable when current state is active (roaming)
	animator.play('walk')
	if vessel.velocity.x == 0:  # Start roaming
		vessel.velocity.x = roam_direction * vessel.ROAM_SPEED

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(delta):
	vessel.move_and_slide()
	
	update_sprite_dir()
	update_raycast_dir()
	
	if !vessel.is_on_floor():  # Temp add gravity in roam, make falling state soon
		vessel.velocity.y += 300
	
	if vessel.is_on_wall():
		flip_roam_dir()
	
	vessel.velocity.x = roam_direction * vessel.ROAM_SPEED

func update_sprite_dir():
	if roam_direction != 0:  # Keep sprite facing the right direction
		vessel.sprite_2d.flip_h = (roam_direction < 0)

func update_raycast_dir():
	if roam_direction > 0:
		vessel.ray_cast_2d.target_position.x = 50
	elif roam_direction < 0:
		vessel.ray_cast_2d.target_position.x = -50

func flip_roam_dir():
	if roam_direction > 0:
		roam_direction = -1
	else:
		roam_direction = 1
