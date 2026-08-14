class_name Odeum
extends PanelContainer


@export var hymn_scene = preload("uid://bb3i0hbvmp0f7")

var data: OdeumData:
	set(value_):
		data = value_
		connect_signals()

var current_canto: Canto
var visible_hymn_indexs: Array


#region init
func connect_signals() -> void:
	data.scenario_changed.connect(_on_scenario_changed)

func _on_scenario_changed() -> void:
	Helper.clear_children(%Hymns)
	visible_hymn_indexs.clear()
	#%HBox.visible = !data.hymns.is_empty()
	
	if data.current_scenario:
		for hymn_data in data.current_scenario.hymns:
			add_hymn(hymn_data)
	
	#var n = min(Catalog.VISIBLE_HYMN_MAX, data.hymns.size())
	#visible_hymn_indexs = range(n)
	#update_visible_hymns()

func add_hymn(hymn_data_: HymnData) -> void:
	var hymn = hymn_scene.instantiate()
	%Hymns.add_child(hymn)
	hymn.data = hymn_data_
	hymn.odeum = self
#endregion

func update_visible_hymns() -> void:
	for index in %Hymns.get_child_count():
		var hymn = %Hymns.get_child(index)
		hymn.visible = visible_hymn_indexs.has(index)
	
	%Buttons.visible = %Hymns.get_child_count() > Catalog.VISIBLE_HYMN_MAX

func _on_next_hymn_pressed() -> void:
	var index = visible_hymn_indexs.back() + 1
	
	if index == %Hymns.get_child_count():
		index = 0
		var hymn = %Hymns.get_child(index)
		index = %Hymns.get_child_count() - 1
		%Hymns.move_child(hymn, index)
	else:
		visible_hymn_indexs.pop_front()
		visible_hymn_indexs.push_back(index)
	
	update_visible_hymns()

func _on_previous_hymn_pressed() -> void:
	var index = visible_hymn_indexs.front() - 1
	
	if index == -1:
		index = %Hymns.get_child_count() - 1
		var hymn = %Hymns.get_child(index)
		index = 0
		%Hymns.move_child(hymn, index)
	else:
		visible_hymn_indexs.pop_back()
		visible_hymn_indexs.push_front(index)
	
	update_visible_hymns()
