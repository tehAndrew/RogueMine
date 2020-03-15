extends Node2D

class_name Grid

var nodes = []

func _ready():
	set_position(Vector2(0, 0))
	
	var mine_class = preload("res://scenes/GridObjects/Mine.tscn")
	var player_class = preload("res://scenes/GridObjects/Player.tscn")
	
	for y in range(0,16):
		var row = []
		for x in range(0,16):
			var node : GridNode = GridNode.new()
			node.set_position(Vector2(32 * x + 16, 32 * y + 16))
			node.uncover()
			add_child(node)
			row.append(node)
		nodes.append(row)
	
	for y in range(0,16):
		for x in range(0,16):
			if (x % 2 == 0):
				var mine = mine_class.instance()
				add_child(mine)
				nodes[y][x].place_object(mine)
			else:
				var player = player_class.instance()
				add_child(player)
				nodes[y][x].place_object(player)