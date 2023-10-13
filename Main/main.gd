extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
#		self.get_tree().change_scene_to_file("res://Menu/start_menu.tscn")
		pass
