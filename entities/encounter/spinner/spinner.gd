@tool
class_name Spinner
extends ColorRect


@export var dice: DiceData:
	set(value_):
		dice = value_
		update_textures()

var face_index: int
var tween: Tween


func update_textures() -> void:
	for _i in dice.values.size():
		var parameter_name = "tex_%s" % str(_i)
		var parameter_value = load("res://entities/encounter/spinner/images/%s.png" % str(dice.values[_i]))
		material.set_shader_parameter(parameter_name, parameter_value)

func spin():
	var spin_step = 1.0 / float(dice.values.size())
	
	face_index = Helper.rng.randi_range(0, dice.values.size() - 1)
	
	var offset = {
		'from': material.get_shader_parameter('y_offset'),
		'to': 3.0 + face_index * spin_step
	}
	
	if tween:
		tween.kill()
	
	tween = get_tree().create_tween()
	tween.tween_method(
		func(a):
			material.set_shader_parameter('y_offset', lerpf(offset.from, offset.to, a)),
		0.0,
		1.0,
		1.0
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_callback(
		func():
			material.set_shader_parameter('y_offset', face_index * spin_step)#offsets[s].to
	)
	
	print(dice.get_value(face_index))
