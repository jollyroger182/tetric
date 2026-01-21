extends Control

const hover_theme = preload("res://resources/theme_button_hover.tres")

@export var level: Dictionary

signal hover
signal selected(level: Dictionary)

@onready var title_label = $MarginContainer/HBoxContainer/TitleLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_label.text = level["title"]


func _on_button_mouse_entered() -> void:
	hover.emit()


func _on_button_pressed() -> void:
	selected.emit(level)
