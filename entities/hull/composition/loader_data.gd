class_name CompositionLoader
extends RefCounted


func load_compositions(path: String) -> Array[CompositionData]:
	var file = FileAccess.open(path, FileAccess.READ)
	
	if file == null:
		push_error("Cannot open: " + path)
		return []
	
	var json = JSON.parse_string(file.get_as_text())
	file.close()
	
	if json == null:
		push_error("Invalid json")
		return []
	
	var result: Array[CompositionData] = []
	
	for data in json:
		var composition = CompositionData.new()
		composition.allocations = create_allocations(data)
		result.append(composition)
	
	return result

func create_allocations(data: Dictionary) -> Array[AllocationData]:
	var result: Array[AllocationData] = []
	var indexs: Array = data["indexs"]
	var flips: Array = data["flips"]
	var twists: Array = data["twists"]
	var letters: Array = data["letters"]
	
	for i in indexs.size():
		@warning_ignore("integer_division")
		var coord = Vector2i(
			int(indexs[i]) % Catalog.BOARD_SIZE.x,
			int(indexs[i]) / Catalog.BOARD_SIZE.x
		)
		var shape: ShapeData = load("res://entities/hull/composition/shape/data/%s.tres" % letters[i])
		var orientation = OrientationData.new(shape, bool(flips[i]), twists[i])
		var allocation = AllocationData.new(orientation, coord)
		result.append(allocation)
	
	return result
