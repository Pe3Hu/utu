class_name ArkData
extends RefCounted


var fleet: FleetData
var stamp: StampData


func _init(fleet_: FleetData, stamp_: StampData) -> void:
	fleet = fleet_
	stamp = stamp_
	
	fleet.arks.append(self)

func get_best_intro_values() -> Array[int]:
	var values: Array[int]
	
	for stake in stamp.tune_to_stakes[Bozo.Tune.INTRO]:
		if not values.has(stake.value) and stake.value > 0:
			values.append(stake.value)
   
	return values
