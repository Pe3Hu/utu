class_name CantoData
extends RefCounted


signal is_critical_changed

var hymn: HymnData

var intro: TuneData
var verse: TuneData
var outro: TuneData

var joint: int

var pulse_value: int = 0
var is_critical: bool = false:
	set(value_):
		if is_critical != value_:
			is_critical = value_
			is_critical_changed.emit()


#region init
func _init(hymn_: HymnData, joint_: int, intro_: StampData, verse_: Variant, outro_: Variant) -> void:
	hymn = hymn_
	joint = joint_
	intro = TuneData.new(self, intro_, Bozo.Tune.INTRO)
	var tune_type: Bozo.Tune
	
	if verse_ != null:
		tune_type = Bozo.Tune.VERSE
		verse = TuneData.new(self, verse_, tune_type)
	
	if outro_ != null:
		tune_type = Bozo.Tune.OUTRO
		outro = TuneData.new(self, outro_, tune_type)
	
	update_pulse()
	
	if hymn.cantos.has(self):
		hymn.tune_to_canto[tune_type] = self
		update_is_critical()

func update_pulse() -> void:
	pulse_value = intro.stake.value
	
	if verse:
		pulse_value += verse.stake.value
	
	if outro:
		pulse_value *= outro.stake.value
		
	if Catalog.pulses.has(pulse_value) and pulse_value > 0:
		if is_affordable():
			hymn.cantos.append(self)
	else:
		return
	
	#if hymn.scenario.atheneum.faction.type == Bozo.Faction.BLUE:
		#if verse:
			#print([intro.stake.value, "+", verse.stake.value, "=", pulse_value ])
		#
		#if outro:
			#print([intro.stake.value, "*", outro.stake.value, "=", pulse_value])

func is_affordable() -> bool:
	var granary = hymn.scenario.atheneum.faction.kernel.granary
	
	if not granary.is_available(intro.stake.value): return false
	
	if verse:
		if not granary.is_available(verse.stake.value): return false
	
	if outro:
		if not granary.is_available(outro.stake.value): return false
	
	return true

func update_is_critical() -> void:
	if hymn.scenario.atheneum.faction.isle.terrain.rampart_to_bastions.has(pulse_value):
		var bastions = hymn.scenario.atheneum.faction.isle.terrain.rampart_to_bastions[pulse_value]
		var externals = hymn.scenario.atheneum.faction.externals.filter(func (a): return bastions.has(a))
		is_critical = !externals.is_empty()
	else:
		is_critical = false
#endregion

func voice() -> void:
	pass
