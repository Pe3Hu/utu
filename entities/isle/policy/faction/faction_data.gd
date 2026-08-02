class_name FactionData
extends RefCounted


var policy: PolicyData
var type: Bozo.Faction

var current_order: int = 0
var shrines: Array[BastionData]


func _init(policy_: PolicyData, type_: Bozo.Faction) -> void:
	policy = policy_
	type = type_
