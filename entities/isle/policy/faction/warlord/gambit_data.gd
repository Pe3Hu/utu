class_name GambitData
extends RefCounted


var warlord: WarlordData
var foothold: Bastion
var direction: Vector2i
var depth: int

var raids: Array[RaidData]



func _init(warlord_: WarlordData, foothold_: Bastion, direction_: Vector2i, depth_: int) -> void:
	warlord = warlord_
	foothold = foothold_
	direction = direction_
	depth = depth_
	
	if is_it_possible():
		warlord.gambits.append(self)
	else:
		raids.clear()
	
	if not raids.is_empty():
		warlord.gambits.append(self)
		
		if not warlord.length_to_gambits.has(raids.size()):
			warlord.length_to_gambits[raids.size()] = []
		
		warlord.length_to_gambits[raids.size()].append(self)


func is_it_possible() -> bool:
	var cantos = warlord.faction.odeum.cantos.duplicate()
	var bastions = []
	
	
	return fasle
