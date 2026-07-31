class_name DLXSolver
extends RefCounted


var matrix: DLXMatrix
var receiver: DLXSolutionReceiver

var current_solution: Array[int]


func _init(
	coverage: CoverageData,
	receiver_: DLXSolutionReceiver
) -> void:
	matrix = DLXMatrix.new(coverage)
	receiver = receiver_

func solve() -> void:
	current_solution.clear()
	search()

func search() -> bool:
	if matrix.is_solved(): return receiver.on_solution(current_solution)

	var column = matrix.select_column()

	if column == null: return false

	if column.size == 0: return false

	matrix.cover(column)

	var row = column.cell.down

	while row != column.cell:
		var next_row = row.down

		current_solution.append(row.row_id)

		var node = row.right

		while node != row:
			matrix.cover(node.header)
			node = node.right

		search()

		node = row.left

		while node != row:
			matrix.uncover(node.header)
			node = node.left

		current_solution.pop_back()

		row = next_row

	matrix.uncover(column)
	return true
