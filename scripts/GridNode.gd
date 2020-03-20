# Class GridNode ---
# Container for the Grid class. Stores Grid objects. They are covered by default which means the
# contained objects are not visible.
extends Node2D

# Private members ---
var _covered : bool
var _grid_object_arr : Array
var _size : Vector2
var _neighboring_mines : int

# Private helpers ---
func _grid_pos() -> Vector2:
	# All grid nodes in the same grid are of the same size. Therefore _size can be used to
	# get the position the grid node has in the grid.
	return Vector2(floor(position.x / _size.x), floor(position.y / _size.y))

# Constructor ---
func init(pos : Vector2, size : Vector2) -> void:
	_grid_object_arr = []
	_covered = true
	_size = size
	_neighboring_mines = 0
	set_position(pos)
	$NeighboringMineLabel.set_text(String(_neighboring_mines) if (_neighboring_mines > 0) else "")
	$NeighboringMineLabel.hide()

# Public methods ---
# Uncover node, all contained objects will become visible. There is no need to cover the node 
# again because of the nature of minesweeper.
func uncover() -> void:
	_covered = false
	$NeighboringMineLabel.show()
	for grid_object in _grid_object_arr:
		grid_object.uncover()

func register_neighboring_mine() -> void:
	_neighboring_mines += 1
	$NeighboringMineLabel.set_text(String(_neighboring_mines))

func unregister_neighboring_mine() -> void:
	_neighboring_mines -= 1
	$NeighboringMineLabel.set_text(String(_neighboring_mines))

# Contain an object within the node.
func place_object(grid_object : Node) -> void:
	if (_covered):
		grid_object.cover()
	else:
		grid_object.uncover()
	
	# All grid nodes in the same grid will have the same size, therefore size can be used to
	# to get grid position.
	grid_object.set_pos(_grid_pos())
	
	add_child(grid_object)
	_grid_object_arr.append(grid_object)

# Remove the object from the node. The object should either be removed or placed in another node.
# The object DOES NOT get removed.
func take_object(grid_object : Node) -> Node:
	var found_object : Node = null
	var index : int = _grid_object_arr.find(grid_object)
	
	if (index != -1):
		found_object = _grid_object_arr[index]
		_grid_object_arr.remove(index)
		remove_child(found_object)
	
	return found_object

# Returns an array of all types of objects contained in a node. Used for collision detection on
# the grid.
func get_object_types() -> Array:
	var types : Array = []
	for grid_object in _grid_object_arr:
		types.append(grid_object.get_type())
	
	return types
