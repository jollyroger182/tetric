extends Node

# level stored in memory:
# { "title": "", "notes": [0], "music_name": "file.wav", "music_data": ... }


func _create_error(error: String):
	return {
		"success": false,
		"error": error
	}


func load_file(path: String):
	var reader = ZIPReader.new()
	var err = reader.open(path)
	if err != OK:
		return _create_error("file is not a valid zip archive")
	
	if not reader.file_exists("level.json"):
		return _create_error("level.json file not found in archive")
	var level_file = reader.read_file("level.json").get_string_from_utf8()
	if level_file.length() == 0:
		return _create_error("level.json is not valid text")
	var level = JSON.parse_string(level_file)
	if level == null:
		return _create_error("level.json is not valid JSON")
	
	var music_name = level["music_name"]
	if music_name == null or music_name is not String:
		return _create_error("music filename not found in level.json")
	var music_data = reader.read_file(music_name)
	
	reader.close()
	
	return {
		"success": true,
		"title": level["title"],
		"notes": level["notes"],
		"music_name": music_name,
		"music_data": music_data,
	}


func save_file(level: Variant, path: String):
	var writer = ZIPPacker.new()
	var err = writer.open(path)
	if err != OK:
		return err
	
	var level_json = {
		"title": level["title"],
		"notes": level["notes"],
		"music_name": level["music_name"]
	}
	var level_data = JSON.stringify(level_json).to_utf8_buffer()
	writer.start_file("level.json")
	writer.write_file(level_data)
	writer.close_file()
	
	writer.start_file(level["music_name"])
	writer.write_file(level["music_data"])
	writer.close_file()

	writer.close()
	return OK 
