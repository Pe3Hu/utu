class_name PhaseFusion
extends Phase


func _init() -> void:
	super._init()
	#type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	print("enter")

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
