class_name EnclosureData
extends RefCounted


signal value_changed
signal volume_changed

var zoo: ZooData
var mount: Bozo.Mount

var matter: Bozo.Matter
var evaluation: Bozo.Evaluation

var value: int = 0:
	set(value_):
		value = value_
		value_changed.emit()

var volume: int = -1:
	set(value_):
		volume = value_
		volume_changed.emit()


func _init(zoo_: ZooData, mount_: Bozo.Mount) -> void:
	zoo = zoo_
	mount = mount_
	
	matter = Digest.mount_to_matter[mount]
	evaluation = Digest.mount_to_evaluation[mount]
	
	zoo.enclosures.append(self)
	zoo.mount_to_enclosure[mount] = self

#region ride
func ride() -> void:
	if value == 0: return
	
	if Catalog.volume_mounts.has(mount):
		volume_ride()
		return
	if Catalog.matter_mounts.has(mount):
		matter_ride()
		return
	
	prime_ride()

func volume_ride() -> void:
	if volume < 0: return
	
	for _matter in zoo.kernel.harvest.volume_to_matter_to_straw[volume]:
		var harvest_straw = zoo.kernel.harvest.volume_to_matter_to_straw[volume][_matter]
		
		if harvest_straw.amount > 0:
			var granary_straw = zoo.kernel.granary.volume_to_matter_to_straw[volume][_matter]
			
			granary_straw.next_amount = granary_straw.amount + harvest_straw.amount
			harvest_straw.raid_amounts.append(int(harvest_straw.next_amount))
			#harvest_straw.next_amount = 0

func matter_ride() -> void:
	var surplus = int(value)
	var options = []
	
	for _volume in zoo.kernel.harvest.matter_to_volume_to_straw[matter]:
		var harvest_straw = zoo.kernel.harvest.matter_to_volume_to_straw[matter][_volume]
		
		if harvest_straw.amount > 0:
			options.append(harvest_straw)
	
	options.sort_custom(func (a, b): return a.amount > b.amount)
	
	while surplus > 0 and not options.is_empty():
		var harvest_straw = options.pop_back()
		var shift = min(surplus, harvest_straw.amount)
		
		var granary_straw = zoo.kernel.granary.matter_to_volume_to_straw[matter][harvest_straw.volume]
		granary_straw.next_amount = granary_straw.amount + shift 
		#harvest_straw.next_amount -= shift
		harvest_straw.raid_amounts.append(shift)
		surplus -= shift

func prime_ride() -> void:
	var surplus = int(value)
	var options = []
	
	for _volume in Catalog.prime_volumes:
		for _matter in zoo.kernel.harvest.volume_to_matter_to_straw[_volume]:
			var harvest_straw = zoo.kernel.harvest.volume_to_matter_to_straw[_volume][_matter]
			
			if harvest_straw.amount > 0:
				options.append(harvest_straw)
	
	options.shuffle()
	
	while surplus > 0 and not options.is_empty():
		var harvest_straw = options.back()
		var shift = min(surplus, harvest_straw.amount)
		
		if options.size() > 0:
			shift = Helper.rng.randi_range(1, shift)
		
		var granary_straw = zoo.kernel.granary.matter_to_volume_to_straw[harvest_straw.matter][harvest_straw.volume]
		granary_straw.next_amount = granary_straw.amount + shift 
		#harvest_straw.next_amount -= shift
		harvest_straw.raid_amounts.append(shift)
		surplus -= shift
		
		if harvest_straw.next_amount == 0:
			options.erase(harvest_straw)
		
		if options.size() > 0:
			options.shuffle()
#endregion
