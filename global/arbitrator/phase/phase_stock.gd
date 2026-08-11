class_name PhaseStock
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.STOCK

func enter_phase():
	super.enter_phase()
	print("enter Stock")
	Arbitrator.chronicler.fleet.kernel.stock_granary()
	Arbitrator.chronicler.fleet.kernel.stock_phase.emit()
	status = Bozo.Status.PLAYING_ANIMATION

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
