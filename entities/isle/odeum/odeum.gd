class_name Odeum
extends PanelContainer


@export var canto_scene = preload("uid://cos2ewexmv4cg")

var data: OdeumData:
	set(value_):
		data = value_
		connect_signals()

var current_canto: Canto
var visible_canto_indexs: Array


#region init
func connect_signals() -> void:
	data.scenario_changed.connect(_on_scenario_changed)

func _on_scenario_changed() -> void:
	Helper.clear_children(%Cantos)
	%HBox.visible = !data.cantos.is_empty()
	visible_canto_indexs.clear()
	
	for canto_data in data.cantos:
		add_canto(canto_data)
	
	var n = min(Catalog.VISIBLE_CANTO_MAX, data.cantos.size())
	visible_canto_indexs = range(n)
	update_visible_cantos()

func add_canto(canto_data_: CantoData) -> void:
	var canto = canto_scene.instantiate()
	%Cantos.add_child(canto)
	canto.data = canto_data_
	canto.odeum = self
#endregion

func update_visible_cantos() -> void:
	for index in %Cantos.get_child_count():
		var canto = %Cantos.get_child(index)
		canto.visible = visible_canto_indexs.has(index)
	
	%Buttons.visible = %Cantos.get_child_count() > Catalog.VISIBLE_CANTO_MAX

func _on_next_canto_pressed() -> void:
	var index = visible_canto_indexs.back() + 1
	
	if index == %Cantos.get_child_count():
		index = 0
		var canto = %Cantos.get_child(index)
		index = %Cantos.get_child_count() - 1
		%Cantos.move_child(canto, index)
	else:
		visible_canto_indexs.pop_front()
		visible_canto_indexs.push_back(index)
	
	update_visible_cantos()

func _on_previous_canto_pressed() -> void:
	var index = visible_canto_indexs.front() - 1
	
	if index == -1:
		index = %Cantos.get_child_count() - 1
		var canto = %Cantos.get_child(index)
		index = 0
		%Cantos.move_child(canto, index)
	else:
		visible_canto_indexs.pop_back()
		visible_canto_indexs.push_front(index)
	
	update_visible_cantos()
