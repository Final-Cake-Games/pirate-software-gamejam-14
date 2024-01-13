extends CharacterBody2D

# Referências aos nós necessários para animar
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D

# Variáveis de física
@export var MAX_SPEED : float = 250
@export var GRAVITY : float = 1000
@export var JUMP_FORCE : float = 450

# Input do utilizador (direção no X)
var direction : float

func _process(delta):
	direction = Input.get_axis('move_left', 'move_right')
	if Input.is_action_just_pressed('jump'):
		jump()

func _physics_process(delta):
	# Se não está no chão, aplica gravidade
	if !is_on_floor():
		velocity.y += GRAVITY * delta
	
	# Lógica de andar/parar na !!horizontal!!
	if direction != 0:  # Estamos a começar a andar
		velocity.x = direction * MAX_SPEED  # Aplica velocidade máxima imediatamente
	else:  # Estamos a parar
		velocity.x = move_toward(velocity.x, 0, 20)  # Abranda até 0 de 20 em 20 unidades
	
	move_and_slide()

func jump():
	velocity.y = -JUMP_FORCE
		
