class_name FineData
extends RefCounted


signal value_changed

var debt: DebtData

var value: int:
	set(value_):
		if value != value_:
			value = value_
			value_changed.emit()


func _init(debt_: DebtData) -> void:
	debt = debt_
	update_value()

func update_value() -> void:
	value = ceil(sqrt(debt.current_value))
