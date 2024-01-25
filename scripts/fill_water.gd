extends Area2D

@onready var dmg_timer = $DmgTimer

@export var MAX_HEIGHT : float = 200.0
@export var RISE_SPEED : float = 0.05  
@export var FALL_SPEED : float = 0.2  

var WATER_SPREADING = preload("res://assets/sfx/water/water_spreading.mp3")
var WATER_SPLASH = preload("res://assets/sfx/water/water_splash.mp3")

var is_rising : bool = true
var player : CharacterBody2D = null

func _ready():
	var water_stream = SfxHandler.play_sfx(WATER_SPREADING, self, -25)
	dmg_timer.stop()
	
func _process(delta):
	
	if is_rising && scale.y < MAX_HEIGHT:
		scale.y += RISE_SPEED * delta
	elif !is_rising && scale.y > 0:
		scale.y -= FALL_SPEED * delta
		
	if player != null && dmg_timer.is_stopped():
		dmg_timer.start()

func _on_body_entered(body):
	player = body
	player.set_water_physics()
	SfxHandler.play_sfx(WATER_SPLASH, player, -5)

func _on_body_exited(body):
	player.revert_physics()
	player = null
	dmg_timer.stop()

func _on_dmg_timer_timeout():
	if player && is_rising:
		player.take_dmg(10)
