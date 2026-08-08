class_name Cornfield
extends GridContainer


@export var straw_scene = preload("uid://c7bwpx4fodib7")

var data: CornfieldData:
	set(value_):
		data = value_
		
		init_straws()

var data_to_straw: Dictionary


#region init
func init_straws() -> void:
	data_to_straw.clear()
	Helper.clear_children(self)
	
	for straw_data in data.blank_straws:
		add_straw(straw_data)

func add_straw(straw_data_: StrawData) -> void:
	var straw = straw_scene.instantiate()
	add_child(straw)
	straw.data = straw_data_
	data_to_straw[straw_data_] = straw
#endregion

func update_straw_amounts(with_animation_: bool = true) -> void:
	for straw in get_children():
		straw.update_amount(with_animation_) 
