class_name EnclaveData
extends RefCounted


var realm: RealmData
var shapes: Array[Bozo.Shape]

var mothers: Array[DomainData]
var fathers: Array[DomainData]


func _init(realm_: RealmData, shapes_: Array) -> void:
	realm = realm_
	shapes.append_array(shapes_)
	
	realm.enclaves.append(self)
	
	if not realm.shape_to_shape_to_enclave.has(shapes[0]):
		realm.shape_to_shape_to_enclave[shapes[0]] = {}
	
	realm.shape_to_shape_to_enclave[shapes[0]][shapes[1]] = self
	
	if not realm.shape_to_shape_to_enclave.has(shapes[1]):
		realm.shape_to_shape_to_enclave[shapes[1]] = {}
	
	realm.shape_to_shape_to_enclave[shapes[1]][shapes[0]] = self
