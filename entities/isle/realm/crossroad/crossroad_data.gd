class_name CrossroadData
extends RefCounted



var realm: RealmData
var bastions: Array[BastionData]

var coord: Vector2i


func _init(realm_: RealmData, bastions_: Array) -> void:
	realm = realm_
	bastions.append_array(bastions_)
	
	realm.crossroads.append(self)
	
	for bastion in bastions:
		coord += bastion.fiefdom.coords.front()
	
	coord /= bastions.size()
	coord += Vector2i.ONE
