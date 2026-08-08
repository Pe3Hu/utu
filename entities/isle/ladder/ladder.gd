class_name Ladder
extends Node2D


const stair_scene = preload("uid://dhgdl75u1j75h")
const girder_scene = preload("uid://b8imnf6o57n7v")

var data: LadderData:
	set(value_):
		data = value_
		
		init_stairs()
		init_girders()

#region init
func _ready() -> void:
	data = LadderData.new()
	position = get_parent().size / 2
	position -= Vector2(Catalog.LADDER_SIZE) * Catalog.STAIR_SIZE / 2

func init_stairs() -> void:
	for stair_data in data.stairs:
		add_stair(stair_data)

func add_stair(stair_data_: StairData) -> void:
	var stair = stair_scene.instantiate()
	%Stairs.add_child(stair)
	stair.data = stair_data_

func init_girders() -> void:
	for girder_data in data.girders:
		add_girder(girder_data)

func add_girder(girder_data_: GirderData) -> void:
	var girder = girder_scene.instantiate()
	%Girders.add_child(girder)
	girder.data = girder_data_
#endregion
