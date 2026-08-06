class_name Atheneum 
extends PanelContainer


@export var card_scene = preload("uid://cfe1p2qnaebxk")

var data: AtheneumData:
	set(value_):
		data = value_
		
		init_cards()

@export var isle: Isle
@export var cards: Array[Card]

var current_card: Card


#region init
func _ready() -> void:
	pass

func init_cards() -> void:
	cards.clear()
	Helper.clear_children(%Cards)
	
	for stamp_data in data.tribunal.actual.stamps:
		add_card(stamp_data)
	
	sort_cards()

func add_card(stamp_data_: StampData) -> void:
	var card = card_scene.instantiate()
	%Cards.add_child(card)
	card.atheneum = self
	card.stamp.data = stamp_data_
	cards.append(card)

func remove_card() -> void:
	if %Cards.get_child_count() == 0: return
	%Cards.get_children().back().destroy()
	cards.pop_back()
#endregion

func shift_card(card_: Card, shift_: int) -> void:
	var new_index = card_.get_index() + shift_
	if new_index < 0 or new_index >= %Cards.get_child_count(): return
	%Cards.move_child(card_, new_index)

func sort_cards() -> void:
	var scenario = data.scenarios.front()
	cards.sort_custom(func (a, b): return scenario.chains.find(a.stamp.data) < scenario.chains.find(b.stamp.data))
	
	for _i in cards.size():
		%Cards.move_child(cards[_i], _i)

func spoil_card(card_: Card) -> void:
	card_.spoil()
	data.tribunal.actual.stamps.erase(card_.stamp.data)
