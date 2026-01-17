extends Node2D
class_name LevelEditor

var GameFile = preload("res://utils/game_file.gd")

@onready var player = $Conductor
@onready var play_button = $UI/ButtonsContainer/PlayButton
@onready var ui_title = $UI/Title
@onready var ui_notes = $UI/Notes

var _music_stream: AudioStreamWAV

var _name: String = "test.wav"


func _ready() -> void:
	$FilePicker.pick()


func _on_file_picker_selected(path: String) -> void:
	var game_file = GameFile.new()
	var level = game_file.load_file(path)
	
	if level["success"]:
		# selected a level zip file
		_name = level["music_name"]
		# title
		for note in level["notes"]:
			ui_notes.add_note(note)
		_music_stream = AudioStreamWAV.load_from_buffer(level["music_data"])
	else:
		# probably a wav file
		var parts = path.split("/")
		_name = parts[parts.size()-1]
		_music_stream = AudioStreamWAV.load_from_file(path)
	
	player.set_audio(_music_stream)
	ui_title.text = "Currently editing: " + _name
	ui_notes.update_size()


func _on_file_picker_cancelled() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _process(_delta: float) -> void:
	if _music_stream:
		play_button.text = "⏸️" if player.playing else "▶️"

# button events

func _on_play() -> void:
	if player.playing:
		player.pause()
	else:
		player.unpause()


func _on_seek_back() -> void:
	if player.stream_paused:
		player.unpause()
	player.seek(max(0, player.playback_pos - 5))


func _on_seek_forward() -> void:
	if player.stream_paused:
		player.unpause()
	player.seek(min(_music_stream.get_length(), player.playback_pos + 5))


func _on_save() -> void:
	_music_stream.save_to_wav("user://tmp.wav")
	var music_data = FileAccess.get_file_as_bytes("user://tmp.wav")
	
	var level = {
		"title": _name,
		"notes": ui_notes.notes,
		"music_name": _name,
		"music_data": music_data
	}
	
	var game_file = GameFile.new()
	game_file.save_file(level, "user://level.zip")
	
	if OS.has_feature("web"):
		var data = FileAccess.get_file_as_bytes("user://level.zip")
		JavaScriptBridge.download_buffer(data, "level.zip", "application/zip")
	else:
		# TODO prompt save
		print("Saved to user data folder")


func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_choose() -> void:
	get_tree().reload_current_scene()

# keyboard events

func _on_play_pause() -> void:
	_on_play()


func _on_add_note() -> void:
	ui_notes.add_note(player.playback_pos)
