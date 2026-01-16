extends Node2D
class_name Board

const Tetromino = preload("res://scenes/components/tetromino/tetromino.tscn")
const Cell = preload("res://scenes/components/tetromino/cell.tscn")

var filled_tiles: Array[Vector2i] = []


func _draw():
	var width = Constants.BOARD_SIZE.x * Constants.SIZE + 10
	var height = Constants.BOARD_SIZE.y * Constants.SIZE + 10
	
	var rect = Rect2(-width/2.0-5, -5, width, height)
	
	draw_rect(rect, Color.WHITE, false, 2)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = Constants.BOARD_SIZE.x * Constants.SIZE / 2.0 + 20
	position.y = \
		get_viewport().get_visible_rect().size.y \
		- Constants.BOARD_SIZE.y \
		* Constants.SIZE \
		- 20
	print(position.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _add_filled_tile(location: Vector2i):
	if location in filled_tiles:
		return
	filled_tiles.append(location)
	
	var sprite = Cell.instantiate()
	sprite.position = location * Constants.SIZE
	add_child(sprite)


func _on_piece_landed(piece: Tetromino):
	for tile in piece.offsets:
		_add_filled_tile(piece.offset + tile)
	piece.queue_free()
	spawn_piece()


func spawn_piece():
	var tetromino: Tetromino = Tetromino.instantiate()
	tetromino.board = self
	tetromino.name = "ActivePiece"
	tetromino.landed.connect(_on_piece_landed)
	add_child(tetromino)


func can_place(offset: Vector2i, piece: Array[Vector2i]) -> bool:
	for tile in piece:
		var pos = offset + tile
		if (
			pos in filled_tiles or
			pos.x < -Constants.BOARD_SIZE.x/2 or
			pos.x >= Constants.BOARD_SIZE.x/2 or
			pos.y < 0 or
			pos.y >= Constants.BOARD_SIZE.y
		):
			return false
	return true
