class_name CornfieldData
extends RefCounted


var kernel: KernelData

var volume_to_matter_to_straw: Dictionary
var blank_straws: Array[StrawData]
var straws: Array[StrawData]


func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_volumes()

func init_volumes() -> void:
	for volume in Catalog.volumes:
		volume_to_matter_to_straw[volume] = {}
	
	for matter in Catalog.matters:
		for volume in Catalog.volumes:
			var _straw = StrawData.new(self, volume, matter)
