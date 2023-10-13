extends Playable
class_name TurnPipe


func _ready() -> void:
	connections = {
		Vector2.LEFT: Global.CLR.EMPTY,
		Vector2.DOWN: Global.CLR.EMPTY
	}

	update_paint()


func rotate_piece() -> void:
	if Vector2.LEFT in connections and Vector2.DOWN in connections:
		connections = {
			Vector2.UP: Global.CLR.EMPTY,
			Vector2.LEFT: Global.CLR.EMPTY
		}
	elif Vector2.UP in connections and Vector2.LEFT in connections:
		connections = {
			Vector2.RIGHT: Global.CLR.EMPTY,
			Vector2.UP: Global.CLR.EMPTY
		}
	elif Vector2.RIGHT in connections and Vector2.UP in connections:
		connections = {
			Vector2.DOWN: Global.CLR.EMPTY,
			Vector2.RIGHT: Global.CLR.EMPTY
		}
	elif Vector2.DOWN in connections and Vector2.RIGHT in connections:
		connections = {
			Vector2.LEFT: Global.CLR.EMPTY,
			Vector2.DOWN: Global.CLR.EMPTY
		}

	self.rotate(PI / 2)


func update_paint() -> void:
	var colors: Array = connections.values()
	var clr: Color = Global.RGB[Global.mix(colors[0], colors[1])]
	if clr.a > 0:
		$Paint.visible = true
		$Paint.material.set_shader_parameter("PAINT_COLOR", clr)
		$Paint.material.set_shader_parameter("SHADOW_COLOR", clr.lerp("#040405", 0.4))
		$Paint.material.set_shader_parameter("FOAM_COLOR", clr.lerp("#ffffff", 0.3))
	else:
		$Paint.visible = false


func receive_paint(direction: Vector2, color: Global.CLR) -> Array[Array]:
	if direction in connections:
		connections[direction] = color

		var orthogonal: Vector2 = direction.orthogonal()
		if not orthogonal in connections:
			orthogonal *= -1

		if connections[orthogonal] == Global.CLR.EMPTY:
			connections[orthogonal] = color

			update_paint()
			return [[orthogonal, color]]

	update_paint()
	return []

