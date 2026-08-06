class_name TribunalData
extends RefCounted


var atheneum: AtheneumData

var hereafter: GyreData = GyreData.new(self, Bozo.Gyre.HEREAFTER)
var actual: GyreData = GyreData.new(self, Bozo.Gyre.ACTUAL)
var bygone: GyreData = GyreData.new(self, Bozo.Gyre.BYGONE)
var gyres: Array[GyreData]


#region init
func _init(atheneum_: AtheneumData) -> void:
	atheneum = atheneum_
	update_gyre_fol()
	update_gyre_ere()
	
	
	gyres = [
		hereafter,
		actual,
		bygone,
	]

func update_gyre_fol() -> void:
	hereafter.fol = actual
	actual.fol = bygone
	bygone.fol = hereafter

func update_gyre_ere() -> void:
	hereafter.ere = bygone
	actual.ere = hereafter
	bygone.ere = actual
#endregion

#region refill
func refill_actual() -> void:
	if hereafter.stamps.is_empty():
		hereafter.ere.clear()
		hereafter.stamps.shuffle()
	
	while actual.stamps.size() < Catalog.GYRE_ACTUAL_STAMP_SIZE:
		hereafter.transfer_stamp()
#endregion
