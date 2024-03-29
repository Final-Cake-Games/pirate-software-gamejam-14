extends CharacterBody2D

# Referências aos nós necessários para animar
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var take_dmg_player = $take_dmg
@onready var player_sprite : Sprite2D = $Sprite2D
@onready var weapon_position_father : Node2D = $Node2D

# Variáveis de física
@export var MAX_SPEED : float = 200
@export var WATER_MAX_SPEED : float = 125
@export var CLIMB_SPEED : float = 100
@export var GRAVITY : float = 900
@export var WATER_GRAVITY : float = 350
@export var JUMP_FORCE : float = 300
@export var WATER_JUMP : float = 200
@export var SECOND_JUMP_FORCE : float = 200
@export var WATER_SECOND_JUMP : float = 100
@export var MAX_JUMPS : int = 2
@export var push_force : float = 100

var direction : float  # Input do utilizador (direção no X)
var jumps_available : int = 0
var is_near_ladder : bool = false
var is_on_ladder : bool = false
var is_near_valve : bool = false
var valve_nearby : Area2D = null
var fixing : bool = false
var can_fix_color : String = ''
var player_dead : bool = false
var life : int = 100
var current_gravity : float
var current_jump_force : float
var current_second_jump_force : float
var current_max_speed : float
var equipped_tool : RigidBody2D = null

#SFX

const WATER_DMG_1 = preload("res://assets/sfx/player/take_dmg/from_water/take_dmg_1.mp3") 
const WATER_DMG_2 = preload("res://assets/sfx/player/take_dmg/from_water/take_dmg_2.mp3")
const WATER_DMG_3 = preload("res://assets/sfx/player/take_dmg/from_water/take_dmg_3.mp3")

const ROACH_DMG_1 = preload("res://assets/sfx/player/take_dmg/from_roach/take_dmg_1.mp3") 
const ROACH_DMG_2 = preload("res://assets/sfx/player/take_dmg/from_roach/take_dmg_2.mp3")
const ROACH_DMG_3 = preload("res://assets/sfx/player/take_dmg/from_roach/take_dmg_3.mp3")

const DEATH_1 = preload("res://assets/sfx/player/die/1.ogg")
const DEATH_2 = preload("res://assets/sfx/player/die/4.ogg")
const DEATH_3 = preload("res://assets/sfx/player/die/5.ogg")
const DEATH_4 = preload("res://assets/sfx/player/die/6.ogg")
const DEATH_5 = preload("res://assets/sfx/player/die/9.ogg")

const JUMP_1 = preload("res://assets/sfx/player/jump/jump_1.mp3") 
const JUMP_2 = preload("res://assets/sfx/player/jump/jump_2.mp3")
const JUMP_3 = preload("res://assets/sfx/player/jump/jump_3.mp3")

const WATER_DMG = [WATER_DMG_1, WATER_DMG_2, WATER_DMG_3]
const ROACH_DMG = [ROACH_DMG_1, ROACH_DMG_2, ROACH_DMG_3]
const DIE = [DEATH_1, DEATH_2, DEATH_3, DEATH_4, DEATH_5]
const JUMP = [JUMP_1, JUMP_2, JUMP_3]

func _ready():
	current_gravity = GRAVITY
	current_jump_force = JUMP_FORCE
	current_second_jump_force = SECOND_JUMP_FORCE
	current_max_speed = MAX_SPEED

func _process(_delta):
	
	$PlayerLife.value = life
	
	if equipped_tool != null:
		can_fix_color = equipped_tool.tool_fix_color
	else:
		can_fix_color = ''
	
	if !player_dead:
		direction = Input.get_axis('move_left', 'move_right')
		if Input.is_action_just_pressed('jump') && jumps_available > 0:
			jump()
		
		if is_near_ladder && (Input.is_action_just_pressed('climb_up') || Input.is_action_just_pressed('climb_down')):
			is_on_ladder = true
		if !is_near_ladder:
			is_on_ladder = false
				
		animation_updater()

func _physics_process(delta):
	if !player_dead:
		move_and_slide()  # Chamado 1º para atualizar is_on_floor() antes de dar rest ao MAX_JUMPS
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().name.begins_with('Box'):
				collision.get_collider().apply_central_impulse(-collision.get_normal() * push_force)
		
		if !is_on_floor() && !is_on_ladder:  # Se não está no chão e escadas, aplica gravidade
			velocity.y += current_gravity * delta
		
		if is_on_floor():  # Se está dá reset aos saltos
			jumps_available = MAX_JUMPS
		
		# Lógica de andar/parar na !!horizontal!!
		if direction != 0:  # Estamos a começar a andar
			if is_on_ladder:  # Sai da escada se andar na horizontal nela
				exit_ladder()
				
			velocity.x = direction * current_max_speed  # Aplica velocidade máxima imediatamente
		else:  # Estamos a parar
			velocity.x = move_toward(velocity.x, 0, 30)  # Abranda até 0 de 30 em 30 unidades
		
		# Lógica de subir/descer escadas	
		if is_on_ladder:
			velocity.y = Input.get_axis('climb_up', 'climb_down') * CLIMB_SPEED
			
			if is_near_ladder == false:  # Sai da escada se subir toda
				exit_ladder()	
	
	
func jump(): 
	if is_on_ladder:  # Sai da escada se tentar saltar nela
		exit_ladder()
		return 
	
	if jumps_available == 2:  # Verifica se é 1º ou 2º salto
		velocity.y = -current_jump_force
	else:
		velocity.y = -current_second_jump_force
	
	jumps_available -= 1
	SfxHandler.play_sfx(JUMP.pick_random(), self, 0)
	
func animation_updater():
	# Responsável por atualizar as animações
	if direction != 0:  # Se for 0 não atualiza e guarda a ultima alteração
		player_sprite.flip_h = (direction == -1)  # Se a direção for esquerda liga o flip na horizontal
		flip_weapon_pos_h(direction == -1)

	
	if is_on_floor():
		if fixing:
			animation_player.play('fixing')
		elif velocity == Vector2.ZERO:
			animation_player.play('idle')
		else:
			animation_player.play('run')
	elif is_on_ladder:
		if velocity.y != 0:
			animation_player.play('climbing')
		else:
			animation_player.pause()
	else:
		if velocity.y < 0:  # A subir
			animation_player.play('jump_1')
			if player_sprite.frame == 6:  # Pausa a animação na ultima frame
				animation_player.pause() 
		else:  # A descer
			animation_player.play('fall')

func flip_weapon_pos_h(looking_left):	
	if looking_left:
		weapon_position_father.position.x = -7
	else:
		weapon_position_father.position.x = 5
		
func take_dmg(amount):
	if !player_dead:			
		take_dmg_player.play('take_dmg')
		life -= amount
		if life <= 0:
			die()
		else:
			if amount == 10:
				SfxHandler.play_sfx(WATER_DMG.pick_random(), self, 0)
			else:
				SfxHandler.play_sfx(ROACH_DMG.pick_random(), self, 0)
		
func die():
	SfxHandler.play_sfx(DIE.pick_random(), self, 5)
	player_dead = true
	animation_player.play('die')
	
func set_water_physics():
	velocity.y = 0
	current_max_speed = WATER_MAX_SPEED
	current_gravity = WATER_GRAVITY
	current_jump_force = WATER_JUMP
	current_second_jump_force = WATER_SECOND_JUMP
	
func revert_physics():
	current_max_speed = MAX_SPEED
	current_gravity = GRAVITY
	current_jump_force = JUMP_FORCE
	current_second_jump_force = SECOND_JUMP_FORCE

func exit_ladder():
	is_on_ladder = false 
	jumps_available = 0

func _on_ladder_check_body_entered(_body):
	is_near_ladder = true
	
func _on_ladder_check_body_exited(_body):
	is_near_ladder = false

func _on_valve_check_area_entered(area):
	is_near_valve = true
	valve_nearby = area

func _on_valve_check_area_exited(area):
	is_near_valve = false
	valve_nearby = null
