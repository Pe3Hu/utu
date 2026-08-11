class_name ActionMoveCard
extends ActionData


var atheneum: Atheneum
var shift: int


func _init(stamp_: StampData, shift_: int, atheneum_: Atheneum = null) -> void:
	type = Bozo.Action.MOVE_CARD
	stamp = stamp_
	shift = shift_
	atheneum = atheneum_

func execute() -> void:
	if atheneum:
		var card = atheneum.stamp_to_card[stamp]
		atheneum.shift_card(card, shift)
	else:
		var actual = stamp.atheneum.tribunal.actual
		var new_index = actual.stamps.find(stamp) + shift
		if new_index < 0 or new_index >= actual.stamps.size(): return
		actual.stamps.erase(stamp)
		actual.stamps(new_index, stamp)
	
	stamp.origin.atheneum.recalc_scenario()
