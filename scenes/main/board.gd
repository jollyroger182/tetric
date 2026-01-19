extends Node2D
class_name Board

const Tetromino = preload("res://scenes/components/tetromino/tetromino.tscn")
const Cell = preload("res://scenes/components/tetromino/cell.tscn")

@export var conductor: Conductor
@export var scorekeeper: Scorekeeper
@export var rhythm: Rhythm

signal piece_spawned(piece: Tetromino)
signal game_over

var filled_tiles: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(40, 40)


func _draw():
	var width = Constants.BOARD_SIZE.x * Constants.SIZE + 10
	var height = Constants.BOARD_SIZE.y * Constants.SIZE + 10
	
	var rect = Rect2(-5, -5, width, height)
	
	draw_rect(rect, Color.WHITE, false, 2)


func _add_filled_tile(location: Vector2i, color: Color):
	if location in filled_tiles:
		return
	
	var sprite = Cell.instantiate()
	sprite.position = location * Constants.SIZE
	sprite.modulate = color
	add_child(sprite)
	
	filled_tiles[location] = sprite


func _on_piece_landed(piece: Tetromino):
	piece.queue_free()
	if not can_place(piece.offset, piece.offsets):
		game_over.emit()
		return
	for tile in piece.offsets:
		_add_filled_tile(piece.offset + tile, piece.modulate)
	_check_filled_rows()
	spawn_piece()


func _check_filled_rows():
	var cleared_rows = []
	for y in range(Constants.BOARD_SIZE.y):
		var is_cleared = true
		for x in range(Constants.BOARD_SIZE.x):
			if Vector2i(x, y) not in filled_tiles:
				is_cleared = false
				break
		if not is_cleared:
			continue
		
		cleared_rows.append(y)
		for x in range(Constants.BOARD_SIZE.x):
			var offset = Vector2i(x, y)
			var node = filled_tiles[offset]
			node.queue_free()
			filled_tiles.erase(offset)
			
	if not cleared_rows.is_empty():
		var num_cleared_rows = cleared_rows.size()
		scorekeeper.cleared_rows(num_cleared_rows)
		
		var new_filled_tiles := {}
		# calculate how much each row needs to shift
		var last_shift = 0
		var shifts = []
		shifts.resize(Constants.BOARD_SIZE.y)
		shifts.fill(0)
		for y in range(Constants.BOARD_SIZE.y-1, 0, -1):
			if y in cleared_rows:
				last_shift += 1
			shifts[y] = last_shift
		for key in filled_tiles:
			var new_offset = Vector2i(key.x, key.y + shifts[key.y])
			var sprite = filled_tiles[key]
			sprite.position = new_offset * Constants.SIZE
			new_filled_tiles[new_offset] = sprite
		filled_tiles = new_filled_tiles


func spawn_piece():
	var tetromino: Tetromino = Tetromino.instantiate()
	tetromino.board = self
	tetromino.rhythm = rhythm
	tetromino.name = "ActivePiece"
	tetromino.landed.connect(_on_piece_landed)
	tetromino.offset.x = Constants.BOARD_SIZE.x/2-1
	add_child(tetromino)
	piece_spawned.emit(tetromino)


func can_place(offset: Vector2i, piece: Array[Vector2i]) -> bool:
	for tile in piece:
		var pos = offset + tile
		if (
			pos in filled_tiles or
			pos.x < 0 or
			pos.x >= Constants.BOARD_SIZE.x or
			pos.y < 0 or
			pos.y >= Constants.BOARD_SIZE.y
		):
			return false
	return true
