class_name Kernel
extends PanelContainer


@export var volume_scene = preload("uid://dpvkcodr3cjop")

var data: KernelData:
	set(value_):
		data = value_
		connect_datas()
		connect_signals()

@export var isle: Isle
@export var harvest: Cornfield
@export var granary: Cornfield
@export var fleet: Fleet

var activated_volumes: Array[Volume]


#region init
func connect_datas() -> void:
	harvest.data = data.harvest
	granary.data = data.granary
	fleet.data = data.fleet
	
	init_volumes()

func init_volumes() -> void:
	Helper.clear_children(%Volumes)
	
	for volume in Catalog.volumes:
		add_volume(volume)

func add_volume(value_: int) -> void:
	var volume = volume_scene.instantiate()
	%Volumes.add_child(volume)
	volume.value = value_

func connect_signals() -> void:
	data.growth_phase.connect(_on_growth_phase)
	data.stock_phase.connect(_on_stock_phase)

func _on_growth_phase() -> void:
	harvest.update_straw_amounts()

func _on_stock_phase() -> void:
	granary.update_straw_amounts()
	harvest.update_straw_amounts()
#endregion

func activate_volumes(ark_: Ark) -> void:
	for ark_volume in ark_.volumes:
		if ark_volume.visible:
			var index = Catalog.volumes.find(ark_volume.value)
			var active_volume = %Volumes.get_child(index)
			activated_volumes.append(active_volume)
			active_volume.is_active = true
	#for stake in stamp_.type_to_stakes[Bozo.Stake.LEFT]:
	#	var index = B

func deactivate_volumes() -> void:
	for volume in activated_volumes:
		volume.is_active = false
	
	activated_volumes.clear()
