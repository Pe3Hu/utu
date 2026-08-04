class_name Biome
extends TileMapLayer


@export var terrain: Terrain

var data: BiomeData:
	set(value_):
		data = value_
		apply_cells()


func apply_cells() -> void:
	set_cells_terrain_connect(data.coords, 0, 0, true)
	modulate = Digest.biome_to_color[data.type]
