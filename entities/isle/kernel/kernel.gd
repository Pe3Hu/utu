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
@export var zoo: Zoo
@export var usurer: Usurer

var active_ark: Ark:
	set(value_):
		switch_volumes(false)#deactivate_volumes()
		active_ark = value_
		
		if active_ark:
			data.active_ark = active_ark.data
		else:
			data.active_ark = null
		
		switch_volumes(true)#activate_volumes()


#region init
func connect_datas() -> void:
	harvest.data = data.harvest
	granary.data = data.granary
	fleet.data = data.fleet
	zoo.data = data.zoo
	usurer.data = data.usurer
	
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
	
	if active_ark:
		active_ark = null
	
	zoo.reset()
#endregion

func switch_volumes(flag_: bool = true) -> void:
	if active_ark:
		for ark_volume in active_ark.volumes:
			if ark_volume.visible:
				var index = Catalog.volumes.find(ark_volume.value)
				var active_volume = %Volumes.get_child(index)
				active_volume.is_active = flag_
