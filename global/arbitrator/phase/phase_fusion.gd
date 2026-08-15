class_name PhaseFusion
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.FUSION

func enter_phase():
	super.enter_phase()
	Arbitrator.chronicler.faction.policy.isle.forge.fusion_phase.emit()
	
	if Arbitrator.chronicler.faction.policy.isle.forge.anvils.is_empty():
		exit_phase()
	else:
		Arbitrator.chronicler.faction.policy.isle.forge.simulate_anvil_choice()

func exit_phase() -> void:
	super.exit_phase()
	Arbitrator.chronicler.faction.policy.isle.forge.phase_finished.emit()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
