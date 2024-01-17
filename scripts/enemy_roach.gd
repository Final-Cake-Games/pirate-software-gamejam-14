class_name  EnemyRoach
extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var detection_area = $DetectionRange
@onready var fight_area = $FightRange

@onready var roach_state_machine = $RoachStateMachine  

@onready var roach_roaming_state = $RoachStateMachine/RoachRoamingState as RoachRoamingState
@onready var roach_chase_state = $RoachStateMachine/RoachChaseState as RoachChaseState

var ROAM_SPEED = 20
var CHASE_SPEED = 50

var current_direction : Vector2

func _ready():
	roach_roaming_state.saw_player.connect(roach_state_machine.change_state.bind(roach_chase_state))
	roach_chase_state.lost_player.connect(roach_state_machine.change_state.bind(roach_roaming_state))

func _process(delta):
	current_direction = velocity
	
	update_sprite_dir()
	
func update_sprite_dir():
	if current_direction.x != 0:  # Keep sprite facing the right direction
		sprite_2d.flip_h = (current_direction.x < 0)

