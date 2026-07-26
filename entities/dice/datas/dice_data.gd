class_name DiceData
extends Resource


@export var values: Array[int] 

var result: int


#region init
func _init() -> void:
	pass

func init_values() -> void:
	pass
#endregion

func roll_result() -> void:
	result = values.pick_random()

func get_value(index_: int) -> int:
	return values[index_]
