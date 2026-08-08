class_name Girder
extends Line2D


var data: GirderData:
	set(value_):
		data = value_
		
		update_points()
		update_colors()


func update_points() -> void:
	var a = Vector2(Digest.volume_to_coord[data.from.volume]) * Catalog.STAIR_SIZE
	var b = Vector2(Digest.volume_to_coord[data.to.volume]) * Catalog.STAIR_SIZE
	var vertexs: Array = [a, b]
	points = vertexs

func update_colors() -> void:
	var color_even = Color(Digest.matter_to_color[data.matter])
	var color_odd = Color(Digest.matter_to_color[data.matter])
	color_even.s = color_even.s - 0.3
	material.set_shader_parameter("color_even", color_even)
	material.set_shader_parameter("color_odd", color_odd)
