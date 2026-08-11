class_name PhaseDiscard
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	print("enter Discard")
	Arbitrator.chronicler.tribunal.actual.clear()
	Arbitrator.chronicler.fleet.stamps.clear()
	status = Bozo.Status.PLAYING_ANIMATION
	Arbitrator.chronicler.tribunal.atheneum.discard_phase.emit()
	Arbitrator.chronicler.fleet.discard_phase.emit()

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
