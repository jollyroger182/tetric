extends Control

const LevelItem = preload("res://scenes/components/level_item/level_item.tscn")

@onready var custom_level_picker = $CustomLevelPicker
@onready var container = $ScrollContainer/VBoxContainer

@onready var sfx = $SFX


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for level_name in DirAccess.get_files_at("res://assets/levels"):
		var path = "res://assets/levels/" + level_name
		_load_level(path)


func _load_level(path: String):
	var level = GameFile.load_file(path)
	if not level["success"]:
		push_warning("Failed to load level ", level, ", error: ", level)
		return
	var data = {
		"title": level["title"],
		"file": path
	}
	
	var node = LevelItem.instantiate()
	node.level = data
	node.hover.connect(_on_button_mouse_entered)
	node.selected.connect(_on_level_selected)
	container.add_child(node)


func _on_level_selected(level: Dictionary):
	await sfx.play_sound("success", true)
	GameState.playing_level = level["file"]
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func _on_button_mouse_entered() -> void:
	sfx.play_sound("select")


func _on_back() -> void:
	await sfx.play_sound("cancel", true)
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_load_custom_level() -> void:
	await sfx.play_sound("confirm", true)
	custom_level_picker.pick()


func _on_custom_level_selected(path: String) -> void:
	_load_level(path)
