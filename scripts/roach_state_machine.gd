# The state manager
class_name RoachStateMachine
extends Node

@export var state : State  # 1st state

func _ready():
	change_state(state)  # Initialize first state on load
	
func change_state(new_state : State):
	pass
	
