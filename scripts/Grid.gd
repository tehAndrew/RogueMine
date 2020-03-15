extends Node2D

class_name Grid

var nodes = []
var timer = 0
var p = 0
var player = null

func _ready():
	set_position(Vector2(0, 0))
	
	var mine_class = preload("res://scenes/GridObjects/Mine.tscn")
	var player_class = preload("res://scenes/GridObjects/Player.tscn")
	
	for y in range(0,16):
		var row = []
		for x in range(0,16):
			var node : GridNode = GridNode.new(Vector2(32 * x + 16, 32 * y + 16))
			node.uncover()
			add_child(node)
			row.append(node)
		nodes.append(row)
	
	player = player_class.instance()
	nodes[0][0].place_object(player)

func _process(delta):
	if (timer >= 1):
		nodes[p][0].take_object(player)
		p = (p+1)%16
		nodes[p][0].place_object(player)
		timer = 0;
	timer += delta

