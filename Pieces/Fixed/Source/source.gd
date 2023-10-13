@tool
extends Fixed
class_name Source


enum DIR {RIGHT, DOWN, LEFT, UP}
var enum2vec: Dictionary = {
	DIR.RIGHT: Vector2.RIGHT,
	DIR.DOWN: Vector2.DOWN,
	DIR.LEFT: Vector2.LEFT,
	DIR.UP: Vector2.UP
}

@export var direction: DIR = DIR.RIGHT:
	set(d):
		direction = d
		self.rotation = d * PI / 2

@export var color: Global.CLR = Global.CLR.EMPTY:
	set(c):
		color = c
		if get_child_count() > 0:
			var clr: Color = Global.RGB[c]
			if clr.a > 0:
				$Paint.visible = true
				$Paint.material.set_shader_parameter("PAINT_COLOR", clr)
				$Paint.material.set_shader_parameter("SHADOW_COLOR", clr.lerp("#040405", 0.4))
				$Paint.material.set_shader_parameter("FOAM_COLOR", clr.lerp("#ffffff", 0.3))
			else:
				$Paint.visible = false


func _ready():
	connections = {enum2vec[direction]: color}


func reset_connections() -> void:
	pass


func get_output() -> Array:
	return [enum2vec[direction], color]
