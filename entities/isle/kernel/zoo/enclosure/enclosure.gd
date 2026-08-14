class_name Enclosure
extends TextureRect


var data: EnclosureData:
	set(value_):
		data = value_
		
		update_texture()
		connect_signals()

var zoo: Zoo


#region init
func update_texture() -> void:
	texture = load("res://entities/isle/kernel/zoo/images/%s.png" % Bozo.enum_to_string(Bozo.Type.MOUNT, data.mount))
	self_modulate = Digest.matter_to_color[data.matter]

func connect_signals() -> void:
	data.value_changed.connect(_on_value_changed)
	_on_value_changed()
	data.volume_changed.connect(_on_volume_changed)
	_on_volume_changed()

func _on_value_changed() -> void:
	%Amount.text = str(data.value)

func _on_volume_changed() -> void:
	if Catalog.volume_mounts.has(data.mount):
		visible = data.volume > 0
		
		if visible:
			var index = Catalog.volumes.size() - Catalog.volumes.find(data.volume)
			var x = -(Catalog.VOLUME_SIZE.x - Catalog.VOLUME_BORDER) * index
			offset_transform_position.x = x - 10
			
			%Amount.offset_transform_position.y = -%Amount.offset_transform_position.x
			%Amount.offset_transform_position.x = 0
#endregion
