class_name Odeum
extends PanelContainer


@export var hymn_scene = preload("uid://bb3i0hbvmp0f7")

var data: OdeumData:
	set(value_):
		data = value_
		connect_signals()

var current_canto: Canto:
	set(value_):
		if value_ != current_canto:
			if current_canto:
				current_canto.is_selected = false
			
			current_canto = value_
			
			if current_canto:
				current_canto.is_selected = true



#region init
func connect_signals() -> void:
	data.scenario_changed.connect(_on_scenario_changed)

func _on_scenario_changed() -> void:
	Helper.clear_children(%Hymns)
	
	if data.current_scenario:
		for hymn_data in data.current_scenario.hymns:
			add_hymn(hymn_data)

func add_hymn(hymn_data_: HymnData) -> void:
	var hymn = hymn_scene.instantiate()
	%Hymns.add_child(hymn)
	hymn.data = hymn_data_
	hymn.odeum = self
#endregion
