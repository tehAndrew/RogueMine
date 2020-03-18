extends TileMap

func init(var size : Vector2) -> void:
	_resize_grid(size)

func _resize_grid(size : Vector2) -> void:
	var x_scale : float = size.x / cell_size.x
	var y_scale : float = size.y / cell_size.y
	set_scale(Vector2(x_scale, y_scale))
