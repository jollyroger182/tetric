extends Panel

signal resume


#func _process(_delta: float):
	#if Input.is_action_just_pressed("pause"):
		#print('unpaused')
		#_on_resume()


func _on_resume() -> void:
	resume.emit()


func _on_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
