class_name FlowData
extends RefCounted


var terrain: TerrainData
var coords: Array[Vector2i]


func _init(terrain_: TerrainData, coords_: Array[Vector2i]) -> void:
	if coords_.size() < 2: return
	terrain = terrain_
	coords.append_array(coords_)
	
	terrain.flows.append(self)
	init_channels()

func init_channels() -> void:
	for _i in coords.size() - 1:
		var a = coords[_i]
		var b = coords[_i + 1]
		var channel_coords: Array[Vector2i] = [a, b]
		var _channel = ChannelData.new(self, channel_coords)
