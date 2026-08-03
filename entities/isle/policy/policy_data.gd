class_name PolicyData
extends RefCounted


var isle: IsleData
var factions: Array[FactionData]


func _init(isle_: IsleData) -> void:
	isle = isle_
	
	init_factions()

func init_factions() -> void:
	for faction in Catalog.factions:
		add_faction(faction)

func add_faction(type_: Bozo.Faction) -> void:
	var faction = FactionData.new(self, type_)
	factions.append(faction)
