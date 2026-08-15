class_name PolicyData
extends RefCounted


var isle: IsleData

var factions: Array[FactionData]

var player_faction: FactionData
var current_faction: FactionData


#region init
func _init(isle_: IsleData) -> void:
	isle = isle_
	
	init_factions()

func init_factions() -> void:
	factions.clear()
	var _faction = FactionData.new(self)
	
	for region in Catalog.shrine_regions:
		for corner in Catalog.corners:
			_faction = FactionData.new(self, region, corner, true)
	
	_faction = FactionData.new(self, Bozo.Region.CENTER, Catalog.corners[0], true)
	_faction = FactionData.new(self, Bozo.Region.CENTER, Catalog.corners[2], true)
	
	player_faction = factions[1]
	current_faction = player_faction
	var passive_faction = factions.front()
	
	for bastion in isle.terrain.bastions:
		if bastion.faction == null:
			passive_faction.capture_bastion(bastion)

#endregion
