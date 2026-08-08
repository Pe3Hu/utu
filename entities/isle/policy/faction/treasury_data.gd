class_name TreasuryData
extends RefCounted


var faction: FactionData
var kernel: KernelData = KernelData.new(self)


func _init(faction_: FactionData) -> void:
	faction = faction_
