class_name DebtData
extends RefCounted


signal current_value_changed

var usurer: UsurerData
var matter: Bozo.Matter

var current_value: int:
	set(value_):
		if current_value != value_:
			current_value = value_
			fine.update_value()
			current_value_changed.emit()
var limit_value: int

var fine: FineData


#region int
func _init(usurer_: UsurerData, matter_: Bozo.Matter) -> void:
	usurer = usurer_
	matter = matter_
	
	fine = FineData.new(self)
	limit_value = Catalog.DEBT_MAX_AMOUNT
	current_value = int(limit_value * 0.5)
	usurer.debts.append(self)
	usurer.matter_to_debt[matter] = self
#endregion

func apply_fine() -> void:
	current_value -= fine.value
