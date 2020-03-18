extends Node2D

# Includes ---
const Player = preload("res://scenes/GridObjects/Player.tscn")
const GridNode = preload("res://scenes/GridNode.tscn")

# Private members
var _size : Vector2
var _cell_amount : Vector2
var _cell_size : Vector2
var _grid_node_arr : Array

# temp
func _ready() -> void:
	init(Vector2(0, 0), Vector2(512, 512), Vector2(16, 16))
	_generate_grid_node_arr()
	spawn_player(Vector2(5, 2))

# Private helpers ---
func _generate_grid_node_arr() -> void:
	for x in range(0, _cell_amount.x):
		var grid_node : Node
		var cell_pos : Vector2
		var col : Array
		
		col = []
		for y in range(0, _cell_amount.y):
			grid_node = GridNode.instance()
			cell_pos = Vector2(_cell_size.x * x + _cell_size.x / 2, _cell_size.y * y + _cell_size.y / 2)
			grid_node.init(cell_pos, _cell_size)
			grid_node.uncover() # TEMP
			col.append(grid_node)
			add_child(grid_node)
			
		_grid_node_arr.append(col)

# Constructor
func init(pos : Vector2, size : Vector2, cell_amount : Vector2) -> void:
	set_position(pos)
	_size = size
	_cell_amount = cell_amount
	_cell_size = Vector2(_size.x / _cell_amount.x, _size.y / _cell_amount.y)

func spawn_player(var pos : Vector2):
	var player : Node = Player.instance()
	player.init(_cell_size)
	_grid_node_arr[pos.x][pos.y].place_object(player)
	player.connect("request_movement", self, "_on_Player_request_movement")

func _on_Player_request_movement(direction : String, obj_id : Node):
	var obj_pos = obj_id.get_pos()
	
	match direction:
		"right":
			if (obj_pos.x + 1 < _cell_amount.x):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x + 1][obj_pos.y].place_object(obj_id)
		"left":
			if (obj_pos.x - 1 >= 0):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x - 1][obj_pos.y].place_object(obj_id)
		"down":
			if (obj_pos.y + 1 < _cell_amount.y):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x][obj_pos.y + 1].place_object(obj_id)
		"up":
			if (obj_pos.y - 1 >= 0):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x][obj_pos.y - 1].place_object(obj_id)

# Debug
func _draw() -> void:
	for x in range(1, _cell_amount.x):
		for y in range(1, _cell_amount.y):
			draw_circle (Vector2(x * _cell_size.x, y * _cell_size.y), 1, Color(0, 0, 0))
