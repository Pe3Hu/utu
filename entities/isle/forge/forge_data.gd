class_name ForgeData
extends RefCounted


signal fusion_phase
@warning_ignore("unused_signal")
signal phase_finished

var anvils: Array[AnvilData]
var stamps: Array[StampData]:
	set(value_):
		stamps = value_
		init_anvils()


#region init
func init_anvils() -> void:
	anvils.clear()
	var sizes = [3, 2]
	
	for size in sizes:
		var arrangements = Helper.generate_unique_arrangements_fixed_size(stamps, size)
		
		for arrangement in arrangements:
			if is_stamps_has_same_origin(arrangement):
				if try_fuse_stamps(arrangement):
					var _anvil = AnvilData.new(self, arrangement)
	
	fusion_phase.emit()

func is_stamps_has_same_origin(stamps_: Array) -> bool:
	for stamp in stamps_:
		if stamp.origin != stamps_.front().origin:
			return false
	
	return true

func try_fuse_stamps(stamps_: Array) -> bool:
	var digits_length = 0
	
	for stamp in stamps_:
		digits_length += stamp.mark_digits.length()
	
	if not Catalog.fusion_mark_lengths.has(digits_length):
		return false
	
	if digits_length == Catalog.MARK_DIGITS_MAX_LENGTH:
		return true
	
	for stamp in stamps_:
		if stamp.mark_digits.length() != stamps_.front().mark_digits.length():
			return false
	
	return Catalog.fusion_mark_lengths.has(digits_length)
#endregion

func simulate_anvil_choice() -> void:
	var anvil = anvils.front()
	anvil.fusion()
