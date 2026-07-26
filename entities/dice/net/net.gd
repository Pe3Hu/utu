class_name DiceNet
extends ColorRect


@export var cell: DragDropCell

var dice: DiceData:
	set(value_):
		dice = value_
		update_textures()

var roll_duration: float = 1.0
var is_rolling: bool = false
var shift_sequence: Array[int] = []

func update_textures():
	var textures: Array
	
	for _i in dice.values.size():
		var texture = load("res://entities/dice/images/%d.png" % dice.values[_i])
		textures.append(texture)
	
	material.set_shader_parameter("textures", textures)

func init_shift_sequence():
	var shift_count = randi_range(10, 12)
	shift_sequence.clear()
	var current_index = Helper.rng.randi_range(0, dice.values.size())
	var previous_index = current_index
	
	for _i in shift_count:
		var available_neighbors = Catalog.net_neighbors[current_index].duplicate()
		available_neighbors.erase(previous_index)
		
		current_index = available_neighbors[randi() % available_neighbors.size()]
		shift_sequence.append(current_index)
		previous_index = current_index

func start_roll():
	if is_rolling: return
	is_rolling = true
	var step_roll_duration: float = roll_duration / shift_sequence.size()
