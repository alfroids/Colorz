extends Node2D
class_name Piece


@export var ID: Global.PC

@onready var connections: Dictionary


func reset_connections() -> void:
	for dir in connections:
		connections[dir] = Global.CLR.EMPTY

	update_paint()


func update_paint() -> void:
	pass


func receive_paint(_direction: Vector2, _color: Global.CLR) -> Array[Array]:
	return []
