extends Node


@onready var selected_piece: Global.PC = Global.PC.SIMPLE_PIPE
@onready var quantities: Dictionary = {
	Global.PC.SIMPLE_PIPE: 16,
	Global.PC.TURN_PIPE: 6,
	Global.PC.MIXER: 0,
	Global.PC.CROSS_PIPE: 0,
	Global.PC.INVERTER: 0
} # iniciar com: (16 6 0 0 0)
@onready var rewards: Dictionary = {
	0: {
		Global.PC.SIMPLE_PIPE: 10,
		Global.PC.TURN_PIPE: 2,
		Global.PC.MIXER: 1,
		Global.PC.CROSS_PIPE: 0,
		Global.PC.INVERTER: 0
	},
	1: {
		Global.PC.SIMPLE_PIPE: 6,
		Global.PC.TURN_PIPE: 2,
		Global.PC.MIXER: 1,
		Global.PC.CROSS_PIPE: 0,
		Global.PC.INVERTER: 0
	},
	2: {
		Global.PC.SIMPLE_PIPE: 25,
		Global.PC.TURN_PIPE: 6,
		Global.PC.MIXER: 4,
		Global.PC.CROSS_PIPE: 0,
		Global.PC.INVERTER: 0
	},
	3: {
		Global.PC.SIMPLE_PIPE: 30,
		Global.PC.TURN_PIPE: 3,
		Global.PC.MIXER: 4,
		Global.PC.CROSS_PIPE: 0,
		Global.PC.INVERTER: 0
	},
	4: {
		Global.PC.SIMPLE_PIPE: 36,
		Global.PC.TURN_PIPE: 15,
		Global.PC.MIXER: 9,
		Global.PC.CROSS_PIPE: 0,
		Global.PC.INVERTER: 0
	},
	5: {
		Global.PC.SIMPLE_PIPE: 19,
		Global.PC.TURN_PIPE: 9,
		Global.PC.MIXER: 4,
		Global.PC.CROSS_PIPE: 2,
		Global.PC.INVERTER: 0
	},
	6: {
		Global.PC.SIMPLE_PIPE: 36,
		Global.PC.TURN_PIPE: 8,
		Global.PC.MIXER: 2,
		Global.PC.CROSS_PIPE: 2,
		Global.PC.INVERTER: 0
	},
	7: {
		Global.PC.SIMPLE_PIPE: 1,
		Global.PC.TURN_PIPE: 0,
		Global.PC.MIXER: 0,
		Global.PC.CROSS_PIPE: 0,
		Global.PC.INVERTER: 1
	},
	8: {
		Global.PC.SIMPLE_PIPE: 24,
		Global.PC.TURN_PIPE: 9,
		Global.PC.MIXER: 4,
		Global.PC.CROSS_PIPE: 1,
		Global.PC.INVERTER: 3
	},
	9: {
		Global.PC.SIMPLE_PIPE: 36,
		Global.PC.TURN_PIPE: 8,
		Global.PC.MIXER: 4,
		Global.PC.CROSS_PIPE: 0,
		Global.PC.INVERTER: 2
	},
	10: {
		Global.PC.SIMPLE_PIPE: 45,
		Global.PC.TURN_PIPE: 24,
		Global.PC.MIXER: 10,
		Global.PC.CROSS_PIPE: 5,
		Global.PC.INVERTER: 2
	},
}

signal quantity_changed(piece)
signal level_complete(id)
signal level_discomplete(id)
signal level_recomplete(id)
signal camera_moved


func is_piece_available(piece: Global.PC) -> bool:
	return quantities[piece] > 0


func update_quantity(piece: Global.PC, delta: int) -> void:
	quantities[piece] += delta
	emit_signal("quantity_changed", piece)


func _on_level_complete(level: int) -> void:
	if level in rewards:
		for piece in rewards[level]:
			update_quantity(piece, rewards[level][piece])

	emit_signal("level_complete", level)


func _on_level_discomplete(level: int) -> void:
	emit_signal("level_discomplete", level)


func _on_level_recomplete(level: int) -> void:
	emit_signal("level_recomplete", level)


func _on_camera_moved() -> void:
	emit_signal("camera_moved")
