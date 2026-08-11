extends Node


signal round_started(round_number: int)
signal phase_changed(phase: Bozo.Phase)
signal round_completed

var chronicler: ChroniclerData:
	set(value_):
		chronicler = value_
		start_new_round()

var phases: Array[Phase] = []

var current_phase_index: int = 0
var current_phase: Phase


func _ready() -> void:
	phases = [
		PhaseGrowth.new(),
		PhaseDraw.new(),
		PhaseDecision.new(),
		PhaseStock.new(),
		PhaseDiscard.new(),
		PhaseFusion.new(),
		#CleanupPhase.new(),
	]

func start_new_round() -> void:
	chronicler.current_round += 1
	current_phase_index = 0
	round_started.emit(chronicler.current_round)
	start_next_phase()

func start_next_phase() -> void:
	if current_phase_index >= phases.size():
		complete_round()
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

func complete_round() -> void:
	round_completed.emit()
	start_new_round()

func queue_an_animation(tween_: Tween) -> void:
	if not current_phase: return
	current_phase.animation_tweens.append(tween_)
	tween_.finished.connect(current_phase._on_tween_finished.bind(tween_))
