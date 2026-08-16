class_name ChroniclerData
extends RefCounted


var faction: FactionData
var tribunal: TribunalData
var fleet: FleetData


func _init(faction_: FactionData) -> void:
	faction = faction_
	tribunal = faction.atheneum.tribunal
	fleet = faction.kernel.fleet
