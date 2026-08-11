class_name Atheneum 
extends PanelContainer


@export var card_scene = preload("uid://cfe1p2qnaebxk")

var data: AtheneumData:
	set(value_):
		data = value_
		connect_signals()

@export var isle: Isle
@export var cards: Array[Card]

var stamp_to_card: Dictionary

var shift_tween: Tween


#region init
func connect_signals() -> void:
	data.draw_phase.connect(_on_draw_phase)
	_on_draw_phase()
	data.discard_phase.connect(_on_discard_phase)
	_on_discard_phase()

func _on_draw_phase() -> void:
	cards.clear()
	stamp_to_card.clear()
	Helper.clear_children(%Cards)
	
	for stamp_data in data.tribunal.actual.stamps:
		add_card(stamp_data)
	
	sort_cards(false)

func add_card(stamp_data_: StampData) -> void:
	var card = card_scene.instantiate()
	%Cards.add_child(card)
	stamp_to_card[stamp_data_] = card
	card.atheneum = self
	card.stamp.data = stamp_data_
	cards.append(card)

func _on_discard_phase() -> void:
	for card in cards:
		card.last_disappear()

func remove_card() -> void:
	if %Cards.get_child_count() == 0: return
	%Cards.get_children().back().destroy()
	var card = cards.pop_back()
	stamp_to_card.erase(card.stamp)

func appear_card(stamp_data_: StampData) -> void:
	var card = stamp_to_card[stamp_data_]
	push_aside_cards(card)
	#fleet.kernel.isle.

func disappear_card(stamp_data_: StampData) -> void:
	var card = stamp_to_card[stamp_data_]
	card.disappear()
#endregion

#region sort
func shift_card(card_: Card, shift_: int) -> void:
	var new_index = card_.get_index() + shift_
	if new_index < 0 or new_index >= %Cards.get_child_count(): return
	if shift_tween and shift_tween.is_running(): return
	
	var neighbour_card = %Cards.get_child(new_index)
	shift_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	var l = get_card_shift_length(neighbour_card)
	
	card_.z_index = 1
	if shift_ < 0:
		l *= -1
	
	var duration = Gear.jalousies[Gear.tempo]
	
	shift_tween.tween_property(card_, "offset_transform_position:x", l, duration)
	shift_tween.tween_property(neighbour_card, "offset_transform_position:x", -l, duration)
	
	await shift_tween.finished
	neighbour_card.offset_transform_position.x = 0
	card_.offset_transform_position.x = 0
	card_.z_index = 0
	%Cards.move_child(card_, new_index)
	cards.erase(card_)
	cards.insert(new_index, card_)
	
	update_stamps()

func update_stamps() -> void:
	var stamp_datas = []
	
	for card in cards:
		stamp_datas.append(card.stamp.data)
	
	data.tribunal.actual.stamps.sort_custom(func (a, b): return stamp_datas.find(a) < stamp_datas.find(b))

func sort_cards(with_animation_: bool = true) -> void:
	if Arbitrator.current_phase and Arbitrator.current_phase.type != Bozo.Phase.DECISION: return
	if data.tribunal.actual.stamps.is_empty(): return
	if shift_tween and shift_tween.is_running(): return
	var scenario = data.scenarios.front()
	var hiden_cards = cards.filter(func (a): return not scenario.chains.has(a.stamp.data))
	var visible_cards = cards.filter(func (a): return scenario.chains.has(a.stamp.data))
	var sorted_cards = cards.filter(func (a): return scenario.chains.has(a.stamp.data))
	sorted_cards.sort_custom(func (a, b): return scenario.chains.find(a.stamp.data) < scenario.chains.find(b.stamp.data))
	var last_index = cards.size() - 1
	
	for card in hiden_cards:
		%Cards.move_child(card, last_index)
	
	if not with_animation_:
		for _i in sorted_cards.size():
			%Cards.move_child(sorted_cards[_i], _i)
	else:
		if shift_tween and shift_tween.is_running(): return
		var duration = Gear.jalousies[Gear.tempo]
		shift_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
		
		for new_index in sorted_cards.size():
			var card = sorted_cards[new_index]
			var old_index = visible_cards.find(card)
			var l = get_card_shift_length(card) * (new_index - old_index)
			shift_tween.tween_property(card, "offset_transform_position:x", l, duration)
	
		await shift_tween.finished
		
		for _i in sorted_cards.size():
			var card = sorted_cards[_i]
			%Cards.move_child(card, _i)
			card.offset_transform_position.x = 0
	
	cards.clear()
	cards.append_array(sorted_cards)
	cards.append_array(hiden_cards)

func close_up_cards(card_: Card) -> void:
	if Arbitrator.current_phase and Arbitrator.current_phase.type != Bozo.Phase.DECISION: return
	if shift_tween and shift_tween.is_running(): return
	jalousie(card_)
	await shift_tween.finished
	card_.visible = false
	
	for card in %Cards.get_children():
		card.offset_transform_position.x = 0
	
	if data.tribunal.actual.stamps.has(card_.stamp.data):
		data.tribunal.actual.stamps.erase(card_.stamp.data)
		data.init_scenarios()
		sort_cards()

func push_aside_cards(card_: Card) -> void:
	if shift_tween and shift_tween.is_running(): return
	jalousie(card_, false)
	await shift_tween.finished
	
	for card in %Cards.get_children():
		card.offset_transform_position.x = 0
	
	card_.appear()
	await card_.appear_tween.finished
	
	if not data.tribunal.actual.stamps.has(card_.stamp.data):
		data.tribunal.actual.stamps.append(card_.stamp.data)
		data.init_scenarios()
		sort_cards()

func jalousie(card_: Card, is_inside_: bool = true) -> void:
	if shift_tween and shift_tween.is_running(): return
	shift_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).set_parallel(true)
	
	var close_index = card_.get_index()
	var duration = Gear.jalousies[Gear.tempo]
	
	for _i in %Cards.get_child_count():
		var neighbour_card = %Cards.get_child(_i)
		
		if neighbour_card != card_:
			var l = get_card_shift_length(neighbour_card) * 0.5
			
			if _i > close_index:
				l *= -1
			
			if not is_inside_:
				l *= -1
			
			shift_tween.tween_property(neighbour_card, "offset_transform_position:x", l, duration)

func get_card_shift_length(card_: Card) -> int:
	return card_.size.x + %Cards.get("theme_override_constants/separation")
#endregion

func skip_phase() -> void:
	Arbitrator.current_phase.exit_phase()

func _input(event) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_SPACE:
				skip_phase()
