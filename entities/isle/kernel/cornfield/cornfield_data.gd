class_name CornfieldData
extends RefCounted


var kernel: KernelData

var volume_to_matter_to_straw: Dictionary
var matter_to_volume_to_straw: Dictionary

var blank_straws: Array[StrawData]
var straws: Array[StrawData]


#region init
func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_volumes()

func init_volumes() -> void:
	for volume in Catalog.volumes:
		volume_to_matter_to_straw[volume] = {}
	
	for matter in Catalog.matters:
		matter_to_volume_to_straw[matter] = {}
	
	for matter in Catalog.matters:
		for volume in Catalog.volumes:
			var _straw = StrawData.new(self, volume, matter)
#endregion

func get_total_volume_amount(volume_: int) -> int:
	var amount: int = 0
	
	for matter in volume_to_matter_to_straw[volume_]:
		var straw = volume_to_matter_to_straw[volume_][matter]
		amount += straw.amount
	
	return amount

func apply_raid_amounts() -> void:
	for straw in straws:
		straw.apply_raid_amounts()

func wither() -> void:
	for straw in straws:
		straw.wither()

func is_available(volume_: int, amount_: int = 1, matter_: Bozo.Matter = Bozo.Matter.ANY) -> bool:
	if not volume_to_matter_to_straw.has(volume_): return false
	var available_amount = 0
	
	for matter in volume_to_matter_to_straw[volume_]:
		if matter_ == Bozo.Matter.ANY or matter == matter_:
			var straw = volume_to_matter_to_straw[volume_][matter]
			available_amount += straw.amount
	
	return amount_ <= available_amount
