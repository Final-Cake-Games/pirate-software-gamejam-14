extends CharacterBody2D

# Referências aos nós necessários para animar
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var player_sprite : Sprite2D = $Sprite2D

# Variáveis de física
@export var MAX_SPEED : float = 500
@export var GRAVITY : float = 400
@export var JUMP_FORCE : float = 500

# Input do utilizador (direção no X)
var direction : float

func _physics_process(delta):
	pass



