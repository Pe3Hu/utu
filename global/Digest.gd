extends Node



var shape_to_color: Dictionary


func _init() -> void:
	init_shape_colors()

func init_shape_colors() -> void:
	shape_to_color.clear()
	var h: float = 0.0
	var s: float = 1.0
	var v: float = 1.0
	
	for shape in Catalog.shapes:
		shape_to_color[shape] = Color.from_hsv(h, s, v)
		h += 1.0 / Catalog.shapes.size()
