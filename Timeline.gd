extends Control


var scrolling := false
var previous_value := 0.0

var points : PackedFloat32Array


func _ready() -> void:
	get_parent().get_parent().get_parent().get_v_scroll_bar().value_changed.connect(
		func (value : float):
			if value == previous_value:
				scrolling = true
			else :
				scrolling = false
				previous_value = value
	)


func _process(delta: float) -> void:
	points.clear()
	var catagories = get_tree().get_nodes_in_group("Catagory")
	for catagory in catagories:
		points.append(catagory.position.y + catagory.size.y / 2)
	queue_redraw()


func _draw() -> void:
	draw_line(Vector2(size.x / 2, 0), Vector2(size.x / 2, DisplayServer.screen_get_size().y), Color.LIGHT_CYAN, 3.0)
	
	for point in points:
		draw_circle(Vector2(size.x / 2, point), 8, Color.LIGHT_CYAN)
