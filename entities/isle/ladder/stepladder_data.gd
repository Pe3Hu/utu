class_name StepladderData
extends RefCounted


signal volume_changed

var settlement: SettlementData

var current_volume: int = 3:
	set(value_):
		current_volume = value_
		volume_changed.emit()


func _init(settlement_: SettlementData) -> void:
	settlement = settlement_
