extends ScrollContainer


var nightly_card := preload("res://LuanchCard.tscn").instantiate()

@onready var container := $HBoxContainer
@onready var check_btn := $HBoxContainer/CheckNightly

var user_dir := OS.get_user_data_dir()

var os := OS.get_name()
var nightly_link := ""

var file_name = ""
var file_extension := ""
var prefix := "nightly"

var date = ""
var up_to_data := false


func _ready() -> void:
	container.add_child(nightly_card)
	
	nightly_card.set_app_name("Pixelorama Nightly")
	nightly_card.set_card_type(nightly_card.CardTypes.Nightly)
	nightly_card.set_author("Orama-Interactive | Nightly.link")


func check_up_to_date() -> bool:
	if FileAccess.file_exists("user://PixeloramaNightly/" + file_name):
		check_btn.hide()
		check_btn.disabled = true
		return true
	
	check_btn.show()
	check_btn.disabled = false
	return false


#func _ready() -> void:
#	return
#	check_btn.pressed.connect(download)
#
#	create_nightly_dir()
#	configure()


func create_nightly_dir() -> void:
	DirAccess.make_dir_recursive_absolute("user://nightly")


func configure() -> void:
	# The OS settings
	match os:
		"Windows":
			file_extension = ".zip"
		"OSX":
			file_extension = ".dmg"
		"X11":
			file_extension = ".AppImage"
	
	# Date
	date = Time.get_date_dict_from_system(true)
	date = str("[", date["day"], ".", date["month"], ".", date["year"], "]")
	
	_update_filename()
	
	up_to_data = is_up_to_date()
	
	_update_nightly_link()
	
	
## Checks the user directory to 
func is_up_to_date() -> bool:
	return false

func _update_nightly_link() -> void:
	match os:
		"Windows":
			nightly_link = "https://nightly.link/Orama-Interactive/Pixelorama/workflows/dev-desktop-builds/master/Windows-64bit.zip"
		"OSX":
			nightly_link = "https://nightly.link/Orama-Interactive/Pixelorama/workflows/dev-desktop-builds/master/Mac.zip"
		"X11":
			nightly_link = "https://nightly.link/Orama-Interactive/Pixelorama/workflows/dev-desktop-builds/master/Linux-64bit.zip"


func download() -> void:
	_update_filename()
	
	var path = "user://nightly/" + file_name
	
	if up_to_data:
		pass
	else:
		print_rich("[color=LIGHT_GREEN]Downloading Pixelorama Nightly: ", date, "[/color]")
		
		# Remove old nightly files
		var dir = DirAccess.open("user://nightly")
		var files = dir.get_files()
		for file in files:
			if prefix in file:
				dir.remove("user://nightly/" + file)
				
		nightly_card.config(nightly_card.Modes.DownloadMode, path, nightly_link, date)
		nightly_card.download(path, nightly_link)

func _update_filename() -> void:
	file_name = prefix + "-" + date + ".zip"


func _on_http_request_request_completed() -> void:
	pass # Replace with function body.
