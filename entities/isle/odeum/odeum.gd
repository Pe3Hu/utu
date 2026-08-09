class_name Odeum
extends PanelContainer


@export var canto_scene = preload("uid://cos2ewexmv4cg")

var data: OdeumData:
	set(value_):
		data = value_
		
		connect_signals()

var current_canto: Canto


#region init
func connect_signals() -> void:
	data.scenario_changed.connect(_on_scenario_changed)
	_on_scenario_changed()

func _on_scenario_changed() -> void:
	Helper.clear_children(%Cantos)
	
	for canto_data in data.cantos:
		add_canto(canto_data)

func add_canto(canto_data_: CantoData) -> void:
	var canto = canto_scene.instantiate()
	%Cantos.add_child(canto)
	canto.data = canto_data_
	canto.odeum = self
#endregion
