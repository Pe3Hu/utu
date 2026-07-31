class_name OrientationData
extends RefCounted


var shape: ShapeData

var is_flipped: bool = false
var twist: int = 0

var coords: Array[Vector2i]


#region init
func _init(shape_: ShapeData, is_flipped_: bool, twist_: int) -> void:
	shape = shape_
	is_flipped = is_flipped_
	twist = twist_
	
	init_coords()

func init_coords() -> void:
	coords.clear()
	var offset: Vector2i = Vector2i(999, 999)
	
	for _coord in shape.coords:
		var coord = Helper.apply_flip(_coord, is_flipped)
		coord = Helper.apply_twist(coord, twist)
		coords.append(coord)
		
		if offset.x > coord.x:
			offset.x = coord.x
		
		if offset.y > coord.y:
			offset.y = coord.y
	
	for _i in coords.size():
		coords[_i] = coords[_i] - offset
#endregion

func get_hash() -> String:
	var sorted = coords.duplicate()
	
	sorted.sort_custom(
		func(a: Vector2i, b: Vector2i) -> bool:
			if a.x == b.x:
				return a.y < b.y

			return a.x < b.x
	)

	var result := ""

	for coord in sorted:
		result += "%d:%d;" % [coord.x, coord.y]

	return result
