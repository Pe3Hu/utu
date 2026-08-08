class_name TuneData
extends RefCounted


var canto: CantoData
var stamp: StampData
var type: Bozo.Tune

var stake: StakeData


func _init(canto_: CantoData, stamp_: StampData, type_: Bozo.Tune) -> void:
	canto = canto_
	stamp = stamp_
	type = type_
	
	stake = stamp.get_stake(canto_.joint, Digest.tune_to_stake[type])
