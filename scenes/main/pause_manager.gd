extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()


func toggle_pause():
	get_tree().paused = not get_tree().paused
	%PauseMenu.visible = get_tree().paused
