class_name CompositionData
extends Resource


var allocations: Array[AllocationData]


func _init(allocations_: Array[AllocationData] = []) -> void:
	allocations = allocations_

func get_data() -> Dictionary:
	var indexs: Array[int]
	var flips: Array[int]
	var twists: Array[int]
	var letters: Array[String]
	
	for allocation in allocations:
		var index = Catalog.BOARD_SIZE.x * allocation.anchor.y + allocation.anchor.x
		indexs.append(index)
		var flip = int(allocation.orientation.is_flipped)
		flips.append(flip)
		var twist = allocation.orientation.twist
		twists.append(twist)
		var letter = Bozo.shape_to_string[allocation.orientation.shape.type]
		letters.append(letter)
	
	return {
		"indexs": indexs,
		"flips": flips,
		"twists": twists,
		"letters": letters,
	}
