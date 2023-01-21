extends Control


const degrees_max := 360.0

@export_group("Range")
@export var value := 0.0
@export var min_value := 0.0
@export var max_value := 0.0

@export_group("Display")
@export var foreground := Color.BLACK
@export var radius := 1.0
@export var width := 1.0
@export var antialiased := false
@export var convert_progress_to_rotation := false


func set_value(new_value : float) -> void:
	value = new_value
	value = clampf(value, min_value, max_value)
	queue_redraw()


func _draw() -> void:
	if convert_progress_to_rotation:
		draw_set_transform_matrix(Transform2D((value * max_value / degrees_max), size / 2))
	
	draw_arc(
		Vector2.ZERO, radius, 0, deg_to_rad(value * degrees_max / max_value), 90, foreground, width, antialiased
	)
