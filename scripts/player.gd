extends CharacterBody2D

# Referências aos nós necessários para animar
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D

# Variáveis de física
@export var MAX_SPEED : float = 250
@export var CLIMB_SPEED : float = 100
@export var GRAVITY : float = 900
@export var JUMP_FORCE : float = 400
@export var SECOND_JUMP_FORCE : float = 250
@export var MAX_JUMPS : int = 2

var direction : float  # Input do utilizador (direção no X)
var jumps_available : int = 0
var is_on_ladder : bool = false

func _process(_delta):
	direction = Input.get_axis('move_left', 'move_right')
	if Input.is_action_just_pressed('jump') && jumps_available > 0:
		jump()
		
	animation_updater()

func _physics_process(delta):
	move_and_slide()  # Chamado 1º para atualizar is_on_floor() antes de dar rest ao MAX_JUMPS
	
	if !is_on_floor() && !is_on_ladder:  # Se não está no chão e escadas, aplica gravidade
		velocity.y += GRAVITY * delta
	else:  # Se está dá reset aos saltos
		jumps_available = MAX_JUMPS
	
	# Lógica de andar/parar na !!horizontal!!
	if direction != 0:  # Estamos a começar a andar
		velocity.x = direction * MAX_SPEED  # Aplica velocidade máxima imediatamente
	else:  # Estamos a parar
		velocity.x = move_toward(velocity.x, 0, 30)  # Abranda até 0 de 30 em 30 unidades
	
	# Lógica de subir/descer escadas	
	if is_on_ladder:
		velocity.y = Input.get_axis('climb_up', 'climb_down') * CLIMB_SPEED
	
func jump():  
	if jumps_available == 2:  # Verifica se é 1º ou 2º salto
		velocity.y = -JUMP_FORCE
	else:
		velocity.y = -SECOND_JUMP_FORCE
	
	jumps_available -= 1
	
func animation_updater():
	# Responsável por atualizar as animações
	if direction != 0:  # Se for 0 não atualiza e guarda a ultima alteração
		player_sprite.flip_h = (direction == -1)  # Se a direção for esquerda liga o flip na horizontal
	
	if is_on_floor():
		if velocity == Vector2.ZERO:
			animation_player.play('idle')
		else:
			animation_player.play('run')
	else:
		if velocity.y < 0:  # A subir
			animation_player.play('jump_1')
			if player_sprite.frame == 3:  # Pausa a animação na ultima frame
				animation_player.pause() 
		else:  # A descer
			animation_player.play('fall')

func _on_ladder_check_body_entered(body):
	is_on_ladder = true
	
func _on_ladder_check_body_exited(body):
	is_on_ladder = false
