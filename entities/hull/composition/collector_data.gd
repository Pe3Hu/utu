class_name CollectorData
extends DLXSolutionReceiver


var canonicalizer = SolutionCanonicalizer.new(self)
var coverage: CoverageData

var solutions: Array = []
var unique_solutions: Dictionary = {}

var compositions: Array[CompositionData] = []


func _init(coverage_: CoverageData) -> void:
	coverage = coverage_

func on_solution(row_ids: Array[int]) -> bool:
	var allocations: Array[AllocationData] = []
	
	for row_id in row_ids:
		allocations.append(
			coverage.allocations[row_id]
		)
	
	var _hash = canonicalizer.get_hash(
		allocations
	)
	
	if unique_solutions.has(_hash):
		return true
	
	unique_solutions[_hash] = allocations
	solutions.append(allocations)
	return true


func init_compositions() -> void:
	for solution in unique_solutions.values():
		var composition = CompositionData.new(solution)
		compositions.append(composition)

func save(
	path: String,
) -> void:
	var data: Array = []

	for composition in compositions:
		data.append(
			composition.get_data()
		)

	var file := FileAccess.open(
		path,
		FileAccess.WRITE
	)

	if file == null:
		push_error(
			"Cannot open file: " + path
		)
		return

	file.store_string(
		JSON.stringify(
			data,
			"\t"
		)
	)

	file.close()
