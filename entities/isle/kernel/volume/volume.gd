class_name Volume
extends PanelContainer


@export var number_node: Control

var value: int:
	set(value_):
		value = value_
		
		visible = value > 0
		%Number.frame_coords = Helper.get_coord_based_on_value(value)

var is_active: bool = false:
	set(value_):
		is_active = value_
		var panel = %Border.get_theme_stylebox("panel")
		
		match is_active:
			true:
				panel.border_color = Color.WHITE
			false:
				panel.border_color = Color.BLACK

#var matter: Bozo.Matter = Bozo.Matter.NONE:
	#set(value_):
		#matter = value_
		#
		#var color = Catalog.matter_to_color[matter]
		#%Border.get_theme_stylebox("panel").border_color = color
