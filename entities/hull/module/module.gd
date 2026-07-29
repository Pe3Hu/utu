class_name Module
extends TileMapLayer


@export var hull: Hull

var allocation: AllocationData:
	set(value_):
		allocation = value_
		apply_cells()


func apply_cells() -> void:
	set_cells_terrain_connect(allocation.coords, 0, 0, true)
	modulate = Digest.shape_to_color[allocation.orientation.shape.type]
