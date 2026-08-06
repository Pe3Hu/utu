class_name Kernel
extends PanelContainer


@export var volume_scene = preload("uid://dpvkcodr3cjop")

var data: KernelData:
	set(value_):
		data = value_
		connect_datas()

@export var harvest: Cornfield
@export var granary: Cornfield
@export var fleet: Fleet


func connect_datas() -> void:
	harvest.data = data.harvest
	granary.data = data.granary
	fleet.data = data.fleet
	
	init_volumes()

func init_volumes() -> void:
	Helper.clear_children(%Volumes)
	
	for volume in Catalog.volume_values:
		add_volume(volume) 

func add_volume(value_: int) -> void:
	var volume = volume_scene.instantiate()
	%Volumes.add_child(volume)
	volume.value = value_
