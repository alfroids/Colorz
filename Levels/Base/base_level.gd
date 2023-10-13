@tool
extends TileMap


@export var ID: int = -1

@export var DIMENSIONS: Vector2 = Vector2(15, 10):
	set(d):
		DIMENSIONS = d
		$Border.size = d * CELL_SIZE

@export var CELL_SIZE: int = 64:
	set(c):
		CELL_SIZE = c
		$Border.size = DIMENSIONS * c

@onready var grid_cell := preload("res://Levels/Base/grid_cell.tscn")
@onready var GRID: Dictionary = {}
@onready var SOURCES: Array[Vector2]
@onready var BUCKETS: Array[Vector2]
@onready var complete = false
@onready var available = false
@onready var half_cell: Vector2 = CELL_SIZE * Vector2.ONE / 2
@onready var half_size: Vector2 = CELL_SIZE * DIMENSIONS / 2

signal level_complete(id)
signal level_discomplete(id)
signal level_recomplete(id)


func _ready():
	tile_set.tile_size = CELL_SIZE * Vector2.ONE

	for source in $Sources.get_children():
		var coord: Vector2 = local_to_map(source.position)
		GRID[coord] = source
		SOURCES.append(coord)

	for bucket in $Buckets.get_children():
		var coord: Vector2 = local_to_map(bucket.position)
		GRID[coord] = bucket
		BUCKETS.append(coord)

	for wall in $Walls.get_children():
		var coord: Vector2 = local_to_map(wall.position)
		GRID[coord] = wall

	if not Engine.is_editor_hint():
		level_complete.connect(ResourceManager._on_level_complete)
		ResourceManager.level_complete.connect(_on_level_complete)
		level_discomplete.connect(ResourceManager._on_level_discomplete)
		ResourceManager.level_discomplete.connect(_on_level_discomplete)
		level_recomplete.connect(ResourceManager._on_level_recomplete)
		ResourceManager.level_recomplete.connect(_on_level_recomplete)

		if ID > 0:
			$Lock.visible = true
		else:
			available = true
		$Border.visible = false

		draw_cells()


func draw_cells() -> void:
	for x in range(DIMENSIONS.x):
		for y in range(DIMENSIONS.y):
			var cell: GridCell = grid_cell.instantiate()
			cell.size = CELL_SIZE * Vector2.ONE
			cell.coord = Vector2(x, y)
			cell.position = map_to_local(Vector2(x, y)) - half_cell
			cell.piece_placed.connect(place_piece)
			cell.piece_removed.connect(remove_piece)
			cell.piece_rotated.connect(rotate_piece)
			$Cells.add_child(cell)


func place_piece(coord: Vector2) -> void:
	if ResourceManager.is_piece_available(ResourceManager.selected_piece):
		if coord in GRID:
#			var r: bool = remove_piece(coord)
#
#			if not r:
#				return
			return

		var piece: Playable = Global.SCENE[ResourceManager.selected_piece].instantiate()
		ResourceManager.update_quantity(ResourceManager.selected_piece, -1)
		piece.position = map_to_local(coord)
		GRID[coord] = piece
		$Pieces.add_child(piece)
		update_pieces()


func remove_piece(coord: Vector2) -> bool:
	if coord in GRID:
		var piece: Piece = GRID[coord]

		if piece is Fixed:
			return false

		GRID.erase(coord)
		ResourceManager.update_quantity(piece.ID, +1)
		piece.queue_free()
		update_pieces()

	return true


func rotate_piece(coord: Vector2) -> void:
	if coord in GRID:
		var piece: Piece = GRID[coord]

		if piece is Fixed:
			return

		piece.rotate_piece()
		update_pieces()


func update_pieces() -> void:
#	print("Update pieces.")
	reset_pieces()

	for coord in SOURCES:
		var source: Source = GRID[coord]
		var output: Array = source.get_output()
		var direction: Vector2 = output[0]
		var color: Global.CLR = output[1]

		send_paint(coord + direction, - direction, color)

	check_buckets()


func reset_pieces() -> void:
	for piece in $Pieces.get_children():
		piece.reset_connections()

	for bucket in $Buckets.get_children():
		bucket.reset_connections()


func send_paint(coord: Vector2, direction: Vector2, color: Global.CLR) -> void:
	if coord in GRID:
		var piece: Piece = GRID[coord]
		var output: Array = piece.receive_paint(direction, color)

		for o in output:
			var dir: Vector2 = o[0]
			var clr: Global.CLR = o[1]

			send_paint(coord + dir, - dir, clr)


func check_buckets() -> void:
	for coord in BUCKETS:
		var bucket: Bucket = GRID[coord]
		if not bucket.fulfilled:
			if complete:
				emit_signal("level_discomplete", ID)
			return

	if not complete:
		complete = true
		emit_signal("level_complete", ID)
	else:
		emit_signal("level_recomplete", ID)


func _on_level_complete(id: int):
	if id == ID - 1:
		available = true
		$Lock.visible = false


func _on_level_discomplete(id: int):
	if id < ID and available:
		$Lock.visible = true


func _on_level_recomplete(id: int):
	if id < ID and available:
		$Lock.visible = false
