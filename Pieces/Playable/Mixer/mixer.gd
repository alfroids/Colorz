extends Playable
class_name Mixer


func _ready() -> void:
	connections = {
		Vector2.UP: Global.CLR.EMPTY,
		Vector2.RIGHT: Global.CLR.EMPTY,
		Vector2.DOWN: Global.CLR.EMPTY
	}

	update_paint()


func rotate_piece() -> void:
	if not Vector2.LEFT in connections:
		connections = {
			Vector2.RIGHT: Global.CLR.EMPTY,
			Vector2.DOWN: Global.CLR.EMPTY,
			Vector2.LEFT: Global.CLR.EMPTY
		}
	elif not Vector2.UP in connections:
		connections = {
			Vector2.DOWN: Global.CLR.EMPTY,
			Vector2.LEFT: Global.CLR.EMPTY,
			Vector2.UP: Global.CLR.EMPTY
		}
	elif not Vector2.RIGHT in connections:
		connections = {
			Vector2.LEFT: Global.CLR.EMPTY,
			Vector2.UP: Global.CLR.EMPTY,
			Vector2.RIGHT: Global.CLR.EMPTY
		}
	elif not Vector2.DOWN in connections:
		connections = {
			Vector2.UP: Global.CLR.EMPTY,
			Vector2.RIGHT: Global.CLR.EMPTY,
			Vector2.DOWN: Global.CLR.EMPTY
		}

	self.rotate(PI / 2)


func update_paint() -> void:
	var clr1: Color
	var clr2: Color
	var clr3: Color

	if not Vector2.LEFT in connections:
		clr1 = Global.RGB[connections[Vector2.UP]]
		clr3 = Global.RGB[connections[Vector2.RIGHT]]
		clr2 = Global.RGB[connections[Vector2.DOWN]]
	elif not Vector2.UP in connections:
		clr1 = Global.RGB[connections[Vector2.RIGHT]]
		clr3 = Global.RGB[connections[Vector2.DOWN]]
		clr2 = Global.RGB[connections[Vector2.LEFT]]
	elif not Vector2.RIGHT in connections:
		clr1 = Global.RGB[connections[Vector2.DOWN]]
		clr3 = Global.RGB[connections[Vector2.LEFT]]
		clr2 = Global.RGB[connections[Vector2.UP]]
	elif not Vector2.DOWN in connections:
		clr1 = Global.RGB[connections[Vector2.LEFT]]
		clr3 = Global.RGB[connections[Vector2.UP]]
		clr2 = Global.RGB[connections[Vector2.RIGHT]]

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

	if clr3.a > 0:
		$Paint3.visible = true
		$Paint3.material.set_shader_parameter("PAINT_COLOR", clr3)
		$Paint3.material.set_shader_parameter("SHADOW_COLOR", clr3.lerp("#040405", 0.4))
		$Paint3.material.set_shader_parameter("FOAM_COLOR", clr3.lerp("#ffffff", 0.3))
	else:
		$Paint3.visible = false


func receive_paint(direction: Vector2, color: Global.CLR) -> Array[Array]:
	if direction in connections:
		connections[direction] = color

		var direction_is_mixed_paint_output: bool = not -direction in connections

		if direction_is_mixed_paint_output:
			var orthogonal: Vector2 = direction.orthogonal()
			if connections[orthogonal] == Global.CLR.EMPTY and \
			connections[-orthogonal] == Global.CLR.EMPTY:
				connections[orthogonal] = color
				connections[-orthogonal] = color
				update_paint()

				return [[orthogonal, color], [-orthogonal, color]]
		else:
			if not connections[-direction] == Global.CLR.EMPTY:
				var orthogonal: Vector2 = direction.orthogonal()

				if not orthogonal in connections:
					orthogonal *= -1

				var mixed: Global.CLR = Global.mix(color, connections[-direction])
				connections[orthogonal] = mixed

				update_paint()
				return [[orthogonal, mixed]]

	update_paint()
	return []
