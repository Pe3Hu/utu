@tool
class_name Volume
extends PanelContainer


var value: int:
	set(value_):
		value = value_
		
		visible = value > 0
		%Number.frame_coords = Helper.get_coord_based_on_value(value)

@export var is_active: bool = false:
	set(value_):
		is_active = value_
		update_color()
		
		if is_active:
			z_index = 1
		else:
			z_index = 0

@export var matter: Bozo.Matter = Bozo.Matter.NONE:
	set(value_):
		matter = value_
		update_color()

@export var number_node: Control


func update_color() -> void:
	if not get_node_or_null("%Border"): return
	var panel = %Border.get_theme_stylebox("panel")
	var color: Color
	
	match is_active:
		true:
			color = Digest.matter_to_color[matter]
		false:
			color = Color.BLACK
	
	panel.border_color = color
