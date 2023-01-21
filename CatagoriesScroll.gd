extends ScrollContainer


func get_catagories() -> Array:
	return get_tree().get_nodes_in_group("Catagory")
