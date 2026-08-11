class_name FleetData
extends RefCounted


@warning_ignore("unused_signal")
signal draw_phase
@warning_ignore("unused_signal")
signal discard_phase


var kernel: KernelData

var stamps: Array[StampData]


func _init(kernel_: KernelData) -> void:
	kernel = kernel_ 
