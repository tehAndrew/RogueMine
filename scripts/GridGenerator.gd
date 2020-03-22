extends Node2D

const Grid = preload("res://scenes/Grid.tscn")

var _grid_size : Vector2
var _mine_count : int

func _ready() -> void:
	randomize()
	generate()

func generate() -> void:
	_grid_size = Vector2(16, 16)
	_mine_count = 20
	
	var grid : Node2D = Grid.instance()
	grid.init(Vector2(0, 0), Vector2(512, 512), _grid_size)
	
	var rand_pos_arr : Array = []
	for i in range(0, _mine_count):
		var found_spot : bool = false
		while (!found_spot):
			var rand_x : int = 1 + randi() % int(_grid_size.x - 1)
			var rand_y : int = 1 + randi() % int(_grid_size.y - 1)
			var rand_pos : Vector2 = Vector2(rand_x, rand_y)
			if (!rand_pos_arr.has(rand_pos)):
				rand_pos_arr.append(rand_pos)
				found_spot = true
	
	for rand_pos in rand_pos_arr:
		grid.spawn_mine(rand_pos)
	
	grid.spawn_player(Vector2(0, 0))
	
	add_child(grid)

func _process(var delta) -> void:
	if (Input.is_action_just_pressed("ui_select")):
		remove_child(get_child(0))
		generate()
