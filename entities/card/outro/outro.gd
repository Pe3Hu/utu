class_name Outro
extends PanelContainer


@export var card: Card

@export var cell: DragDropCell



func apply_matter() -> void:
	update_color()
	update_bases()
	
	cell.value = Catalog.matter_to_factor[card.matter]

func update_color() -> void:
	var color = Catalog.matter_to_color[card.matter]
	%Bottom.get_theme_stylebox("panel").bg_color = color
	get_theme_stylebox("panel").border_color = color

func update_bases() -> void:
	var textures: Array
	var indexs: Array
	var ranks = [1, 2]
	
	for _i in 5:
		var value = 0
		
		if _i in ranks:
			var options = Catalog.outro_to_matter_to_values[_i][card.matter]
			value = options.pick_random()
		
		var texture = load("res://entities/dice/images/%d.png" % value)
		textures.append(texture)
		indexs.append(value > 0)
	
	%Bases.material.set_shader_parameter("textures", textures)
	%Bases.material.set_shader_parameter("indexs", indexs)
