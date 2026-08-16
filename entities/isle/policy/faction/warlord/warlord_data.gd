class_name WarlordData
extends RefCounted


var faction: FactionData

var gambits: Array[GambitData]
var length_to_gambits: Dictionary

var current_gambit: GambitData

var emblem_speed: Vector2
var emblem_rotation: float


func _init(faction_: FactionData) -> void:
	faction = faction_
	
	var angle: float = faction.index + Helper.rng.randf_range(-0.15, 0.15)
	angle *= PI * 2 / Catalog.ACTIVE_FACTIONS
	
	if faction.index % 2 == 0:
		angle *= -1
	
	emblem_speed = Vector2.from_angle(angle)
	emblem_rotation = angle#Helper.rng.randf_range(-PI, PI)

func init_gambits() -> void:
	current_gambit = null
	gambits.clear()
	length_to_gambits.clear()
	
	for foothold in faction.odeum.faction.internals:
		for direction in foothold.fiefdom.direction_to_fiefdom:
			if foothold.fiefdom.direction_to_fiefdom[direction].bastion.faction != faction:
				var no_more: bool = false
				var l = 1
				
				while not no_more:
					no_more = true
					var _gambit = GambitData.new(self, foothold, direction, l)
					
					if not _gambit.raids.is_empty():
						no_more = false
						l += 1

func simulate_gambit_choice() -> void:
	if length_to_gambits.keys().is_empty(): 
		print("not gambits")
		return
	
	var best_gambits = length_to_gambits[length_to_gambits.keys().size()]
	
	if faction == faction.policy.player_faction:
		print(["$", gambits.size()])
	
	best_gambits.sort_custom(func (a, b): return a.total_profit > b.total_profit)
	var options = best_gambits.duplicate()
	options.filter(func (a): return a.total_profit == best_gambits.front().total_profit)
	options.sort_custom(func (a, b): return a.total_overrun < b.total_overrun)
	
	#for gambit in best_gambits:
		#var rapmarts = []
		#var pulses = []
		#
		#for raid in gambit.raids:
			#var _pulses = []
			#rapmarts.append(raid.bastion.current_rampart)
			#
			#for canto in raid.cantos:
				#_pulses.append(canto.pulse_value)
			#
			#pulses.append(_pulses)
		#
		#print([gambit.total_profit, rapmarts, gambit.total_overrun, pulses])
	
	current_gambit = options.front()#options.pick_random()
	current_gambit.launch()
	#print([best_gambit.total_profit, best_gambit.total_overrun])
