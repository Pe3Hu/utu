class_name PolicyData
extends RefCounted


var isle: IsleData

var factions: Array[FactionData]
var type_to_faction: Dictionary


#region init
func _init(isle_: IsleData) -> void:
	isle = isle_
	
	init_factions()

func init_factions() -> void:
	factions.clear()
	type_to_faction.clear()
	
	for faction in Catalog.factions:
		add_faction(faction)

func add_faction(type_: Bozo.Faction) -> void:
	var faction = FactionData.new(self, type_)
	factions.append(faction)
	type_to_faction[type_] = faction
#endregion
