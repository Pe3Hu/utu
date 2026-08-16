extends Node


signal round_started
signal phase_changed(phase: Bozo.Phase)
signal round_completed

var current_round: int = 0

var factions: Array[FactionData]
var current_faction_index: int
var current_chronicler: ChroniclerData
var player_chronicler: ChroniclerData

var phases: Array[Phase]
var current_phase_index: int = 0
var current_phase: Phase


func _ready() -> void:
	phases = [
		PhaseRecruitment.new(),
		PhaseGrowth.new(),
		PhaseDraw.new(),
		PhaseDecision.new(),
		PhaseStock.new(),
		PhaseDiscard.new(),
		PhaseFusion.new(),
	]

#region round
func start_new_round() -> void:
	current_round += 1
	current_phase_index = 0
	current_faction_index = 0
	print("### ROUND %d ###" % [current_round])
	round_started.emit()
	start_next_chronicler()

func complete_round() -> void:
	round_completed.emit()
	start_new_round()
#endregion

#region phase
func start_next_phase() -> void:
	if Gear.is_pause: return
	
	if current_phase_index >= phases.size():
		complete_chronicler()
		return

	current_phase = phases[current_phase_index]
	current_phase.phase_completed.connect(_on_phase_completed, CONNECT_ONE_SHOT)
	phase_changed.emit(current_phase.type)
	current_phase.enter_phase()

func _on_phase_completed() -> void:
	current_phase.exit_phase()
	current_phase = null
	current_phase_index += 1
	start_next_phase()
#endregion

#region chronicler
func start_next_chronicler() -> void:
	if current_faction_index >= factions.size():
		complete_round()
		return
	
	current_chronicler = factions[current_faction_index].chronicler
	current_chronicler.faction.policy.current_faction = current_chronicler.faction
	current_phase_index = 0
	start_next_phase()

func complete_chronicler() -> void:
	current_faction_index += 1
	start_next_chronicler()
#endregion

func queue_an_animation(tween_: Tween) -> void:
	if not current_phase: return
	current_phase.animation_tweens.append(tween_)
	tween_.finished.connect(current_phase._on_tween_finished.bind(tween_))

func is_player() -> bool:
	return Arbitrator.player_chronicler == Arbitrator.current_chronicler
