# Class GridNode
# Container for the Grid class. Stores Grid objects. They are covered by default which means the
# contained objects are not visible.

extends Node2D

class_name GridNode

# Private members
var _covered : bool
var _grid_object_arr : Array

# Constructor.
func _init(grid_object_arr : Array = []):
	_grid_object_arr = grid_object_arr
	_covered = true

# Uncover node, all contained objects will become visible. There is no need to cover the node 
# again because of the nature of minesweeper.
func uncover() -> void:
	_covered = false
	for grid_object in _grid_object_arr:
		grid_object.uncover()

# Contain an object within the node.
func place_object(grid_object : GridObject) -> void:
	if (_covered):
		grid_object.cover()
	else:
		grid_object.uncover()
	
	grid_object.set_position(self.position)
	_grid_object_arr.append(grid_object)

# Remove the object from the node. The object should either be removed or placed in another node.
func take_object(grid_object : GridObject) -> GridObject:
	var found_object : GridObject = null
	var index : int = _grid_object_arr.find(grid_object)
	
	if (index != -1):
		found_object = _grid_object_arr[index]
	
	return found_object

# Returns an array of all types of objects contained in a node. Used for collision detection on
# the grid.
func get_object_types() -> Array:
	var types : Array = []
	for grid_object in _grid_object_arr:
		types.append(grid_object.get_type())
		
	return types