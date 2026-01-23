extends Panel

@onready var sfx = $SFX


func _on_main_menu() -> void:
	await sfx.play_sound("cancel", true)
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_button_mouse_entered() -> void:
	sfx.play_sound("select")
