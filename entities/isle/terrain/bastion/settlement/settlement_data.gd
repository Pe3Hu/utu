class_name SettlementData
extends RefCounted


var bastion: BastionData
var stepladder: StepladderData



func _init(bastion_: BastionData) -> void:
	bastion = bastion_
	
	stepladder = StepladderData.new(self)
