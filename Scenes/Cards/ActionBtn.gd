extends Button


@export_group("Action Icons")
@export var idle_icon : Texture
@export var download_icon : Texture
@export var cancel_icon : Texture

enum Actions {
	Idle, Downloading, Cancel
}



func _process(delta: float) -> void:
	$"../Progress".set_value($"../Progress".value + delta)
