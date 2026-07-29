class_name CoverageData
extends RefCounted


var board: BoardData

var orientations: Array[OrientationData]
var allocations: Array[AllocationData]

var matrix: Array[Array]

var cell_columns: int
var piece_columns: int
var total_columns: int


func _init() -> void:
	var holes: Array[Vector2i] = [
		Vector2i(3, 3),
		Vector2i(3, 4),
		Vector2i(4, 3),
		Vector2i(4, 4),
	]

	board = BoardData.new(holes)

	cell_columns = board.all_coords.size()
	piece_columns = Catalog.shapes.size()
	total_columns = cell_columns + piece_columns

	init_orientations()
	build_matrix()

func init_orientations() -> void:
	orientations.clear()

	for letter in Catalog.letters:
		var shape: ShapeData = load(
			"res://entities/beast/hull/module/shape/%s.tres" % letter
		)

		var twists: Array[int] = [0]
		var flips: Array[bool] = [false]

		if shape.symmetry.x == 0:
			for i in 3:
				if shape.symmetry.y == 0 or i % 2 == 1:
					twists.append(i + 1)
		elif shape.symmetry.y == 0:
			twists.append(1)

		if shape.symmetry.z == 0:
			flips.append(true)

		for flip in flips:
			for twist in twists:
				var orientation = OrientationData.new(
					shape,
					flip,
					twist
				)

				if !has_orientation(orientation):
					orientations.append(orientation)

func build_matrix() -> void:
	matrix.clear()
	allocations.clear()

	var counter = {}

	for orientation in orientations:
		var anchors = board.get_valid_anchors(orientation)

		for anchor in anchors:
			add_allocation(
				orientation,
				anchor
			)

			var id = orientation.shape.type

			if !counter.has(id):
				counter[id] = 0

			counter[id] += 1

func add_allocation(
	orientation: OrientationData,
	anchor: Vector2i
	) -> void:
	var row: Array[int] = []

	row.resize(total_columns)
	row.fill(0)

	for local in orientation.coords:
		var world = anchor + local
		var column = board.get_column(world)

		row[column] = 1

	var piece_id = Catalog.shapes.find(
		orientation.shape.type
	)

	row[cell_columns + piece_id] = 1

	matrix.append(row)

	allocations.append(
		AllocationData.new(
			orientation,
			anchor
		)
	)

func has_orientation(
	new_orientation: OrientationData
	) -> bool:
	for old_orientation in orientations:
		if old_orientation.shape.type != new_orientation.shape.type:
			continue

		if same_coords(
			old_orientation.coords,
			new_orientation.coords
		):
			return true

	return false

func same_coords(
	a: Array[Vector2i],
	b: Array[Vector2i]
	) -> bool:
	if a.size() != b.size():
		return false

	var aa = a.duplicate()
	var bb = b.duplicate()

	aa.sort()
	bb.sort()

	return aa == bb
