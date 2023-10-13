extends Playable
class_name CrossPipe


@onready var rotated: bool = false


func _ready() -> void:
	connections = {
		Vector2.LEFT: Global.CLR.EMPTY,
		Vector2.RIGHT: Global.CLR.EMPTY,
		Vector2.UP: Global.CLR.EMPTY,
		Vector2.DOWN: Global.CLR.EMPTY
	}

	update_paint()


func rotate_piece() -> void:
	connections = {
		Vector2.LEFT: Global.CLR.EMPTY,
		Vector2.RIGHT: Global.CLR.EMPTY,
		Vector2.UP: Global.CLR.EMPTY,
		Vector2.DOWN: Global.CLR.EMPTY
	}

	rotated = not rotated

	self.rotate(PI / 2)


func update_paint() -> void:
	var clr13: Color
	var clr2: Color

	if not rotated:
		clr13 = Global.RGB[Global.mix(connections[Vector2.UP], connections[Vector2.DOWN])]
		clr2 = Global.RGB[Global.mix(connections[Vector2.LEFT], connections[Vector2.RIGHT])]
	else:
		clr13 = Global.RGB[Global.mix(connections[Vector2.LEFT], connections[Vector2.RIGHT])]
		clr2 = Global.RGB[Global.mix(connections[Vector2.UP], connections[Vector2.DOWN])]

	if clr13.a > 0:
		$Paint1.visible = true
		$Paint1.material.set_shader_parameter("PAINT_COLOR", clr13)
		$Paint1.material.set_shader_parameter("SHADOW_COLOR", clr13.lerp("#040405", 0.4))
		$Paint1.material.set_shader_parameter("FOAM_COLOR", clr13.lerp("#ffffff", 0.3))

		$Paint3.visible = true
		$Paint3.material.set_shader_parameter("PAINT_COLOR", clr13)
		$Paint3.material.set_shader_parameter("SHADOW_COLOR", clr13.lerp("#040405", 0.4))
		$Paint3.material.set_shader_parameter("FOAM_COLOR", clr13.lerp("#ffffff", 0.3))
	else:
		$Paint1.visible = false
		$Paint3.visible = false

	if clr2.a > 0:
		$Paint2.visible = true
		$Paint2.material.set_shader_parameter("PAINT_COLOR", clr2)
		$Paint2.material.set_shader_parameter("SHADOW_COLOR", clr2.lerp("#040405", 0.4))
		$Paint2.material.set_shader_parameter("FOAM_COLOR", clr2.lerp("#ffffff", 0.3))
	else:
		$Paint2.visible = false


func receive_paint(direction: Vector2, color: Global.CLR) -> Array[Array]:
	connections[direction] = color

	if connections[-direction] == Global.CLR.EMPTY:
		connections[-direction] = color

		update_paint()
		return[[-direction, color]]

	update_paint()
	return []

