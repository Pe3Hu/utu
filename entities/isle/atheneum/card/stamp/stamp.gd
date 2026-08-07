class_name Stamp 
extends PanelContainer


@export var stake_scene = preload("uid://ddqqetmqeecl1")

var data: StampData:
	set(value_):
		data = value_
		
		init_stakes()
		update_colors()
		%Spoil.texture = load("res://entities/dice/images/%d.png" % data.spoil_value)

@export var border: Panel

@export var card: Card:
	set(value_):
		card = value_


#region init
func init_stakes() -> void:
	for type in data.type_to_stakes:
		for stake_data in data.type_to_stakes[type]:
			add_stake(stake_data)

func add_stake(stake_data_: StakeData) -> void:
	var stake = stake_scene.instantiate()
	var stakes = get_stakes(stake_data_.type)
	stakes.add_child(stake)
	stake.data = stake_data_

func get_stakes(type_: Bozo.Stake) -> VBoxContainer:
	var path = Bozo.enum_to_string(Bozo.Type.STAKE, type_)
	path = "%" + path.capitalize() + "Stakes"
	return get_node(path)

func update_colors() -> void:
	var color = Digest.matter_to_color[data.origin.matter]
	border.get_theme_stylebox("panel").border_color = color
	%Top.get_theme_stylebox("panel").bg_color = color
	%Bottom.get_theme_stylebox("panel").bg_color = color
#endregion
