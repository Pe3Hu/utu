class_name Biome
extends Polygon2D



var data: BiomeData:
	set(value_):
		data = value_
		apply_cells()

@export var terrain: Terrain
@export var border: TileMapLayer


#region init
func apply_cells() -> void:
	border.set_cells_terrain_connect(data.coords, 0, 0, true)
	modulate = Digest.biome_to_color[data.type]
	polygon = get_ordered_boundary()
	Helper.update_colors(self, data.source.matter)

func get_ordered_boundary() -> Array[Vector2]:
	if data.coords.is_empty(): return []

	var occupied = {}
	for coord in data.coords:
		occupied[coord] = true

	var unvisited = occupied.duplicate()
	var components = []

	while not unvisited.is_empty():
		var start = unvisited.keys()[0]
		var comp = []
		var stack = [start]
		unvisited.erase(start)

		while not stack.is_empty():
			var coord = stack.pop_back()
			comp.append(coord)
			
			for direction in Catalog.directions:
				var coord_direction = coord + direction
				if unvisited.has(coord_direction):
					unvisited.erase(coord_direction)
					stack.append(coord_direction)

		components.append(comp)

	var best_loop = []
	var best_area = 0.0

	for comp in components:
		var comp_occupied = {}
		for coord in comp:
			comp_occupied[coord] = true

		var edges = []
		for coord in comp:
			var x: int = coord.x
			var y: int = coord.y

			if not comp_occupied.has(Vector2i(x, y - 1)):
				edges.append([Vector2i(x, y), Vector2i(x + 1, y)])

			if not comp_occupied.has(Vector2i(x + 1, y)):
				edges.append([Vector2i(x + 1, y), Vector2i(x + 1, y + 1)])

			if not comp_occupied.has(Vector2i(x, y + 1)):
				edges.append([Vector2i(x + 1, y + 1), Vector2i(x, y + 1)])

			if not comp_occupied.has(Vector2i(x - 1, y)):
				edges.append([Vector2i(x, y + 1), Vector2i(x, y)])

		var next_edge = {}
		for edge in edges:
			next_edge[edge[0]] = edge[1]

		var visited_starts = {}
		var loops = []

		for start in next_edge.keys():
			if visited_starts.has(start):
				continue

			var loop_points = []
			var cur = start
			var steps = 0

			while true:
				if visited_starts.has(cur):
					break

				visited_starts[cur] = true
				loop_points.append(cur)

				if not next_edge.has(cur):
					break

				cur = next_edge[cur]
				steps += 1

				if cur == start:
					break
				if steps > edges.size() + 1:
					break

			if loop_points.size() >= 4:
				loops.append(loop_points)

		for loop in loops:
			var area = polygon_area(loop)
			if absf(area) > best_area:
				best_area = absf(area)
				best_loop = loop

	var result: Array[Vector2] = []
	
	for point in best_loop:
		result.append(Vector2(point) * Catalog.BASTION_SIZE)

	return result

func polygon_area(points_: Array) -> float:
	var s = 0.0
	var n = points_.size()
	
	for i in n:
		var a: Vector2i = points_[i]
		var b: Vector2i = points_[(i + 1) % n]
		s += float(a.x * b.y - a.y * b.x)
	return s * 0.5
#endregion
