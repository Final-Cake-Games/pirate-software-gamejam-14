extends Node2D

@export var sewage_source : CPUParticles2D
@export var water_level : Area2D

@onready var player : CharacterBody2D = $Player
@onready var hud = $HUD

var level_valves_arr = []
var closed_valves_arr = []
var total_valves_count : int = 0
var closed_valves_count : int = 0
var last_seen_valve : Area2D = null
var level_win : bool = false

var total_red_valves : int = 0
var total_blue_valves : int = 0
var total_lime_valves : int = 0
var total_orange_valves : int = 0

var fixed_red_valves : int = 0
var fixed_blue_valves : int = 0
var fixed_lime_valves : int = 0
var fixed_orange_valves : int = 0



func _ready():
	level_valves_arr = $Valves.get_children()
	count_valves()
	update_hud_info()

func _process(delta):
	if level_win || player.player_dead:
		player.player_dead = true #  Freeze player
		print('game over status -> ', level_win)
	
	level_win = !water_level.is_rising
	#Lógica da subida de água e fecho do esgoto
	water_level.is_rising = !level_valves_arr.all(get_closed_valves)  # Verifica todas as valvulas do nível para parar agua
	closed_valves_arr = level_valves_arr.filter(get_closed_valves)  # Guarda valvulas fechadas
	count_valves(closed_valves_arr)  # Keep track of each closed color
	update_hud_info()  
	
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

func update_hud_info():
	hud.set_red_left(total_red_valves - fixed_red_valves)
	hud.set_blue_left(total_blue_valves - fixed_blue_valves)
	hud.set_lime_left(total_lime_valves - fixed_lime_valves)
	hud.set_orange_left(total_orange_valves - fixed_orange_valves)
	
func count_valves(valves_arr = null):
	if valves_arr == null:
		total_red_valves = level_valves_arr.filter(func(valve): return valve.name.contains('Red')).size()
		total_blue_valves = level_valves_arr.filter(func(valve): return valve.name.contains('Blue')).size()
		total_lime_valves = level_valves_arr.filter(func(valve): return valve.name.contains('Lime')).size()
		total_orange_valves = level_valves_arr.filter(func(valve): return valve.name.contains('Orange')).size()
	else:
		fixed_red_valves = valves_arr.filter(func(valve): return valve.name.contains('Red')).size()
		fixed_blue_valves = valves_arr.filter(func(valve): return valve.name.contains('Blue')).size()
		fixed_lime_valves = valves_arr.filter(func(valve): return valve.name.contains('Lime')).size()
		fixed_orange_valves = valves_arr.filter(func(valve): return valve.name.contains('Orange')).size()
