@tool
class_name Canto
extends PanelContainer


var data: CantoData:
	set(value_):
		data = value_
		connect_signals()
		connect_datas()

var hymn: Hymn

@export var pulse: Pulse

@export var intro: Tune
@export var verse: Tune
@export var outro: Tune

var is_selected: bool = false:
	set(value_):
		is_selected = value_
		
		match is_selected:
			true:
				%Selection.color = Color.SLATE_GRAY
			false:
				%Selection.color = Color.LIGHT_GRAY


#region Новая область кода
func connect_signals() -> void:
	data.is_critical_changed.connect(pulse._on_is_critical_changed)
	pulse._on_is_critical_changed()

func connect_datas() -> void:
	pulse.value = data.pulse_value
	intro.data = data.intro
	
	if data.verse:
		verse.data = data.verse
		verse.visible = true
	else:
		verse.visible = false
	
	if data.outro:
		outro.data = data.outro
		outro.visible = true
	else:
		outro.visible = false
#endregion

func _on_button_pressed() -> void:
	update_selection()

func update_selection() -> void:
	if hymn.odeum.current_canto == self: return
	if hymn.odeum.current_canto:
		hymn.odeum.current_canto.is_selected = false
	
	hymn.odeum.current_canto = self
	is_selected = true

func voice() -> void:
	data.voice()
	hymn.get_parent().remove_child(self)
	hymn.queue_free()
	queue_free()
	
	if hymn.odeum.current_canto:
		hymn.odeum.current_canto = null
		#hymn.odeum.update_visible_cantos()
