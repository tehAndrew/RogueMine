extends Node2D

class_name Grid

var _size : Vector2
var _cell_amount : Vector2
var _cell_size : Vector2
var _grid_node_arr : Array

# Temporary
var p_x = 0
var p_y = 0
var timer = 0
var player = null

# Will be a constructor later
func _ready():
	_size = Vector2(512, 512);
	_cell_amount = Vector2(32, 32)
	_cell_size = Vector2(_size.x / _cell_amount.x, _size.y / _cell_amount.y)
	_generate_grid_node_arr()
	player = preload("res://scenes/GridObjects/Player.tscn").instance()
	_grid_node_arr[0][0].place_object(player)

# Helper function, private
func _generate_grid_node_arr() -> void:
	for x in range(0, _cell_amount.x):
		var col = []
		for y in range(0, _cell_amount.y):
			var cell_pos = Vector2(_cell_size.x * x + _cell_size.x / 2, _cell_size.y * y + _cell_size.y / 2)
			var grid_node = GridNode.new(cell_pos, _cell_size)
			col.append(grid_node)
			add_child(grid_node)
			grid_node.uncover() # temporary, all nodes will start covered
		_grid_node_arr.append(col)

# Debug
func _draw():
	for x in range(1, _cell_amount.x):
		for y in range(1, _cell_amount.y):
			draw_circle (Vector2(x * _cell_size.x, y * _cell_size.y), 1, Color(0, 0, 0))

# Temporary
func _process(delta):
	if (timer >= 0.05):
		_grid_node_arr[p_x][p_y].take_object(player)
		if (p_x == _cell_amount.x - 1):
			p_y = fmod((p_y + 1), _cell_amount.y)
		p_x = fmod((p_x + 1), _cell_amount.x)
		_grid_node_arr[p_x][p_y].place_object(player)
		timer = 0;
	timer += delta