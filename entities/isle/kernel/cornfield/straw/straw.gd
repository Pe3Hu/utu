class_name Straw
extends PanelContainer


var data: StrawData:
	set(value_):
		data = value_
		
		connect_signals()
		update_border()

var tween_amount: Tween

#region init
func connect_signals() -> void:
	data.amount_changed.connect(_on_amount_changed)
	_on_amount_changed()

func update_border() -> void:
	var color = Digest.matter_to_color[data.matter]
	%Border.get_theme_stylebox("panel").border_color = color
	
	if data.matter == Bozo.Matter.LIQUID:
		%Border.z_index = 1

func _on_amount_changed() -> void:
	if not data.cornfield.straws.has(data): return
	
	%Border.visible = data.amount >= 0
	%Amount.visible = data.amount >= 1
	%Amount.text = str(data.amount)
#endregion


func update_amount(with_animation_: bool = false) -> void:
	if data.amount == data.next_amount or data.next_amount < 0: return
	
	if with_animation_:
		var duration = 1.0
		tween_amount = create_tween()
		tween_amount.tween_property(data, "amount", data.next_amount, duration)
		await tween_amount.finished
	else:
		data.amount = data.next_amount
