class_name HierarchyData
extends RefCounted


var isle: IsleData

var leagues: Array[LeagueData]
var domain_to_leagues: Dictionary


func _init(isle_: IsleData) -> void:
	isle = isle_
	
	#init_leagues()

func init_leagues() -> void:
	leagues.clear()
	domain_to_leagues.clear()
	
	var kingdom = isle.realm.kingdoms[0]
	
	#for dukedom in kingdom.vassals:
		#for earldom in dukedom.vassals:
			#for fiefdom in earldom.vassals:
				#var _league = LeagueData.new(self, fiefdom)
	
	for dukedom in kingdom.vassals:
		for earldom in dukedom.vassals:
			var _league = LeagueData.new(self, earldom)
