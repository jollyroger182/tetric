extends Node2D
class_name LevelEditor

const play_icon = preload("res://assets/images/icon_play.png")
const pause_icon = preload("res://assets/images/icon_pause.png")
const backward_icon = preload("res://assets/images/icon_backward.png")
const forward_icon = preload("res://assets/images/icon_forward.png")

@onready var play_button = $UI/ButtonsContainer/PlayButton
@onready var ui_title = $UI/Title
@onready var ui_notes = $UI/Notes

@onready var player = $Conductor
@onready var undo_manager = $UndoManager
@onready var file_saver = $FileSaver

var _music_stream: AudioStreamWAV

var _name: String = "test.wav"

# loading stuff

func _ready() -> void:
	$FilePicker.pick()


func _on_file_picker_selected(path: String) -> void:
	var level = GameFile.load_file(path)
	
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
		play_button.icon = pause_icon if player.playing else play_icon

# perform action

func _perform_action(action):
	var type = action["type"]
	match type:
		"add":
			var time = action["time"]
			ui_notes.add_note(time)
		"delete":
			var time = action["time"]
			ui_notes.delete_note(time)


func _undo_action(action):
	var type = action["type"]
	match type:
		"add":
			var time = action["time"]
			ui_notes.delete_note(time)
		"delete":
			var time = action["time"]
			ui_notes.add_note(time)


func perform_action(action):
	_perform_action(action)
	undo_manager.push_action(action)


func undo():
	var action = undo_manager.undo()
	if action:
		_undo_action(action)


func redo():
	var action = undo_manager.redo()
	if action:
		_perform_action(action)


func seek(offset: float):
	if player.stream_paused:
		player.unpause()
	player.seek(max(0, min(_music_stream.get_length(), player.playback_pos + offset)))


# button events

func _on_play() -> void:
	if player.playing:
		player.pause()
	else:
		player.unpause()


func _on_seek_back() -> void:
	seek(-5)


func _on_seek_forward() -> void:
	seek(5)


func _on_save() -> void:
	_music_stream.save_to_wav("user://tmp.wav")
	var music_data = FileAccess.get_file_as_bytes("user://tmp.wav")
	
	var level = {
		"title": _name,
		"notes": ui_notes.notes,
		"music_name": _name,
		"music_data": music_data
	}
	
	GameFile.save_file(level, "user://level.zip")
	
	var data = FileAccess.get_file_as_bytes("user://level.zip")
	file_saver.save(data, "level.zip", "application/zip", "Saved game file")


func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_choose() -> void:
	get_tree().reload_current_scene()

# events

func _on_note_deleted(time: float) -> void:
	undo_manager.push_action({ "type": "delete", "time": time })


func _on_input_play_pause() -> void:
	if _music_stream:
		_on_play()


func _on_input_add_note() -> void:
	if _music_stream:
		var time = max(0, min(_music_stream.get_length(), player.playback_pos - Settings.offset / 1000.0))
		perform_action({ "type": "add", "time": time })


func _on_input_redo() -> void:
	redo()


func _on_input_undo() -> void:
	undo()


func _on_input_seek(amount: float) -> void:
	if _music_stream:
		seek(amount)
