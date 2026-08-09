class_name LadderData
extends RefCounted


var stairs: Array[StairData]
var girders: Array[GirderData]

var volume_to_stair: Dictionary

var current_volume: StairData



func _init() -> void:
	init_stairs()
	init_girders()

func init_stairs() -> void:
	for volume in Digest.volume_to_coord:
		var _stair = StairData.new(self, volume)

func init_girders() -> void:
	for volume in Digest.volume_to_matter_to_volume:
		var stair = volume_to_stair[volume]
		
		for matter in Digest.volume_to_matter_to_volume[volume]:
			var _girder = GirderData.new(self, stair, matter)
