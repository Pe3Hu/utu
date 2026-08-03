class_name FactionData
extends RefCounted


var policy: PolicyData
var type: Bozo.Faction

var current_order: int = 0

var order_to_shrines: Dictionary
var captured_shrines: Array[BastionData]
var available_shrines: Array[BastionData]


func _init(policy_: PolicyData, type_: Bozo.Faction) -> void:
	policy = policy_
	type = type_
	
	init_shrines()

func init_shrines() -> void:
	for order in Catalog.shrines.size():
		order_to_shrines[order] = []
		
		for shrine in Catalog.shrines[order]:
			for corner_index in Catalog.corners.size():
				var is_even: bool = (order + corner_index) % 2 == 0
				var shrine_faction = Digest.flag_to_faction[is_even]
				
				if shrine_faction == type:
					var corner = Catalog.corners[corner_index] * Catalog.BOARD_SIZE
					var coord = corner + Helper.apply_acnhor_twist(shrine, corner_index)
					order_to_shrines[order].append(coord)
	
	capture_default_shrines()

func capture_default_shrines() -> void:
	for coord in order_to_shrines[0]:
		captured_shrine(coord)

func captured_shrine(coord_: Vector2i) -> void:
	var bastion = policy.isle.realm.coord_to_fiefdom[coord_].bastion
	bastion.faction = type
