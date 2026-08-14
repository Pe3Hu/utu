class_name PhaseRecruitment
extends Phase



func _init() -> void:
	super._init()
	type = Bozo.Phase.RECRUITMENT

func enter_phase():
	super.enter_phase()
	
	if Catalog.STAMPS_LIMIT_FOR_RECRUITMENT <= Arbitrator.chronicler.tribunal.get_remaining_amount():
		Arbitrator.chronicler.tribunal.atheneum.recruiment_phase()
	#Arbitrator.chronicler.tribunal.refill_actual()
	#Arbitrator.chronicler.fleet.init_arks(Arbitrator.chronicler.tribunal.actual.stamps)
	#Arbitrator.chronicler.tribunal.atheneum.init_scenarios()
	#status = Bozo.Status.PLAYING_ANIMATION
	#Arbitrator.chronicler.tribunal.atheneum.draw_phase.emit()
	#Arbitrator.chronicler.fleet.draw_phase.emit()
	exit_phase()
