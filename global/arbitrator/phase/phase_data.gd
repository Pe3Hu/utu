class_name Phase
extends Resource


signal phase_completed
signal all_animations_finished

var type: Bozo.Phase
var status: Bozo.Status = Bozo.Status.IDLE

var animation_tweens: Array[Tween]


func _init() -> void:
	all_animations_finished.connect(_on_all_animations_finished)

func enter_phase() -> void:
	#if Arbitrator.is_player():
	#	print(Bozo.enum_to_string(Bozo.Type.PHASE, type))
	pass

func exit_phase() -> void:
	phase_completed.emit()

func can_execute_action(_action: ActionData) -> bool:
	return true

func try_execute_action(action: ActionData) -> bool:
	if not can_execute_action(action):
		return false

	action.execute()
	return true

func _on_tween_finished(tween_: Tween) -> void:
	animation_tweens.erase(tween_)
	
	if animation_tweens.is_empty():
		all_animations_finished.emit()

func _on_all_animations_finished() -> void:
	pass
