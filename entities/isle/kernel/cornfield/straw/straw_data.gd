class_name StrawData
extends RefCounted


signal amount_changed()

var cornfield: CornfieldData
var volume: int
var matter: int
var next_amount: int = 0
var amount: int:
	set(value_):
		if amount != value_:
			amount = value_
			amount_changed.emit()

var expiration_to_amount: Dictionary
var raid_amounts: Array[int]


func _init(cornfield_: CornfieldData, volume_: int, matter_: int, amount_: int = 0) -> void:
	cornfield = cornfield_
	volume = volume_
	matter = matter_
	amount = amount_
	
	cornfield.blank_straws.append(self)
	
	if volume % Digest.matter_to_factor[matter] == 0:
		cornfield.volume_to_matter_to_straw[volume][matter] = self
		cornfield.matter_to_volume_to_straw[matter][volume] = self
		cornfield.straws.append(self)
	else:
		amount = -1

func apply_expiration() -> void:
	var expiration_amount = next_amount - amount
	
	if expiration_amount > 0:
		var max_expiration = Digest.expiration_to_factor[matter]
		expiration_to_amount[max_expiration] = expiration_amount

func apply_raid_amounts() -> void:
	while not raid_amounts.is_empty():
		var raid_amount = raid_amounts.pop_back()
		
		while raid_amount > 0 and not expiration_to_amount.keys().is_empty():
			var expiration_duration = expiration_to_amount.keys().min()
			var expiration_amount = expiration_to_amount[expiration_duration]
			var shift_value = min(raid_amount, expiration_amount)
			raid_amount -= shift_value
			expiration_amount -= shift_value
			next_amount -= shift_value

func wither() -> void:
	if expiration_to_amount.keys().is_empty(): return
	var max_expiration = Digest.expiration_to_factor[matter]
	
	if max_expiration == 0:
		next_amount = 0
		return
	
	var expirations = expiration_to_amount.keys()
	expirations.sort()
	
	for expiration in expirations:
		expiration_to_amount[expiration - 1] = int(expiration_to_amount[expiration])
		expiration_to_amount.erase(expiration)
	
	if expiration_to_amount.has(0):
		next_amount -= expiration_to_amount[0]
		expiration_to_amount.erase(0)
