class_name Phase
extends Resource


signal phase_completed

var type: Bozo.Phase
var available_actions: Array[Bozo.Action]
var required_actions: Array[Bozo.Action]


func _ready() -> void:
	pass

func enter_phase() -> void:
	pass

func exit_phase() -> void:
	pass

func is_action_allowed(action_: Bozo.Action) -> bool:
	return action_ in available_actions

func try_execute_action(action_: Bozo.Action) -> bool:
	if not is_action_allowed(action_):
		return false
	
	execute_action(action_)
	
	if all_actions_completed():
		phase_completed.emit()
	
	return true

func execute_action(_action: Bozo.Action) -> void:
	pass

func add_action(action_: Bozo.Action) -> void:
	required_actions.append(action_)
	available_actions.append(action_)

func remove_action(action_: Bozo.Action) -> void:
	required_actions.erase(action_)
	available_actions.erase(action_)

func all_actions_completed() -> bool:
	return required_actions.is_empty()

func skip_action(action_: Bozo.Action) -> void:
	if action_:
		remove_action(action_)
	else:
		var action = required_actions.front()
		remove_action(action)
	
	if all_actions_completed():
		phase_completed.emit()
