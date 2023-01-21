class_name LuanchCard
extends PanelContainer


@onready var request = $HTTPRequest
@onready var app_label = $MarginContainer/Rows/App
@onready var author_label = $MarginContainer/Rows/Mentions/Author
@onready var type_label = $MarginContainer/Rows/Mentions/Type
@onready var progress_bar = $MarginContainer/Rows/Actions/Progress


enum CardTypes {App, Extension, Nightly}


var download_id := -1

var url := ""
var app_name := ""
var author := ""
var card_type := 0

var downloading := false


func _process(delta: float) -> void:
	if downloading and request.get_body_size() > 0:
		var v = request.get_downloaded_bytes() * 100.0 / request.get_body_size()
		progress_bar.set_value(v)


# Public
func set_app_name(new_name : String) -> void:
	app_name = new_name
	_update_ui()


func set_card_type(new_type : int) -> void:
	card_type = new_type
	_update_ui()


func set_author(new_author : String) -> void:
	author = new_author
	_update_ui()


func download() -> void:
	download_id = PckUnpacker.download_count
	request.set_download_file("user://Downloads/" + str(download_id)+ ".zip")
	PckUnpacker.download_count += 1
	
	request.request(url)


func reset_progress() -> void:
	progress_bar.set_value(0)

# Signals
func _on_file_request_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	PckUnpacker.unpack("user://Downloads/" + str(download_id) + ".zip", CardTypes.keys()[card_type])


func _action_btn_pressed() -> void:
	if downloading:
		request.cancel_request()
		downloading = false
		reset_progress()
	else:
		download()
		downloading = true


# Private
func _update_ui() -> void:
	app_label.text = app_name
	author_label.text = author
	type_label.text = CardTypes.keys()[card_type]
