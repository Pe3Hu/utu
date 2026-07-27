class_name DiceNet
extends PanelContainer


@export var icons: ColorRect
@export var cell: DragDropCell
@export var card: Card

var dice: DiceData:
	set(value_):
		dice = value_
		update_textures()

@export var tune: Bozo.Tune

var roll_duration: float = 1.0
var is_rolling: bool = false
var shift_sequence: Array[int]


#region init
func update_textures() -> void:
	var textures: Array
	
	for _i in dice.values.size():
		#var texture = load("res://entities/dice/images/%d.png" % _i)
		var texture = load("res://entities/dice/images/%d.png" % dice.values[_i])
		textures.append(texture)
	
	icons.material.set_shader_parameter("textures", textures)

func update_border() -> void:
	var color = Catalog.matter_to_color[card.matter]
	%Border.get_theme_stylebox("panel").border_color = color
	
	match tune:
		Bozo.Tune.INTRO:
			%Border.get_theme_stylebox("panel").border_width_left = 0
		Bozo.Tune.VERSE:
			%Border.get_theme_stylebox("panel").border_width_right = 0
#endregion

#region roll
func init_shift_sequence() -> void:
	var shift_count = randi_range(10, 12)

	shift_sequence.clear()

	var current_index = Helper.rng.randi_range(0, dice.values.size() - 1)
	var previous_index = -1

	for _i in shift_count:
		var available_neighbors = Catalog.net_neighbors[current_index].duplicate()

		if previous_index != -1:
			available_neighbors.erase(previous_index)

		var next_index = available_neighbors.pick_random()

		shift_sequence.append(next_index)

		previous_index = current_index
		current_index = next_index

func start_roll() -> void:
	if is_rolling: return
	init_shift_sequence()

	is_rolling = true
	icons.material.set_shader_parameter("show_all", false)

	var tween = create_tween()
	var total = shift_sequence.size()

	for i in total:
		var t = float(i) / float(total - 1)
		var delay = lerp(0.03, 0.15, t * t) * roll_duration

		var index = shift_sequence[i]

		tween.tween_callback(
			func():
				icons.material.set_shader_parameter("current_index", index)
		)
		tween.tween_interval(delay)

	tween.finished.connect(end_roll)

func end_roll() -> void:
	is_rolling = false

	icons.material.set_shader_parameter(
		"current_index",
		shift_sequence.back()
	)
	
	icons.visible = false
	cell.visible = true
	cell.value = dice.values[shift_sequence.back()]
	cell.grid = Catalog.axis_to_anchor.keys()[shift_sequence.back()]
#endregion

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_SPACE:
				start_roll()
	
