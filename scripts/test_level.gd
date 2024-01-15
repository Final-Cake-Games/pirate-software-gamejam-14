extends Node2D

@export var sewage_source : CPUParticles2D
@export var water_level : Area2D

@onready var player : CharacterBody2D = $Player

var level_valves_arr = []
var closed_valves_arr = []
var total_valves_count : int = 0
var closed_valves_count : int = 0
var last_seen_valve : Area2D = null


func _ready():
	level_valves_arr = $Valves.get_children()

func _process(delta):
	#Lógica da subida de água e fecho do esgoto
	water_level.is_rising = !level_valves_arr.all(get_closed_valves)  # Verifica todas as valvulas do nível para parar agua
	closed_valves_arr = level_valves_arr.filter(get_closed_valves)  # Guarda valvulas fechadas
	
	total_valves_count = level_valves_arr.size()
	closed_valves_count = closed_valves_arr.size()
	
	if total_valves_count == closed_valves_count:
		sewage_source.one_shot = true
	
	
	# Lógia do jogador concertar
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

func get_closed_valves(valve):
	return valve.is_fixed
