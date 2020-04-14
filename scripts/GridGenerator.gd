# class GridGenerator ---
# The grid is grouped by 4x4 partitions. The grid must therefore have a width and a height
# divisible by 4. The mines is distributed throughout the partitions that does not contain
# the player or the goal.
extends Node2D

const Grid = preload("res://scenes/Grid.tscn")

const PATCH_SIZE : Vector2 = Vector2(4, 4)

var _patch_amount : Vector2
var _grid_size : Vector2
var _mine_density : int
var _mine_density_offset : int

func _ready() -> void:
	randomize()
	generate()

# Generate grid
func generate() -> void:
	_patch_amount = Vector2(4, 4)
	_grid_size = _patch_amount * PATCH_SIZE
	_mine_density = 2
	_mine_density_offset = 1
	
	# Init patches array
	var patch_matrix : Array = []
	for x in range(_patch_amount.x):
		var col = []
		for y in range(_patch_amount.y):
			col.append(null)
		patch_matrix.append(col)
	
	# Place start and end patches
	var start_pos : Vector2 = _generate_start_pos()
	var end_pos : Vector2 = _generate_end_pos(start_pos)
	patch_matrix[start_pos.x][start_pos.y] = generate_single_object_patch("start", true)
	patch_matrix[end_pos.x][end_pos.y] = generate_single_object_patch("end", false)
	
	# Generate mine patches
	for x in range(_patch_amount.x):
		for y in range(_patch_amount.y):
			if (patch_matrix[x][y] == null):
				patch_matrix[x][y] = generate_mine_patch()
	
	# Create grid object
	var grid : Node2D = Grid.instance()
	grid.init(Vector2(0, 0), Vector2(512, 512), _grid_size)
	add_child(grid)
	
	var uncover_pos_arr : Array = []
	
	# Spawn mines from the patches
	for x in range(_patch_amount.x):
		for y in range(_patch_amount.y):
			var patch : Patch = patch_matrix[x][y]
			var pos : Vector2 = Vector2(x, y)
			
			match patch.type:
				"start":
					grid.spawn_player(pos * PATCH_SIZE + patch.spawn_pos_arr[0])
				"end":
					grid.spawn_stairs(pos * PATCH_SIZE + patch.spawn_pos_arr[0])
				"mine":
					for mine_local_pos in patch.spawn_pos_arr:
						grid.spawn_mine(pos * PATCH_SIZE + mine_local_pos)
			
			if (patch.uncover):
				uncover_pos_arr.append(pos * PATCH_SIZE + patch.spawn_pos_arr[0])
	
	for uncover_pos in uncover_pos_arr:
		grid.uncover(uncover_pos)

func generate_single_object_patch(var type : String, var uncover : bool) -> Patch:
	var patch : Patch = Patch.new()
	patch.type =type
	patch.spawn_pos_arr = [Vector2(int(rand_range(1, _patch_amount.x - 1)), int(rand_range(1, _patch_amount.y - 1)))]
	patch.uncover = uncover
	return patch

# Generate a mine patch.
func generate_mine_patch() -> Patch:
	var patch : Patch = Patch.new()
	patch.type = "mine"
	patch.spawn_pos_arr = []
	patch.uncover = false
	
	var mine_amount : int = _mine_density + int(rand_range(-_mine_density_offset, _mine_density_offset + 1))
	
	for i in range(0, mine_amount):
		var found_spot : bool = false
		while (!found_spot):
			var rand_x : int = randi() % int(PATCH_SIZE.x)
			var rand_y : int = randi() % int(PATCH_SIZE.y)
			var rand_pos : Vector2 = Vector2(rand_x, rand_y)
			if (!patch.spawn_pos_arr.has(rand_pos)):
				patch.spawn_pos_arr.append(rand_pos)
				found_spot = true
	
	return patch

func _generate_start_pos() -> Vector2:
	var pos_arr : Array
	pos_arr.append(Vector2(0, 0))
	pos_arr.append(Vector2(_patch_amount.x - 1, 0))
	pos_arr.append(Vector2(0, _patch_amount.y - 1))
	pos_arr.append(Vector2(_patch_amount.x - 1, _patch_amount.y - 1))
	
	return pos_arr[randi() % pos_arr.size()]

func _generate_end_pos(start_pos : Vector2) -> Vector2:
	var translation : Vector2 = (_patch_amount - Vector2(1, 1)) * 0.5
	var rot_matrix : Transform2D = Transform2D(Vector2(-1, 0), Vector2(0, -1), Vector2(0, 0)) 
	
	start_pos -= translation
	var trans_pos : Vector2 = rot_matrix.xform(start_pos)
	trans_pos += translation
	
	var offset_x : int = randi() % int(_patch_amount.x)
	var offset_y : int = randi() % int(_patch_amount.y)
	
	var pos_arr : Array
	pos_arr.append(Vector2(int(trans_pos.x + offset_x) % int(_patch_amount.x), trans_pos.y))
	pos_arr.append(Vector2(trans_pos.x, int(trans_pos.y + offset_y) % int(_patch_amount.y)))
	
	return pos_arr[randi() % pos_arr.size()]

# TEMP
func _draw() -> void:
	draw_rect(Rect2(0, 0, 512, 512), Color(0.56, 0.34, 0.23))

# TEMP
func _process(var delta) -> void:
	if (Input.is_action_just_pressed("ui_select")):
		remove_child(get_child(0))
		generate()

# Inner classes
class Patch:
	var type : String
	var spawn_pos_arr : Array
	var uncover : bool
