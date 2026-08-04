class_name BiomeData
extends RefCounted


var terrain: TerrainData
var type: Bozo.Biome
var regions: Array[RegionData]

var coords: Array[Vector2i]
var neighbour_regions: Array[RegionData]


func _init(terrain_: TerrainData, type_: Bozo.Biome = Bozo.Biome.NONE) -> void:
	terrain = terrain_
	type = type_

func add_region(region_: RegionData) -> void:
	region_.biome = self
	regions.append(region_)
	coords.append_array(region_.coords)
	
	for neighbour_region in region_.neighbours:
		if not neighbour_regions.has(neighbour_region):
			neighbour_regions.append(neighbour_region)

func is_region_allowed(region_: RegionData) -> bool:
	if region_.biome != null: return false
	
	for neighbour in region_.neighbours:
		if neighbour.biome != null:
			if neighbour.biome.type == type and neighbour.biome != self:
				return false
	
	return true
