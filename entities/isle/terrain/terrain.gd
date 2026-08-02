class_name Terrain
extends Node2D


@export var bastion_scene = preload("uid://dqu1hfm51no6n")
@export var channel_scene = preload("uid://cak23pqer2rnl")

@export var isle: Isle

var data: TerrainData:
	set(value_):
		data = value_
		
		init_bastions()
		init_channels()

var data_to_bastion: Dictionary


#region init
func _ready() -> void:
	var board_size = (Catalog.BOARD_SIZE * 2  * 0.5 + Vector2.ONE * 0.5) * Catalog.BASTION_SIZE
	position = Vector2(get_parent().size / 2) - (board_size) * scale
	%Channels.position = Vector2(Catalog.BASTION_SIZE) * 0.5

func init_bastions() -> void:
	for bastion_data in data.bastions:
		add_bastion(bastion_data)

func add_bastion(bastion_data_: BastionData) -> void:
	var bastion = bastion_scene.instantiate()
	%Bastions.add_child(bastion)
	bastion.data = bastion_data_

func init_channels() -> void:
	for channel_data in data.channels:
		add_channel(channel_data)

func add_channel(channel_data_: ChannelData) -> void:
	var channel = channel_scene.instantiate()
	%Channels.add_child(channel)
	channel.data = channel_data_
#endregion
