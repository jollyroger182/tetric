extends Control

@onready var game_title = $VBoxContainer/TitleContainer/GameTitle
@onready var sfx = $SFX

const BPM = 150.0


func _ready():
	var tween = create_tween()
	tween.tween_property(game_title, "theme_override_font_sizes/font_size", 80, 120/BPM).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(game_title, "theme_override_font_sizes/font_size", 60, 120/BPM).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
	tween.play()


func _on_play():
	#await sfx.play_sound("success", true)
	await sfx.play_sound("confirm", true)
	get_tree().change_scene_to_file("res://scenes/level_menu/level_menu.tscn")


func _on_level_editor() -> void:
	await sfx.play_sound("confirm", true)
	get_tree().change_scene_to_file("res://scenes/level_editor/level_editor.tscn")


func _on_quit():
	await sfx.play_sound("cancel", true)
	get_tree().quit()


func _on_settings() -> void:
	await sfx.play_sound("confirm", true)
	get_tree().change_scene_to_file("res://scenes/settings/settings.tscn")


func _on_mouse_entered_button():
	sfx.play_sound("select")
