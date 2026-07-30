class_name Module
extends TileMapLayer


@export var hull: Hull

var domain: DomainData:
	set(value_):
		domain = value_
		apply_cells()


func apply_cells() -> void:
	set_cells_terrain_connect(domain.coords, 0, 0, true)
	var domains = domain.realm.get_domains(domain.type)
	var hue = float(domains.find(domain)) / domains.size()
	modulate = Color.from_hsv(hue, 1.0, 1.0)
	#modulate = Digest.shape_to_color[orientation.shape.type]

func recolor(color_: Color) -> void:
	modulate = color_
