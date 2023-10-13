@tool
extends Fixed
class_name Bucket


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

@export var label: Global.CLR = Global.CLR.RED:
	set(l):
		label = l
		if get_child_count() > 0:
			$Label.color = Global.RGB[l]

@onready var fulfilled: bool = false


func _ready() -> void:
	connections = {enum2vec[direction]: Global.CLR.EMPTY}
	update_paint()


func update_paint() -> void:
	var color: Global.CLR = connections[enum2vec[direction]]
	var clr: Color = Global.RGB[color]
	if clr.a > 0:
		$Paint.visible = true
		$Paint.material.set_shader_parameter("PAINT_COLOR", clr)
		$Paint.material.set_shader_parameter("SHADOW_COLOR", clr.lerp("#040405", 0.4))
		$Paint.material.set_shader_parameter("FOAM_COLOR", clr.lerp("#ffffff", 0.3))
	else:
		$Paint.visible = false
	fulfilled = color == label


func receive_paint(dir: Vector2, color: Global.CLR) -> Array[Array]:
	if dir in connections:
		connections[dir] = color

	update_paint()
	return []
