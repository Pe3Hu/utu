class_name PhaseFusion
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.FUSION

func enter_phase():
	super.enter_phase()
	print("enter Fusion")
	Arbitrator.chronicler.faction.isle.forge.fusion_phase.emit()
	if Arbitrator.chronicler.faction.isle.forge.anvils.is_empty():
		exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
