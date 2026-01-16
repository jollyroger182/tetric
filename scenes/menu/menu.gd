extends Control


func _on_play():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit():
	get_tree().quit()
