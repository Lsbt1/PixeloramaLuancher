extends Button


@export_group("Action Icons")
@export var idle_icon : Texture
@export var download_icon : Texture
@export var cancel_icon : Texture

enum Actions {
	Idle, Downloading, Cancel
}

var action := 0


func switch_action(old_action : int, new_action : int) -> void:
	match new_action:
		"":
			pass
		

func _process(delta: float) -> void:
	$"../Control".set_value($"../Control".value + delta)
