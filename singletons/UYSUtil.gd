extends Node2D


var game_rng_seed = "Kingmaker" setget set_seed
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var node_name_regex

func _ready():
	set_seed(game_rng_seed)
	rng.randomize()
	
	node_name_regex = RegEx.new()
	node_name_regex.compile("@?(\\w+)@?\\d+")


func set_seed(_seed) -> void:
	game_rng_seed = str(_seed)
	rng.set_seed(hash(game_rng_seed))


func list_files_in_directory(path: String, prepend_needed := "") -> Array:
	var files := []
	var dir := Directory.new()
	# warning-ignore:return_value_discarded
	dir.open(path)
	# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	while true:
		var file := dir.get_next()
		if file == "":
			break
		elif not file.begins_with('.')\
				and file.begins_with(prepend_needed)\
				and not file.ends_with(".remap")\
				and not file.ends_with(".import")\
				and not file.ends_with(".md"):
			files.append(file)
	dir.list_dir_end()
	return(files)


func list_imported_in_directory(path: String) -> Array:
	var files := []
	var dir := Directory.new()
	# warning-ignore:return_value_discarded
	dir.open(path)
	# warning-ignore:return_value_discarded
	dir.list_dir_begin()
	while true:
		var file := dir.get_next()
		if file == "":
			break
		elif file.ends_with(".import"):
			files.append(file.rstrip(".import"))
	dir.list_dir_end()
	return(files)


func shuffle_array(array: Array) -> void:
	var n = array.size()
	if n<2:
		return
	var j
	var tmp
	for i in range(n-1,1,-1):
		j = rng.randi()%(i+1)
		tmp = array[j]
		array[j] = array[i]
		array[i] = tmp


func rnd_color(single_color := false) -> Vector3:
	var r := 1.0
	var g := 1.0
	var b := 1.0
	while r > 0.7 and g > 0.7 and b > 0.7:
		r = rng.randf_range(0.0,0.9)
		g = rng.randf_range(0.0,0.9)
		b = rng.randf_range(0.0,0.9)
		# print("rgb: %s, %s, %s" % [r,g,b])
	var final_color := Vector3(r,g,b)
	if single_color:
		var solid_color = rng.randf_range(0,2)
		for rgb in [0,1,2]:
			if rgb != solid_color:
				final_color[rgb] *= 0.2
			else:
				final_color[rgb] = rng.randf_range(0.7,1.0)
	# print("Colour: %s" % [final_color])
	return(final_color)


func rand_bool() -> bool:
	var rnd_bool = {0:true, 1: false}
	return(rnd_bool[rng.randi_range(0,1)])


func rand_one_in_n(n=2):
	"""
	Return a one in N chance.
	
	Defaults to coin flip (one in two chance), so will return
	true half the time, and false half the time.
	"""
	var x = rng.randi() % n + 1
	return x == 1


func rand_item(items: Array):
	return items[rng.randi_range(0, len(items) - 1)]


func rand_str(n: int = 8, use_numbers: bool = false) -> String:
	var alpha = "abcdefghijklmnopqrstuvwxyz"
	var numeric = "0123456789"
	var all = alpha
	
	if use_numbers:
		all = alpha + numeric
	
	var val = ""
	for i in n:
		val += all[rng.randi_range(0,len(all) - 1)]
	
	return val


const n = 0
func error(msg: String):
	print(":( %s" % [msg])
	var _fake_exception = 42.0/n


func real_name(node_or_node_name):
	var node_name = node_or_node_name
	if "custom_name" in node_or_node_name:
		node_name = node_or_node_name.get("custom_name")
	elif typeof(node_or_node_name) == TYPE_STRING:
		node_name = node_or_node_name
	else:
		node_name = node_or_node_name.name
	
	var result = node_name_regex.search(node_name)
	if result:
		var match1 = result.get_string(1)
		# print("%s --> %s" % [node_name, match1])
		return match1
	else:
		return node_name


# We're using this helper function, to allow our mouse-position relevant code
# to work during integration testing
# Returns either the adjusted global mouse position
# or a fake mouse position provided by integration testing
func determine_global_mouse_pos() -> Vector2:
	var zoom = get_zoom_level()
	var offset_mouse_position = get_viewport().get_mouse_position() - get_viewport_transform().origin
	offset_mouse_position *= zoom
	return offset_mouse_position


#func get_zoom_level() -> Vector2:
#	if get_viewport() and get_viewport().has_node("ZoomingCamera"):
#		var cam: Camera2D = get_viewport().get_node("ZoomingCamera")
#		return cam.zoom
#	else:
#		return Vector2.ONE


var camera
func _get_camera() -> Camera2D:
	if not camera:
		camera = get_tree().get_nodes_in_group("camera")[0]
	return camera


func get_zoom_level() -> Vector2:
	return _get_camera().zoom
	# retur_get_camera().get("_zoom_level")


func get_camera_offset() -> Vector2:
	if _get_camera().use_offset_based_panning:
		return _get_camera().get_offset()
	else:
		return _get_camera().position


func get_camera_xform(position: Vector2) -> Vector2:
	# return position * U.get_zoom_level()
	# return _get_camera().transform.xform_inv(position)  #* U.get_zoom_level()
	# return _get_camera().transform.xform_inv(position) * U.get_zoom_level()
	# return _get_camera().transform.xform(position) * U.get_zoom_level()
	# return _get_camera().transform.xform(position) #* U.get_zoom_level()
	# return _get_camera().transform.xform_inv(position)  / U.get_zoom_level()
	return _get_camera().get_viewport_transform().xform_inv(position)
