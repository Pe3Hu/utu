class_name Domain
extends TileMapLayer


@export var realm: Realm

var data: DomainData:
	set(value_):
		data = value_
		apply_cells()


func apply_cells() -> void:
	set_cells_terrain_connect(data.coords, 0, 0, true)
	#var domains = data.realm.get_domains(data.type)
	#var hue = float(domains.find(data)) / domains.size()
	modulate = Color.WHITE#Color.from_hsv(hue, 1.0, 1.0)
	#modulate = Digest.shape_to_color[orientation.shape.type]

func recolor(color_: Color) -> void:
	modulate = color_
