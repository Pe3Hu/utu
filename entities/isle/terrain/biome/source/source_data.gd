class_name SourceData
extends Resource


@export var biome: Bozo.Biome
@export var matter: Bozo.Matter

@export var pure_volumes: Array[int]
@export var pure_shares: Array[int]

@export var mix_volumes: Array[int]
@export var mix_shares: Array[int]

@export var volume_to_share: Dictionary


func update() -> void:
	volume_to_share.clear()
	
	for _i in pure_volumes.size():
		var volume = pure_volumes[_i]
		var share = pure_shares[_i]
		volume_to_share[volume] = share
	
	for _i in mix_volumes.size():
		var volume = mix_volumes[_i]
		var share = mix_shares[_i]
		volume_to_share[volume] = share

func get_rnd_volume() -> int:
	return Helper.get_random_key(volume_to_share)
