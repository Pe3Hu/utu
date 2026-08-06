class_name Fleet
extends PanelContainer


@export var ark_scene = preload("uid://calvuwftbo0tx")

var data: FleetData:
	set(value_):
		data = value_
		
		init_arks()


#region init
func init_arks() -> void:
	Helper.clear_children(%Arks)
	
	for stamp_data in data.stamps:
		add_ark(stamp_data)

func add_ark(stamp_data_: StampData) -> void:
	var ark = ark_scene.instantiate()
	%Arks.add_child(ark)
	ark.stamp = stamp_data_
#endregion

func do_top_ark() -> void:
	var ark = %Arks.get_child(0)
	ark.flip()

func undo_top_ark() -> void:
	var ark = %Arks.get_child(0)
	ark.slide()

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_Z:
				do_top_ark()
			KEY_X:
				undo_top_ark()
