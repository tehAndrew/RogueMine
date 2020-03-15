# Class GridObject
# Super class for all grid objects.

extends Node2D

class_name GridObject

# Private member
export (String) var type setget , get_type;

# Getters
func get_type() -> String:
	return type;

# Hide sprite.
func cover() -> void:
	var sprite : Sprite = get_node("Sprite")
	sprite.set_visible(false)

# Show sprite.
func uncover() -> void:
	var sprite : Sprite = get_node("Sprite")
	sprite.set_visible(true)