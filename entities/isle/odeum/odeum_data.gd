class_name OdeumData
extends RefCounted


signal scenario_changed

var faction: FactionData

var scenario: ScenarioData:
	set(value_):
		scenario = value_
		init_cantos()
		scenario_changed.emit()

var cantos: Array[CantoData]


#region init
func _init(faction_: FactionData) -> void:
	faction = faction_

func init_cantos() -> void:
	cantos.clear()
	
	for _i in scenario.chains.size() - 1:
		var first = scenario.chains[_i]
		var second = scenario.chains[_i + 1]
		
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

#endregion
