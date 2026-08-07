class_name Fleet
extends PanelContainer


var ark_scene = preload("uid://calvuwftbo0tx")

var data: FleetData:
	set(value_):
		data = value_
		
		init_arks()

@export var kernel: Kernel

var arks: Array[Ark]
var stamp_to_ark: Dictionary

var sort_tween: Tween


#region init
func init_arks() -> void:
	await get_tree().process_frame
	arks.clear()
	stamp_to_ark.clear()
	Helper.clear_children(%Arks)
	
	for stamp_data in data.stamps:
		add_ark(stamp_data)
	
	sort_arks()

func add_ark(stamp_data_: StampData) -> void:
	var ark = ark_scene.instantiate()
	%Arks.add_child(ark)
	arks.append(ark)
	stamp_to_ark[stamp_data_] = ark
	ark.stamp = stamp_data_
	ark.fleet = self
#endregion

func top_ark_animation(flag_: bool = true) -> void:
	var ark = %Arks.get_child(0)
	ark.apply_animation(flag_)

func sort_arks() -> void:
	arks.sort_custom(func(a, b): return a.stamp.get_spoil_weight() > b.stamp.get_spoil_weight())
	
	for _i in arks.size():
		var ark = arks[_i]
		%Arks.move_child(ark, _i)

func apply_ark_animation(stamp_data_: StampData) -> void:
	var ark = stamp_to_ark[stamp_data_]
	var clockwise = ark.last_animation == Bozo.Ark.DISAPPEAR
	ark.apply_animation(clockwise, false)

func push_ark_on_top(ark_: Ark) -> void:
	if sort_tween and sort_tween.is_running(): return
	var selected_index = ark_.get_index()
	if selected_index == 0: return
	
	var ark_on_top = arks[0]
	
	if ark_on_top.last_animation == Bozo.Ark.ACTIVATE:
		ark_on_top.apply_animation(false)
		await ark_on_top.slide_tween.finished
		await ark_on_top.flip_tween.finished
	
	ark_.z_index = 5
	var separation = %Arks.get("theme_override_constants/separation")
	# Получаем высоту одной карты + separation
	var ark_height = ark_.size.y + separation
	var duration = Gear.peaks[Gear.tempo]
	
	sort_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	var y = -selected_index * ark_height
	
	if ark_.last_animation == Bozo.Ark.DISAPPEAR or ark_.last_animation == Bozo.Ark.ACTIVATE:
		y *= -1
	
	sort_tween.tween_property(ark_, "offset_transform_position:y", y, duration)
	
	for _i in selected_index:
		var ark = arks[_i]
		y = ark.offset_transform_position.y + ark_height
		
		if ark.last_animation == Bozo.Ark.DISAPPEAR or ark.last_animation == Bozo.Ark.ACTIVATE:
			y *= -1
		
		sort_tween.tween_property(ark, "offset_transform_position:y", y, duration)
	
	await sort_tween.finished
	
	arks.erase(ark_)
	arks.push_front(ark_)
	ark_.z_index = 0
	
	for _i in arks.size():
		var ark = arks[_i]
		%Arks.move_child(ark, _i)
		ark.offset_transform_position.y = 0.0
		ark.apply_status(Bozo.Ark.ACTIVATE)#APPEAR DEACTIVATE DISAPPEAR ACTIVATE 
	
	#ark_.apply_animation()

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_Z:
				top_ark_animation(false)
			KEY_X:
				top_ark_animation()
