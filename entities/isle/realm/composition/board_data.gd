class_name BoardData
extends RefCounted


var size: Vector2i = Vector2i(8, 8)

var coord_to_hole: Dictionary = {}
var coord_to_column: Dictionary = {}

var all_coords: Array[Vector2i] = []
var empty_coords: Array[Vector2i] = []


func _init(hole_coords_: Array[Vector2i]) -> void:
	init_coords(hole_coords_)

func init_coords(hole_coords_: Array[Vector2i]) -> void:
	all_coords.clear()
	empty_coords.clear()

	var column: int = 0

	for _y in size.y:
		for _x in size.x:
			var coord = Vector2i(_x, _y)

			coord_to_hole[coord] = coord in hole_coords_

			if coord_to_hole[coord]:
				continue

			all_coords.append(coord)
			coord_to_column[coord] = column

			column += 1

	empty_coords.append_array(all_coords)

func get_valid_anchors(
	orientation_: OrientationData
) -> Array[Vector2i]:
	var anchors: Array[Vector2i] = []

	for coord in all_coords:
		if can_place(orientation_, coord):
			anchors.append(coord)

	return anchors

func can_place(
	orientation_: OrientationData,
	anchor_: Vector2i
) -> bool:
	for local_coord in orientation_.coords:
		var coord = anchor_ + local_coord

		if coord.x < 0 or coord.x >= size.x:
			return false

		if coord.y < 0 or coord.y >= size.y:
			return false

		if coord_to_hole[coord]:
			return false

	return true

func has_hole(coord: Vector2i) -> bool:
	return coord_to_hole.get(coord, false)

func get_column(coord: Vector2i) -> int:
	return coord_to_column[coord]

func get_coord(column: int) -> Vector2i:
	return all_coords[column]
