class_name FleetData
extends RefCounted


var kernel: KernelData

var stamps: Array[StampData]


func _init(kernel_: KernelData) -> void:
	kernel = kernel_ 
