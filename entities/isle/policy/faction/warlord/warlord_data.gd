class_name WarlordData
extends RefCounted


var faction: FactionData

var gambits: Array[GambitData]
var length_to_gambits: Dictionary
var bastions_to_gambit: Dictionary


func _init(faction_: FactionData) -> void:
	faction = faction_

func init_gambits() -> void:
	gambits.clear()
	length_to_gambits.clear()
	bastions_to_gambit.clear()
	
	#var scenario: ScenarioData = faction.atheneum.scenarios.front()
	#var odeum = faction.odeum.cantos
	
	#var canto_to_criticals = {}
	#var semi_criticals = []
	#
	#for canto in faction.odeum.cantos:
		#if canto.is_critical:
			#var bastions = faction.odeum.faction.isle.terrain.rampart_to_bastions[canto.pulse_value]
			#var externals = faction.odeum.faction.externals.filter(func (a): return bastions.has(a))
			#canto_to_criticals[canto] = externals
		#else:
			#semi_criticals.append(canto)
	
	for bastion in faction.odeum.faction.externals:
		var _gambit = GambitData.new(self, [bastion])
	
	if not gambits.is_empty():
		var l = length_to_gambits.keys().size()
		var no_more_gambits: bool = false
		
		while l < 3 and not no_more_gambits:
			no_more_gambits = true
			
			for old_gambit in length_to_gambits[l]:
				for option in old_gambit.further_externals:
					var gambit_bastions = [option]
					gambit_bastions.append_array(old_gambit.bastions)
					gambit_bastions.sort()
					
					if not bastions_to_gambit.has(gambit_bastions):
						var new_gambit = GambitData.new(self, gambit_bastions)
						
						if new_gambit.raids.is_empty():
							no_more_gambits = false
			
	
	var gambit = gambits.back()
	
	var rapmarts = []
	
	for raid in gambit.raids:
		rapmarts.append(raid.bastion.current_rampart)
	
	print(rapmarts)
	pass
