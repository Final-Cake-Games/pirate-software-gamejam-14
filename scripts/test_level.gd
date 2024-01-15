extends Node2D

@export var sewage_source : CPUParticles2D
@export var water_level : Area2D

@onready var player : CharacterBody2D = $Player

var last_seen_valve : Area2D = null

func _process(delta):
	
	if player.is_near_valve: 
		last_seen_valve = player.valve_nearby
		if !last_seen_valve.is_fixed:
			if last_seen_valve.fix_color == player.can_fix_color && Input.is_action_pressed('fix'):
				toggle_fixing(true)
			else:
				toggle_fixing(false)
		else:
			toggle_fixing(false)	
	else:
		toggle_fixing(false)
			

func toggle_fixing(status : bool):
	player.fixing = status
	if last_seen_valve:
		last_seen_valve.is_getting_fixed = status
		
	
	
		
