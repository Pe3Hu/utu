class_name KernelData
extends RefCounted


var isle: IsleData

var harvest: CornfieldData = CornfieldData.new(self)
var granary: CornfieldData = CornfieldData.new(self)
var fleet: FleetData = FleetData.new(self)


func _init(isle_: IsleData) -> void:
	isle = isle_
