extends Node


var download_count := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DirAccess.make_dir_recursive_absolute("user://Downloads")
	DirAccess.make_dir_recursive_absolute("user://PixeloramaOfficial")
	DirAccess.make_dir_recursive_absolute("user://PixeloramaNightly")
	DirAccess.make_dir_recursive_absolute("user://PixeloramaCustom")
	DirAccess.make_dir_recursive_absolute("user://PixeloramaExtensions")


func unpack(zip_file : String, out_dir : String) -> void:
	var reader = ZIPReader.new()
	var err := reader.open(zip_file)
	if err != OK:
		printerr("Could not unpack")
		return 
	for file in reader.get_files():
		if file.get_extension() == "pck":
			var file_access = FileAccess.open("user://Pixelorama" + out_dir + "/" + file, FileAccess.WRITE)
			file_access.store_buffer(reader.read_file(file))

