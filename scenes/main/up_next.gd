extends Control

const Tetromino = preload("res://scenes/components/tetromino/tetromino.tscn")


func update():
	var pieces = Randomizer.up_next
	for node in get_children():
		node.queue_free()
	for i in range(3):
		var piece = pieces[i]
		var tetromino: Tetromino = Tetromino.instantiate()
		tetromino.shape = piece
		
		var max_x = 0
		var max_y = 0
		for tile in piece["tiles"]:
			max_x = max(max_x, tile.x)
			max_y = max(max_y, tile.y)
		var x = (size.x - max_x*32 - 32) / 2
		var y = i*3*32 + (2*32-max_y*32)/2
		tetromino.position = Vector2(x, y)
		
		add_child(tetromino)
