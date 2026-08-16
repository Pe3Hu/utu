class_name PhaseDiscard
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DISCARD

func enter_phase():
	super.enter_phase()
	update_forge_stamps()
	Arbitrator.current_chronicler.faction.odeum.current_scenario = null
	
	Arbitrator.current_chronicler.fleet.put_ark_into_actual()
	Arbitrator.current_chronicler.tribunal.actual.clear()
	
	if Arbitrator.is_player():
		Arbitrator.current_chronicler.tribunal.atheneum.discard_phase.emit()
		Arbitrator.current_chronicler.fleet.discard_phase.emit()
	else:
		exit_phase()
	

func update_forge_stamps() -> void:
	var forge_stamps: Array[StampData]
	#forge_stamps.append_array(Arbitrator.current_chronicler.tribunal.actual.stamps)
	
	for ark in Arbitrator.current_chronicler.fleet.arks:
		forge_stamps.append(ark.stamp)
	
	Arbitrator.current_chronicler.faction.policy.isle.forge.stamps = forge_stamps

func _on_all_animations_finished() -> void:
	super._on_all_animations_finished()
	status = Bozo.Status.IDLE
	exit_phase()
