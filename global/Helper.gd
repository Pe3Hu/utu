extends Node


var rng = RandomNumberGenerator.new()
var ladder: LadderData = LadderData.new()


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

#func get_scenario_result(permutation_: Array) -> int:
	#var intro: CardData
	#var verse: CardData
	#var outro: CardData
	#
	#intro = permutation_[0]
	#
	#if permutation_[1]:
		#verse = permutation_[1]
	#
	#if permutation_[2]:
		#outro = permutation_[2]
	#
	#var result: int = 0
	#
	#if intro:
		#result += intro.intro.result
	#
	#if verse:
		#result += verse.verse.result
		#
		#if !Catalog.pulse_values.has(result):
			#result = -1
			#return result
	#
	#if outro:
		#if outro.outro_bases.has(result):
			#result *= Digest.matter_to_factor[outro.matter]
			#
			#if !Catalog.pulse_values.has(result):
				#result = -1
		#else:
			#result = -1
	#
	#return result

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

func generate_unique_arrangements_fixed_size(arr_: Array, size_: int) -> Array:
	var result_: Array = []
	generate_unique_arrangements(arr_, [], 0, size_, result_)
	return result_

func generate_unique_arrangements(available_: Array, current_: Array, start_index_: int, target_size_: int, result_: Array) -> void:
	if current_.size() == target_size_:
		result_.append(current_.duplicate())
		return
	
	for _i in range(start_index_, available_.size()):
		var element = available_[_i]
		current_.append(element)
		generate_unique_arrangements(available_, current_, _i + 1, target_size_, result_)
		current_.pop_back()
#endregion

#region twist

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
#endregion

func get_matters(value_: int) -> Array[Bozo.Matter]:
	var matters: Array[Bozo.Matter]
	
	for factor in Digest.factor_to_matter:
		if value_ % factor == 0:
			matters.append(Digest.factor_to_matter[factor])
	
	return matters

func get_coord_based_on_value(value_: int, base_: int = 10) -> Vector2i:
	var x = value_ % base_
	@warning_ignore("integer_division")
	var y = floor(value_ / base_)
	return Vector2i(x, y)

func get_direction_from_region_centers(a_: RegionData, b_: RegionData) -> Vector2i:
	var direction = b_.center - a_.center
	
	if abs(direction.x) > abs(direction.y):
		direction.x = sign(direction.x)
		direction.y = 0
	else:
		direction.x = 0
		direction.y = sign(direction.y)
	
	return Vector2i(direction)

func _is_connected(coords_array: Array[Vector2i]) -> bool:
	if coords_array.is_empty():
		return false
	
	var visited = {}
	var stack = [coords_array[0]]
	
	while not stack.is_empty():
		var current = stack.pop_back()
		if current in visited:
			continue
		visited[current] = true
		
		for direction in Catalog.directions:
			var neighbour = current + direction
			if neighbour in coords_array and neighbour not in visited:
				stack.append(neighbour)
	
	return visited.size() == coords_array.size()

func find_all_trios() -> void:
	var aliquots_2 = [2, 4, 6, 8, 10, 12, 18, 20, 30, 32]
	var aliquots_3 = [3, 6, 9, 12, 15, 18, 27, 30]
	var aliquots_5 = [5, 10, 15, 20, 25, 30]
	
	for a in aliquots_2:
		for b in aliquots_3:
			for c in aliquots_5:
				var _sum = a + b + c


#region jugs and cups
func find_optimal_spills(jugs: Array, cups: Array) -> Array:
	var caps = []
	var orig_jug_indices = []
	var initial_full_count: int = 0
	
	for _i in jugs.size():
		var cap = jugs[_i].target_volume - jugs[_i].current_volume
		
		if cap > 0:
			caps.append(cap)
			orig_jug_indices.append(_i)
		else:
			initial_full_count += 1
	
	var m = caps.size()
	var n = cups.size()
	
	var items: Array
	
	for _i in n:
		items.append({ "index": _i, "volume": cups[_i].volume })
	
	items.sort_custom(func(a, b): return a.volume > b.volume)
	
	var suffix_sum = []
	suffix_sum.resize(n + 1)
	suffix_sum[n] = 0
	for i in range(n - 1, -1, -1):
		suffix_sum[i] = suffix_sum[i + 1] + items[i].volume
	
	var greedy_sums: Array = []
	var greedy_assign: Array = []
	for _j in range(m):
		greedy_sums.append(0)
		greedy_assign.append([])
	
	var greedy_full_count: int = initial_full_count
	var greedy_spill: int = 0
	
	for item in items:
		var v: int = item.volume
		var orig_idx: int = item.index
		var best_j: int = -1
		var best_need: int = -1
		for j in range(m):
			if greedy_sums[j] < caps[j]:
				var need: int = caps[j] - greedy_sums[j]
				if need > best_need:
					best_need = need
					best_j = j
		if best_j != -1:
			greedy_sums[best_j] += v
			greedy_assign[best_j].append(orig_idx)
			if greedy_sums[best_j] >= caps[best_j]:
				greedy_full_count += 1
				greedy_spill += greedy_sums[best_j] - caps[best_j]
	
	var best = {
		"full_count": greedy_full_count,
		"spill": greedy_spill,
		"assignment": greedy_assign
	}
	
	var sums: Array = []
	var assign: Array = []
	for _j in range(m):
		sums.append(0)
		assign.append([])
	
	var search_state = {
		"caps": caps,
		"items": items,
		"suffix_sum": suffix_sum,
		"sums": sums,
		"assign": assign,
		"best": best,
		"m": m,
		"n": n,
		"initial_full_count": initial_full_count
	}
	
	var dfs_result = dfs_search(0, initial_full_count, 0, search_state)
	
	var result: Array = []
	for j in range(m):
		if dfs_result.assignment[j].size() > 0:
			result.append({
				"jug": orig_jug_indices[j],
				"cups": dfs_result.assignment[j]
			})
	return result

func dfs_search(idx: int, full_count: int, spill: int, state: Dictionary) -> Dictionary:
	var n: int = state.n
	var m: int = state.m
	var caps: Array = state.caps
	var items: Array = state.items
	var suffix_sum: Array = state.suffix_sum
	var sums: Array = state.sums
	var assign: Array = state.assign
	var best: Dictionary = state.best
	
	if idx == n:
		if full_count > best.full_count or (full_count == best.full_count and spill < best.spill):
			best.full_count = full_count
			best.spill = spill
			best.assignment = []
			for j in range(m):
				best.assignment.append(assign[j].duplicate())
		return best
	
	var remaining_vol: int = suffix_sum[idx]
	var potential_full: int = 0
	for j in range(m):
		if sums[j] < caps[j]:
			if sums[j] + remaining_vol >= caps[j]:
				potential_full += 1
	
	if full_count + potential_full < best.full_count:
		return best
	if full_count + potential_full == best.full_count and spill >= best.spill:
		return best
	
	var v: int = items[idx].volume
	var orig_idx: int = items[idx].index
	
	dfs_search(idx + 1, full_count, spill, state)
	
	for j in range(m):
		if sums[j] < caps[j]:
			var need: int = caps[j] - sums[j]
			var new_spill: int = spill + max(0, v - need)
			var new_full_count: int = full_count + (1 if sums[j] + v >= caps[j] else 0)
			
			sums[j] += v
			assign[j].append(orig_idx)
			
			dfs_search(idx + 1, new_full_count, new_spill, state)
			
			assign[j].pop_back()
			sums[j] -= v
	
	return best
#endregion
