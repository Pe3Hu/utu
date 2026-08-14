class_name Hymn
extends PanelContainer


@export var canto_scene = preload("uid://cos2ewexmv4cg")

var data: HymnData:
	set(value_):
		data = value_
		init_cantos()

var odeum: Odeum


#region init
func init_cantos() -> void:
	Helper.clear_children(%Cantos)
	
	for canto_data in data.cantos:
		add_canto(canto_data)

func add_canto(canto_data_: CantoData) -> void:
	var canto = canto_scene.instantiate()
	%Cantos.add_child(canto)
	canto.data = canto_data_
	canto.hymn = self
#endregion
