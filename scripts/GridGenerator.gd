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
	_mine_density_offset = 0
	
	var patches : Array = []
	
	patches.append(generate_start_patch(Vector2(0, 0)))
	patches.append(generate_end_patch(Vector2(_patch_amount.x - 1, _patch_amount.y - 1)))
	
	# Generate mine patches
	for x in range(0, _patch_amount.x):
		for y in range(0, _patch_amount.y):
			if (Vector2(x, y) != Vector2(0, 0) && Vector2(x, y) != Vector2(_patch_amount.x - 1, _patch_amount.y - 1)):
				patches.append(generate_mine_patch(Vector2(x, y)))
	
	# Create grid object
	var grid : Node2D = Grid.instance()
	grid.init(Vector2(0, 0), Vector2(512, 512), _grid_size)
	add_child(grid)
	
	var uncover_pos_arr : Array = []
	
	# Spawn mines from the patches
	for patch in patches:
		match patch.type:
			"start":
				grid.spawn_player(patch.pos * PATCH_SIZE + patch.spawn_pos_arr[0])
				uncover_pos_arr.append(patch.pos * PATCH_SIZE + patch.spawn_pos_arr[0])
			"end":
				grid.spawn_stairs(patch.pos * PATCH_SIZE + patch.spawn_pos_arr[0])
				uncover_pos_arr.append(patch.pos * PATCH_SIZE + patch.spawn_pos_arr[0])
			"mine":
				for mine_local_pos in patch.spawn_pos_arr:
					grid.spawn_mine(patch.pos * PATCH_SIZE + mine_local_pos)
	
	for uncover_pos in uncover_pos_arr:
		grid.uncover(uncover_pos)

func generate_start_patch(var pos : Vector2) -> Patch:
	var patch : Patch = Patch.new()
	patch.type = "start"
	patch.pos = pos
	patch.spawn_pos_arr = [Vector2(int(rand_range(1, _patch_amount.x - 1)), int(rand_range(1, _patch_amount.y - 1)))]
	patch.uncover = true
	return patch

func generate_end_patch(var pos : Vector2) -> Patch:
	var patch : Patch = Patch.new()
	patch.type = "end"
	patch.pos = pos
	patch.spawn_pos_arr = [Vector2(int(rand_range(0, _patch_amount.x)), int(rand_range(0, _patch_amount.y)))]
	patch.uncover = false
	return patch

# Generate a mine patch.
func generate_mine_patch(var pos : Vector2) -> Patch:
	var patch : Patch = Patch.new()
	patch.type = "mine"
	patch.pos = pos
	patch.spawn_pos_arr = []
	patch.uncover = false
	
	var mine_amount : int = _mine_density + int(rand_range(-_mine_density_offset, _mine_density_offset + 1))
	
	for i in range(0, mine_amount):
		var found_spot : bool = false
		while (!found_spot):
			var rand_x : int = randi() % int(PATCH_SIZE.x - 1)
			var rand_y : int = randi() % int(PATCH_SIZE.y - 1)
			var rand_pos : Vector2 = Vector2(rand_x, rand_y)
			if (!patch.spawn_pos_arr.has(rand_pos)):
				patch.spawn_pos_arr.append(rand_pos)
				found_spot = true
	
	return patch

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
	var pos : Vector2
	var spawn_pos_arr : Array
	var uncover : bool
