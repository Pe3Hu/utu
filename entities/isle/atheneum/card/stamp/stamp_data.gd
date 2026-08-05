class_name StampData
extends RefCounted


var origin: OriginData
var intro_value: int
var verse_value: int

var type_to_stakes: Dictionary
var joint_to_type_to_stakes: Dictionary


func _init(origin_: OriginData, intro_value_: int, verse_value_: int) -> void:
	origin = origin_
	intro_value = intro_value_
	verse_value = verse_value_
	
	origin.stamps.append(self)
	origin.atheneum.tribunal.hereafter.stamps.append(self)
	init_stakes()

func init_stakes() -> void:
	var joints: Array[int] = [2, 3]
	
	for type in Catalog.stakes:
		type_to_stakes[type] = []
		
		match type:
			Bozo.Stake.RIGHT:
				var _stake = StakeData.new(self, Bozo.Tune.INTRO, joints, intro_value)
			Bozo.Stake.LEFT:
				var _stake = StakeData.new(self, Bozo.Tune.VERSE, [joints.front()], verse_value)
				
				var outro_value = Digest.matter_to_factor[origin.matter]
				_stake = StakeData.new(self, Bozo.Tune.OUTRO, [joints.back()], outro_value)

func get_stake(joint_: int, type_: Bozo.Stake) -> Variant:
	if not joint_to_type_to_stakes.has(joint_): return null
	if not joint_to_type_to_stakes[joint_].has(type_): return null
	return joint_to_type_to_stakes[joint_][type_]

func can_outro(pulse_: int) -> bool:
	for stake in type_to_stakes[Bozo.Stake.RIGHT]:
		if stake.value == pulse_:
			return true
	
	return false
