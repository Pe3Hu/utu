class_name PhaseGrowth
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.GROWTH

func enter_phase():
	super.enter_phase()
	Arbitrator.chronicler.fleet.kernel.grow_harvest()
	Arbitrator.chronicler.fleet.kernel.growth_phase.emit()
	status = Bozo.Status.PLAYING_ANIMATION

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
