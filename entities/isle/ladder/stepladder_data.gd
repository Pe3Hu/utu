class_name StepladderData
extends RefCounted


signal volume_changed

var ladder: LadderData

var current_volume: int = 2:
	set(value_):
		current_volume = value_
		volume_changed.emit()

func _init() -> void:
	ladder = Helper.ladder
