# Class GridObject
# Super class for all grid objects.

extends Node2D

class_name GridObject

const SPRITE_INDX = 0

# Private member
export (String) var type setget , get_type;

# Getters
func get_type() -> String:
	return type;

# Hide sprite.
func cover() -> void:
	get_child(SPRITE_INDX).set_visible(false)

# Show sprite.
func uncover() -> void:
	get_child(SPRITE_INDX).set_visible(true)

# Resizes the sprite to match the size of the grid size.
func resize_sprite(size : Vector2) -> void:
	var spr_rect = get_child(SPRITE_INDX).get_rect()
	var x_scale : float = size.x / spr_rect.size.x
	var y_scale : float = size.y / spr_rect.size.y
	set_scale(Vector2(x_scale, y_scale))