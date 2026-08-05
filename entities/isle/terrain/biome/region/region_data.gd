class_name RegionData
extends RefCounted


var terrain: TerrainData
var biome: BiomeData
var coords: Array[Vector2i]

var type: Bozo.Region
var neighbours: Array[RegionData]

var center: Vector2


#region init
func _init(terrain_: TerrainData, coords_: Array[Vector2i]) -> void:
	terrain = terrain_
	coords = coords_.duplicate()
	
	terrain.regions.append(self)
	update_center()

func add_neighbour(neighbour_: RegionData) -> void:
	neighbours.append(neighbour_)
	neighbour_.neighbours.append(self)

func update_center() -> void:
	center = Vector2.ZERO
	
	for coord in coords:
		center += Vector2(coord) / coords.size()

func update_type() -> void:
	var edge_size = Catalog.BOARD_SIZE * 2 - Vector2i.ONE
	type = Bozo.Region.CORNER
	
	if neighbours.size() != 2:
		type = Bozo.Region.CENTER
		
		for coord in coords:
			if coord.x == 0 or coord.y == 0 or coord.x == edge_size.x or coord.y == edge_size.y:
				type = Bozo.Region.SIDE
				break
	
	if not terrain.type_to_regions.has(type):
		terrain.type_to_regions[type] = []
	
	terrain.type_to_regions[type].append(self)
#endregion

func coords_exchange(neighbour_: RegionData) -> void:
	var direction = Helper.get_direction_from_region_centers(self, neighbour_)
	var self_boundary = get_boundary_cells(direction)
	var neighbour_boundary = neighbour_.get_boundary_cells(-direction)
	var options = []
	
	for cell_a in self_boundary:
		for diagonal in Digest.direction_to_diagonal[direction]:
			var cell_b = cell_a + diagonal
			
			if not neighbour_boundary.has(cell_b):
				continue
			
			if not is_removable(cell_a):
				continue
			if not neighbour_.is_removable(cell_b):
				continue
			
			var new_self = coords.duplicate()
			new_self.erase(cell_a)
			new_self.append(cell_b)
			var new_neighbour = neighbour_.coords.duplicate()
			new_neighbour.erase(cell_b)
			new_neighbour.append(cell_a)
			var self_connected = Helper._is_connected(new_self)
			var neighbour_connected = Helper._is_connected(new_neighbour)
			
			if self_connected and neighbour_connected:
				options.append({
					"a": cell_a,
					"b": cell_b,
				})
	
	if options.is_empty(): return
	var option = options.pick_random()
	perform_exchange(option.a, option.b, neighbour_)

func get_boundary_cells(direction_: Vector2i) -> Array[Vector2i]:
	var boundary: Array[Vector2i]
	if coords.is_empty(): return boundary
	
	var min_x = coords[0].x
	var max_x = coords[0].x
	var min_y = coords[0].y
	var max_y = coords[0].y
	
	for cell in coords:
		min_x = min(min_x, cell.x)
		max_x = max(max_x, cell.x)
		min_y = min(min_y, cell.y)
		max_y = max(max_y, cell.y)
	
	if abs(direction_.x) > abs(direction_.y):
		var border_x = max_x if direction_.x > 0 else min_x
		
		for cell in coords:
			if cell.x == border_x:
				boundary.append(cell)
	else:
		var border_y = max_y if direction_.y > 0 else min_y
		
		for cell in coords:
			if cell.y == border_y:
				boundary.append(cell)
	
	return boundary

func is_removable(coord_: Vector2i) -> bool:
	var temp_coords = coords.duplicate()
	temp_coords.erase(coord_)
	return Helper._is_connected(temp_coords)

func perform_exchange(a_: Vector2i, b_: Vector2i, neighbour_: RegionData) -> void:
	if a_ not in coords: return
	if b_ not in neighbour_.coords: return
	
	coords.erase(a_)
	biome.coords.erase(a_)
	neighbour_.coords.erase(b_)
	neighbour_.biome.coords.erase(b_)
	
	coords.append(b_)
	biome.coords.append(b_)
	neighbour_.coords.append(a_)
	neighbour_.biome.coords.append(a_)
