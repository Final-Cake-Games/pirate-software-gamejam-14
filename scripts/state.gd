class_name State
extends Node

signal state_finished  # Notify manager when curr state is done

@export var vessel : EnemyRoach  # vessel will be occupied only by a scene that extends from EnemyRoach
@export var animator : AnimationPlayer

func _enter_state() -> void:  # every state load execute the following (gets replaced by each state's _enter_state())
	pass
	
func _exit_state() -> void:  # every state exit execute the following (gets replaced by each state's _exit_state())
	pass
