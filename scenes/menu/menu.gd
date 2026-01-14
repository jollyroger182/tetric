extends Control

@onready var play_button = $ButtonsContainer/PlayButton
@onready var quit_button = $ButtonsContainer/QuitButton


func _ready() -> void:
	play_button.pressed.connect(_on_play)
	quit_button.pressed.connect(_on_quit)


func _on_play():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_quit():
	get_tree().quit()
