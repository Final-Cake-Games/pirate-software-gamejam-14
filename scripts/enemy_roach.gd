class_name  EnemyRoach
extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var detection_area = $DetectionRange
@onready var fight_area = $FightRange

@onready var roach_state_machine = $RoachStateMachine  

@onready var roach_roaming_state = $RoachStateMachine/RoachRoamingState as RoachRoamingState
@onready var roach_chase_state = $RoachStateMachine/RoachChaseState as RoachChaseState
@onready var roach_fight_state = $RoachStateMachine/RoachFightState as RoachFightState
@onready var roach_die_state = $RoachStateMachine/RoachDieState as RoachDieState

@export var GRAVITY : float = 400

var ROAM_SPEED = 20
var CHASE_SPEED = 50
var dead = false

var current_direction : Vector2
var player_target : CharacterBody2D = null
var player_dir : Vector2 

func _ready():
	roach_roaming_state.saw_player.connect(roach_state_machine.change_state.bind(roach_chase_state))
	roach_chase_state.lost_player.connect(roach_state_machine.change_state.bind(roach_roaming_state))
	roach_chase_state.fight_player.connect(roach_state_machine.change_state.bind(roach_fight_state))
	roach_fight_state.player_left_fight_range.connect(roach_state_machine.change_state.bind(roach_chase_state))
	
	roach_roaming_state.roach_die.connect(roach_state_machine.change_state.bind(roach_die_state))
	roach_chase_state.roach_die.connect(roach_state_machine.change_state.bind(roach_die_state))
	roach_fight_state.roach_die.connect(roach_state_machine.change_state.bind(roach_die_state))

func _process(delta):
	print(player_dir)
	current_direction = velocity
	update_sprite_dir()
	if player_target != null:
		update_player_dir()
		
func update_player_dir():
	player_dir = to_local(self.player_target.global_position)
	
	if player_dir.x > 0:
		player_dir.x = 1
	elif player_dir.x < 0:
		player_dir.x = -1
		
	if player_dir.y > 0:
		player_dir.y = 1
	elif player_dir.y < 0:
		player_dir.y = -1
	
	
	
func update_sprite_dir():
	if current_direction.x != 0:  # Keep sprite facing the right direction
		sprite_2d.flip_h = (current_direction.x < 0)
		
func die():
	roach_state_machine.current_state.roach_die.emit()

