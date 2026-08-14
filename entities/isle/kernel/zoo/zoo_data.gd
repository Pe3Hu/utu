class_name ZooData
extends RefCounted


var kernel: KernelData

var enclosures: Array[EnclosureData]
var mount_to_enclosure: Dictionary

var reset_hyena_value: int = 1


#region init
func _init(kernel_: KernelData) -> void:
	kernel = kernel_
	
	init_enclosures()

func init_enclosures() -> void:
	for mount in Catalog.mounts:
		var _enclosure = EnclosureData.new(self, mount)
	
	reset_values()
#endregion

#region update
func update_enclosure_volumes() -> void:
	for mount_type in Catalog.volume_mounts:
		var enclosure = mount_to_enclosure[mount_type]
		enclosure.volume = -1
	
	if kernel.active_ark:
		var volumes = kernel.active_ark.get_best_intro_values()
		
		for _i in volumes.size():
			var mount_type = Catalog.volume_mounts[_i]
			var enclosure = mount_to_enclosure[mount_type]
			enclosure.volume = volumes[_i]
			enclosure.value = kernel.harvest.get_total_volume_amount(enclosure.volume)

func updaet_matter_enclosure(ark_: ArkData, sign_: int = 1) -> void:
	var value = Digest.verse_to_spoil[ark_.stamp.origin.verse.get_sum()] * sign_
	var matter = ark_.stamp.origin.matter
	var mount_type = Digest.matter_to_mount[matter]
	var enclosure = mount_to_enclosure[mount_type]
	enclosure.value += value

func reset_values() -> void:
	for enclosure in enclosures:
		if enclosure.mount == Bozo.Mount.HYENA:
			enclosure.value = reset_hyena_value
		else:
			enclosure.value = 0
#endregion
