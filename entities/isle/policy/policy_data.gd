class_name PolicyData
extends RefCounted


var isle: IsleData
var factions: Array[FactionData]

var regard_to_order_to_shrines: Dictionary

func _init(isle_: IsleData) -> void:
	isle = isle_
	
	init_factions()
	init_shrines()

func init_factions() -> void:
	for faction in Catalog.factions:
		add_faction(faction)

func add_faction(type_: Bozo.Faction) -> void:
	var faction = FactionData.new(self, type_)
	factions.append(faction)

func init_shrines() -> void:
	regard_to_order_to_shrines.clear()
	var regards = [Bozo.Regard.ALLY, Bozo.Regard.ENEMY]
	
	for regard in regards:
		regard_to_order_to_shrines[regard] = {}
	
	for order in Catalog.shrines.size():
		for regard in regards:
			regard_to_order_to_shrines[regard][order] = []
		
		for shrine in Catalog.shrines[order]:
			for corner_index in Catalog.corners.size():
				var is_even: bool = (order + corner_index) % 2 == 0
				var regard = Digest.flag_to_regard[is_even]
				
				var corner = Catalog.corners[corner_index] * Catalog.BOARD_SIZE
				var coord = corner + Helper.apply_acnhor_twist(shrine, corner_index)
				regard_to_order_to_shrines[regard][order].append(coord)
				var bastion = isle.realm.coord_to_fiefdom[coord].bastion
				bastion.regard = regard
