class_name Terrain
extends Node2D


@export var bastion_scene = preload("uid://dqu1hfm51no6n")
@export var channel_scene = preload("uid://cak23pqer2rnl")
@export var blob_scene = preload("uid://drx2g8y6cdoeg")
@export var biome_scene = preload("uid://4xkr2nw7mdl3")

@export var isle: Isle

var data: TerrainData:
	set(value_):
		data = value_
		
		init_bastions()
		init_channels()
		init_blobs()
		init_biomes()
		
		connect_signals()

var data_to_bastion: Dictionary


#region init
func _ready() -> void:
	var board_size = (Catalog.BOARD_SIZE * 2  * 0.5 + Vector2.ONE * 0.5) * Catalog.BASTION_SIZE
	position = Vector2(get_parent().size / 2) - (board_size) * scale
	%Channels.position = Vector2(Catalog.BASTION_SIZE) * 0.5

func init_bastions() -> void:
	Helper.clear_children(%Bastions)
	
	for bastion_data in data.bastions:
		add_bastion(bastion_data)

func add_bastion(bastion_data_: BastionData) -> void:
	var bastion = bastion_scene.instantiate()
	%Bastions.add_child(bastion)
	bastion.data = bastion_data_
	bastion.terrain = self
	data_to_bastion[bastion_data_] = bastion

func init_channels() -> void:
	Helper.clear_children(%Channels)
	
	for channel_data in data.channels:
		add_channel(channel_data)

func add_channel(channel_data_: ChannelData) -> void:
	var channel = channel_scene.instantiate()
	%Channels.add_child(channel)
	channel.data = channel_data_

func init_blobs() -> void:
	Helper.clear_children(%Blobs)
	
	for bastion in data.bastions:
		if bastion.blob:
			add_blob(bastion.blob)

func add_blob(blob_data_: BlobData) -> void:
	var blob = blob_scene.instantiate()
	%Blobs.add_child(blob)
	blob.data = blob_data_


func init_biomes() -> void:
	Helper.clear_children(%Biomes)
	
	for biome_data in data.biomes:
		add_biome(biome_data)

func add_biome(biome_data_: BiomeData) -> void:
	var biome = biome_scene.instantiate()
	%Biomes.add_child(biome)
	biome.data = biome_data_

func connect_signals() -> void:
	data.externals_changed.connect(_on_externals_changed)
	_on_externals_changed()

func _on_externals_changed() -> void:
	var faction = isle.data.policy.type_to_faction[Bozo.Faction.BLUE]
	
	for bastion_data in faction.externals:
		var bastion = data_to_bastion[bastion_data]
		bastion.is_external = true
	
	for bastion_data in faction.internals:
		var bastion = data_to_bastion[bastion_data]
		bastion.is_external = false
#endregion

func apply_river_flow() -> void:
	data.apply_blobs()
	init_bastions()
	init_blobs()
	init_channels()


func _input(event) -> void:
	if event is InputEventKey and not event.is_echo() and event.is_pressed():
		match event.keycode:
			KEY_SPACE:
				pass
				#apply_river_flow()
