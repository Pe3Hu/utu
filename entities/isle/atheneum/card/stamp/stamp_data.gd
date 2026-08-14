class_name StampData
extends RefCounted


var origin: OriginData
var intro_values: Array[int]
var verse_values: Array[int]
var spoil_value: int = 1

var type_to_stakes: Dictionary
var tune_to_stakes: Dictionary
var joint_to_type_to_stakes: Dictionary

var mark_digits: String:
	set(value_):
		mark_digits = value_
		init_stakes()


#region init
func _init(origin_: OriginData, intro_values_: Array[int], verse_values_: Array[int]) -> void:
	origin = origin_
	intro_values = intro_values_
	verse_values = verse_values_

func init_stakes() -> void:
	type_to_stakes.clear()
	tune_to_stakes.clear()
	
	for stake_type in Catalog.stakes:
		type_to_stakes[stake_type] = []
	
	for stake_tune in Catalog.tunes:
		tune_to_stakes[stake_tune] = []
	
	for tune in Catalog.tunes:
		for _i in Digest.tune_to_length_to_joints[tune][mark_digits.length()].size():
			var joints = Digest.tune_to_length_to_joints[tune][mark_digits.length()][_i]
			var stake_value: int
			
			match tune:
				Bozo.Tune.INTRO:
					stake_value = intro_values[_i]
				Bozo.Tune.VERSE:
					stake_value = verse_values[_i]
				Bozo.Tune.OUTRO:
					stake_value = Digest.matter_to_factor[origin.matter]
			
			var _stake = StakeData.new(self, tune, joints, stake_value)
#endregion

#region get
func get_stake(joint_: int, type_: Bozo.Stake) -> Variant:
	if not joint_to_type_to_stakes.has(joint_): return null
	if not joint_to_type_to_stakes[joint_].has(type_): return null
	return joint_to_type_to_stakes[joint_][type_]

func can_outro(pulse_: int) -> bool:
	for stake in type_to_stakes[Bozo.Stake.RIGHT]:
		if stake.value == pulse_:
			return true
	
	return false

func get_spoil_weight() -> int:
	#var weight = 0
	#weight += intro_values.size()
	#return weight
	return intro_values.size()
#endregion
