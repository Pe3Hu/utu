class_name ChannelData
extends RefCounted


var flow: FlowData
var coords: Array[Vector2i]


#region init
func _init(flow_: FlowData, coords_: Array[Vector2i]) -> void:
	flow = flow_
	coords.append_array(coords_)
	
	flow.terrain.channels.append(self)
	update_neighbours()

func update_neighbours() -> void:
	var a = flow.terrain.coord_to_bastion[coords.front()]
	var b = flow.terrain.coord_to_bastion[coords.back()]
	a.neighbour_to_channel[b] = self
	b.neighbour_to_channel[a] = self
#endregion

func get_points() -> Array[Vector2]:
	var points: Array[Vector2]
	
	for coord in coords:
		var point = Vector2(coord) * Catalog.BASTION_SIZE
		points.append(point)
	
	points.reverse()
	return points
