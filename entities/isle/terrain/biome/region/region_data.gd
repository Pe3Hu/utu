class_name RegionData
extends RefCounted


var terrain: TerrainData
var biome: BiomeData
var coords: Array[Vector2i]

var type: Bozo.Region
var neighbours: Array[RegionData]


func _init(terrain_: TerrainData, coords_: Array[Vector2i]) -> void:
	terrain = terrain_
	coords = coords_.duplicate()
	
	terrain.regions.append(self)

func add_neighbour(neighbour_: RegionData) -> void:
	neighbours.append(neighbour_)
	neighbour_.neighbours.append(self)

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
