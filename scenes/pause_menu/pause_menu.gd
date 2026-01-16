extends Panel

signal resume


func _on_resume() -> void:
	resume.emit()


func _on_quit() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
