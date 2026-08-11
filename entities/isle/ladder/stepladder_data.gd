class_name StepladderData
extends RefCounted


signal volume_changed

var settlement: SettlementData

var current_volume: int = 2:
	set(value_):
		current_volume = value_
		volume_changed.emit()


func _init(settlement_: SettlementData) -> void:
	settlement = settlement_

func promote_volume(matter_: Bozo.Matter) -> void:
	current_volume = Digest.volume_to_matter_to_volume[current_volume][matter_]
