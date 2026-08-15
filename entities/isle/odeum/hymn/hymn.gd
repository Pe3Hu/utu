class_name Hymn
extends PanelContainer


@export var canto_scene = preload("uid://cos2ewexmv4cg")

var data: HymnData:
	set(value_):
		data = value_
		init_cantos()

var odeum: Odeum

var active_canto_index: int = 0:
	set(value_):
		var canto: Canto
		if %Cantos.get_child_count() > 0:
			canto = %Cantos.get_child(active_canto_index)
			canto.visible = false
		
		active_canto_index = value_
		canto = %Cantos.get_child(active_canto_index)
		canto.visible = true
		
		if odeum:
			odeum.current_canto = null


#region init
func init_cantos() -> void:
	Helper.clear_children(%Cantos)
	
	if get_node_or_null("%PreviousCanto"):
		%PreviousCanto.visible = data.cantos.size() > 1
		%NextCanto.visible = data.cantos.size() > 1
	
	for canto_data in data.cantos:
		add_canto(canto_data)
	
	active_canto_index = 0

func add_canto(canto_data_: CantoData) -> void:
	var canto = canto_scene.instantiate()
	%Cantos.add_child(canto)
	canto.data = canto_data_
	canto.hymn = self
#endregion


func _on_previous_canto_pressed() -> void:
	active_canto_index = (active_canto_index + 1) % %Cantos.get_child_count()

func _on_next_canto_pressed() -> void:
	active_canto_index = (active_canto_index - 1 + %Cantos.get_child_count()) % %Cantos.get_child_count()
