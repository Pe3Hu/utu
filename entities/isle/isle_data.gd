class_name IsleData
extends RefCounted


var atheneum: AtheneumData

var realm: RealmData
var policy: PolicyData
var terrain: TerrainData


func _init() -> void:
	atheneum = AtheneumData.new()
	#terrain = TerrainData.new(self)
	#realm = RealmData.new(self)
	#policy = PolicyData.new(self)
	
	#terrain.init_galores()
	pass
