@tool
extends Node


enum CLR {EMPTY, RED, BLUE, YELLOW, GREEN, ORANGE, PURPLE, BLACK}

var RGB: Dictionary = {
	CLR.EMPTY: Color.TRANSPARENT,
	CLR.RED: Color("#f91552"),
	CLR.BLUE: Color("#18aded"),
	CLR.YELLOW: Color("#f5b829"),
	CLR.GREEN: Color("#8bd938"),
	CLR.ORANGE: Color("#f05e0f"),
	CLR.PURPLE: Color("#6950f1"),
	CLR.BLACK: Color("#212121")
}

enum PC {FIXED, SIMPLE_PIPE, TURN_PIPE, MIXER, CROSS_PIPE, INVERTER}

var SCENE: Dictionary = {
	PC.SIMPLE_PIPE: preload("res://Pieces/Playable/SimplePipe/simple_pipe.tscn"),
	PC.TURN_PIPE: preload("res://Pieces/Playable/TurnPipe/turn_pipe.tscn"),
	PC.MIXER: preload("res://Pieces/Playable/Mixer/mixer.tscn"),
	PC.CROSS_PIPE: preload("res://Pieces/Playable/CrossPipe/cross_pipe.tscn"),
	PC.INVERTER: preload("res://Pieces/Playable/Inverter/inverter.tscn")
}


func is_primary(color: CLR) -> bool:
	return color in [CLR.RED, CLR.BLUE, CLR.YELLOW]


func is_secondary(color: CLR) -> bool:
	return color in [CLR.GREEN, CLR.ORANGE, CLR.PURPLE]


func mix(col1: CLR, col2: CLR) -> CLR:
	if col1 == col2:
		return col1

	if is_primary(col1) and is_primary(col2):
		if col1 + col2 == CLR.RED + CLR.BLUE:
			return CLR.PURPLE
		if col1 + col2 == CLR.RED + CLR.YELLOW:
			return CLR.ORANGE
		if col1 + col2 == CLR.BLUE + CLR.YELLOW:
			return CLR.GREEN

	if is_secondary(col1) and is_secondary(col2):
		return CLR.BLACK

	return CLR.EMPTY

func invert(color: CLR) -> CLR:
	var inverses: Dictionary = {
		CLR.RED: CLR.GREEN,
		CLR.BLUE: CLR.ORANGE,
		CLR.YELLOW: CLR.PURPLE,
		CLR.GREEN: CLR.RED,
		CLR.ORANGE: CLR.BLUE,
		CLR.PURPLE: CLR.YELLOW
	}

	if not color in inverses:
		return CLR.EMPTY

	return inverses[color]
