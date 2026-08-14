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

func put_ark_into_actual() -> void:
	for ark in arks:
		var stamp = ark.stamp
		
		if not kernel.faction.atheneum.tribunal.actual.stamps.has(stamp):
			kernel.faction.atheneum.tribunal.actual.stamps.append(stamp)
	
	arks.clear()
