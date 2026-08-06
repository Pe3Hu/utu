class_name ScenarioData
extends Resource


var atheneum: AtheneumData
var chains: Array[StampData]
var spoils: Array[StampData]

var pulses: Array[int]
var total_sum: int = 0


func _init(atheneum_: AtheneumData, chains_: Array[StampData], spoils_: Array[StampData]) -> void:
	atheneum = atheneum_
	chains.append_array(chains_)
	spoils.append_array(spoils_)
	
	calc_pulses()
	atheneum.scenarios.append(self)

func calc_pulses() -> void:
	pulses.clear()
	total_sum = 0
	
	for _i in chains.size() - 1:
		var first = chains[_i]
		var second = chains[_i + 1]
		
		for joint in first.joint_to_type_to_stakes:
			var left_stake = second.get_stake(joint, Bozo.Stake.LEFT)
			
			if left_stake:
				var right_stake = first.get_stake(joint, Bozo.Stake.RIGHT)
				var pulse = right_stake.value
				
				match left_stake.tune:
					Bozo.Tune.VERSE:
						pulse += left_stake.value
					Bozo.Tune.OUTRO:
						if second.can_outro(pulse):
							pulse *= left_stake.value
						else:
							continue
				
				if Catalog.pulse_values.has(pulse) and pulse > 0:
					pulses.append(pulse)
	
	for pulse in pulses:
		total_sum += pulse
	
