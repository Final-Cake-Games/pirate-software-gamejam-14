extends Area2D

var MaxSize = 200.0
var velocity = 0.001  

func _process(delta):
	scale.y += velocity * delta
		
