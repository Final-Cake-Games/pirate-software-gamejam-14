class_name  EnemyRoach
extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var ray_cast_2d = $RayCast2D

var ROAM_SPEED = 20
var CHASE_SPEED = 50
