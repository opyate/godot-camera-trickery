extends Node2D


var points = []
func _draw():
	var c = 0
	for point in points:
		draw_circle(point["p"], 20, point["color"])
		c+=1


func _process(_delta):
	update()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				points = []
				var evpos
				evpos = event.position - get_viewport().size/2
				var p = U.get_zoom_level() * evpos + U.get_camera_offset()
				
				points.append({
					"p": p,
					"color": Color.purple
				})
