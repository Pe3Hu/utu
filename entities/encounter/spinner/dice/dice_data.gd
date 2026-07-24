class_name DiceData
extends Resource


@export var values: Array[int] 

var matter: Bozo.Matter:
	set(value_):
		matter = value_
		init_values()

var result: int


#region init
func _init() -> void:
	pass

func init_values() -> void:
	var matter_string = Bozo.enum_to_string(Bozo.Type.MATTER, matter)
	var source = load("res://entities/cylinder/dice/%s.tres" % matter_string)
	values.append_array(source.values)
	values.shuffle()
#endregion

func roll_result() -> void:
	result = values.pick_random()

func get_value(index_: int) -> int:
	return values[index_]
