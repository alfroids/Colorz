extends Node2D


@export var SPEED: float = 0.3
@export var OFFSET: Vector2 = Vector2(256, 40)

@onready var LEVELS: Array[Vector2] = []
@onready var TARGET: int = 0

signal camera_moved


func _ready():
	for level in self.get_children():
		LEVELS.append(-level.position + OFFSET)

	self.position = LEVELS[TARGET]

	camera_moved.connect(ResourceManager._on_camera_moved)


func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		if TARGET + 1 < len(LEVELS):
			TARGET += 1
			emit_signal("camera_moved")
	elif event.is_action_pressed("ui_left"):
		if TARGET - 1 >= 0:
			TARGET -= 1
			emit_signal("camera_moved")


func _physics_process(_delta):
	self.position = self.position.lerp(LEVELS[TARGET], SPEED)
