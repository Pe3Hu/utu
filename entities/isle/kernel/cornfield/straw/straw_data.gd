class_name StrawData
extends RefCounted


signal amount_changed()

var cornfield: CornfieldData
var volume: int
var matter: int
var amount: int:
	set(value_):
		if amount != value_:
			amount = value_
			amount_changed.emit()


func _init(cornfield_: CornfieldData, volume_: int, matter_: int, amount_: int = 0) -> void:
	cornfield = cornfield_
	volume = volume_
	matter = matter_
	amount = amount_
	
	cornfield.straws.append(self)
	
	if volume % Digest.matter_to_factor[matter] == 0:
		cornfield.volume_to_matter_to_cornfield[volume][matter] = self
	else:
		amount = -1
