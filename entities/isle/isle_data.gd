class_name IsleData
extends RefCounted


var kernel: KernelData
var atheneum: AtheneumData

var realm: RealmData
var policy: PolicyData
var terrain: TerrainData


func _init() -> void:
	kernel = KernelData.new(self)
	atheneum = AtheneumData.new(self)
	#terrain = TerrainData.new(self)
	#realm = RealmData.new(self)
	#policy = PolicyData.new(self)
	
	#terrain.init_galores()
	pass
