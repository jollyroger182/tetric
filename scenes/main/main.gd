extends Node2D

@onready var board: Board = $Board
@onready var rhythm = $Rhythm
@onready var pause_manager = $PauseManager
@onready var conductor = $Conductor
@onready var scorekeeper = $Scorekeeper

@onready var ui = $UI
@onready var playing_label = $UI/ScorePanel/PlayingLabel
@onready var score_label = $UI/ScorePanel/ScoreLabel
@onready var total_label = $UI/ScorePanel/TotalLabel
@onready var hits_label = $UI/ScorePanel/HitsLabel
@onready var misses_label = $UI/ScorePanel/MissesLabel
@onready var up_next = $UI/ScorePanel/Next

@onready var score_layer = $ScoreLayer
@onready var score_name = $ScoreLayer/Panel/VBoxContainer/NameLabel
@onready var score_total = $ScoreLayer/Panel/VBoxContainer/Stats/Notes/Value
@onready var score_hits = $ScoreLayer/Panel/VBoxContainer/Stats/Hits/Value
@onready var score_misses = $ScoreLayer/Panel/VBoxContainer/Stats/Misses/Value
@onready var score_score = $ScoreLayer/Panel/VBoxContainer/Score/Value

@onready var sfx = $SFX


var level: Dictionary


func _ready() -> void:
	print("playing level: ", GameState.playing_level)
	
	level = GameFile.load_file(GameState.playing_level)
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


func _on_score_changed() -> void:
	score_label.text = str(scorekeeper.score)
	total_label.text = str(scorekeeper.hits + scorekeeper.misses)
	hits_label.text = str(scorekeeper.hits)
	misses_label.text = str(scorekeeper.misses)


func _on_game_over() -> void:
	print("game over")
	conductor.pause()
	pause_manager.set_process(false)
	ui.hide()
	score_layer.show()
	
	score_name.text = level["title"]
	score_total.text = str(scorekeeper.hits + scorekeeper.misses)
	score_hits.text = str(scorekeeper.hits)
	score_misses.text = str(scorekeeper.misses)
	score_score.text = str(scorekeeper.score)


func _on_piece_spawned(_piece: Tetromino) -> void:
	up_next.update()


func _on_music_finished() -> void:
	_on_game_over()


func _on_replay() -> void:
	await sfx.play_sound("confirm", true)
	get_tree().reload_current_scene()


func _on_menu() -> void:
	await sfx.play_sound("cancel", true)
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_button_mouse_entered() -> void:
	sfx.play_sound("select")
