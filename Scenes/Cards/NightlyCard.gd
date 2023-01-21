extends PanelContainer


@onready var request := $HTTPRequest
@onready var date_label := $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Date
@onready var options := $MarginContainer/VBoxContainer/Options
@onready var download_options := $MarginContainer/VBoxContainer/Download
@onready var download_progress := $MarginContainer/VBoxContainer/Download/ProgressBar

var mode := -1

enum Modes {
	DownloadMode, ViewMode
}


func _ready() -> void:
	request.request_completed.connect(_on_request_completed)


func config(config_mode : int, out : String, url : String, date : String) -> void:
	mode = config_mode
	date_label.text = date
	
	match mode:
		Modes.DownloadMode:
			options.hide()
			download_options.show()
		Modes.ViewMode:
			options.show()
			download_options.hide()


func download(output : String, url : String) -> void:
	request.set_download_file(output)
	request.request(url)


func _process(delta: float) -> void:
	if mode == Modes.DownloadMode:
		download_progress.max_value = request.get_body_size()
		download_progress.value = request.get_downloaded_bytes()


func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	mode = Modes.ViewMode
	
	var path = request.get_download_file()
	
	# Extracting the zip file
	var reader = ZIPReader.new()
	var err := reader.open(path)
	if err == OK:
		var files = reader.get_files()
		for file in files:
			var fa = FileAccess.open(path + file, FileAccess.WRITE)
			fa.store_buffer(reader.read_file(file))
			
	reader.close()
