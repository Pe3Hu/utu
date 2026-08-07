class_name Stake
extends PanelContainer


var data: StakeData:
	set(value_):
		data = value_
		
		update_texture()
		custom_minimum_size.y = data.joints.size() * Catalog.JOINT_SIZE.y + (data.joints.size() - 1) * Catalog.JOINT_OFFEST

@export var card: Card
@export var border: Panel


#region init
func update_texture() -> void:
	%Number.frame_coords = Helper.get_coord_based_on_value(data.value)
	var style = %Border.get("theme_override_styles/panel")
	
	match data.type:
		Bozo.Stake.RIGHT:
			style.border_width_right = 0
			%Number.position.x = Catalog.JOINT_OFFEST * 0.5
		Bozo.Stake.LEFT:
			style.border_width_left = 0
			%Number.position.x = Catalog.JOINT_OFFEST
			%Sign.position.x = -Catalog.JOINT_OFFEST * 2
			
			if data.value >= 10:
				%Number.position.x -= Catalog.JOINT_OFFEST * 0.5
				%Sign.position.x -= Catalog.JOINT_OFFEST
				
			
			%Sign.visible = true
			
			var tune_str = Bozo.enum_to_string(Bozo.Type.MATH, Digest.tune_to_math[data.tune])
			%Sign.texture = load("res://entities/isle/terrain/flow/blob/images/%s.png" % tune_str)
		
	update_border()

func update_border() -> void:
	var color = Digest.matter_to_color[data.stamp.origin.matter]
	%Border.get_theme_stylebox("panel").border_color = color
	
	#match tune:
		#Bozo.Tune.INTRO:
			#%Border.get_theme_stylebox("panel").border_width_left = 0
		#Bozo.Tune.VERSE:
			#%Border.get_theme_stylebox("panel").border_width_right = 0
#endregion
