class_name Ark
extends PanelContainer


var stamp: StampData:
	set(value_):
		stamp = value_
		
		update_volumes()
		
		var color = Catalog.matter_to_color[stamp.origin.matter]
		%Right.get_theme_stylebox("panel").bg_color = color

@export var volumes: Array[Volume]

var flip_tween: Tween
var slide_tween: Tween

var time = 1.0


func update_volumes() -> void:
	#for _i in stamp.intro_values:
	var value = stamp.intro_value
	var volume = volumes.front()
	volume.value = value
	#volume.matter = stamp.origin.matter

func flip(is_clockwise_: bool = true) -> void:
	if flip_tween:
		flip_tween.kill()
	
	flip_tween = create_tween()
	var angle = PI
	
	if !is_clockwise_:
		angle = 0

	flip_tween.tween_property(self, "rotation", angle, time)

	for volume in volumes:
		flip_tween.parallel().tween_property(volume.number_node, "offset_transform_rotation", -angle, time)
	
	flip_tween.parallel().tween_property(%Spoil, "offset_transform_rotation", -angle, time)
	
	if is_clockwise_:
		flip_tween.tween_callback(slide.bindv([!is_clockwise_]))

func slide(is_back_: bool = true) -> void:
	if slide_tween:
		slide_tween.kill()
	
	slide_tween = create_tween()
	var l = -%Right.size.x
	if is_back_:
		l = 0
	
	slide_tween.tween_property(self, "offset_transform_position:x", l, time / 3)
	
	if is_back_:
		slide_tween.tween_callback(flip.bindv([!is_back_]))
