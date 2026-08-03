class_name FlowData
extends RefCounted


var terrain: TerrainData
var coords: Array[Vector2i]
var blobs: Array[BlobData]


func _init(terrain_: TerrainData, coords_: Array[Vector2i]) -> void:
	terrain = terrain_
	coords.append_array(coords_)
	if not check_conditions(): return
	
	terrain.flows.append(self)
	init_channels()
	init_blobs()

func check_conditions() -> bool:
	if coords.size() < 3: return false
	
	var a = terrain.coord_to_bastion[coords[0]]
	var b = terrain.coord_to_bastion[coords[1]]
	if a.neighbour_to_channel.has(b): 
		return false
	
	return true

func init_channels() -> void:
	for _i in coords.size() - 1:
		var a = coords[_i]
		var b = coords[_i + 1]
		var channel_coords: Array[Vector2i] = [a, b]
		var _channel = ChannelData.new(self, channel_coords)

func init_blobs() -> void:
	blobs.clear()
	var l = coords.size() - 1
	var values = [-l, l]
	var indexs = [0, l]
	
	for _i in values.size():
		var value = values[_i]
		var index = indexs[_i]
		var coord = coords[index]
		var bastion = terrain.coord_to_bastion[coord]
		
		if bastion.blob != null:
			bastion.blob.value += value
			
		else:
			bastion.blob = BlobData.new(self, coord, value)
		
		blobs.append(bastion.blob)
