class_name PhaseDraw
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.DRAW

func enter_phase():
	super.enter_phase()
	print("enter Draw")
	
	Arbitrator.chronicler.tribunal.refill_actual()
	Arbitrator.chronicler.fleet.init_arks(Arbitrator.chronicler.tribunal.actual.stamps)
	Arbitrator.chronicler.tribunal.atheneum.init_scenarios()
	status = Bozo.Status.PLAYING_ANIMATION
	Arbitrator.chronicler.tribunal.atheneum.draw_phase.emit()
	Arbitrator.chronicler.fleet.draw_phase.emit()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
