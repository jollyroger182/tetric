extends Node2D

const GameFile = preload("res://utils/game_file.gd")

@onready var board: Board = $Board
@onready var rhythm = $Rhythm
@onready var pause_manager = $PauseManager
@onready var conductor = $Conductor
@onready var scorekeeper = $Scorekeeper

@onready var playing_label = $UI/ScorePanel/PlayingLabel
@onready var score_label = $UI/ScorePanel/ScoreLabel
@onready var total_label = $UI/ScorePanel/TotalLabel
@onready var hits_label = $UI/ScorePanel/HitsLabel
@onready var misses_label = $UI/ScorePanel/MissesLabel
@onready var up_next = $UI/ScorePanel/Next

var level: Dictionary


func _ready() -> void:
	print("playing level: ", GameState.playing_level)
	
	var game_file = GameFile.new()
	level = game_file.load_file(GameState.playing_level)
	if not level["success"]:
		print("failed to load level: ", level)
		get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
		return
	
	var stream = AudioStreamWAV.load_from_buffer(level["music_data"])
	conductor.set_audio(stream)
	conductor.unpause()
	
	playing_label.text = level["title"]
	
	Randomizer.reset()
	board.spawn_piece()
	
	rhythm.load_level(level)


func _on_resume() -> void:
	pause_manager.toggle_pause()


func _on_score_changed(_old: int, new: int) -> void:
	score_label.text = str(new)


func _on_game_over() -> void:
	print("game over")
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_piece_spawned(piece: Tetromino) -> void:
	up_next.update()
