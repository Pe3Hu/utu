class_name UsurerData
extends RefCounted


var kernel: KernelData

var debts: Array[DebtData]
var matter_to_debt: Dictionary


func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_debts()

func init_debts() -> void:
	for matter in Catalog.matters:
		var _debt = DebtData.new(self, matter)
