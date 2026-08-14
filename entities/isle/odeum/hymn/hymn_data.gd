class_name HymnData
extends RefCounted


var scenario: ScenarioData
var stamps: Array[StampData]

var cantos: Array[CantoData]
var tune_to_canto: Dictionary


func _init(scenario_: ScenarioData, stamps_: Array) -> void:
	scenario = scenario_
	stamps.append_array(stamps_)
	
	init_cantos()
	if not cantos.is_empty():
		scenario.hymns.append(self)

func init_cantos() -> void:
	var first = stamps.front()
	var second = stamps.back()
	
	for joint in first.joint_to_type_to_stakes:
		var left_stake = second.get_stake(joint, Bozo.Stake.LEFT)
		
		if left_stake:
			var right_stake = first.get_stake(joint, Bozo.Stake.RIGHT)
			var pulse = right_stake.value
			
			match left_stake.tune:
				Bozo.Tune.VERSE:
					var _canto = CantoData.new(self, joint, first, second, null)
				Bozo.Tune.OUTRO:
					if second.can_outro(pulse):
						var _canto = CantoData.new(self, joint, first, null, second)

func get_canto_with_max_pulse() -> CantoData:
	cantos.sort_custom(func (a, b): return a.pulse_value < b.pulse_value)
	return cantos.back()
