class_name Zoo
extends PanelContainer



var data: ZooData:
	set(value_):
		data = value_
		connect_datas()

@export var kernel: Kernel

@export var elephant: Enclosure
@export var giraffe: Enclosure
@export var rhino: Enclosure
@export var horse: Enclosure
@export var zebra: Enclosure
@export var donkey: Enclosure
@export var hyena: Enclosure


@export var volume_enclosures: Array[Enclosure]

#region init
func connect_datas() -> void:
	elephant.data = data.mount_to_enclosure[Bozo.Mount.ELEPHANT]
	giraffe.data = data.mount_to_enclosure[Bozo.Mount.GIRAFFE]
	rhino.data = data.mount_to_enclosure[Bozo.Mount.RHINO]
	horse.data = data.mount_to_enclosure[Bozo.Mount.HORSE]
	zebra.data = data.mount_to_enclosure[Bozo.Mount.ZEBRA]
	donkey.data = data.mount_to_enclosure[Bozo.Mount.DONKEY]
	hyena.data = data.mount_to_enclosure[Bozo.Mount.HYENA]
#endregion


func reset() -> void:
	for enclosure in volume_enclosures:
		enclosure.visible = false
