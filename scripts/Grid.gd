extends Node2D

class_name Grid

var _size : Vector2
var _cell_amount : Vector2
var _cell_size : Vector2
var _grid_node_arr : Array

# Will be a constructor later
func _ready():
	# Init
	_size = Vector2(512, 512);
	_cell_amount = Vector2(16, 16)
	_cell_size = Vector2(_size.x / _cell_amount.x, _size.y / _cell_amount.y)
	_generate_grid_node_arr()
	
	# Place player - Temporary
	var player = preload("res://scenes/GridObjects/Player.tscn").instance()
	_grid_node_arr[0][0].place_object(player)
	
	# Connect signals
	player.connect("request_movement", self, "_on_Player_request_movement")

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

func _on_Player_request_movement(direction, obj_id):
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
func _draw():
	for x in range(1, _cell_amount.x):
		for y in range(1, _cell_amount.y):
			draw_circle (Vector2(x * _cell_size.x, y * _cell_size.y), 1, Color(0, 0, 0))