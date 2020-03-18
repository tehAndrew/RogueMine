# Class GridObject ---
# Super class for all grid objects. Grid objects does not have a position on their own,
# they get their position from the grid node they inhabit.
extends Node2D

const SPRITE_INDX = 0

# Exports --- 
export (String) var type setget , get_type

# Private members ---
var _pos : Vector2 setget set_pos, get_pos

# Private helpers ---
# Resizes the sprite to match the size of the grid size.
func _resize_sprite(size : Vector2) -> void:
	var spr_rect = get_child(SPRITE_INDX).get_rect()
	var x_scale : float = size.x / spr_rect.size.x
	var y_scale : float = size.y / spr_rect.size.y
	set_scale(Vector2(x_scale, y_scale))

# Constructor ---
func init(size : Vector2) -> void:
	_resize_sprite(size)

# Setters ---
func set_pos(pos : Vector2) -> void:
	_pos = pos

# Getters ---
func get_type() -> String:
	return type
	
func get_pos() -> Vector2:
	return _pos

# Public methods ---
# Hide sprite.
func cover() -> void:
	get_child(SPRITE_INDX).set_visible(false)

# Show sprite.
func uncover() -> void:
	get_child(SPRITE_INDX).set_visible(true)
