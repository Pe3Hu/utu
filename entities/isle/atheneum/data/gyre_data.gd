class_name GyreData
extends RefCounted


var tribunal: TribunalData
var type: Bozo.Gyre

var fol: GyreData
var ere: GyreData

var stamps: Array[StampData]


func _init(tribunal_: TribunalData, type_: Bozo.Gyre) -> void:
	tribunal = tribunal_
	type = type_

func clear() -> void:
	if type == Bozo.Gyre.HEREAFTER: return
	stamps.shuffle()
	fol.stamps.append_array(stamps)
	stamps.clear()

func transfer_stamp() -> StampData:
	if stamps.is_empty():
		ere.clear()
	
	var stamp = stamps.pop_back()
	fol.stamps.append(stamp)
	return stamp
