class_name KernelData
extends RefCounted


@warning_ignore("unused_signal")
signal growth_phase
@warning_ignore("unused_signal")
signal stock_phase

var faction: FactionData

var harvest: CornfieldData = CornfieldData.new(self)
var granary: CornfieldData = CornfieldData.new(self)
var fleet: FleetData = FleetData.new(self)
var zoo: ZooData = ZooData.new(self)

var active_ark: ArkData:
	set(value_):
		active_ark = value_
		zoo.update_enclosure_volumes()


func _init(faction_: FactionData) -> void:
	faction = faction_

func apply_starter_volumes() -> void:
	if faction.type == Bozo.Faction.GREEN: return
	
	for _i in Catalog.STARTER_HARVEST_AMOUNT:
		grow_harvest(true)

func grow_harvest(instant_stock_: bool = false) -> void:
	for bastion in faction.internals:
		var source = bastion.region.biome.source
		var volume = source.get_rnd_volume()
		
		if instant_stock_:
			var granary_straw = granary.volume_to_matter_to_straw[volume][source.matter]
			granary_straw.amount += 1
			granary_straw.next_amount += 1
		else:
			var straw = harvest.volume_to_matter_to_straw[volume][source.matter]
			straw.next_amount += 1

func stock_granary() -> void:
	for mount_type in Catalog.volume_mounts:
		var enclosure = zoo.mount_to_enclosure[mount_type]
		enclosure.ride()
	
	for mount_type in Catalog.matter_mounts:
		var enclosure = zoo.mount_to_enclosure[mount_type]
		enclosure.ride()
	
	var hyena_enclosure = zoo.mount_to_enclosure[Bozo.Mount.HYENA]
	hyena_enclosure.ride()
	zoo.reset_values()
	
	#for harvest_straw in harvest.straws:
		#if harvest_straw.amount > 0:
			#var granary_straw = granary.volume_to_matter_to_straw[harvest_straw.volume][harvest_straw.matter]
			#granary_straw.next_amount = granary_straw.amount + harvest_straw.amount 
			#harvest_straw.next_amount = 0
