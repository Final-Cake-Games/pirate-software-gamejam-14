class_name State
extends Node

signal state_finished  # Notify manager when curr state is done

func _enter_state() -> void:  # every state load execute the following (gets replaced by each state's _enter_state())
	pass
	
func _exit_state() -> void:  # every state exit execute the following (gets replaced by each state's _exit_state())
	pass
