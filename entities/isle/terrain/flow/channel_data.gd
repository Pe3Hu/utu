class_name ChannelData
extends RefCounted


var flow: FlowData
var coords: Array[Vector2i]


func _init(flow_: FlowData, coords_: Array[Vector2i]) -> void:
	flow = flow_
	coords.append_array(coords_)
	
	flow.terrain.channels.append(self)

func get_points() -> Array[Vector2]:
	var points: Array[Vector2]
	
	for coord in coords:
		var point = Vector2(coord) * Catalog.BASTION_SIZE
		points.append(point)
	
	points.reverse()
	return points
