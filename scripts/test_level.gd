extends Node2D

@export var sewage_source : CPUParticles2D
@export var water_level : Area2D

@onready var player : CharacterBody2D = $Player

func _process(delta):
	
	if player.is_near_valve:
		if player.valve_nearby.fix_color == player.can_fix_color && Input.is_action_pressed('fix'):
			player.valve_nearby.is_getting_fixed = true
		elif Input.is_action_just_released('fix'):
			player.valve_nearby.is_getting_fixed = false
