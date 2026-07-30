class_name PartitionSolver
extends RefCounted



func solve(domains_: Array[DomainData], size_: int) -> Array:
	var unused = {}
	
	for domain in domains_:
		unused[domain] = true
	
	return search([], unused, size_)

func search(groups_: Array, unused_: Dictionary, size_: int) -> Array:
	if unused_.is_empty(): return groups_
	
	var _seed = choose_seed(unused_)
	var candidates = build_groups(_seed, unused_, size_)
	candidates.shuffle()
	
	for group in candidates:
		var next_unused = unused_.duplicate()
		
		for d in group:
			next_unused.erase(d)
		
		if is_valid_state(next_unused, size_):
			var result = search(groups_ + [group], next_unused, size_)
			
			if result: return result
	
	return []

func choose_seed(unused_: Dictionary) -> DomainData:
	var best = null
	var best_count = INF
	
	for domain in unused_:
		var count = 0
		
		for neighbour in domain.neighbours:
			if unused_.has(neighbour):
				count += 1
		
		if count < best_count:
			best_count = count
			best = domain
	
	return best

func build_groups(seed_: DomainData, unused_: Dictionary, size_: int) -> Array:
	var result = []
	var current = [seed_]
	grow(current, unused_, size_, result)
	return result

func grow(group: Array, unused_: Dictionary, size_: int, result_: Array) -> void:
	if group.size() == size_:
		result_.append(group.duplicate())
		return
	
	var frontier = {}
	
	for domain in group:
		for neighbour in domain.neighbours:
			if unused_.has(neighbour):
				frontier[neighbour] = true
	
	for next in frontier:
		if group.has(next): continue
		
		group.append(next)
		grow(group, unused_, size_, result_)
		group.pop_back()

func is_valid_state(unused_: Dictionary, size_: int) -> bool:
	var components = get_components(unused_)
	
	for component in components:
		if component.size() % size_ != 0:
			return false
	
	return true

func get_components(available_: Dictionary) -> Array:
	var result: Array = []
	var visited = {}
	
	for domain: DomainData in available_.keys():
		if visited.has(domain): continue
		result.append(get_component(domain, available_, visited))
	
	return result

func get_component(start_: DomainData, available_: Dictionary, visited_: Dictionary) -> Array[DomainData]:
	var result: Array[DomainData] = []
	var queue: Array[DomainData] = [start_]
	visited_[start_] = true
	
	while !queue.is_empty():
		var current: DomainData = queue.pop_front()
		result.append(current)
		
		for neighbour in current.neighbours:
			if !available_.has(neighbour): continue
			if visited_.has(neighbour): continue
			visited_[neighbour] = true
			queue.append(neighbour)
	
	return result
