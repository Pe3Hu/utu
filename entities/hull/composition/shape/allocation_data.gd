class_name AllocationData
extends RefCounted


var orientation: OrientationData
var anchor: Vector2i
var corner: Vector2i = Vector2i.ZERO:
	set(value_):
		corner = value_
		init_coords()
var twist: int = 0

var coords: Array[Vector2i]


func _init(orientation_: OrientationData, anchor_: Vector2i) -> void:
	orientation = orientation_
	anchor = anchor_
	init_coords()
	
func init_coords() -> void:
	coords.clear()
	
	for _coord in orientation.coords:
		var coord = Helper.apply_twist(_coord, twist) + Helper.apply_acnhor_twist(anchor, twist) + corner
		coords.append(coord)
