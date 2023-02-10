extends Node2D


var points = []
func _draw():
	var c = 0
	for point in points:
		draw_circle(point, 20, G.colours[c % G.colours.size()])
		c+=1


func _process(_delta):
	update()


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				points = []
				
				# event.position
				points.append(event.position)
				
				points.append(event.position * U.get_zoom_level())
				points.append(event.position / U.get_zoom_level())
				
				points.append(event.position                      - U.get_camera_offset())
				points.append(event.position                      + U.get_camera_offset())
				points.append(event.position                      - U.get_camera_offset() * U.get_zoom_level())
				points.append(event.position                      + U.get_camera_offset() / U.get_zoom_level())
				
				points.append(event.position * U.get_zoom_level() - U.get_camera_offset())
				points.append(event.position / U.get_zoom_level() + U.get_camera_offset())
				points.append(event.position * U.get_zoom_level() - U.get_camera_offset() * U.get_zoom_level())
				points.append(event.position / U.get_zoom_level() + U.get_camera_offset() / U.get_zoom_level())
				
				# event.global_position
				points.append(event.global_position)
				
				points.append(event.global_position * U.get_zoom_level())
				points.append(event.global_position / U.get_zoom_level())
				
				points.append(event.global_position                      - U.get_camera_offset())
				points.append(event.global_position                      + U.get_camera_offset())
				points.append(event.global_position                      - U.get_camera_offset() * U.get_zoom_level())
				points.append(event.global_position                      + U.get_camera_offset() / U.get_zoom_level())
				
				points.append(event.global_position * U.get_zoom_level() - U.get_camera_offset())
				points.append(event.global_position / U.get_zoom_level() + U.get_camera_offset())
				points.append(event.global_position * U.get_zoom_level() - U.get_camera_offset() * U.get_zoom_level())
				points.append(event.global_position / U.get_zoom_level() + U.get_camera_offset() / U.get_zoom_level())
				
				# event.position xform
				points.append(U.get_camera_xform(event.position))
				
				points.append(U.get_camera_xform(event.position) * U.get_zoom_level())
				points.append(U.get_camera_xform(event.position) / U.get_zoom_level())
				
				points.append(U.get_camera_xform(event.position)                      - U.get_camera_offset())
				points.append(U.get_camera_xform(event.position)                      + U.get_camera_offset())
				points.append(U.get_camera_xform(event.position)                      - U.get_camera_offset() * U.get_zoom_level())
				points.append(U.get_camera_xform(event.position)                      + U.get_camera_offset() / U.get_zoom_level())
				
				points.append(U.get_camera_xform(event.position) * U.get_zoom_level() - U.get_camera_offset())
				points.append(U.get_camera_xform(event.position) / U.get_zoom_level() + U.get_camera_offset())
				points.append(U.get_camera_xform(event.position) * U.get_zoom_level() - U.get_camera_offset() * U.get_zoom_level())
				points.append(U.get_camera_xform(event.position) / U.get_zoom_level() + U.get_camera_offset() / U.get_zoom_level())
				
				# shifted by vpsize
				var evpos = event.position - get_viewport().size/2
				points.append(evpos)
				
				points.append(evpos * U.get_zoom_level())
				points.append(evpos / U.get_zoom_level())
				
				points.append(evpos                      - U.get_camera_offset())
				points.append(evpos                      + U.get_camera_offset())
				points.append(evpos                      - U.get_camera_offset() * U.get_zoom_level())
				points.append(evpos                      + U.get_camera_offset() / U.get_zoom_level())
				
				points.append(evpos * U.get_zoom_level() - U.get_camera_offset())
				points.append(evpos / U.get_zoom_level() + U.get_camera_offset())
				points.append(evpos * U.get_zoom_level() - U.get_camera_offset() * U.get_zoom_level())
				points.append(evpos / U.get_zoom_level() + U.get_camera_offset() / U.get_zoom_level())
				
				# shifted by vpsize other direction
				evpos = event.position + get_viewport().size/2
				points.append(evpos)
				
				points.append(evpos * U.get_zoom_level())
				points.append(evpos / U.get_zoom_level())
				
				points.append(evpos                      - U.get_camera_offset())
				points.append(evpos                      + U.get_camera_offset())
				points.append(evpos                      - U.get_camera_offset() * U.get_zoom_level())
				points.append(evpos                      + U.get_camera_offset() / U.get_zoom_level())
				
				points.append(evpos * U.get_zoom_level() - U.get_camera_offset())
				points.append(evpos / U.get_zoom_level() + U.get_camera_offset())
				points.append(evpos * U.get_zoom_level() - U.get_camera_offset() * U.get_zoom_level())
				points.append(evpos / U.get_zoom_level() + U.get_camera_offset() / U.get_zoom_level())
				
				# shifted xform
				evpos = event.position - get_viewport().size/2
				points.append(U.get_camera_xform(evpos))
				
				points.append(U.get_camera_xform(evpos) * U.get_zoom_level())
				points.append(U.get_camera_xform(evpos) / U.get_zoom_level())
				
				points.append(U.get_camera_xform(evpos)                      - U.get_camera_offset())
				points.append(U.get_camera_xform(evpos)                      + U.get_camera_offset())
				points.append(U.get_camera_xform(evpos)                      - U.get_camera_offset() * U.get_zoom_level())
				points.append(U.get_camera_xform(evpos)                      + U.get_camera_offset() / U.get_zoom_level())
				
				points.append(U.get_camera_xform(evpos) * U.get_zoom_level() - U.get_camera_offset())
				points.append(U.get_camera_xform(evpos) / U.get_zoom_level() + U.get_camera_offset())
				points.append(U.get_camera_xform(evpos) * U.get_zoom_level() - U.get_camera_offset() * U.get_zoom_level())
				points.append(U.get_camera_xform(evpos) / U.get_zoom_level() + U.get_camera_offset() / U.get_zoom_level())
				
				# shifted xform other way
				evpos = event.position + get_viewport().size/2
				points.append(U.get_camera_xform(evpos))
				
				points.append(U.get_camera_xform(evpos) * U.get_zoom_level())
				points.append(U.get_camera_xform(evpos) / U.get_zoom_level())
				
				points.append(U.get_camera_xform(evpos)                      - U.get_camera_offset())
				points.append(U.get_camera_xform(evpos)                      + U.get_camera_offset())
				points.append(U.get_camera_xform(evpos)                      - U.get_camera_offset() * U.get_zoom_level())
				points.append(U.get_camera_xform(evpos)                      + U.get_camera_offset() / U.get_zoom_level())
				
				points.append(U.get_camera_xform(evpos) * U.get_zoom_level() - U.get_camera_offset())
				points.append(U.get_camera_xform(evpos) / U.get_zoom_level() + U.get_camera_offset())
				points.append(U.get_camera_xform(evpos) * U.get_zoom_level() - U.get_camera_offset() * U.get_zoom_level())
				points.append(U.get_camera_xform(evpos) / U.get_zoom_level() + U.get_camera_offset() / U.get_zoom_level())
