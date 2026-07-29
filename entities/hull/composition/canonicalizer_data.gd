class_name SolutionCanonicalizer
extends RefCounted


var collector: CollectorData


func _init(collector_: CollectorData) -> void:
	collector = collector_

func get_hash(solution: Array[AllocationData]) -> String:
	var grid := create_grid(solution)

	var hashes: Array[String] = []

	for variant in get_symmetries(grid):
		hashes.append(
			grid_hash(variant)
		)

	hashes.sort()

	return hashes[0]


func create_grid(
	solution: Array[AllocationData]
) -> Array:
	var grid: Array = []

	for _y in collector.coverage.board.size.y:
		grid.append([])

		for _x in collector.coverage.board.size.x:
			grid[_y].append(-1)

	for _i in solution.size():
		var allocation = solution[_i]

		for local in allocation.orientation.coords:
			var world = allocation.anchor + local

			grid[world.y][world.x] = int(allocation.orientation.shape.type)

	return grid


func get_symmetries(
	grid: Array
) -> Array:
	var result := []

	var current = grid

	for i in 4:
		result.append(current)
		result.append(flip_horizontal(current))

		current = rotate90(current)

	return result


func rotate90(
	grid: Array
) -> Array:
	var result := []

	for _y in collector.coverage.board.size.y:
		result.append([])

	for _y in collector.coverage.board.size.y:
		for _x in collector.coverage.board.size.x:
			result[_y].append(
				grid[collector.coverage.board.size.x - _x - 1][_y]
			)

	return result


func flip_horizontal(
	grid: Array
) -> Array:
	var result := []

	for _y in collector.coverage.board.size.y:
		result.append(
			grid[_y].duplicate()
		)

	for _y in collector.coverage.board.size.y:
		result[_y].reverse()

	return result


func grid_hash(
	grid: Array
) -> String:
	var result := ""

	for row in grid:
		for value in row:
			result += "%02d" % value

	return result
