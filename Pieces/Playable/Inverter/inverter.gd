extends Playable
class_name Inverter


@onready var horizontal: bool = true


func _ready() -> void:
	connections = {
		Vector2.LEFT: Global.CLR.EMPTY,
		Vector2.RIGHT: Global.CLR.EMPTY
	}

	update_paint()


func rotate_piece() -> void:
	if horizontal:
		connections = {
			Vector2.UP: Global.CLR.EMPTY,
			Vector2.DOWN: Global.CLR.EMPTY
		}
		self.rotate(PI / 2)
	else:
		connections = {
			Vector2.LEFT: Global.CLR.EMPTY,
			Vector2.RIGHT: Global.CLR.EMPTY
		}
		self.rotate(- PI / 2)

	horizontal = not horizontal


func update_paint() -> void:
	var clr1: Color
	var clr2: Color

	if horizontal:
		clr1 = Global.RGB[connections[Vector2.LEFT]]
		clr2 = Global.RGB[connections[Vector2.RIGHT]]
	else:
		clr1 = Global.RGB[connections[Vector2.UP]]
		clr2 = Global.RGB[connections[Vector2.DOWN]]

	if clr1.a > 0:
		$Paint1.visible = true
		$Paint1.material.set_shader_parameter("PAINT_COLOR", clr1)
		$Paint1.material.set_shader_parameter("SHADOW_COLOR", clr1.lerp("#040405", 0.4))
		$Paint1.material.set_shader_parameter("FOAM_COLOR", clr1.lerp("#ffffff", 0.3))
	else:
		$Paint1.visible = false

	if clr2.a > 0:
		$Paint2.visible = true
		$Paint2.material.set_shader_parameter("PAINT_COLOR", clr2)
		$Paint2.material.set_shader_parameter("SHADOW_COLOR", clr2.lerp("#040405", 0.4))
		$Paint2.material.set_shader_parameter("FOAM_COLOR", clr2.lerp("#ffffff", 0.3))
	else:
		$Paint2.visible = false


func receive_paint(direction: Vector2, color: Global.CLR) -> Array[Array]:
	if direction in connections:
		connections[direction] = color

		if connections[-direction] == Global.CLR.EMPTY:
			var inverse: Global.CLR = Global.invert(color)
			connections[-direction] = inverse

			update_paint()
			return [[-direction, inverse]]

	update_paint()
	return []

