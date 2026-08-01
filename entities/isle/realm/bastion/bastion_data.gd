class_name BastionData
extends RefCounted


var fiefdom: DomainData

var regard: Bozo.Regard = Bozo.Regard.WILD
var limit_rampart: int
var current_rampart: int


func _init(fiefdom_: DomainData) -> void:
	fiefdom = fiefdom_
	fiefdom.realm.bastions.append(self)
	reset_ramparts(Catalog.DEFAULT_RAMPART)

func reset_ramparts(rampart_: int) -> void:
	limit_rampart = int(rampart_)
	current_rampart = int(limit_rampart)
