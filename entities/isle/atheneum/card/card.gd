class_name Card 
extends PanelContainer


var data: CardData:
	set(value_):
		data = value_
		update_colors()
		intro.dice = data.intro
		verse.dice = data.verse

@export var border: Panel

@export var overlap: CardOverlap:
	set(value_):
		overlap = value_
		init_hovers()

@export var intro: DiceNet
@export var verse: DiceNet
@export var outro: Outro

@export var nets: Array[DiceNet]

var is_used: bool = false


#region init
func init_hovers() -> void:
	var nodes = [intro, verse, outro]
	
	for node in nodes:
		node.mouse_entered.connect(overlap.hover)
		node.mouse_exited.connect(
			func() -> void:
				if !get_global_rect().has_point(get_global_mouse_position()):
					overlap.unhover()
		)

func update_colors() -> void:
	var color = Catalog.matter_to_color[data.matter]
	border.get_theme_stylebox("panel").border_color = color
	%Top.get_theme_stylebox("panel").bg_color = color
	
	for net in nets:
		net.update_border()
	
	outro.apply_matter()
#endregion

func roll_nets() -> void:
	for net in nets:
		net.start_roll()

func _drag_left_net() -> void:
	pass
	#intro_net.cell._get_drag_data()

func apply_result() -> void:
	var intro_index = data.intro.values.find(data.intro.result)
	intro.set_result(intro_index)
	var verse_index = data.verse.values.find(data.verse.result)
	verse.set_result(verse_index)
