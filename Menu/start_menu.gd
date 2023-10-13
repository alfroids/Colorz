extends Control


func _on_start_game_button_pressed():
	self.get_tree().change_scene_to_file("res://Main/main.tscn")


func _on_quit_game_button_pressed():
	self.get_tree().quit()
