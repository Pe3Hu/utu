class_name PhaseDecision
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DECISION

func enter_phase():
	print("enter Decision")
	exit_phase()
