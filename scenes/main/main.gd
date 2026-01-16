extends Node2D

@onready var board: Board = $Board
@onready var pause_manager = $PauseManager


func _ready() -> void:
	board.spawn_piece()


func _on_resume() -> void:
	pause_manager.toggle_pause()
