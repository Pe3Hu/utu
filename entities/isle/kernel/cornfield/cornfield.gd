class_name Cornfield
extends GridContainer


@export var straw_scene = preload("uid://c7bwpx4fodib7")

var data: CornfieldData:
	set(value_):
		data = value_
		
		init_straws()


#region init
func init_straws() -> void:
	Helper.clear_children(self)
	
	for straw_data in data.straws:
		add_straw(straw_data)

func add_straw(straw_data_: StrawData) -> void:
	var straw = straw_scene.instantiate()
	add_child(straw)
	straw.data = straw_data_
#endregion
