class_name PhaseDraw
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.DRAW

func enter_phase():
	super.enter_phase()
	
	Arbitrator.current_chronicler.tribunal.refill_actual()
	Arbitrator.current_chronicler.fleet.init_arks(Arbitrator.current_chronicler.tribunal.actual.stamps)
	Arbitrator.current_chronicler.tribunal.atheneum.init_scenarios()
	
	if Arbitrator.is_player():
		status = Bozo.Status.PLAYING_ANIMATION
		Arbitrator.current_chronicler.tribunal.atheneum.draw_phase.emit()
		Arbitrator.current_chronicler.fleet.draw_phase.emit()
	else:
		exit_phase()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
