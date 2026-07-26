extends Node
class_name GameManager

signal round_started(round_number: int)
signal phase_changed(phase_name: String)
signal game_round_completed

var current_round: int = 0
var current_phase_index: int = 0
var phases: Array[Phase] = []
var current_phase: Phase


func _ready():
	# Инициализация фаз в нужном порядке
	phases = [
		#$PhaseMove,
		#$PhaseAttack,
		#$PhaseDefend
	]
	
	start_new_round()

func start_new_round():
	current_round += 1
	current_phase_index = 0
	round_started.emit(current_round)

func start_next_phase():
	if current_phase_index >= phases.size():
		# Все фазы раунда завершены
		game_round_completed.emit()
		start_new_round()
		return
	
	if current_phase:
		current_phase = phases[current_phase_index]
		current_phase.enter_phase()
		current_phase.phase_completed.connect(_on_phase_completed)
		phase_changed.emit(current_phase.name)

func _on_phase_completed():
	current_phase.phase_completed.disconnect(_on_phase_completed)
	current_phase.exit_phase()
	current_phase_index += 1
	start_next_phase()

func execute_player_action(action_name: String) -> bool:
	if current_phase.try_execute_action(action_name):
		return true
	else:
		print("Действие '%s' недоступно в текущей фазе" % action_name)
		return false
