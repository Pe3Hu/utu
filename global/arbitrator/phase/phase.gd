extends Node
class_name Phase

signal phase_completed

var available_actions: Array[String] = []
var player_ref: Node


func _ready():
	pass

func enter_phase():
	"""Вызывается при входе в фазу"""
	pass

func exit_phase():
	"""Вызывается при выходе из фазы"""
	pass

func is_action_allowed(action_name: String) -> bool:
	return action_name in available_actions

func try_execute_action(action_name: String) -> bool:
	if not is_action_allowed(action_name):
		return false
	
	execute_action(action_name)
	
	if all_actions_completed():
		phase_completed.emit()
	
	return true

func execute_action(_action_name: String):
	"""Переопределяется в подклассах"""
	pass

func all_actions_completed() -> bool:
	"""Переопределяется в подклассах для своей логики"""
	return true
