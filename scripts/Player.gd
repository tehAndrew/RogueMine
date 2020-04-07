# class Player ---
# Contains the player sprite and handles the player movement.
extends "res://scripts/GridObject.gd"

# Signals ---
signal request_movement(direction, obj_id)

# Update function ---
func _process(delta):
	if (Input.is_action_just_pressed("ui_right")):
		emit_signal("request_movement", "right", self)
		
	elif (Input.is_action_just_pressed("ui_left")):
		emit_signal("request_movement", "left", self)
			
	elif (Input.is_action_just_pressed("ui_down")):
		emit_signal("request_movement", "down", self)
			
	elif (Input.is_action_just_pressed("ui_up")):
		emit_signal("request_movement", "up", self)
