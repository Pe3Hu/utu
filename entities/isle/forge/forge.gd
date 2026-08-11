class_name Forge
extends PanelContainer


var anvil_scene = preload("uid://bf50ul084wkr1")

var data: ForgeData:
	set(value_):
		data = value_
		connect_signals()

var current_anvil_index: int = 0:
	set(value_):
		var anvil
		
		if %Anvils.get_child_count() > current_anvil_index:
			anvil = %Anvils.get_child(current_anvil_index)
			anvil.visible = false
		
		current_anvil_index = value_
		
		if %Anvils.get_child_count() > current_anvil_index:
			anvil = %Anvils.get_child(current_anvil_index)
			anvil.visible = true

#region init
func connect_signals() -> void:
	data.fusion_phase.connect(_on_fusion_phase)

func _on_fusion_phase() -> void:
	Helper.clear_children(%Anvils)
	if data.anvils.is_empty(): return
	visible = true
	
	for anvil_data in data.anvils:
		add_anvil(anvil_data)
	
	current_anvil_index = 0

func add_anvil(anvil_data: AnvilData) -> void:
	var anvil = anvil_scene.instantiate()
	%Anvils.add_child(anvil)
	anvil.forge = self
	anvil.data = anvil_data
#endregion

func _on_next_anvil_pressed() -> void:
	current_anvil_index = (current_anvil_index + 1) % %Anvils.get_child_count()

func _on_previous_anvil_pressed() -> void:
	current_anvil_index = (%Anvils.get_child_count() + current_anvil_index - 1) % %Anvils.get_child_count()
