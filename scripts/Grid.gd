extends Node2D

# Includes ---
const Player = preload("res://scenes/GridObjects/Player.tscn")
const Mine = preload("res://scenes/GridObjects/Mine.tscn")
const GridNode = preload("res://scenes/GridNode.tscn")

# Private members ---
var _size : Vector2
var _cell_amount : Vector2
var _cell_size : Vector2
var _grid_node_arr : Array

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
			col.append(grid_node)
			add_child(grid_node)
			get_node("GridTileMap").set_cell(x, y, 47)
			get_node("GridTileMap").update_bitmask_area(Vector2(x, y))
			
		_grid_node_arr.append(col)

func _uncover(pos : Vector2) -> void:
	_uncover_rec(pos)

func _uncover_rec(pos : Vector2) -> void:
	if (!_is_inside_grid(pos)):
		push_error("Pos is outside of grid.")
		get_tree().quit()
	
	if (_grid_node_arr[pos.x][pos.y].is_covered()):
		_grid_node_arr[pos.x][pos.y].uncover()
		get_node("GridTileMap").set_cell(pos.x, pos.y, -1)
		get_node("GridTileMap").update_bitmask_area(pos)
		
		if (_grid_node_arr[pos.x][pos.y]._neighboring_mines == 0):
			for x_offset in range(-1, 2):
				for y_offset in range(-1, 2):
					if (!(x_offset == 0 && y_offset == 0) && _is_inside_grid(pos + Vector2(x_offset, y_offset))):
						_uncover(pos + Vector2(x_offset, y_offset))

func _is_inside_grid(pos : Vector2) -> bool:
	return pos.x >= 0 && pos.y >= 0 && pos.x < _cell_amount.x && pos.y < _cell_amount.y

func _init_tile_map():
	var x_scale : float = _cell_size.x / get_node("GridTileMap").cell_size.x
	var y_scale : float = _cell_size.y / get_node("GridTileMap").cell_size.y
	get_node("GridTileMap").set_scale(Vector2(x_scale, y_scale))

# Constructor
func init(pos : Vector2, size : Vector2, cell_amount : Vector2) -> void:
	set_position(pos)
	_size = size
	_cell_amount = cell_amount
	_cell_size = Vector2(_size.x / _cell_amount.x, _size.y / _cell_amount.y)
	_generate_grid_node_arr()
	_init_tile_map()

func spawn_player(var pos : Vector2):
	if (!_is_inside_grid(pos)):
		push_error("Can't spawn player outside of grid.")
		get_tree().quit()
	
	var player : Node = Player.instance()
	player.init(_cell_size)
	_grid_node_arr[pos.x][pos.y].place_object(player)
	_uncover(pos)
	player.connect("request_movement", self, "_on_Player_request_movement")

func spawn_mine(var pos : Vector2):
	if (!_is_inside_grid(pos)):
		push_error("Can't spawn mine outside of grid.")
		get_tree().quit()
	
	var mine : Node = Mine.instance()
	mine.init(_cell_size)
	_grid_node_arr[pos.x][pos.y].place_object(mine)
	
	# Notify cells in eight direction about this new mines existence.
	for x_offset in range(-1, 2):
		for y_offset in range(-1, 2):
			if (!(x_offset == 0 && y_offset == 0) && _is_inside_grid(pos + Vector2(x_offset, y_offset))):
				_grid_node_arr[pos.x + x_offset][pos.y + y_offset].inc_neighboring_mines()

func _on_Player_request_movement(direction : String, obj_id : Node) -> void:
	var obj_pos = obj_id.get_pos()
	
	match direction:
		"right":
			if (obj_pos.x + 1 < _cell_amount.x):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x + 1][obj_pos.y].place_object(obj_id)
				_uncover(Vector2(obj_pos.x + 1, obj_pos.y))
		"left":
			if (obj_pos.x - 1 >= 0):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x - 1][obj_pos.y].place_object(obj_id)
				_uncover(Vector2(obj_pos.x - 1, obj_pos.y))
		"down":
			if (obj_pos.y + 1 < _cell_amount.y):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x][obj_pos.y + 1].place_object(obj_id)
				_uncover(Vector2(obj_pos.x, obj_pos.y + 1))
		"up":
			if (obj_pos.y - 1 >= 0):
				_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
				_grid_node_arr[obj_pos.x][obj_pos.y - 1].place_object(obj_id)
				_uncover(Vector2(obj_pos.x, obj_pos.y - 1))
