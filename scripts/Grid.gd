extends Node2D

# Includes ---
const Player = preload("res://scenes/GridObjects/Player.tscn")
const Stairs = preload("res://scenes/GridObjects/Stairs.tscn")
const Mine = preload("res://scenes/GridObjects/Mine.tscn")
const GridNode = preload("res://scenes/GridNode.tscn")

# Constants ---
var CELL_SIZE : Vector2 = Vector2(32, 32)

# Private members ---
var _size : Vector2
var _cell_amount : Vector2
var _grid_node_arr : Array

# Private helpers ---
# Initializes the grid node array and the tilemap.
func _init_grid() -> void:
	for x in range(0, _cell_amount.x):
		var grid_node : Node
		var cell_pos : Vector2
		var col : Array
		
		col = []
		for y in range(0, _cell_amount.y):
			grid_node = GridNode.instance()
			cell_pos = Vector2(CELL_SIZE.x * x + CELL_SIZE.x / 2, CELL_SIZE.y * y + CELL_SIZE.y / 2)
			grid_node.init(cell_pos, CELL_SIZE)
			col.append(grid_node)
			add_child(grid_node)
			get_node("GridTileMap").set_cell(x, y, 0)
			get_node("GridTileMap").update_bitmask_area(Vector2(x, y))
			
		_grid_node_arr.append(col)

# Use DFS to uncover all nodes recursively, minesweeper style.
func uncover(pos : Vector2) -> void:
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
						uncover(pos + Vector2(x_offset, y_offset))

# Check wheter or not a position is inside of the grid.
func _is_inside_grid(pos : Vector2) -> bool:
	return pos.x >= 0 && pos.y >= 0 && pos.x < _cell_amount.x && pos.y < _cell_amount.y

# Constructor ---
func init(pos : Vector2, size : Vector2, cell_amount : Vector2) -> void:
	set_position(pos)
	_size = size
	_cell_amount = cell_amount
	_init_grid()

# Spawns a player at position pos. Terminates the program if the pos is out of
# index range.
func spawn_player(var pos : Vector2):
	if (!_is_inside_grid(pos)):
		push_error("Can't spawn player outside of grid.")
		get_tree().quit()
	
	# Setup player object
	var player : Node = Player.instance()
	_grid_node_arr[pos.x][pos.y].place_object(player)
	
	player.connect("request_movement", self, "_on_Player_request_movement")

# Spawns stairs at position pos. Terminates the program if the pos is out of
# index range.
func spawn_stairs(var pos : Vector2):
	if (!_is_inside_grid(pos)):
		push_error("Can't spawn stairs outside of grid.")
		get_tree().quit()
	
	# Setup stairs object
	var stairs : Node = Stairs.instance()
	_grid_node_arr[pos.x][pos.y].place_object(stairs)

# Spawns a mine at position pos. Terminates the program if the pos is out of
# index range.
func spawn_mine(var pos : Vector2):
	if (!_is_inside_grid(pos)):
		push_error("Can't spawn mine outside of grid.")
		get_tree().quit()
	
	# Setup mine object
	var mine : Node = Mine.instance()
	_grid_node_arr[pos.x][pos.y].place_object(mine)
	
	# Notify cells in eight direction about this new mines existence.
	for x_offset in range(-1, 2):
		for y_offset in range(-1, 2):
			if (!(x_offset == 0 && y_offset == 0) && _is_inside_grid(pos + Vector2(x_offset, y_offset))):
				_grid_node_arr[pos.x + x_offset][pos.y + y_offset].inc_neighboring_mines()

# Important, the implementation of this method is temporary
func _on_Player_request_movement(direction : String, obj_id : Node) -> void:
	var obj_pos : Vector2 = obj_id.get_pos()
	var obj_new_pos : Vector2 = obj_pos
	
	match direction:
		"right":
			if (obj_pos.x + 1 < _cell_amount.x):
				obj_new_pos = Vector2(obj_pos.x + 1, obj_pos.y)
		"left":
			if (obj_pos.x - 1 >= 0):
				obj_new_pos = Vector2(obj_pos.x - 1, obj_pos.y)
		"down":
			if (obj_pos.y + 1 < _cell_amount.y):
				obj_new_pos = Vector2(obj_pos.x, obj_pos.y + 1)
		"up":
			if (obj_pos.y - 1 >= 0):
				obj_new_pos = Vector2(obj_pos.x, obj_pos.y - 1)
	
	if (_grid_node_arr[obj_new_pos.x][obj_new_pos.y].is_covered()):
		uncover(obj_new_pos)
	else:
		if (_grid_node_arr[obj_new_pos.x][obj_new_pos.y].get_object_types().empty()):
			_grid_node_arr[obj_pos.x][obj_pos.y].take_object(obj_id)
			_grid_node_arr[obj_new_pos.x][obj_new_pos.y].place_object(obj_id)
