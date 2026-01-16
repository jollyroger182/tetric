extends Node2D

@onready var player = $AudioStreamPlayer


func _ready() -> void:
	$FilePicker.pick()


func _process(_delta: float) -> void:
	$Label.text = str(player.playback_pos)


func _on_button_pressed() -> void:
	if player.playing:
		player.pause()
	else:
		player.unpause()


func _on_file_picker_selected(path: String) -> void:
	print("file:", path)


func _on_file_picker_cancelled() -> void:
	print("CANCELLED")
