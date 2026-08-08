class_name FakeDice
extends PanelContainer


@export var digit_cube: ColorRect
@export var background_cube: ColorRect

@export var roll_min_steps: int = 1
@export var roll_max_steps: int = 2
@export var step_duration: float = 0.25

var digit_tween: Tween
var background_tween: Tween
var current_rotation: Vector3 = Vector3.ZERO
var target_rotation: Vector3 = Vector3.ZERO
var steps: Array = []
var current_face: int

var current_side: int = 0

func _ready() -> void:
	Helper.rng.randomize()
	reset_cube()

func start_roll() -> void:
	if background_tween and background_tween.is_running(): return
	
	steps = generate_steps()
	target_rotation = simulate_rotation(current_rotation)
	animate_steps()

func generate_steps() -> Array:
	steps.clear()
	var n: int = Helper.rng.randi_range(roll_min_steps, roll_max_steps)
	var result: Array = []
	var prev_axis: int = -1
	
	var local_side: int = current_side
	
	for _i in n:
		var axis_options = [0, 1, 2]
		axis_options.shuffle()
		
		if prev_axis != -1:
			axis_options.erase(prev_axis)
		
		var locked_axis: int = get_locked_axis(local_side)
		
		var filtered_options: Array = []
		
		for axis in axis_options:
			if axis != locked_axis:
				filtered_options.append(axis)
		
		if filtered_options.is_empty():
			filtered_options = [0, 1, 2]
			
			if prev_axis != -1:
				filtered_options.erase(prev_axis)
		
		var axis_index: int = filtered_options.pick_random()
		prev_axis = axis_index
		var turns: int = 1 if Helper.rng.randf() < 0.7 else 2
		
		result.append({
			"axis_index": axis_index,
			"turns": turns
		})
		
		local_side = get_next_side(local_side, axis_index, turns)
	
	current_side = local_side
	return result

func get_next_side(current_side_: int, axis_index_: int, turns_: int) -> int:
	var new_side: int = current_side_
	
	for _i in turns_:
		new_side = Digest.side_to_axis_to_side[new_side][axis_index_]
	
	return new_side

func get_locked_axis(current_side_: int) -> int:
	match current_side_:
		0, 5: return 2  # Front/Back -> ось Z
		3, 2: return 0  # Right/Left -> ось X
		4, 1: return 1  # Top/Bottom -> ось Y
		_: return -1

func simulate_rotation(start_: Vector3) -> Vector3:
	var result = start_
	
	for step in steps:
		var axis = Catalog.axes[step["axis_index"]]
		var turns = step["turns"]
		
		result += axis * turns
	
	return result

func animate_steps() -> void:
	var start_rotation = current_rotation
	var current_rot = start_rotation
	
	background_tween = create_tween()
	digit_tween = create_tween()
	
	for _i in steps.size():
		var step = steps[_i]
		var axis = Catalog.axes[step["axis_index"]]
		var turns = step["turns"]
		
		var end_rotation = current_rot + axis * turns
		var t: float = float(_i) / float(max(steps.size() - 1, 1))
		var speed_factor: float = pow(1.8, t)
		var duration: float = step_duration * speed_factor
		
		if turns == 2:
			duration *= 2.0
		
		var step_start = current_rot
		var step_end = end_rotation
		
		background_tween.tween_method(
			func(progress: float) -> void:
				var ease_progress = 1.0 - pow(1.0 - progress, 3.0)
				var interpolated = step_start.lerp(step_end, ease_progress)
				background_cube.material.set_shader_parameter("rotation_deg", interpolated)
				,
				0.0, 1.0, duration
		)
		digit_tween.tween_method(
			func(progress: float) -> void:
				var ease_progress = 1.0 - pow(1.0 - progress, 3.0)
				var interpolated = step_start.lerp(step_end, ease_progress)
				digit_cube.material.set_shader_parameter("rotation_deg", interpolated)
				,
				0.0, 1.0, duration
		)
		
		current_rot = end_rotation
	
	digit_tween.finished.connect(_on_roll_finished)

func _on_roll_finished() -> void:
	current_rotation = target_rotation
	background_cube.material.set_shader_parameter("rotation_deg", current_rotation)
	digit_cube.material.set_shader_parameter("rotation_deg", current_rotation)
	
	current_face = get_visible_face()
	print(current_face)

func get_visible_face() -> int:
	match current_side:
		0: return 5  # Front -> Back
		1: return 4  # Top -> Bottom
		2: return 3  # Right -> Left
		3: return 2  # Left -> Right
		4: return 1  # Bottom -> Top
		5: return 0  # Back -> Front
		_: return -1

func reset_cube() -> void:
	current_rotation = Vector3.ZERO
	target_rotation = Vector3.ZERO
	
	background_cube.material.set_shader_parameter("rotation_deg", current_rotation)
	digit_cube.material.set_shader_parameter("rotation_deg", current_rotation)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE:
			start_roll()
