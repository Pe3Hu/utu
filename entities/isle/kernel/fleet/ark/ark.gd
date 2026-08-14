class_name Ark
extends PanelContainer


var fleet: Fleet

var data: ArkData:
	set(value_):
		data = value_
		
		update_volumes()
		reset_spoils_color()

@export var volumes: Array[Volume]
@export var spoils: Array[Spoil]

var flip_tween: Tween
var slide_tween: Tween

var duration = 0.8
var last_animation: Bozo.Ark = Bozo.Ark.APPEAR


#region init
func _ready() -> void:
	await get_tree().process_frame
	apply_status(Bozo.Ark.DISAPPEAR)

func apply_status(status_: Bozo.Ark) -> void:
	var angle: float
	var l: float
	
	match status_:
		Bozo.Ark.DISAPPEAR:
			angle = -PI
			l = get_offset_x()
		Bozo.Ark.APPEAR:
			angle = 0
			l = 0
		Bozo.Ark.ACTIVATE:
			angle = PI
			l = -%RightSpoil.size.x
		Bozo.Ark.DEACTIVATE:
			angle = 0
			l = 0
	
	last_animation = status_
	apply_offset_transforms(angle, l)

func apply_offset_transforms(angle_: float, l_: float) -> void:
	offset_transform_rotation = angle_
	
	for volume in volumes:
		volume.number_node.offset_transform_rotation = -angle_
	
	for spoil in spoils:
		spoil.button.offset_transform_rotation = -angle_
	
	offset_transform_position.x = l_
	
	if get_volume_count() > 0:
		match last_animation:
			Bozo.Ark.DISAPPEAR: 
				offset_transform_pivot.x = Catalog.ARK_PIVOT.x - Catalog.VOLUME_SIZE.x * get_volume_count()
			Bozo.Ark.ACTIVATE: 
				offset_transform_pivot.x = Catalog.ARK_PIVOT.x
			#Bozo.Ark.APPEAR: 
				#offset_transform_pivot.x = Catalog.ARK_PIVOT.x

func update_volumes() -> void:
	var values = data.get_best_intro_values()
	
	for _i in values.size():
		var value = values[_i]
		var volume = volumes[_i]
		volume.value = value
#endregion

#region animation
func flip(angle_: float) -> void:
	if flip_tween:
		flip_tween.kill()
	
	flip_tween = create_tween()

	flip_tween.tween_property(self, "offset_transform_rotation", angle_, duration)

	for volume in volumes:
		flip_tween.parallel().tween_property(volume.number_node, "offset_transform_rotation", -angle_, duration)
	
	for spoil in spoils:
		flip_tween.parallel().tween_property(spoil.button, "offset_transform_rotation", -angle_, duration)

func slide(l_: float) -> void:
	if slide_tween:
		slide_tween.kill()
	
	if get_volume_count() == 0:
		duration *= 2
	
	slide_tween = create_tween()
	slide_tween.tween_property(self, "offset_transform_position:x", l_, duration / 3)
	
	await slide_tween.finished
	
	if get_volume_count() == 0:
		duration /= 2

func apply_animation(clockwise_: bool = true, is_main_: bool = true) -> void:
	if Arbitrator.current_phase.type != Bozo.Phase.DECISION: return
	if not Digest.ark_to_flag_to_ark[last_animation].has(clockwise_): return
	if is_animation_running(): return
	reset_spoils_color()
	var next_animation =  Digest.ark_to_flag_to_ark[last_animation][clockwise_]
	
	match next_animation:
		Bozo.Ark.APPEAR:
			fleet.push_ark_on_top(self)
			
			if fleet.arks.front() == self:
				if is_main_:
					fleet.kernel.isle.atheneum.disappear_card(data.stamp)
					update_zoo_matter()
				
				duration = Gear.appears[Gear.tempo]
				%LeftSpoil.update_texture(false)
				slide(0)
				await slide_tween.finished
				flip(0)
				await flip_tween.finished
				last_animation = next_animation
				
				if get_volume_count() > 0:
					offset_transform_pivot.x += Catalog.VOLUME_SIZE.x * get_volume_count()
		Bozo.Ark.DISAPPEAR:
			if is_main_:
				fleet.kernel.isle.atheneum.appear_card(data.stamp)
				update_zoo_matter(false)
			
			duration = Gear.appears[Gear.tempo]
			
			if get_volume_count() > 0:
				offset_transform_pivot.x -= Catalog.VOLUME_SIZE.x * get_volume_count()
			
			var l = get_offset_x()
			flip(-PI)
			await flip_tween.finished
			slide(l)
			await slide_tween.finished
			last_animation = next_animation
			%LeftSpoil.update_texture()
		Bozo.Ark.ACTIVATE:
			fleet.push_ark_on_top(self)
			
			if fleet.arks.front() == self:
				update_zoo_matter(false)
				duration = Gear.activates[Gear.tempo]
				var l = %RightSpoil.size.x
				flip(PI)
				await flip_tween.finished
				slide(l)
				await slide_tween.finished
				last_animation = next_animation
				%RightSpoil.update_texture(false)
				fleet.kernel.active_ark = self
		Bozo.Ark.DEACTIVATE:
			duration = Gear.activates[Gear.tempo]
			fleet.kernel.active_ark = null
			update_zoo_matter()
			slide(0)
			await slide_tween.finished
			flip(0)
			await flip_tween.finished
			last_animation = next_animation
			%RightSpoil.update_texture()
	
	detect_mouse_inside_spoils()

func is_animation_running() -> bool:
	if slide_tween and slide_tween.is_running(): return true
	if flip_tween and flip_tween.is_running(): return true
	return false
#endregion

#region mouse
func reset_spoils_color() -> void:
	for spoil in spoils:
		spoil._on_button_mouse_exited()

func detect_mouse_inside_spoils() -> void:
	for spoil in spoils:
		if spoil.is_mouse_inside():
			spoil._on_button_mouse_entered()
#endregion

#region get
func get_volume_count() -> int:
	var k = 0
	
	for volume in volumes:
		if volume.visible:
			k += 1
	
	return k

func get_offset_x() -> float:
	var k = get_volume_count()
	var x: float = -%RightSpoil.size.x + Catalog.VOLUME_BORDER * 2
	
	if k == 0:
		x = %RightSpoil.size.x - custom_minimum_size.x
	else:
		x += Catalog.VOLUME_SIZE.x * ((k - 1) * 2 - 1)
	
	return x
#endregion

func update_zoo_matter(flag_: bool = true) -> void:
	var _sign: int = 1
	
	if not flag_:
		_sign = -1
	
	data.fleet.kernel.zoo.updaet_matter_enclosure(data, _sign)
