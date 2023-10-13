extends Piece
class_name Playable


func _ready() -> void:
	connections = {}


func rotate_piece() -> void:
	self.rotate(PI / 2)


func update_paint() -> void:
	pass
