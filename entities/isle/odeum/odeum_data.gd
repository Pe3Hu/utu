class_name OdeumData
extends RefCounted


signal scenario_changed

var faction: FactionData

var current_scenario: ScenarioData:
	set(value_):
		current_scenario = value_
		scenario_changed.emit()


func _init(faction_: FactionData) -> void:
	faction = faction_
