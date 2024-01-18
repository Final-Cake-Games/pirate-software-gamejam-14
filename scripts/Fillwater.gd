extends Area2D

@onready var dmg_timer = $DmgTimer

@export var MAX_HEIGHT : float = 200.0
@export var RISE_SPEED : float = 0.05  
@export var FALL_SPEED : float = 0.2  

var is_rising : bool = true
var player : CharacterBody2D = null

func _ready():
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

func _on_body_exited(body):
	player = null
	dmg_timer.stop()

func _on_dmg_timer_timeout():
	if player && is_rising:
		player.take_dmg(10)
	
		
