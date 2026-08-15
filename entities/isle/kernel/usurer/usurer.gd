class_name Usurer
extends PanelContainer


var data: UsurerData:
	set(value_):
		data = value_
		connect_datas()

@export var kernel: Kernel

@export var gas: Debt
@export var liquid: Debt
@export var solid: Debt


func connect_datas() -> void:
	gas.data = data.matter_to_debt[Bozo.Matter.GAS]
	liquid.data = data.matter_to_debt[Bozo.Matter.LIQUID]
	solid.data = data.matter_to_debt[Bozo.Matter.SOLID]
