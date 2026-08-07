class_name Blob
extends Node2D


var data: BlobData:
	set(value_):
		data = value_
		
		rnd_speed()
		update_sprites()
		orbit_center = (Vector2(data.coord) + Vector2.ONE * 0.25) * Catalog.BASTION_SIZE
		orbit_center.x += Catalog.BASTION_SIZE.x * 0.1

var orbit_center: Vector2 = Vector2.ZERO
var orbit_radius_x: float = Catalog.BASTION_SIZE.x * 0.45
var orbit_radius_y: float = Catalog.BASTION_SIZE.y * 0.35
var orbit_speed: float = 2.0
var angle: float = 0.0


func _process(delta: float) -> void:
	angle += orbit_speed * delta
	position = orbit_center + Vector2(
		cos(angle) * orbit_radius_x,
		sin(angle) * orbit_radius_y
	)

func rnd_speed() -> void:
	orbit_speed = Helper.rng.randf_range(1.75, 2.25)
	angle = Helper.rng.randf_range(0, PI * 2)

func update_sprites() -> void:
	%Number.frame_coords = Helper.get_coord_based_on_value(abs(data.value))
	
	if abs(data.value) < 10:
		%Sign.position.x = 5#2
	elif abs(data.value) < 100:
		%Sign.position.x = 1#-2
	else:
		%Sign.position.x = -8#-8
	
	if data.value > 0:
		%Sign.texture = load("res://entities/isle/terrain/flow/blob/images/plus.png")
	if data.value < 0:
		%Sign.texture = load("res://entities/isle/terrain/flow/blob/images/minus.png")
	
	if data.value < 0:
		orbit_speed *= -1
	
