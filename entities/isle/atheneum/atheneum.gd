class_name Atheneum 
extends PanelContainer


@export var card_scene = preload("uid://cfe1p2qnaebxk")

var data: AtheneumData:
	set(value_):
		data = value_
		
		init_cards()

@export var isle: Isle
@export var cards: Array[Card]

var stamp_to_card: Dictionary


#region init
func init_cards() -> void:
	cards.clear()
	stamp_to_card.clear()
	Helper.clear_children(%Cards)
	
	for stamp_data in data.tribunal.actual.stamps:
		add_card(stamp_data)
	
	sort_cards()

func add_card(stamp_data_: StampData) -> void:
	var card = card_scene.instantiate()
	%Cards.add_child(card)
	stamp_to_card[stamp_data_] = card
	card.atheneum = self
	card.stamp.data = stamp_data_
	cards.append(card)

func remove_card() -> void:
	if %Cards.get_child_count() == 0: return
	%Cards.get_children().back().destroy()
	var card = cards.pop_back()
	stamp_to_card.erase(card.stamp)

func appear_card(stamp_data_: StampData) -> void:
	var card = stamp_to_card[stamp_data_]
	card.appear()
	#fleet.kernel.isle.atheneum.

func disappear_card(stamp_data_: StampData) -> void:
	var card = stamp_to_card[stamp_data_]
	card.disappear()
#endregion

#region sort
func shift_card(card_: Card, shift_: int) -> void:
	var new_index = card_.get_index() + shift_
	if new_index < 0 or new_index >= %Cards.get_child_count(): return
	%Cards.move_child(card_, new_index)

func sort_cards() -> void:
	var scenario = data.scenarios.front()
	cards.sort_custom(func (a, b): return scenario.chains.find(a.stamp.data) < scenario.chains.find(b.stamp.data))
	
	for _i in cards.size():
		%Cards.move_child(cards[_i], _i)
#endregion
