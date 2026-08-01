class_name DomainData
extends RefCounted


var realm: RealmData
var type: Bozo.Domain
var coords: Array[Vector2i]

var vassals: Array[DomainData]
var suzerain: DomainData

var neighbours: Array[DomainData]

var direction_to_fiefdom: Dictionary
var bastion: BastionData


#region init
func _init(realm_: RealmData, type_: Bozo.Domain, coords_: Array[Vector2i]) -> void:
	realm = realm_
	type = type_
	coords = coords_.duplicate()
	
	if type_ == Bozo.Domain.FIEFDOM:
		bastion = BastionData.new(self)

func add_vassal(vassal_: DomainData) -> void:
	vassals.append(vassal_)
	vassal_.suzerain = self

func get_superior(type_: Bozo.Domain) -> DomainData:
	if type_ == type: return self
	var superior = suzerain
	
	while superior.type != type_:
		superior = superior.suzerain
	
	return superior

func add_neighbour(neighbour_: DomainData) -> void:
	neighbours.append(neighbour_)
	neighbour_.neighbours.append(self)
	
	if type == Bozo.Domain.FIEFDOM:
		var direction = neighbour_.coords.front() - coords.front()
		direction_to_fiefdom[direction] = neighbour_
		neighbour_.direction_to_fiefdom[-direction] = self
#endregion
