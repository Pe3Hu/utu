class_name Bastion
extends Sprite2D


var data: BastionData:
	set(value_):
		data = value_
		
		position = Vector2(data.fiefdom.coords.front()) * Catalog.BASTION_SIZE
		#%Halocline.visible = data.is_halocline
		#%Halocline.offset_transform_rotation = Helper.rng.randf_range(0, 360)
		connect_signals()

@export var terrain: Terrain

var is_external: bool:
	set(value_):
		is_external = value_
		seed_select_shader()


#region init
func seed_select_shader() -> void:
	%Select.visible = is_external
	var speed = Helper.rng.randf_range(2.5, 4.5)
	%Select.material.set_shader_parameter("speed", speed)
	if true: return
	if not is_external: return
	
	var deg = Helper.rng.randf_range(25, 35)
	%Select.material.set_shader_parameter("rotation_deg", deg)
	var pos = Helper.rng.randf_range(0, 1.0)
	%Select.material.set_shader_parameter("position", pos)

func connect_signals() -> void:
	data.rampart_changed.connect(_on_rampart_changed)
	_on_rampart_changed()
	data.faction_changed.connect(_on_faction_changed)
	_on_faction_changed()
	
	if data.settlement:
		data.settlement.stepladder.volume_changed.connect(_on_volume_changed)
		_on_volume_changed()

func _on_rampart_changed() -> void:
	if data.settlement:
		frame_coords = Catalog.NO_RAMPART_COORD
		_on_volume_changed()
		return
	
	frame_coords = Helper.get_coord_based_on_value(data.current_rampart)

func _on_volume_changed() -> void:
	%CrownBG.visible = data.settlement != null
	%CrownPart.visible = data.settlement != null
	var volume = data.settlement.stepladder.current_volume
	var shape = Digest.volume_to_shape[volume]
	var stage = Digest.volume_to_stage[volume]
	%CrownBG.texture = load("res://entities/isle/terrain/bastion/images/crown/%d/%d.png" % [shape, shape])
	%CrownPart.texture = load("res://entities/isle/terrain/bastion/images/crown/%d/%d %d.png" % [shape, shape, stage])

func _on_faction_changed() -> void:
	#var g = data.galore
	#%Background.color = Color.from_hsv(1.0, 0.0, 1-g)
	#%Background.color = Color.from_hsv(g, 1.0, 1.0)
	%Background.color = Digest.faction_to_color[data.faction.type]
#endregion

func _on_press_button_pressed() -> void:
	try_capture()

func try_capture() -> void:
	if !is_external: return
	if not terrain.isle.odeum.current_canto: return
	var is_captured = data.try_capture(terrain.isle.odeum.current_canto.data)
	
	if is_captured:
		is_external = false
		terrain.data.externals_changed.emit()
	
	terrain.isle.odeum.current_canto.voice()

func _process(delta_: float) -> void:
	if %Halocline.visible:
		var new_angle = %Halocline.offset_transform_rotation + delta_
		%Halocline.offset_transform_rotation = fposmod(new_angle, 360.0)
