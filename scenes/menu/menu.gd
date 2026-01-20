extends Control

@onready var game_title = $VBoxContainer/TitleContainer/GameTitle
@onready var sfx = $SFX


func _ready():
	var tween = create_tween()
	tween.tween_property(game_title, "theme_override_font_sizes/font_size", 80, 2.0/3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(game_title, "theme_override_font_sizes/font_size", 60, 2.0/3).set_ease(Tween.EASE_IN_OUT)
	tween.set_loops()
	tween.play()


func _on_play():
	sfx.play_sound("success")
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_level_editor() -> void:
	get_tree().change_scene_to_file("res://scenes/level_editor/level_editor.tscn")


func _on_quit():
	sfx.play_sound("confirm")
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()


func _on_mouse_entered_button():
	sfx.play_sound("select")
