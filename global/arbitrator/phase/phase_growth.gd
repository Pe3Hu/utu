class_name PhaseGrowth
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.GROWTH

func enter_phase():
	super.enter_phase()
	Arbitrator.current_chronicler.fleet.kernel.grow_harvest(not Arbitrator.is_player())
	
	if Arbitrator.is_player():
		Arbitrator.current_chronicler.fleet.kernel.growth_phase.emit()
		status = Bozo.Status.PLAYING_ANIMATION
	else:
		exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
