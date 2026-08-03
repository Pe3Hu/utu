class_name BlobData
extends RefCounted


var flow: FlowData
var coord: Vector2i
var value: int


func _init(flow_: FlowData, coord_: Vector2i, value_: int) -> void:
	flow = flow_
	coord = coord_
	value = value_


func get_bastion() -> BastionData:
	return flow.terrain.coord_to_bastion[coord]

func apply_value() -> void:
	var bastion = get_bastion()
	bastion.reset_ramparts(bastion.current_rampart + value)
	bastion.blob = null
