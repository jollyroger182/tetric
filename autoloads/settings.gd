extends Node

const FILE_PATH = "user://settings.cfg"
var config = ConfigFile.new()

var offset = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var err = config.load(FILE_PATH)
	if err != OK:
		push_warning("Error ", err, " loading config file")
		DirAccess.remove_absolute(FILE_PATH)
	
	offset = config.get_value("gameplay", "offset", 0)


func save():
	config.set_value("gameplay", "offset", offset)
	config.save(FILE_PATH)
