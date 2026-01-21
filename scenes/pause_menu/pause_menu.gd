extends Panel

signal resume

@onready var sfx = $SFX


func _on_resume() -> void:
	await sfx.play_sound("confirm", true)
	resume.emit()


func _on_quit() -> void:
	await sfx.play_sound("cancel", true)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_button_mouse_entered() -> void:
	sfx.play_sound("select")
