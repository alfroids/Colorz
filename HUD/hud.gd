extends CanvasLayer
class_name HUD


func _ready():
	ResourceManager.level_complete.connect(_on_level_complete)
	ResourceManager.camera_moved.connect(_on_camera_moved)
	$Buttons/SimplePipeButton.button_pressed = true


func _on_level_complete(_level: int) -> void:
	$Arrow.visible = true


func _on_camera_moved() -> void:
	$Arrow.visible = false
