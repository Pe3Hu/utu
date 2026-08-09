class_name Ladder
extends Node2D


const stair_scene = preload("uid://dhgdl75u1j75h")
const girder_scene = preload("uid://b8imnf6o57n7v")

var data: StepladderData:
	set(value_):
		data = value_
		
		init_stairs()
		init_girders()
		connect_signals()

var current_stair: Stair
var volume_to_stair: Dictionary


#region init
func _ready() -> void:
	data = StepladderData.new()
	position = get_parent().size / 2
	position -= Vector2(Catalog.LADDER_SIZE) * Catalog.STAIR_SIZE / 2

func connect_signals() -> void:
	data.volume_changed.connect(_on_volume_changed)
	_on_volume_changed()

func _on_volume_changed() -> void:
	if current_stair:
		current_stair.is_current = false
	
	current_stair = volume_to_stair[data.current_volume]
	current_stair.is_current = true

func init_stairs() -> void:
	for stair_data in data.ladder.stairs:
		add_stair(stair_data)

func add_stair(stair_data_: StairData) -> void:
	var stair = stair_scene.instantiate()
	%Stairs.add_child(stair)
	stair.data = stair_data_
	volume_to_stair[stair_data_.volume] = stair

func init_girders() -> void:
	for girder_data in data.ladder.girders:
		add_girder(girder_data)

func add_girder(girder_data_: GirderData) -> void:
	var girder = girder_scene.instantiate()
	%Girders.add_child(girder)
	girder.data = girder_data_
#endregion

func test_stair() -> void:
	var options = Digest.volume_to_matter_to_volume[data.current_volume].keys()
	if options.is_empty(): 
		data.current_volume = 2
		return
	options.shuffle()
	var matter = options.pick_random()
	data.current_volume = Digest.volume_to_matter_to_volume[data.current_volume][matter]

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_D:
				test_stair()
