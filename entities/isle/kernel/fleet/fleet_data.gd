class_name FleetData
extends RefCounted


@warning_ignore("unused_signal")
signal draw_phase
@warning_ignore("unused_signal")
signal discard_phase


var kernel: KernelData

var arks: Array[ArkData]


func _init(kernel_: KernelData) -> void:
	kernel = kernel_ 

func init_arks(stamps_: Array[StampData]) -> void:
	for stamp in stamps_:
		var _ark = ArkData.new(self, stamp)
