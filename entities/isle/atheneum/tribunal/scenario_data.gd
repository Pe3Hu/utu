class_name ScenarioData
extends Resource


var atheneum: AtheneumData
var chains: Array[StampData]
var spoils: Array[StampData]

var active_spoil: StampData
var spoil_weight: int = 0

var pulses: Array[int]
var pulse_weight: int = 0


func _init(atheneum_: AtheneumData, chains_: Array[StampData], spoils_: Array[StampData]) -> void:
	atheneum = atheneum_
	chains.append_array(chains_)
	spoils.append_array(spoils_)
	calc_spoil_weight()
	
	init_pulses()
	atheneum.scenarios.append(self)

func init_pulses() -> void:
	pulses.clear()
	pulse_weight = 0
	
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
				
				if Catalog.pulses.has(pulse) and pulse > 0:
					pulses.append(pulse)
	
	calc_pulse_weight()
	
func calc_pulse_weight() -> void:
	for pulse in pulses:
		pulse_weight += pulse

func calc_spoil_weight() -> void:
	spoil_weight = 0
