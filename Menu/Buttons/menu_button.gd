@tool
extends Button


var color: Color:
	get:
		var clr: Color = Global.RGB[color_id]
		clr.a = 0.8
		return clr
@export var color_id: Global.CLR:
	set(c):
		color_id = c
		if Engine.is_editor_hint():
			$Label.set("theme_override_colors/font_shadow_color", color)


func _ready():
	if not Engine.is_editor_hint():
		$Label.set("theme_override_colors/font_shadow_color", color)
