extends Node


var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()

func clear_children(parent_: Node) -> void:
	while parent_.get_child_count() > 0:
		var child = parent_.get_child(0)
		parent_.remove_child(child)
		child.queue_free()

func get_random_key(dict_: Dictionary):
	if dict_.is_empty():
		push_error("empty dictionary in get_random_key")
		return null
	
	var keys = dict_.keys()
	var total := 0.0
	
	for key in keys:
		total += dict_[key]
	
	if total <= 0:
		return null
	
	var r := rng.randf() * total
	var cumulative := 0.0
	
	for key in keys:
		cumulative += dict_[key]
		if r < cumulative:
			return key
	
	push_error("random selection failed")

#region permutation
func generate_permutations(arr_: Array) -> Array:
	var result: Array
	permute(arr_, 0, result)
	return result

func permute(arr_: Array, start_: int, result_: Array) -> void:
	if start_ == arr_.size() - 1:
		result_.append(arr_.duplicate())
		return
	
	for i in range(start_, arr_.size()):
		var temp = arr_[start_]
		arr_[start_] = arr_[i]
		arr_[i] = temp
		
		permute(arr_, start_ + 1, result_)
		
		temp = arr_[start_]
		arr_[start_] = arr_[i]
		arr_[i] = temp
#endregion

func get_scenario_result(permutation_: Array) -> int:
	var intro: Card
	var verse: Card
	var outro: Card
	
	intro = permutation_[0].card
	
	if permutation_[1]:
		verse = permutation_[1].card
	
	if permutation_[2]:
		outro = permutation_[2].card
	
	var result: int = 0
	
	if intro:
		result += intro.intro.cell.value
	
	if verse:
		result += verse.verse.cell.value
		
		if !Catalog.pulse_values.has(result):
			result = -1
			return result
	
	if outro:
		if outro.outro.bases.has(result):
			result *= outro.outro.cell.value
			
			if !Catalog.pulse_values.has(result):
				result = -1
		else:
			result = -1
	
	return result

#region arrangement
func generate_arrangements_fixed_size(arr_: Array, size_: int) -> Array:
	var result_: Array = []
	generate_arrangements(arr_, [], size_, result_)
	return result_

func generate_arrangements(available_: Array, current_: Array, target_size_: int, result_: Array) -> void:
	if current_.size() == target_size_:
		result_.append(current_.duplicate())
		return
	
	for _i in available_.size():
		var element = available_[_i]
		var new_available = available_.duplicate()
		new_available.remove_at(_i)
		current_.append(element)
		
		generate_arrangements(new_available, current_, target_size_, result_)
		current_.pop_back()
#endregion


func apply_flip(coord_: Vector2i, is_flipped_: bool) -> Vector2i:
	if not is_flipped_: return coord_
	return Vector2i(-coord_.x, coord_.y)

func apply_twist(coord_: Vector2i, twist_: int) -> Vector2i:
	if twist_ == 0: return coord_
	var angle = PI / 2 * twist_
	var rotated_coord = Vector2(coord_).rotated(angle).round()
	return Vector2i(rotated_coord)


func apply_acnhor_twist(coord_: Vector2i, twist_: int) -> Vector2i:
	if twist_ == 0: return coord_
	var a = Vector2i(coord_)
	var b = Vector2i(coord_)
	
	for _i in twist_:
		b = Vector2i(Catalog.BOARD_SIZE.y - 1 - a.y, a.x)
		a = Vector2i(b)
	
	return b
