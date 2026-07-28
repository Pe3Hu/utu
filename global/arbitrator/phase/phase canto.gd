class_name CantoPhase
extends Phase


func _init() -> void:
	type = Bozo.Phase.CANTO

func enter_phase():
	print("enter Canto")
	available_actions = [Bozo.Action.SELECT_INTRO, Bozo.Action.SELECT_VERSE, Bozo.Action.SELECT_OUTRO]
	required_actions = [Bozo.Action.SELECT_INTRO, Bozo.Action.SELECT_VERSE, Bozo.Action.SELECT_OUTRO]

func execute_action(action_: Bozo.Action) -> void:
	match action_:
		Bozo.Action.SELECT_INTRO:
			pass
