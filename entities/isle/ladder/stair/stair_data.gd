class_name StairData
extends RefCounted


var ladder: LadderData
var volume: int

var grider_to_stair: Dictionary


func _init(ladder_: LadderData, volume_: int) -> void:
	ladder = ladder_
	volume = volume_
	
	ladder.stairs.append(self)
	ladder.volume_to_stair[volume] = self
	
