extends Playable
class_name SimplePipe


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
	else:
		connections = {
			Vector2.LEFT: Global.CLR.EMPTY,
			Vector2.RIGHT: Global.CLR.EMPTY
		}

	horizontal = not horizontal

	self.rotate(PI / 2)
#	$Animation.play("rotation")


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

		if connections[-direction] == Global.CLR.EMPTY:
			connections[-direction] = color

			update_paint()
			return [[-direction, color]]

	update_paint()
	return []

