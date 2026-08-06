class_name CornfieldData
extends RefCounted


var kernel: KernelData
var volume_to_matter_to_cornfield: Dictionary
var straws: Array[StrawData]


func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_volumes()

func init_volumes() -> void:
	for volume in Catalog.volume_values:
		volume_to_matter_to_cornfield[volume] = {}
	
	for matter in Catalog.matters:
		for volume in Catalog.volume_values:
			var _straw = StrawData.new(self, volume, matter)
