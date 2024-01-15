extends Area2D

@export var MAX_HEIGHT : float = 200.0
@export var RISE_SPEED : float = 0.05  

var is_rising : bool = true

func _process(delta):
	
	if is_rising && scale.y < MAX_HEIGHT:
		scale.y += RISE_SPEED * delta
		
