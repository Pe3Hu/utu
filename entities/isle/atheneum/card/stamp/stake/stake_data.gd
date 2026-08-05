class_name StakeData
extends RefCounted


var stamp: StampData
var type: Bozo.Stake
var tune: Bozo.Tune
var joints: Array[int]
var value: int


func _init(stamp_: StampData, tune_: Bozo.Tune, joints_: Array[int], value_: int) -> void:
	stamp = stamp_
	tune = tune_
	joints.append_array(joints_)
	value = value_
	
	type = Digest.tune_to_stake[tune]
	stamp.type_to_stakes[type].append(self)
	
	for joint in joints:
		if not stamp.joint_to_type_to_stakes.has(joint):
			stamp.joint_to_type_to_stakes[joint] = {}
		
		stamp.joint_to_type_to_stakes[joint][type] = self
