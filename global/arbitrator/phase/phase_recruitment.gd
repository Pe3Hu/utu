class_name PhaseRecruitment
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.RECRUITMENT

func enter_phase():
	super.enter_phase()
	
	if Catalog.STAMPS_LIMIT_FOR_RECRUITMENT <= Arbitrator.current_chronicler.tribunal.get_remaining_amount():
		Arbitrator.current_chronicler.tribunal.atheneum.recruiment_phase()
	#Arbitrator.current_chronicler.tribunal.refill_actual()
	#Arbitrator.current_chronicler.fleet.init_arks(Arbitrator.current_chronicler.tribunal.actual.stamps)
	#Arbitrator.current_chronicler.tribunal.atheneum.init_scenarios()
	#status = Bozo.Status.PLAYING_ANIMATION
	#Arbitrator.current_chronicler.tribunal.atheneum.draw_phase.emit()
	#Arbitrator.current_chronicler.fleet.draw_phase.emit()
	exit_phase()
