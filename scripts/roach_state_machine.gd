# The state manager
class_name RoachStateMachine
extends Node

@export var default_state : State

var current_state : State  # Only scenes that are of State class or extended from State class 


func _ready():
	change_state(default_state)  # Initialize first state on load
	
func change_state(new_state : State):
	if current_state != null:  # Exit currently loaded state (if there is any...)
		current_state._exit_state()
	new_state._enter_state()
	current_state = new_state  # Update the current state to the just loaded state

