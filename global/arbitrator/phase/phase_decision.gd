class_name PhaseDecision
extends Phase


func _init() -> void:
	super._init()
	type = Bozo.Phase.DECISION

func enter_phase():
	Arbitrator.current_chronicler.faction.warlord.init_gambits()
	
	if Gear.is_auto_play:
		Arbitrator.current_chronicler.faction.warlord.simulate_gambit_choice()
		exit_phase()
