extends Camera2D


# debug
onready var zoom_debug = $CanvasLayer/Label

# Lower cap for the `_zoom_level`.
export var min_zoom := 1.0
# Upper cap for the `_zoom_level`.
export var max_zoom := 4.0
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
export var zoom_factor := 0.1
# Duration of the zoom's tween animation.
export var zoom_duration := 0.2

# The camera's target zoom level.
var _zoom_level := 1.0 setget _set_zoom_level

# We store a reference to the scene's tween node.
onready var tween: Tween = $Tween

signal signal_drag(val)
var dragging := false
var previous_mouse_pos := Vector2.ZERO
var previous_offset
var previous_position
var camera_drag_enabled := true

var use_offset_based_panning = true


func _ready():
	# print("_ready() get_camera_screen_center(): %s" % [get_camera_screen_center()])
	
	# start centered on game scene, as camera would normally be positioned
	# so its center is over the game's top left corner
	var vp_size = get_viewport().size
	# position = vp_size / 2
	#set_offset(vp_size / 2)
	previous_offset = get_offset()
	previous_position = position
	#_set_zoom_level(2.0)
	
	add_to_group("camera")
	
	# warning-ignore:RETURN_VALUE_DISCARDED
	connect("signal_drag", self, "_set_drag_pc")
	# warning-ignore:RETURN_VALUE_DISCARDED
	tween.connect("tween_all_completed", self, "_on_tween_all_completed")


func _process(_delta):
	if dragging:
		var mouse_pos := get_viewport().get_mouse_position()
		var distance := previous_mouse_pos - mouse_pos
		pan(distance)


func _set_drag_pc(val):
	dragging = val
	if val:
		previous_mouse_pos = get_viewport().get_mouse_position()
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		camera_changed()


func _set_zoom_level(value: float) -> void:
	# We limit the value between `min_zoom` and `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)
	zoom_debug.text = str(_zoom_level)
	# Then, we ask the tween node to animate the camera's `zoom` property from its current value
	# to the target zoom level.
	# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	# warning-ignore:return_value_discarded
	tween.start()


func camera_changed():
	pass
	#print("get_camera_screen_center(): %s" % [get_camera_screen_center()])


func pan(dist: Vector2):
	if use_offset_based_panning:
		pan_offset_based(dist)
	else:
		pan_position_based(dist)


func pan_position_based(dist: Vector2):
	position += dist * _zoom_level
	previous_position = position
	previous_mouse_pos = get_viewport().get_mouse_position()
	camera_changed()


func pan_offset_based(dist: Vector2):
	set_offset(previous_offset + dist * _zoom_level)
	previous_offset = get_offset()
	previous_mouse_pos = get_viewport().get_mouse_position()
	camera_changed()


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		# Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
		# call the setter function to use it.
		_set_zoom_level(_zoom_level - zoom_factor)
	
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)
	
	if event.is_action_pressed("move_up"):
		pan(Vector2.UP * 100)
	
	if event.is_action_pressed("move_down"):
		pan(Vector2.DOWN * 100)
	
	if event.is_action_pressed("move_left"):
		pan(Vector2.LEFT * 100)
	
	if event.is_action_pressed("move_right"):
		pan(Vector2.RIGHT * 100)
	
	if not camera_drag_enabled:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			emit_signal("signal_drag", event.pressed)
	elif event is InputEventScreenTouch:
		if event.get_index() == 0:
			emit_signal("signal_drag", event.pressed)


func _on_tween_all_completed():
	camera_changed()

