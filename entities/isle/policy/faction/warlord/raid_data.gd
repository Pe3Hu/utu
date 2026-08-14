class_name RaidData
extends RefCounted


var gambit: GambitData
var bastion: BastionData
var cantos: Array[CantoData]


func _init(gambit_: GambitData, bastion_: BastionData, cantos_: Array) -> void:
	gambit = gambit_
	bastion = bastion_
	cantos.append_array(cantos_)
	
	gambit.raids.append(self)
