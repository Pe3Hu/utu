class_name APhase
extends Phase

var attacks_available: int = 2
var attacks_used: int = 0

func enter_phase():
	available_actions = ["attack", "skip"]
	attacks_used = 0
	attacks_available = 2

func execute_action(action_name: String):
	match action_name:
		"attack":
			attacks_used += 1
			print("Атака выполнена!")
		"skip":
			attacks_used = attacks_available  # Пропуск = завершение фазы

func all_actions_completed() -> bool:
	return attacks_used >= attacks_available
