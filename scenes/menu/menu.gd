extends Control

@onready var sfx = $SFX


func _on_play():
	sfx.play_sound("success")
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_level_editor() -> void:
	get_tree().change_scene_to_file("res://scenes/level_editor/level_editor.tscn")


func _on_quit():
	get_tree().quit()


func _on_mouse_entered_button():
	sfx.play_sound("select")
