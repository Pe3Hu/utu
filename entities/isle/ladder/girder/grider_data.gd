class_name GirderData
extends RefCounted


var ladder: LadderData
var matter: Bozo.Matter

var from: StairData
var to: StairData


func _init(ladder_: LadderData, from_: StairData, matter_: Bozo.Matter) -> void:
	ladder = ladder_
	from = from_
	matter = matter_
	
	ladder.girders.append(self)
	
	var to_volume = Digest.volume_to_matter_to_volume[from_.volume][matter]
	to = ladder.volume_to_stair[to_volume]
	from_.grider_to_stair[self] = to
