# Class GridObject ---
# Super class for all grid objects. Grid objects does not have a position on their own,
# they get their position from the grid node they inhabit.
extends Node2D

# Exports --- 
export (String) var type setget , get_type

# Private members ---
var _pos : Vector2 setget set_pos, get_pos

# Constructor ---
func init(size : Vector2) -> void:
	var spr_rect = get_node("Sprite").get_rect()
	var x_scale : float = size.x / spr_rect.size.x
	var y_scale : float = size.y / spr_rect.size.y
	set_scale(Vector2(x_scale, y_scale))

# Public methods ---
func set_pos(pos : Vector2) -> void:
	_pos = pos

func get_type() -> String:
	return type
	
func get_pos() -> Vector2:
	return _pos

# Hide sprite.
func cover() -> void:
	get_node("Sprite").set_visible(false)

# Show sprite.
func uncover() -> void:
	get_node("Sprite").set_visible(true)
