class_name Straw
extends PanelContainer


var data: StrawData:
	set(value_):
		data = value_
		
		connect_signals()
		update_border()


#region init
func connect_signals() -> void:
	data.amount_changed.connect(_on_amount_changed)
	_on_amount_changed()

func update_border() -> void:
	var color = Catalog.matter_to_color[data.matter]
	%Border.get_theme_stylebox("panel").border_color = color
	
	if data.matter == Bozo.Matter.LIQUID:
		%Border.z_index = 1

func _on_amount_changed() -> void:
	%Border.visible = data.amount >= 0
	%Amount.visible = data.amount >= 1
	%Amount.text = str(data.amount)
#endregion
