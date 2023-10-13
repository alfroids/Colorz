extends ReferenceRect
class_name GridCell


var coord: Vector2

signal piece_placed(c)
signal piece_removed(c)
signal piece_rotated(c)


func _on_gui_input(event) -> void:
	if event.is_action_pressed("select"):
		if Input.is_key_pressed(KEY_SHIFT):
			emit_signal("piece_removed", coord)
		else:
			emit_signal("piece_placed", coord)
	elif event.is_action_pressed("rotate"):
		emit_signal("piece_rotated", coord)
