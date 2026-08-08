class_name Bastion
extends Sprite2D



var data: BastionData:
	set(value_):
		data = value_
		
		position = Vector2(data.fiefdom.coords.front()) * Catalog.BASTION_SIZE
		update_color()
		update_rampart()

@export var terrain: Terrain

var is_external: bool:
	set(value_):
		is_external = value_
		seed_select_shader()

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

func update_rampart() -> void:
	frame_coords = Helper.get_coord_based_on_value(data.current_rampart)

func update_color() -> void:
	#var g = data.galore
	#%Background.color = Color.from_hsv(1.0, 0.0, 1-g)
	#%Background.color = Color.from_hsv(g, 1.0, 1.0)
	%Background.color = Digest.faction_to_color[data.faction]

func _on_press_button_pressed() -> void:
	if !is_external: return
	var blue_faction = data.fiefdom.realm.isle.policy.type_to_faction[Bozo.Faction.BLUE]
	blue_faction.captured_bastion(data)
	update_color()
	is_external = false
	terrain.highlight_externals()
